-- Tarea 4a Crear tabla auditoria_inventario para registrar modificaciones
CREATE TABLE auditoria_inventario (
    id_auditoria SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    id_ubicacion INT NOT NULL,
    cantidad_anterior INT NOT NULL,
    cantidad_nueva INT NOT NULL,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tarea 4b Agregar un atributo adicional mediante ALTER TABLE
ALTER TABLE auditoria_inventario 
ADD COLUMN usuario_responsable VARCHAR(100);

-- Tarea 4c Eliminar dicho atributo mediante ALTER TABLE ... DROP COLUMN
ALTER TABLE auditoria_inventario 
DROP COLUMN usuario_responsable;

-- Tarea 4d Eliminar la tabla creada mediante DROP TABLE
DROP TABLE auditoria_inventario;