import http from 'k6/http';
import { check } from 'k6';
import { Trend, Rate } from 'k6/metrics';

const URL = __ENV.TARGET_URL;
const DURATION = __ENV.DURATION || '60s';
const VUS = Number(__ENV.VUS || 1);

export const options = {
  vus: VUS,
  durations: DURATION,
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<2000']
  },
  discardResponseBodies: true,
  noConnectionReuse: false,
};

const latency = new Trend('latency');
const okRate = new Rate('ok_rate');

export default function () {
  const res = http.get(URL);
  okRate.add(res.status === 200);
  latency.add(res.timings.duration);
  check(res, { 'status 200': (r) => r.status === 200 });
}
