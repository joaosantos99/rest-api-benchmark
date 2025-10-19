#include <iostream>
#include <string>
#include <cstdlib>
#include <crow.h>
#include "tests/hello_world.h"
#include "tests/n_body.h"

int main() {
    crow::SimpleApp app;

    // Get port from environment variable or use default
    const char* port_env = std::getenv("PORT");
    int port = port_env ? std::atoi(port_env) : 8080;

    CROW_ROUTE(app, "/api/hello-world")
        .methods("GET"_method)
        ([](){
            return hello_world();
        });

    CROW_ROUTE(app, "/api/n-body")
        .methods("GET"_method)
        ([](){
            return n_body();
        });

    std::cout << "Server running at http://localhost:" << port << " (C++)" << std::endl;
    app.port(port).multithreaded().run();

    return 0;
}
