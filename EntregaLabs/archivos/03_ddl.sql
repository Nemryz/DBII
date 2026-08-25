SET search_path TO logitrack;

CREATE TABLE auditoria_inventario (
    id_auditoria SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    id_ubicacion INT NOT NULL,
    cantidad_anterior INT NOT NULL,
    cantidad_nueva INT NOT NULL,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE auditoria_inventario
ADD COLUMN usuario_responsable VARCHAR(100);

ALTER TABLE auditoria_inventario
DROP COLUMN usuario_responsable;

DROP TABLE auditoria_inventario;
