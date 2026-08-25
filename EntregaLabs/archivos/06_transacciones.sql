SET search_path TO logitrack;

-- Transaccion 1: Registrar orden, detalle y envio con COMMIT
BEGIN;

INSERT INTO ordenes (id_cliente, estado, direccion_envio, ciudad_envio)
VALUES (1, 'pendiente', 'Av. Bernardo O''Higgins 1234', 'Santiago');

INSERT INTO detalle_ordenes (id_orden, id_producto, cantidad, precio_unitario)
VALUES (currval('logitrack.ordenes_id_orden_seq'), 1, 2, 10.99);

INSERT INTO envios (id_orden, id_transportista, id_empleado, estado)
VALUES (currval('logitrack.ordenes_id_orden_seq'), 1, 1, 'programado');

COMMIT;

SELECT * FROM ordenes WHERE id_orden = currval('logitrack.ordenes_id_orden_seq');
SELECT * FROM detalle_ordenes WHERE id_orden = currval('logitrack.ordenes_id_orden_seq');
SELECT * FROM envios WHERE id_orden = currval('logitrack.ordenes_id_orden_seq');

-- Transaccion 2: Prueba con ROLLBACK (los cambios NO permanecen)
BEGIN;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email)
VALUES ('María López', '22.222.222-2', 'Avenida Siempre Viva 456', 'Santiago', '555-6789', 'maria.lopez@example.com');

UPDATE inventario SET stock = stock + 10 WHERE id_producto = 1 AND id_ubicacion = 1;

ROLLBACK;

SELECT count(*) AS maria_no_existe FROM clientes WHERE rut = '22.222.222-2';
SELECT stock AS stock_inalterado FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;

-- Transaccion 3: SAVEPOINT, ROLLBACK TO SAVEPOINT y COMMIT
BEGIN;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email)
VALUES ('Carlos García', '33.333.333-3', 'Calle del Sol 789', 'Santiago', '555-9876', 'carlos.garcia@example.com');

SAVEPOINT sp1;

UPDATE inventario SET stock = stock - 5 WHERE id_producto = 1 AND id_ubicacion = 1;

ROLLBACK TO SAVEPOINT sp1;

COMMIT;

SELECT count(*) AS carlos_existe FROM clientes WHERE rut = '33.333.333-3';
SELECT stock AS stock_inalterado FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;
