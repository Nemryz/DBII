SET search_path TO logitrack;

-- 7. Productos con stock bajo
-- Se define como stock bajo una cantidad menor o igual a un valor definido por el estudiante (ejemplo: 10)
SELECT p.id_producto, p.nombre AS nombre_producto, i.stock
FROM productos p
JOIN inventario i ON p.id_producto = i.id_producto
WHERE i.stock <= 10
ORDER BY i.stock;

/* El resultado de esta consulta mostrará los productos cuyo stock es menor o igual a 10, junto con su ID y nombre En este caso si consideramos bien los datos de poblacion.sql se tiene que el resultado de la consulta, al ingresar esta consulta en postgresql me entrega que 

No hay resultados, ya que en la tabla inventario no hay ningun producto con stock menor o igual a 10. Esto es porque en la tabla inventario se tiene que el stock minimo es 15, 20, 25, 30 y 35, por lo que no hay ningun producto con stock bajo. De querer hacer que funcione tendríamos que modificar los datos de la tabla inventario para que haya productos con stock menor o igual a 10, o cambiar el valor de comparación en la consulta a un valor mayor o igual a 15, 20, 25, 30 o 35.

Pero si consideramos la consulta con el valor de stock_minimo, podemos crear esta consulta de la siguiente forma:
*/

Select p.id_producto, p.nombre AS nombre_producto, i.stock, i.stock_minimo
From productos p
Join inventario i ON p.id_producto = i.id_producto
Where i.stock <= i.stock_minimo
Order by i.stock;

-- Y, nos seguirá arrojando el mismo resultado, ya que en la tabla inventario no hay ningun producto con stock menor o igual a su stock_minimo.  