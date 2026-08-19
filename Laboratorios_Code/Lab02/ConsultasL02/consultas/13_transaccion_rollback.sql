SET search_path TO logitrack;

-- 13. Transacción de prueba que inserta y modifica registros, revertida con ROLLBACK
-- Verificar que los cambios NO permanecen almacenados en la base de datos
BEGIN;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email)
VALUES ('María López', '22.222.222-2', 'Avenida Siempre Viva 456', 'Santiago', '555-6789', 'maria.lopez@example.com');

UPDATE inventario SET stock = stock + 10 WHERE id_producto = 1 AND id_ubicacion = 1;

ROLLBACK;

-- Verificación: la clienta no existe y el stock no cambió
SELECT count(*) AS maria_no_existe FROM clientes WHERE rut = '22.222.222-2';
SELECT stock AS stock_inalterado FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;