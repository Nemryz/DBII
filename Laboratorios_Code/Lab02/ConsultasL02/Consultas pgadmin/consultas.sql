/* 
5.- Realizaremos además algunas pocas DML básicas: 

a) Insertaremos un nuevo cliente y un nuevo producto siguiendo la estructura de las tablas clientes y productos del archivo 'poblacion.sql'.
*/
SET search_path TO logitrack;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email, fecha_registro) VALUES ('Juan Pérez', '11.111.111-1', 'Calle Falsa 123', 'Santiago', '555-1234', 'juan.perez@example.com', '2024-06-01');

-- se hizo un cambio por error de la consulta propia, porque Clientes.rut y Clientes.ciudad son datos NOT NULL en el archivo de modeloDiagrama.sql, además, rut es un dato único, por lo que no se puede repetir. 

INSERT INTO productos (sku, nombre, descripcion, peso_kg, precio_unitario, id_categoria) VALUES ('SKU-TEST-001', 'Producto A', 'Descripción del Producto A', 1.00, 10.99, 1); 

/* 
B) Actualizaremos ahora el stock de un producto en una ubicación específica. 
*/

UPDATE inventario
SET stock = stock - 5
WHERE id_producto = 1 AND id_ubicacion = 1; -- actualiza el stock del producto 1 en la ubicación 1 

-- Para ser honesto esto es un ejemplo simple, en un escenario real se debería verificar que el stock no sea negativo antes de realizar la actualización. 

/* 
c) Actualizar los datos de un contacto de un proveedor.
*/
UPDATE proveedores
SET telefono = '555-5678', email = 'proveedor@example.com'
WHERE id_proveedor = 1; -- Suponiendo que el proveedor con id_proveedor = 1 es el que queremos actualizar  
-- Debería asegurarse de que el proveedor existe antes de realizar la actualización para evitar errores.

-- d) Elimine un registro d prueba, respetando las restricciones de integridad referencial.
DELETE FROM clientes
WHERE id_cliente = (SELECT id_cliente FROM clientes WHERE rut = '11.111.111-1'); -- Suponiendo que el cliente con rut = '11.111.111-1' es el que queremos eliminar, el de la consulta 5 a)

-- e) Ahora haremos la consulta de los datos ingresados o modificados para verificar los resultados de las operaciones realizadas. 
SELECT * FROM clientes WHERE id_cliente = 1; -- Verificar si el cliente fue eliminado correctamente
SELECT * FROM productos WHERE id_producto = 1; -- Verificar el stock del producto después de la actualización

-- 7.- Creemos una consulta que permita identificar productos con stock bajo, considerando como stock bajo una cantidad menor o igual a un valor definido por el estudiante, según los datos de 'población.sql'.
SELECT p.id_producto, p.nombre AS nombre_producto, i.stock
FROM productos p
JOIN inventario i ON p.id_producto = i.id_producto
WHERE i.stock <= 10; -- Suponiendo que el valor definido para stock bajo es 10   

-- 8.- Cremos una consulta que permite obtener la cantidad total de productos almacenados por bodega, considerando los datos de 'población.sql'.
SELECT b.nombre AS nombre_bodega, SUM(i.stock) AS total_productos
FROM inventario i
JOIN ubicaciones u ON i.id_ubicacion = u.id_ubicacion
JOIN bodega b ON u.id_bodega = b.id_bodega
GROUP BY b.nombre;
/* Veremos que esta consulta devuelve el nombre de cada bodega junto con la cantidad total de productos almacenados en ella. Se utiliza la función de agregación SUM para calcular la cantidad total de productos por bodega, y se agrupa el resultado por el nombre de la bodega.  
Antes había un error dentro de esta consulta, y, era que la tabla estaba escrita en plural, cuando era singular. Y, el "nombre" de la bodega estaba escrito como "nombre_bodega", cuando era "nombre". Por lo que se corrigió el error y ahora la consulta funciona correctamente. Por último, en el "Inventario" no se tiene una FK directa a bodega, tiene id ubicacion, y, la tabla "Ubicaciones" tiene una FK a bodega, por lo que se debe hacer un JOIN adicional para obtener el nombre de la bodega. 
*/

-- 9.- Creemos una consulta que permita identificar los productos asociados a cada proveedor, considerando que un producto puede tener múltiples proveedores, según los datos de 'población.sql'.
SELECT p.id_producto, p.nombre AS nombre_producto, pr.id_proveedor, pr.nombre AS nombre_proveedor
FROM productos p
JOIN producto_proveedor pp ON p.id_producto = pp.id_producto
JOIN proveedores pr ON pp.id_proveedor = pr.id_proveedor;

--  Esta consulta devuelve el id y nombre de cada producto junto con el id y nombre de cada proveedor asociado a ese producto. Se utiliza una tabla intermedia "productos_proveedor" para establecer la relación muchos a muchos entre productos y proveedores. 

-- 10.- Realizaremos un respaldo (backup) de la base de datos implementada mediante pgAdmin o la herramienta pg_dump de PostgreSQL. El comando para realizar un respaldo completo de la base de datos desde la línea de comandos sería el siguiente:
-- pg_dump -U nombre_usuario -h localhost -p puerto nombre_base_de_datos > respaldo.sql
-- Donde:
-- -U: nombre de usuario
-- -h: host
-- -p: puerto
-- nombre_base_de_datos: nombre de la base de datos a respaldar
-- >: redirige la salida del comando a un archivo
-- respaldo.sql: nombre del archivo donde se guardará el respaldo

