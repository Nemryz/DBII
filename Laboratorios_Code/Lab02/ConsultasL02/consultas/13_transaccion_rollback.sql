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

/* 
Debería entregar 0 para la primera consulta y el stock original para la segunda, confirmando que la transacción fue revertida correctamente con ROLLBACK. 

Usando "SELECT count(*) AS maria_no_existe FROM clientes WHERE rut = '22.222.222-2';" debería devolver 0, indicando que la clienta no fue insertada.

Mientras que posteriormente, usando la segunda consulta. "SELECT stock AS stock_inalterado FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;" debería devolver el stock original, confirmando que la actualización fue revertida y no se aplicó ningún cambio en la base de datos. El stock original es 115 en este caso.*/