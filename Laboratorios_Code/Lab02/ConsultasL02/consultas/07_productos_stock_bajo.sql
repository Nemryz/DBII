SET search_path TO logitrack;

-- 7. Productos con stock bajo
-- Se define como stock bajo una cantidad menor o igual a un valor definido por el estudiante (ejemplo: 10)
SELECT p.id_producto, p.nombre AS nombre_producto, i.stock
FROM productos p
JOIN inventario i ON p.id_producto = i.id_producto
WHERE i.stock <= 10
ORDER BY i.stock;