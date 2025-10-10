import helloWorld from "./tests/hello-world";
import piDigits from "./tests/pi-digits";

const port = process.env.PORT || 8080;

Bun.serve({
  port: port,
  routes: {
    '/api/hello-world': () => helloWorld(),
    '/api/pi-digits': () => piDigits(),
  },
});

console.log(`Server running at http://localhost:${port} (Bun v${Bun.version})`);
