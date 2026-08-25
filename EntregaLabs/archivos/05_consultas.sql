SET search_path TO logitrack;

-- Consulta 1: Ordenes junto con el cliente que las genero
SELECT
    o.id_orden,
    c.nombre AS nombre_cliente,
    o.fecha_orden,
    o.estado AS estado_orden
FROM ordenes o
JOIN clientes c ON o.id_cliente = c.id_cliente;

-- Consulta 2: Detalle de cada orden (producto, categoria, cantidad, precio)
SELECT
    do_.id_orden,
    p.nombre AS nombre_producto,
    cat.nombre AS nombre_categoria,
    do_.cantidad AS cantidad_solicitada,
    do_.precio_unitario AS precio_historico,
    (do_.cantidad * do_.precio_unitario) AS valor_total_linea
FROM detalle_ordenes do_
JOIN productos p ON do_.id_producto = p.id_producto
JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY do_.id_orden;

-- Consulta 3: Envios con orden, cliente, transportista y empleado
SELECT
    e.id_envio,
    e.id_orden,
    c.nombre AS nombre_cliente,
    t.nombre AS nombre_transportista,
    emp.nombre AS empleado_responsable,
    e.estado AS estado_envio
FROM envios e
JOIN ordenes o ON e.id_orden = o.id_orden
JOIN clientes c ON o.id_cliente = c.id_cliente
JOIN transportistas t ON e.id_transportista = t.id_transportista
JOIN empleados emp ON e.id_empleado = emp.id_empleado;

-- Consulta 4: Inventario por bodega, ubicacion y producto
SELECT
    b.nombre AS nombre_bodega,
    u.pasillo,
    u.estante,
    u.nivel,
    p.nombre AS nombre_producto,
    p.sku,
    i.stock AS stock_disponible,
    i.stock_minimo
FROM inventario i
JOIN ubicaciones u ON i.id_ubicacion = u.id_ubicacion
JOIN bodega b ON u.id_bodega = b.id_bodega
JOIN productos p ON i.id_producto = p.id_producto
ORDER BY b.nombre, u.pasillo, u.estante, p.nombre;

-- Consulta 5: Productos con stock bajo (umbral: 50)
SELECT p.id_producto, p.nombre AS nombre_producto, i.stock
FROM productos p
JOIN inventario i ON p.id_producto = i.id_producto
WHERE i.stock <= 50
ORDER BY i.stock;

-- Consulta 6: Cantidad total de productos almacenados por bodega
SELECT b.nombre AS nombre_bodega, SUM(i.stock) AS total_productos
FROM inventario i
JOIN ubicaciones u ON i.id_ubicacion = u.id_ubicacion
JOIN bodega b ON u.id_bodega = b.id_bodega
GROUP BY b.nombre
ORDER BY total_productos DESC;

-- Consulta 7: Productos asociados a cada proveedor
SELECT p.id_producto, p.nombre AS nombre_producto,
       pr.id_proveedor, pr.nombre AS nombre_proveedor
FROM productos p
JOIN producto_proveedor pp ON p.id_producto = pp.id_producto
JOIN proveedores pr ON pp.id_proveedor = pr.id_proveedor
ORDER BY p.id_producto, pr.id_proveedor;
