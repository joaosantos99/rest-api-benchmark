import helloWorld from "./tests/hello-world.ts";

const port = Number(Deno.env.get("PORT") || 8080);

Deno.serve({ port: port }, (req) => {
  const url = new URL(req.url);

  switch (url.pathname) {
    case "/api/hello-world":
      return helloWorld();
    default:
      return new Response("Not found", { status: 404 });
  }
});

console.log(`Server running at http://localhost:${port} (Deno v${Deno.version.deno})`);
