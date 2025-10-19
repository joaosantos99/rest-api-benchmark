<?php

require_once 'tests/hello_world.php';
require_once 'tests/n_body.php';

// Set CORS headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Get the request path
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Route requests
switch ($path) {
    case '/api/hello-world':
        $response = hello_world();
        http_response_code(200);
        header('Content-Type: text/plain');
        echo $response;
        break;
    case '/api/n-body':
        $response = n_body();
        http_response_code(200);
        header('Content-Type: text/plain');
        echo $response;
        break;
    default:
        http_response_code(404);
        header('Content-Type: text/plain');
        echo 'Not found';
        break;
}

?>
