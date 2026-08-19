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

-- Verificación: el cliente queda registrado, pero la actualización del stock se deshizo
SELECT count(*) AS carlos_existe FROM clientes WHERE rut = '33.333.333-3';
SELECT stock AS stock_inalterado FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;