<?php
require_once 'MensajeManager.php';
$manager = new MensajeManager();

if ($_SERVER['REQUEST_METHOD'] == 'POST' && !empty($_POST['mensaje'])) {
    $manager->guardar($_POST['mensaje']);
    header("Location: index.php");
    exit();
}

$busqueda = $_GET['buscar'] ?? '';
$mensajes = $manager->obtenerTodos($busqueda);
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestor de Mensajes</title>
</head>
<body>
    <h1>Mis Mensajes</h1>

    <form method="GET" style="margin-bottom: 20px;">
        <input type="text" name="buscar" value="<?= htmlspecialchars($busqueda) ?>" placeholder="Buscar...">
        <button type="submit">Buscar</button>
        <a href="index.php">Limpiar</a>
    </form>
    
    <form method="POST">
        <input type="text" name="mensaje" placeholder="Escribe un mensaje" required>
        <button type="submit">Enviar</button>
    </form>

    <hr>

    <ul>
        <?php foreach ($mensajes as $m): ?>
            <li>
                <?= htmlspecialchars($m['texto']) ?>
                <a href="editar.php?id=<?= $m['id'] ?>">[Editar]</a>
                <a href="borrar.php?id=<?= $m['id'] ?>" onclick="return confirm('¿Seguro?');" style="color:red;">[Borrar]</a>
            </li>
        <?php endforeach; ?>
    </ul>
</body>
</html>
