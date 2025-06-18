<?php

$host = getenv('DB_HOST');
$dbname = getenv('DB_NAME');
$user = getenv('DB_USER');
$password = getenv('DB_PASSWORD');
$port = getenv('DB_PORT') ?: '3306';


if (!$host || !$dbname || !$user || !$password) {
    die("Error: Las variables de entorno de la base de datos no están configuradas correctamente o están vacías.<br>" .
        "HOST: '" . htmlspecialchars($host) . "'<br>" .
        "DB_NAME: '" . htmlspecialchars($dbname) . "'<br>" .
        "DB_USER: '" . htmlspecialchars($user) . "'<br>" .
        "DB_PASSWORD: '" . (empty($password) ? '[VACIO]' : '[SET]') . "'<br>" .
        "DB_PORT: '" . htmlspecialchars($port) . "'<br>" .
        "Por favor, revisa docker-apache-env.conf y la configuración del Dockerfile."
    );
}

try {
    $dsn = "mysql:host=$host;dbname=$dbname;port=$port;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    // Si la conexión falla AUNQUE las variables estén bien
    die("Error de conexión a la base de datos (con getenv()): " . $e->getMessage() . "<br>" .
        "DSN usado: " . htmlspecialchars($dsn) . "<br>" .
        "Usuario: " . htmlspecialchars($user)
    );
}

?>
