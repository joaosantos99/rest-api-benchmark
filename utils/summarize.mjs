import fs from 'node:fs';
import path from 'node:path';

const files = fs.readdirSync('results/raw').filter(f => f.endsWith('.json'));

const rows = files.map(f => {
  const j = JSON.parse(fs.readFileSync(path.join('results/raw', f), 'utf8'));
  const m = j.metrics;
  const dur = m.http_req_duration; // { p(50), p(95), p(99) are in 'percentiles' if enabled }
  const totalReqs = m.http_reqs.values.count;
  const failRate = m.http_req_failed.values.rate || 0;
  // derive req/s from `j.metrics.iterations` or duration from filename if needed
  return {
    file: f,
    p50: dur.values['p(50)'],
    p95: dur.values['p(95)'],
    p99: dur.values['p(99)'],
    rps: j.metrics.iterations.values.rate, // close proxy when 1 GET per VU loop
    failRate
  };
});
fs.writeFileSync('results/summary/summary.json', JSON.stringify(rows, null, 2));
