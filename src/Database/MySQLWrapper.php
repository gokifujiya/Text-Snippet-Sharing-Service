<?php
namespace Database;

use mysqli;
use App\Helpers\Settings;

class MySQLWrapper extends mysqli {
    public function __construct(
        ?string $hostname = 'localhost',
        ?string $username = null,
        ?string $password = null,
        ?string $database = null,
        ?int $port = null,
        ?string $socket = null
    ) {
        // Fail fast on error
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        $username = $username ?? Settings::env('DATABASE_USER');
        $password = $password ?? Settings::env('DATABASE_USER_PASSWORD');
        $database = $database ?? Settings::env('DATABASE_NAME');

        parent::__construct($hostname, $username, $password, $database, $port, $socket);
    }

    /** Get the name of the current database */
    public function getDatabaseName(): string {
        $result = $this->query("SELECT DATABASE() AS the_db");
        if (!$result) {
            throw new \Exception("Failed to fetch current database name");
        }
        return $result->fetch_row()[0];
    }
}
