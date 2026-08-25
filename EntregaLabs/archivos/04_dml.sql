SET search_path TO logitrack;

INSERT INTO clientes (nombre, rut, direccion, ciudad, telefono, email, fecha_registro)
VALUES ('Juan Pérez', '11.111.111-1', 'Calle Falsa 123', 'Santiago', '555-1234', 'juan.perez@example.com', '2024-06-01');

INSERT INTO productos (sku, nombre, descripcion, peso_kg, precio_unitario, id_categoria)
VALUES ('SKU-TEST-001', 'Producto A', 'Descripción del Producto A', 1.00, 10.99, 1);

UPDATE inventario
SET stock = stock - 5
WHERE id_producto = 1 AND id_ubicacion = 1;

UPDATE proveedores
SET telefono = '555-5678', email = 'proveedor@example.com'
WHERE id_proveedor = 1;

DELETE FROM clientes
WHERE id_cliente = (SELECT id_cliente FROM clientes WHERE rut = '11.111.111-1');

SELECT * FROM clientes WHERE rut = '11.111.111-1';
SELECT * FROM productos WHERE sku = 'SKU-TEST-001';
SELECT * FROM proveedores WHERE id_proveedor = 1;
SELECT * FROM inventario WHERE id_producto = 1 AND id_ubicacion = 1;
