import helloWorld from "./tests/hello-world";
import piDigits from "./tests/pi-digits";
import nbody from "./tests/n-body";

const port = process.env.PORT || 8080;

Bun.serve({
  port: port,
  routes: {
    '/api/hello-world': () => helloWorld(),
    '/api/pi-digits': () => piDigits(),
    '/api/n-body': () => nbody(),
  },
});

console.log(`Server running at http://localhost:${port} (Bun v${Bun.version})`);
