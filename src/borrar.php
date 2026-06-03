<?php
$pdo = new PDO("mysql:host=db;dbname=laboratorio_db", "root", "rootpassword");

if (isset($_GET['id']) && is_numeric($_GET['id'])) {
    $stmt = $pdo->prepare("DELETE FROM mensajes WHERE id = :id");
    $stmt->execute(['id' => $_GET['id']]);
}

header("Location: index.php");
exit();
