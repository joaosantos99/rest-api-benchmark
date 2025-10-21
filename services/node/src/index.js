import { createServer } from 'http';
import { URL } from 'url';
import helloWorld from './tests/hello-world.js';
import piDigits from './tests/pi-digits.js';
import nbody from './tests/n-body.js';
import regexRedux from './tests/regex-redux.js';

const port = process.env.PORT || 8080;

const server = createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  switch (url.pathname) {
    case '/api/hello-world':
      const helloResponse = helloWorld();
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end(helloResponse);
      break;
    case '/api/pi-digits':
      const piResponse = piDigits();
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end(piResponse);
      break;
    case '/api/n-body':
      const nbodyResponse = nbody();
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end(nbodyResponse);
      break;
    case '/api/regex-redux':
      const regexReduxResponse = regexRedux();
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end(regexReduxResponse);
      break;
    default:
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Not found');
  }
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port} (Node.js v${process.version})`);
});
