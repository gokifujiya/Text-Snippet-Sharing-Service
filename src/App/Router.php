<?php
namespace App;

final class Router {
    private array $routes = [];

    public function get(string $path, callable $handler): void {
        $this->routes["GET {$path}"] = $handler;
    }
    public function dispatch(): void {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
        $uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);
        $key = "{$method} {$uri}";
        if (isset($this->routes[$key])) { ($this->routes[$key])(); return; }
        http_response_code(404); echo "Not Found";
    }
}
