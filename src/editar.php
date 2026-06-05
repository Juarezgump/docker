<?php
require_once 'MensajeManager.php';
$manager = new MensajeManager();

// Procesar el guardado si se envió el formulario
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $manager->actualizar($_POST['id'], $_POST['texto']);
    header("Location: index.php");
    exit();
}

// Obtener el mensaje a editar
$id = $_GET['id'] ?? null;
$mensaje = $manager->obtenerPorId($id);

if (!$mensaje) {
    die("Mensaje no encontrado.");
}
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Mensaje</title>
</head>
<body>
    <h1>Editar Mensaje</h1>
    <form method="POST">
        <input type="hidden" name="id" value="<?= $mensaje['id'] ?>">
        <input type="text" name="texto" value="<?= htmlspecialchars($mensaje['texto']) ?>" required>
        <button type="submit">Guardar cambios</button>
        <a href="index.php">Cancelar</a>
    </form>
</body>
</html>
