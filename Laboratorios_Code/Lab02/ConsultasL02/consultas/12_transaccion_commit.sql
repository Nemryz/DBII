SET search_path TO logitrack;

-- 12. Transacción que registra una nueva orden, su detalle y el envío asociado
-- Confirmada con BEGIN y COMMIT
BEGIN;

INSERT INTO ordenes (id_cliente, estado, direccion_envio, ciudad_envio)
VALUES (1, 'pendiente', 'Av. Bernardo O''Higgins 1234', 'Santiago');

-- currval() devuelve el id_orden recién generado por la secuencia dentro de la sesión actual
-- (equivalente portable de RETURNING ... \gset, funciona en psql y pgAdmin4)
INSERT INTO detalle_ordenes (id_orden, id_producto, cantidad, precio_unitario)
VALUES (currval('logitrack.ordenes_id_orden_seq'), 1, 2, 10.99);

INSERT INTO envios (id_orden, id_transportista, id_empleado, estado)
VALUES (currval('logitrack.ordenes_id_orden_seq'), 1, 1, 'programado');

COMMIT;

-- Verificación: la orden, su detalle y el envío quedaron registrados
SELECT * FROM ordenes WHERE id_orden = currval('logitrack.ordenes_id_orden_seq');
SELECT * FROM detalle_ordenes WHERE id_orden = currval('logitrack.ordenes_id_orden_seq');
SELECT * FROM envios WHERE id_orden = currval('logitrack.ordenes_id_orden_seq'); 

-- Debe entregar lo siguiente: 
-- id_envio | id_orden | id_transportista | id_empleado | fecha despacho | fecha_entrega | estado
-- 51 |	51 | 1 |	1 |	"2026-08-19 12:02:30.129857"                     | NULL	| "programado" | 

-- Es decir, la orden con id_orden=51, su detalle y el envío asociado fueron correctamente registrados en la base de datos.. 