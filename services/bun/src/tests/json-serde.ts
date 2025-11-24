import crypto from 'crypto';

function printHash(data: any, label: string = ''): string {
    const str = JSON.stringify(data);
    const hash = crypto.createHash('md5').update(str, 'utf-8').digest('hex');
    return `${label ? label + ' ' : ''}MD5 Hash: ${hash}`;
}

const jsonSerde = () => {
    const sampleData = {
        users: [
            { id: 1, name: "Alice", email: "alice@example.com", active: true },
            { id: 2, name: "Bob", email: "bob@example.com", active: false },
            { id: 3, name: "Charlie", email: "charlie@example.com", active: true }
        ],
        metadata: {
            version: "1.0.0",
            timestamp: new Date().toISOString(),
            settings: {
                theme: "dark",
                notifications: true,
                language: "en"
            }
        },
        statistics: {
            totalUsers: 3,
            activeUsers: 2,
            averageAge: 28.5,
            tags: ["javascript", "nodejs", "benchmark", "json", "serialization"]
        }
    };

    const n = 100; // Number of serialization/deserialization cycles

    const jsonStr = JSON.stringify(sampleData);

    const parsed = JSON.parse(jsonStr);
    const originalHash = printHash(parsed, 'Original');

    const results = [];
    for (let i = 0; i < n; i++) {
        const serialized = JSON.stringify(parsed);
        const deserialized = JSON.parse(serialized);
        results.push(deserialized);
    }

    const finalHash = printHash(results, `x${n} Cycles`);

    return new Response([
        originalHash,
        finalHash,
        `Performed ${n} serialization/deserialization cycles`,
        `Original data size: ${jsonStr.length} bytes`,
        `Final array size: ${results.length} objects`
    ].join('\n'));
};

export default jsonSerde;

