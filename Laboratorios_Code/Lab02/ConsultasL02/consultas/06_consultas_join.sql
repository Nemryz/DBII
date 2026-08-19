SET search_path TO logitrack;

-- 6. Consultas utilizando JOIN
-- a. Órdenes junto con el nombre del cliente que las generó
SELECT
    o.id_orden,
    c.nombre AS nombre_cliente,
    o.fecha_orden,
    o.estado AS estado_orden
FROM ordenes o
JOIN clientes c ON o.id_cliente = c.id_cliente;

-- b. Detalle de cada orden, incluyendo producto, categoría, cantidad solicitada y precio o valor asociado
-- (alias do_ para evitar la palabra reservada DO de PostgreSQL)
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

-- c. Envíos indicando número de orden, cliente, transportista y empleado responsable
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

-- d. Inventario disponible por bodega, ubicación y producto
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