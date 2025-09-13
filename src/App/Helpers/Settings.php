<?php
namespace App\Helpers;

use App\Exceptions\ReadAndParseEnvException;

final class Settings {
    private const ENV_PATH = '.env';
    private static ?array $cache = null;

    /**
     * @throws ReadAndParseEnvException
     */
    public static function env(string $key): string {
        if (self::$cache === null) {
            // this file lives in src/App/Helpers → go up 3 levels to project root
            $root = dirname(__DIR__, 3);
            $file = $root . '/' . self::ENV_PATH;
            $cfg = @parse_ini_file($file);
            if ($cfg === false) {
                throw new ReadAndParseEnvException("Failed to read or parse {$file}");
            }
            self::$cache = $cfg;
        }

        if (!array_key_exists($key, self::$cache)) {
            throw new ReadAndParseEnvException("Key '{$key}' not found in env file");
        }
        // return as string
        return (string) self::$cache[$key];
    }
}
