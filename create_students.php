<?php
require __DIR__ . '/vendor/autoload.php';

$mysqli = new \Database\MySQLWrapper();

$createTableQuery = "
    CREATE TABLE IF NOT EXISTS students (
      id INT PRIMARY KEY AUTO_INCREMENT,
      name VARCHAR(100),
      age INT,
      major VARCHAR(50)
    )
";

$mysqli->query($createTableQuery);

echo "✅ students table created.\n";
