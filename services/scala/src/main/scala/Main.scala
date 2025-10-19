import akka.actor.typed.ActorSystem
import akka.actor.typed.scaladsl.Behaviors
import akka.http.scaladsl.Http
import akka.http.scaladsl.model._
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.server.Route
import akka.stream.scaladsl.Source
import akka.util.ByteString
import tests.NBody

import scala.concurrent.ExecutionContextExecutor
import scala.io.StdIn

object Main {
  def main(args: Array[String]): Unit = {
    implicit val system: ActorSystem[Nothing] = ActorSystem(Behaviors.empty, "scala-benchmark")
    implicit val executionContext: ExecutionContextExecutor = system.executionContext

    val port = if (args.length > 0) args(0).toInt else 8080

    val route: Route =
      path("api" / "hello-world") {
        get {
          complete(HttpEntity(ContentTypes.`text/plain(UTF-8)`, "Hello World!"))
        }
      } ~
      path("api" / "n-body") {
        get {
          complete(HttpEntity(ContentTypes.`text/plain(UTF-8)`, NBody.nBody()))
        }
      } ~
      path("health") {
        get {
          complete(HttpEntity(ContentTypes.`text/plain(UTF-8)`, "OK"))
        }
      }

    val bindingFuture = Http().newServerAt("0.0.0.0", port).bind(route)

    println(s"Server running at http://localhost:$port (Scala ${scala.util.Properties.versionString})")

    // Keep the server running
    scala.sys.addShutdownHook {
      bindingFuture
        .flatMap(_.unbind())
        .onComplete(_ => system.terminate())
    }

    // Block the main thread
    scala.io.StdIn.readLine()
  }
}
