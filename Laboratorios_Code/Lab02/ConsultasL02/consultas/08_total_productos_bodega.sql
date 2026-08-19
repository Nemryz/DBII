SET search_path TO logitrack;

-- 8. Cantidad total de productos almacenados por bodega
-- Inventario no tiene FK directa a bodega: pasa por Ubicaciones (id_ubicacion -> id_bodega)
SELECT b.nombre AS nombre_bodega, SUM(i.stock) AS total_productos
FROM inventario i
JOIN ubicaciones u ON i.id_ubicacion = u.id_ubicacion
JOIN bodega b ON u.id_bodega = b.id_bodega
GROUP BY b.nombre
ORDER BY total_productos DESC;

/* 
Debería de entregar algo como: 

"CD Valparaíso"	2248
"CD Concepción"	2101
"CD Antofagasta"	2079
"CD Santiago Sur"	1208
"Centro de Distribución Santiago Norte"	1062

En caso contrario, revisar la carga de datos en poblacion.sql y la integridad referencial de las tablas involucradas.
*/