import helloWorld from "./tests/hello-world.ts";
import piDigits from "./tests/pi-digits.ts";

const port = Number(Deno.env.get("PORT") || 8080);

Deno.serve({ port: port }, (req) => {
  const url = new URL(req.url);

  switch (url.pathname) {
    case "/api/hello-world":
      return helloWorld();
    case "/api/pi-digits":
      return piDigits();
    default:
      return new Response("Not found", { status: 404 });
  }
});

console.log(`Server running at http://localhost:${port} (Deno v${Deno.version.deno})`);
