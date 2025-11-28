package com.benchmark;

import com.benchmark.tests.HelloWorld;
import com.benchmark.tests.JsonSerde;
import com.benchmark.tests.NBody;
import com.benchmark.tests.RegexRedux;
import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Main {
    public static void main(String[] args) throws IOException {
        String port = System.getenv("PORT");
        if (port == null) {
            port = "8080";
        }

        HttpServer server = HttpServer.create(new InetSocketAddress(Integer.parseInt(port)), 0);

        server.createContext("/api/hello-world", new HelloWorld());
        server.createContext("/api/json-serde", new JsonSerde());
        server.createContext("/api/n-body", new NBody());
        server.createContext("/api/regex-redux", new RegexRedux());

        server.setExecutor(null);
        server.start();

        System.out.println("Server running at http://localhost:" + port + " (Java 21)");
    }
}
