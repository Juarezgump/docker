<?php
class Database {
    private static $instance = null;

    public static function getConnection() {
        if (self::$instance === null) {
            // Leemos del entorno, si no existe, usamos valores por defecto
            $host = 'db';
            $db   = getenv('DB_NAME') ?: 'laboratorio_db';
            $user = getenv('DB_USER') ?: 'root';
            $pass = getenv('DB_PASS') ?: 'rootpassword';

            try {
                self::$instance = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
                self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            } catch (PDOException $e) {
                die("Error de conexión: " . $e->getMessage());
            }
        }
        return self::$instance;
    }
}