-- 11.- Crearemos una nueva base de datos en ella el respaldo generado. Verifique que las tablas, restricciones y registros se hayan restaurado correctamente. El comando para restaurar la base de datos desde un archivo de respaldo sería el siguiente:
-- psql -U nombre_usuario -h localhost -p puerto nombre_nueva_base_de_datos < respaldo.sql
-- Donde:
-- -U: nombre de usuario
-- -h: host
-- -p: puerto
-- nombre_nueva_base_de_datos: nombre de la nueva base de datos donde se restaurará el respaldo

-- 12.- Ejecutaremos una transacción que registre una nueva orden, su detalle y el envío asociado (con los datos de la base de datos, siendo 'población.sql'). Confirme todos los cambios utilizando BEGIN y COMMIT. 
-- BEGIN se utiliza para iniciar la transacción, y COMMIT se utiliza para confirmar todos los cambios realizados durante la transacción. Si ocurre algún error durante la transacción, se puede utilizar ROLLBACK para deshacer todos los cambios realizados hasta ese punto. En este caso, se asume que las tablas ordenes, detalle_orden y envios ya existen y están correctamente relacionadas entre sí.

-- Pero si queremos hacer una nueva orden, primero debemos insertar un registro en la tabla ordenes, luego en detalle_orden y finalmente en envios. A continuación se muestra un ejemplo de cómo se podría realizar esta transacción:
BEGIN;

INSERT INTO ordenes (id_cliente, estado, direccion_envio, ciudad_envio) VALUES (1, 'pendiente', 'Av. Bernardo O''Higgins 1234', 'Santiago');

-- VARIANTE pgAdmin4: en lugar de RETURNING ... \gset (solo psql) se usa currval()
-- para recuperar el id_orden recién generado por la secuencia de la tabla ordenes.
INSERT INTO detalle_ordenes (id_orden, id_producto, cantidad, precio_unitario) VALUES (currval('logitrack.ordenes_id_orden_seq'), 1, 2, 10.99);

INSERT INTO envios (id_orden, id_transportista, id_empleado, estado) VALUES (currval('logitrack.ordenes_id_orden_seq'), 1, 1, 'programado');
COMMIT;

-- La transacción anterior inserta una nueva orden para el cliente con id_cliente = 1, luego inserta un detalle de orden para el producto con id_producto = 1, y finalmente inserta un registro de envío asociado a la orden recién creada. Se utiliza RETURNING para obtener el id de la nueva orden y almacenarlo en la variable new_order_id, que se utiliza en las siguientes inserciones. Al final, se confirma la transacción con COMMIT.

-- 13.- Ejecutaremos una transacción de prueba que inserte o modifique registros y posteriormente revierta los cambios utilizando ROLLBACK. Verifique que los cambios no permanezcan almacenados en la base de datos. 

BEGIN;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email) VALUES ('María López', '22.222.222-2', 'Avenida Siempre Viva 456', 'Santiago', '555-6789', 'maria.lopez@example.com');

UPDATE inventario SET stock = stock + 10 WHERE id_producto = 1 AND id_ubicacion = 1;

ROLLBACK;

-- La transacción anterior inserta un nuevo cliente y actualiza el stock de un producto, pero luego se revierte utilizando ROLLBACK. Esto significa que los cambios realizados durante la transacción no se guardarán en la base de datos, y cualquier registro insertado o modificado será descartado. Para verificar que los cambios no permanecen almacenados, se pueden realizar consultas a las tablas clientes y productos para confirmar que el nuevo cliente no existe y que el stock del producto no ha cambiado.

-- 14.- Ejecutaremos una transacción que utilice al menos un SAVEPOINT. Realizaremos modificaciones posteriores al punto de guardado, revierta parcialmente los cambios con ROLLBACK TO SAVEPOINT y confirme los cambios válidos mediante COMMIT utilizando los datos de la base de datos, siendo 'población.sql'.

BEGIN;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email) VALUES ('Carlos García', '33.333.333-3', 'Calle del Sol 789', 'Santiago', '555-9876', 'carlos.garcia@example.com');

SAVEPOINT sp1;

UPDATE inventario SET stock = stock - 5 WHERE id_producto = 1 AND id_ubicacion = 1;

ROLLBACK TO SAVEPOINT sp1;

-- La transacción anterior inserta un nuevo cliente y luego establece un punto de guardado (SAVEPOINT) llamado sp1. Después, se realiza una actualización en el stock de un producto, pero luego se revierte esa actualización utilizando ROLLBACK TO SAVEPOINT sp1. Esto significa que la inserción del nuevo cliente se mantiene, pero la actualización del stock del producto se deshace.

COMMIT;

-- Al final, se confirma la transacción con COMMIT, lo que significa que los cambios realizados antes del SAVEPOINT (la inserción del nuevo cliente) se guardarán en la base de datos, mientras que los cambios realizados después del SAVEPOINT (la actualización del stock del producto) no se guardarán. Para verificar los resultados, se pueden realizar consultas a las tablas clientes y productos para confirmar que el nuevo cliente existe y que el stock del producto no ha cambiado.