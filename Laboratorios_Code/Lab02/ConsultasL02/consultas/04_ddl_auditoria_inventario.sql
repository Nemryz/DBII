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
-- Para revisar que se agrego el atributo, se puede usar el comando \d auditoria_inventario en psql, o SELECT * FROM auditoria_inventario LIMIT 0; para ver la estructura de la tabla.

-- c. Eliminar dicho atributo mediante ALTER TABLE ... DROP COLUMN
ALTER TABLE auditoria_inventario
DROP COLUMN usuario_responsable;
-- Para revisar que se elimino el atributo, se puede usar el comando \d auditoria_inventario en psql, o SELECT * FROM auditoria_inventario LIMIT 0; para ver la estructura de la tabla.

-- d. Eliminar la tabla creada mediante DROP TABLE
DROP TABLE auditoria_inventario;

/*- La consulta 4d es la que elimina la tabla creada, por lo que no se puede ejecutar nuevamente sin antes crear la tabla de nuevo. Pero para ver la estructura de la tabla antes de eliminarla, se puede usar el comando \d auditoria_inventario en psql, o SELECT * FROM auditoria_inventario LIMIT 0; para ver la estructura de la tabla. Si no se ejecuta la consulta 4d, la tabla auditoria_inventario seguirá existiendo en la base de datos y se podrá consultar su estructura y datos.

-- Para ver que se confirmo esto, te debe salir lo siguiente: 

ERROR:  no existe la relación «auditoria_inventario»
LINE 3: SELECT * FROM auditoria_inventario LIMIT 0; 

Si no aparece este error, es porque la tabla auditoria_inventario sigue existiendo en la base de datos.
*/