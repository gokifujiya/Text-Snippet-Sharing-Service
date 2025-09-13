<?php
namespace App\Repositories;

use Infrastructure\Database\Connection;

final class ProductRepository {
    public function all(): array {
        $pdo = Connection::get();
        return $pdo->query("SELECT id, name, description, price, stock FROM products ORDER BY id")->fetchAll();
    }
}
