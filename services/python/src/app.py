#!/usr/bin/env python3

import http.server
import socketserver
import urllib.parse
import sys
from tests.hello_world import hello_world
from tests.pi_digits import pi_digits
from tests.n_body import n_body
from tests.json_serde import json_serde
from tests.regex_redux import regex_redux

class BenchmarkHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # Parse URL
        parsed_url = urllib.parse.urlparse(self.path)
        path = parsed_url.path

        # Set CORS headers
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.send_header('Content-Type', 'text/plain')
        self.end_headers()

        # Route requests
        if path == '/api/hello-world':
            response = hello_world()
            self.wfile.write(response.encode('utf-8'))
        elif path == '/api/n-body':
            response = n_body()
            self.wfile.write(response.encode('utf-8'))
        elif path == '/api/json-serde':
            response = json_serde()
            self.wfile.write(response.encode('utf-8'))
        elif path == '/api/regex-redux':
            response = regex_redux()
            self.wfile.write(response.encode('utf-8'))
        else:
            self.send_response(404)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'Not found')

    def do_OPTIONS(self):
        # Handle preflight requests
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080

    with socketserver.TCPServer(("", port), BenchmarkHandler) as httpd:
        print(f"Server running at http://localhost:{port} (Python {sys.version.split()[0]})")
        httpd.serve_forever()

if __name__ == "__main__":
    main()
