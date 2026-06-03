<?php
require_once 'Database.php';

/**
 * Clase encargada de gestionar las operaciones CRUD de los mensajes.
 */
class MensajeManager {
    /** @var PDO $pdo Instancia de la conexión a la base de datos */
    private $pdo;

    /**
     * Constructor que inicializa la conexión a la base de datos.
     */
    public function __construct() {
        $this->pdo = Database::getConnection();
    }

    /**
     * Obtiene una lista de mensajes, opcionalmente filtrada por un término de búsqueda.
     *
     * @param string $busqueda Término de búsqueda para filtrar el texto del mensaje.
     * @return array Retorna un arreglo asociativo con los resultados encontrados.
     */
    public function obtenerTodos($busqueda = '') {
        $sql = "SELECT id, texto FROM mensajes WHERE texto LIKE :busqueda";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['busqueda' => "%$busqueda%"]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * Guarda un nuevo mensaje en la base de datos.
     *
     * @param string $texto El contenido del mensaje a guardar.
     * @return void
     */
    public function guardar($texto) {
        $stmt = $this->pdo->prepare("INSERT INTO mensajes (texto) VALUES (:texto)");
        $stmt->execute(['texto' => $texto]);
    }

    /**
     * Borra un mensaje específico de la base de datos según su ID.
     *
     * @param int $id El identificador único del mensaje a borrar.
     * @return void
     */
    public function borrar($id) {
        $stmt = $this->pdo->prepare("DELETE FROM mensajes WHERE id = :id");
        $stmt->execute(['id' => $id]);
    }
    
    /**
     * Obtiene un mensaje específico de la base de datos por su ID.
     *
     * @param int $id El identificador único del mensaje.
     * @return array|false Retorna un arreglo asociativo con el mensaje o false si no existe.
     */
    public function obtenerPorId($id) {
        $stmt = $this->pdo->prepare("SELECT * FROM mensajes WHERE id = :id");
        $stmt->execute(['id' => $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}
