SET search_path TO logitrack;

-- 9. Productos asociados a cada proveedor
-- Un producto puede tener múltiples proveedores (relación N:N vía producto_proveedor)
SELECT p.id_producto, p.nombre AS nombre_producto,
       pr.id_proveedor, pr.nombre AS nombre_proveedor
FROM productos p
JOIN producto_proveedor pp ON p.id_producto = pp.id_producto
JOIN proveedores pr ON pp.id_proveedor = pr.id_proveedor
ORDER BY p.id_producto, pr.id_proveedor;

-- Deben mostrarse todos los productos y sus proveedores asociados, ordenados por id_producto y luego por id_proveedor. Se comprueba que aparecen todos los productos y proveedores, y que los productos sin proveedores no aparecen en el resultado.