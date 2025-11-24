import helloWorld from "./tests/hello-world.ts";
import piDigits from "./tests/pi-digits.ts";
import nbody from "./tests/n-body.ts";
import jsonSerde from "./tests/json-serde.ts";
import regexRedux from "./tests/regex-redux.ts";

const port = Number(Deno.env.get("PORT") || 8080);

Deno.serve({ port: port }, (req) => {
  const url = new URL(req.url);

  switch (url.pathname) {
    case "/api/hello-world":
      return helloWorld();
    case "/api/pi-digits":
      return piDigits();
    case "/api/n-body":
      return nbody();
    case "/api/json-serde":
      return jsonSerde();
    case "/api/regex-redux":
      return regexRedux();
    default:
      return new Response("Not found", { status: 404 });
  }
});

console.log(`Server running at http://localhost:${port} (Deno v${Deno.version.deno})`);
