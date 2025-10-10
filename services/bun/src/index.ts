import helloWorld from "./tests/hello-world";

const port = process.env.PORT || 8080;

Bun.serve({
  port: port,
  routes: {
    '/api/hello-world': () => helloWorld()
  },
});

console.log(`Server running at http://localhost:${port} (Bun v${Bun.version})`);
