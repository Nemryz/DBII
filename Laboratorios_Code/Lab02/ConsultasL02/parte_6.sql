 
SET search_path TO logitrack;

 
 /*6: DESARROLLE AL MENOS TRES CONSULTAS UTILIZANDO JOIN
  

 
- a. Liste las órdenes junto con el nombre del cliente que las generó.
  
-- Relaciona la tabla Ordenes con Clientes usando la clave foránea id_cliente 
  para rescatar el nombre de la empresa contratante.*/
SELECT 
    o.id_orden,
    c.nombre AS nombre_cliente,
    o.fecha_orden,
    o.estado AS estado_orden
FROM ordenes o
JOIN clientes c ON o.id_cliente = c.id_cliente;


 
/*-- b. Muestre el detalle de cada orden, incluyendo producto, categoría, 
      cantidad solicitada y precio o valor asociado.
 
  Conecta la tabla asociativa Detalle_Ordenes con las entidades maestras 
  Productos y Categorias, trayendo el precio_unitario histórico capturado 
  en el momento de la compra y calculando el valor total de la línea.*/
-- CORRECCIÓN: el alias original "do" es palabra reservada de PostgreSQL (DO), por lo que
-- la consulta fallaba con "error de sintaxis en o cerca de «do»". Se renombra a "do_".
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


 
  /*c. Liste los envíos indicando número de orden, cliente, transportista y 
       empleado responsable.
 
    Vincula la tabla Envios con Ordenes para llegar al Cliente original, 
    cruzando además con Transportistas y Empleados para individualizar a los 
    actores involucrados en el despacho.*/
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


 
/* d. Como consulta adicional, muestre el inventario disponible por bodega, 
      ubicación y producto.
 
    Desglosa las existencias en tiempo real cruzando la tabla Inventario con 
    la jerarquía física de almacenamiento (Ubicaciones -> Bodega) y el maestro 
    de Productos.*/
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