SET search_path TO logitrack;

-- 14. Transacción con al menos un SAVEPOINT
-- Modificaciones posteriores al punto de guardado se revierten con ROLLBACK TO SAVEPOINT
-- y los cambios válidos se confirman con COMMIT
BEGIN;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email)
VALUES ('Carlos García', '33.333.333-3', 'Calle del Sol 789', 'Santiago', '555-9876', 'carlos.garcia@example.com');

SAVEPOINT sp1;

UPDATE inventario SET stock = stock - 5 WHERE id_producto = 1 AND id_ubicacion = 1;

ROLLBACK TO SAVEPOINT sp1;

COMMIT;
-- Una vez colocado esta transacción savepoint, tendrás que verificar que el cliente queda registrado, pero la actualización del stock se deshizo.
-- Dado que el cliente queda registrado, pero la actualización del stock se deshizo, usaremos estos consultas para verificarlo:
SELECT count(*) AS carlos_existe FROM clientes WHERE rut = '33.333.333-3';

-- La primera consulta nos devuelve 1, lo que significa que el cliente Carlos García fue insertado correctamente en la tabla clientes.

SELECT stock AS stock_inalterado FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;

-- La segunda consulta nos devuelve el stock original del producto con id_producto = 1 y id_ubicacion = 1, lo que indica que la actualización del stock fue revertida correctamente al hacer ROLLBACK TO SAVEPOINT. Y, debería retornar el stock original que es 115.