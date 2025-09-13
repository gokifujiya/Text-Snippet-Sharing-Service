<?php
namespace App\Repositories;

use Infrastructure\Database\Connection;

final class OrderRepository {
    public function allWithItems(): array {
        $pdo = Connection::get();
        $sql = "
        SELECT
            o.id AS order_id,
            o.user_id,
            u.name AS user_name,
            o.total,
            o.status,
            o.created_at,
            oi.product_id,
            p.name AS product_name,
            oi.quantity,
            oi.price
        FROM orders o
        LEFT JOIN users u ON u.id = o.user_id
        LEFT JOIN order_items oi ON oi.order_id = o.id
        LEFT JOIN products p ON p.id = oi.product_id
        ORDER BY o.id, oi.id
        ";
        $rows = $pdo->query($sql)->fetchAll();

        // Group rows by order
        $orders = [];
        foreach ($rows as $r) {
            $oid = $r['order_id'];
            if (!isset($orders[$oid])) {
                $orders[$oid] = [
                    'order_id' => $oid,
                    'user_id' => $r['user_id'],
                    'user_name' => $r['user_name'],
                    'total' => $r['total'],
                    'status' => $r['status'],
                    'created_at' => $r['created_at'],
                    'items' => [],
                ];
            }
            if ($r['product_id'] !== null) {
                $orders[$oid]['items'][] = [
                    'product_id' => $r['product_id'],
                    'product_name' => $r['product_name'],
                    'quantity' => $r['quantity'],
                    'price' => $r['price'],
                ];
            }
        }
        return array_values($orders);
    }
}
