<?php
namespace Infrastructure\Database;

use PDO;
use Dotenv\Dotenv;

final class Connection {
    private static ?PDO $pdo = null;

    public static function get(): PDO {
        if (self::$pdo) {
            return self::$pdo;
        }

        $root = dirname(__DIR__, 3);
        // Autoload (Composer)
        require_once $root . '/vendor/autoload.php';

        // Load .env if present
        if (file_exists($root . '/.env')) {
            $dotenv = Dotenv::createImmutable($root);
            $dotenv->safeLoad();
        }

        $host = $_ENV['DB_HOST'] ?? 'localhost';
        $db   = $_ENV['DB_NAME'] ?? 'practice_db';
        $user = $_ENV['DB_USER'] ?? 'devuser';
        $pass = $_ENV['DB_PASS'] ?? 't';

        $dsn = "mysql:host={$host};dbname={$db};charset=utf8mb4";

        self::$pdo = new PDO($dsn, $user, $pass, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);

        return self::$pdo;
    }
}
