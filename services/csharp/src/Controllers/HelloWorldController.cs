using Microsoft.AspNetCore.Mvc;

namespace CSharpBenchmark.Controllers;

[ApiController]
[Route("api")]
public class HelloWorldController : ControllerBase
{
    [HttpGet("hello-world")]
    public IActionResult GetHelloWorld()
    {
        return Ok("Hello World!");
    }
}
