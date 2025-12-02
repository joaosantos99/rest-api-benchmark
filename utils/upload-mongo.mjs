import fs from 'node:fs';
import path from 'node:path';
import { MongoClient } from 'mongodb';

// Load .env file if it exists
function loadEnvFile() {
  try {
    const envFile = fs.readFileSync('.env', 'utf8');
    for (const line of envFile.split('\n')) {
      const trimmed = line.trim();
      if (trimmed && !trimmed.startsWith('#') && trimmed.includes('=')) {
        const [key, ...valueParts] = trimmed.split('=');
        const value = valueParts.join('=').replace(/^["']|["']$/g, '');
        if (!process.env[key]) {
          process.env[key] = value;
        }
      }
    }
  } catch {
    // .env file doesn't exist, that's okay
  }
}

loadEnvFile();

/**
 * Parses filename to extract benchmark metadata
 * Format: ${lang}_${test}_${CPUS}vCPU_rep${rep}_${scenario}_summary.json
 */
function parseFilename(filename) {
  const match = filename.match(/^(.+?)_(.+?)_(\d+)vCPU_rep(\d+)_(.+?)_summary\.json$/);
  if (!match) {
    throw new Error(`Invalid filename format: ${filename}`);
  }

  const [, language, test, cpus, repetition, scenario] = match;
  return {
    language,
    test,
    cpus: parseInt(cpus, 10),
    repetition: parseInt(repetition, 10),
    scenario
  };
}

/**
 * Transforms k6 result data into MongoDB document structure
 */
function transformResult(filename, metadata, rawData) {
  const m = rawData.metrics;
  const dur = m.http_req_duration || {};
  const httpReqs = m.http_reqs || {};
  const httpFailed = m.http_req_failed || {};

  return {
    filename,
    ...metadata,
    timestamp: new Date(),
    metrics: {
      throughput: {
        requestsPerSecond: m.iterations?.rate || httpReqs.rate || 0,
        totalRequests: httpReqs.count || m.iterations?.count || 0
      },
      latency: {
        p50: dur['p(50)'] || null,
        p95: dur['p(95)'] || null,
        p99: dur['p(99)'] || null,
        min: dur.min || null,
        max: dur.max || null,
        avg: dur.avg || null
      },
      errorRate: httpFailed.value || 0,
      httpMetrics: {
        sending: m.http_req_sending || {},
        waiting: m.http_req_waiting || {},
        receiving: m.http_req_receiving || {},
        connecting: m.http_req_connecting || {},
        blocked: m.http_req_blocked || {}
      },
      dataTransfer: {
        sent: m.data_sent || {},
        received: m.data_received || {}
      },
      virtualUsers: {
        min: m.vus?.min || null,
        max: m.vus?.max || null,
        value: m.vus?.value || null
      }
    },
    checks: rawData.root_group?.checks || {},
    rawData: rawData
  };
}

/**
 * Uploads benchmark results to MongoDB Atlas
 */
async function uploadToMongo() {
  const connectionString = process.env.MONGODB_URI;
  if (!connectionString) {
    throw new Error('MONGODB_URI environment variable is required');
  }

  if (!connectionString.startsWith('mongodb://') && !connectionString.startsWith('mongodb+srv://')) {
    throw new Error('Invalid MONGODB_URI format. Must start with mongodb:// or mongodb+srv://');
  }

  const dbName = process.env.MONGODB_DB_NAME || 'benchmark';
  const collectionName = process.env.MONGODB_COLLECTION || 'results';

  const client = new MongoClient(connectionString, {
    serverSelectionTimeoutMS: 10000,
    retryWrites: true
  });

  try {
    await client.connect();
    console.log('Connected to MongoDB Atlas');

    const db = client.db(dbName);
    const collection = db.collection(collectionName);

    try {
      const testDoc = { _test: true, timestamp: new Date() };
      await collection.insertOne(testDoc);
      await collection.deleteOne({ _test: true });
      console.log('Write access verified');
    } catch (error) {
      throw error;
    }

    const resultsDir = 'results/raw';
    const files = fs.readdirSync(resultsDir).filter(f => f.endsWith('_summary.json'));

    if (files.length === 0) {
      console.log('No result files found');
      return;
    }

    console.log(`Found ${files.length} result files to upload`);

    const documents = [];
    for (const file of files) {
      try {
        const filePath = path.join(resultsDir, file);
        const rawData = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        const metadata = parseFilename(file);
        documents.push(transformResult(file, metadata, rawData));
        console.log(`Processed: ${file}`);
      } catch (error) {
        console.error(`Error processing ${file}:`, error.message);
      }
    }

    if (documents.length === 0) {
      console.log('No documents to upload');
      return;
    }

    // Insert documents
    let insertedCount = 0;
    let errorCount = 0;

    for (const doc of documents) {
      try {
        await collection.insertOne(doc);
        insertedCount++;
      } catch (error) {
        errorCount++;
        console.error(`Error inserting ${doc.filename}:`, error.message);
      }
    }

    console.log(`Successfully uploaded ${insertedCount} documents${errorCount > 0 ? `, ${errorCount} errors` : ''}`);

    // Create indexes
    try {
      await collection.createIndex({ language: 1, test: 1, cpus: 1, scenario: 1 });
      await collection.createIndex({ timestamp: -1 });
      await collection.createIndex({ 'metrics.throughput.requestsPerSecond': -1 });
      console.log('Created indexes');
    } catch (error) {
      console.warn('Could not create indexes:', error.message);
    }

  } catch (error) {
    console.error('Error uploading to MongoDB:', error);
    throw error;
  } finally {
    await client.close();
    console.log('Disconnected from MongoDB Atlas');
  }
}

// Run the upload
uploadToMongo().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});

