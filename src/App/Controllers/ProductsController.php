<?php
namespace App\Controllers;

use App\Repositories\ProductRepository;

final class ProductsController {
    public function index(): void {
        $repo = new ProductRepository();
        $products = $repo->all();
        header('Content-Type: text/html; charset=utf-8');
        echo "<h1>Products</h1><ul>";
        foreach ($products as $p) {
            $price = number_format((float)$p['price'], 2);
            echo "<li><strong>{$p['name']}</strong> — \${$price} (stock: {$p['stock']})</li>";
        }
        echo "</ul>";
    }
}
