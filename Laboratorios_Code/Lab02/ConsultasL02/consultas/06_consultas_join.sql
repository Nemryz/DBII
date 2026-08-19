SET search_path TO logitrack;

-- 6. Consultas utilizando JOIN, es una copia de la parte 6 del archivo "Consultas pgadmin/parte_6.sql" pero con los alias corregidos para evitar palabras reservadas de PostgreSQL y además, el search_path se establece al esquema logitrack para evitar problemas de referencia a tablas en el esquema public.
-- a. Órdenes junto con el nombre del cliente que las generó
SELECT
    o.id_orden,
    c.nombre AS nombre_cliente,
    o.fecha_orden,
    o.estado AS estado_orden
FROM ordenes o
JOIN clientes c ON o.id_cliente = c.id_cliente;

-- El resultado esperado es una lista de órdenes con el nombre del cliente correspondiente, la fecha de la orden y el estado de la orden. Si no se establece el search_path al esquema logitrack, la consulta podría fallar si hay tablas con el mismo nombre en el esquema public.

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

-- El resultado esperado es una lista de detalles de órdenes, mostrando el nombre del producto, la categoría, la cantidad solicitada, el precio unitario histórico y el valor total de cada línea de detalle.  

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

-- El resultado esperado es una lista de envíos, mostrando el número de orden, el nombre del cliente, el nombre del transportista, el nombre del empleado responsable y el estado del envío. 

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

-- El resultado esperado es una lista de inventario disponible, mostrando el nombre de la bodega, la ubicación (pasillo, estante, nivel), el nombre del producto, su SKU, el stock disponible y el stock mínimo.