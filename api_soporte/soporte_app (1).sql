CREATE DATABASE IF NOT EXISTS soporte_app CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE soporte_app;

CREATE TABLE IF NOT EXISTS incidencias (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre_usuario VARCHAR(100) NOT NULL,
  correo VARCHAR(150) NOT NULL,
  numero_equipo INT(11) NOT NULL,
  descripcion VARCHAR(500) NOT NULL,
  prioridad ENUM('Baja','Media','Alta') NOT NULL,
  estado ENUM('Pendiente','En proceso','Resuelta') NOT NULL,
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
