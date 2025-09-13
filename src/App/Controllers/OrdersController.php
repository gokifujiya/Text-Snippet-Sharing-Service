<?php
namespace App\Controllers;

use App\Repositories\OrderRepository;

final class OrdersController {
    public function index(): void {
        $repo = new OrderRepository();
        $orders = $repo->allWithItems();

        header('Content-Type: text/html; charset=utf-8');
        echo "<h1>Orders</h1>";

        if (empty($orders)) {
            echo "<p>No orders yet.</p>";
            return;
        }

        foreach ($orders as $o) {
            echo "<div style='margin-bottom:1rem;padding:0.75rem;border:1px solid #ccc;border-radius:8px'>";
            echo "<h3>Order #{$o['order_id']} — {$o['status']} — Total \$" . number_format((float)$o['total'], 2) . "</h3>";
            echo "<div>Customer: " . htmlspecialchars($o['user_name'] ?? 'Guest') . "</div>";
            echo "<div>Date: {$o['created_at']}</div>";
            echo "<ul>";
            foreach ($o['items'] as $it) {
                $price = number_format((float)$it['price'], 2);
                echo "<li>{$it['product_name']} × {$it['quantity']} — \${$price}</li>";
            }
            echo "</ul>";
            echo "</div>";
        }
    }
}
