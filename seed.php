<?php
require_once 'src/MensajeManager.php';

$manager = new MensajeManager();

// 1. Limpiar la tabla (opcional, pero recomendado)
$db = Database::getConnection();
$db->exec("TRUNCATE TABLE mensajes");

// 2. Definir datos de prueba
$datos = [
    "Bienvenidos al curso de programación.",
    "El examen será el próximo viernes.",
    "No olviden subir sus proyectos al repositorio.",
    "El servidor está funcionando correctamente.",
    "Recuerden revisar la documentación de la API."
];

// 3. Insertar datos
foreach ($datos as $texto) {
    $manager->guardar($texto);
}

echo "Base de datos sembrada con " . count($datos) . " mensajes.\n";
