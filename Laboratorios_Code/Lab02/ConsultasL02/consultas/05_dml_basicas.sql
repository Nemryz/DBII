SET search_path TO logitrack;

-- 5. Consultas DML básicas
-- a. Insertar un nuevo cliente y un nuevo producto
INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email, fecha_registro)
VALUES ('Juan Pérez', '11.111.111-1', 'Calle Falsa 123', 'Santiago', '555-1234', 'juan.perez@example.com', '2024-06-01');

INSERT INTO productos (sku, nombre, descripcion, peso_kg, precio_unitario, id_categoria)
VALUES ('SKU-TEST-001', 'Producto A', 'Descripción del Producto A', 1.00, 10.99, 1);

-- Para revisar los datos insertados, se pueden usar las siguientes consultas:
SELECT * FROM clientes WHERE rut = '11.111.111-1';
SELECT * FROM productos WHERE sku = 'SKU-TEST-001';

-- b. Actualizar el stock de un producto en una ubicación específica
UPDATE inventario
SET stock = stock - 5
WHERE id_producto = 1 AND id_ubicacion = 1;

-- Revisar el stock actualizado
SELECT * FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;

-- c. Actualizar los datos de contacto de un proveedor
UPDATE proveedores
SET telefono = '555-5678', email = 'proveedor@example.com'
WHERE id_proveedor = 1;

-- Revisar los datos actualizados del proveedor
SELECT * FROM proveedores WHERE id_proveedor = 1;

-- d. Eliminar un registro de prueba respetando las restricciones de integridad referencial
-- (el cliente insertado en a) no tiene órdenes asociadas, por lo que puede eliminarse)
DELETE FROM clientes
WHERE id_cliente = (SELECT id_cliente FROM clientes WHERE rut = '11.111.111-1');

-- Revisar que el cliente haya sido eliminado, si aparece un registro, significa que no se eliminó correctamente
SELECT * FROM clientes WHERE rut = '11.111.111-1';

-- e. Consultar los datos ingresados o modificados para verificar los resultados de las operaciones, por cierto, es uno a uno las consultas. 
SELECT * FROM clientes WHERE id_cliente = 1;
SELECT * FROM productos WHERE id_producto = 1;
SELECT * FROM proveedores WHERE id_proveedor = 1;
SELECT * FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;