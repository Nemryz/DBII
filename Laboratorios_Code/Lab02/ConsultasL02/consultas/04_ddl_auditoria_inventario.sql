SET search_path TO logitrack;

-- 4. Consultas DDL básicas sobre la base de datos, btw, es el mismo code que esta en el archivo tarea4_ddl.sql, pero lo dejo aquí para que se pueda ejecutar de manera independiente y no dependa de otro archivo, en caso de cualquier error de antemano.
-- a. Crear una tabla adicional denominada auditoria_inventario para registrar modificaciones relevantes del inventario
CREATE TABLE auditoria_inventario (
    id_auditoria SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    id_ubicacion INT NOT NULL,
    cantidad_anterior INT NOT NULL,
    cantidad_nueva INT NOT NULL,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- b. Modificar la tabla agregando al menos un atributo adicional mediante ALTER TABLE
ALTER TABLE auditoria_inventario
ADD COLUMN usuario_responsable VARCHAR(100);

-- c. Eliminar dicho atributo mediante ALTER TABLE ... DROP COLUMN
ALTER TABLE auditoria_inventario
DROP COLUMN usuario_responsable;

-- d. Eliminar la tabla creada mediante DROP TABLE
DROP TABLE auditoria_inventario;