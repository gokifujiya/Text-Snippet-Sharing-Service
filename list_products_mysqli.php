<?php
require __DIR__ . '/vendor/autoload.php';
use Database\MySQLWrapper;

$mysqli = new MySQLWrapper();
$res = $mysqli->query("SELECT id, name, price, stock FROM products ORDER BY id");
while ($row = $res->fetch_assoc()) {
    printf("%d) %s — $%.2f (stock: %d)\n", $row['id'], $row['name'], $row['price'], $row['stock']);
}
$mysqli->close();
