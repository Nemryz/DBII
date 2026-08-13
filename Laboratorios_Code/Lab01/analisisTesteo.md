# Testeo de la base de datos

## Objetivo

Verificar que el modelo implementado en `modeloDiagrama.sql` y poblado con `poblacion.sql` funciona de acuerdo con el enunciado del laboratorio siendo esto verificar su integridad de datos, relaciones entre entidades y capacidad de responder consultas relevantes para la toma de decisiones en un contexto de logística (almacenamiento, inventario, pedidos y despachos).

## Metodología utilizada para la realización

- Primero se utilizo el entorno de PostgreSQL 15 en formato local. Aunque en los pgadmin4 de la sede vieja son PostgreSQL 16, no existen diferencias significativas en la sintaxis SQL que afecten las consultas realizadas, por lo que se puede considerar que los resultados obtenidos son válidos y reproducibles en ambos entornos.

- Datos, 13 tablas con 50 a 60 registros cada una. Es como se solicita en el primer laboratorio.

- Herramienta utilizada, psql 15 vía línea de comandos para ambos casos, pero este es más eficiente que pgAdmin 4. Las consultas pueden reproducirse idénticamente en pgAdmin 4 sin ningun problema.

- Seguridad, todas las consultas de pruebas negativas se ejecutan dentro de transacciones por medio de `BEGIN ... ROLLBACK`, de modo que ningún INSERT o UPDATE inválido queda persistido. Verificado después con conteos, los datos siguen intactos. Esto es importante para mantener la integridad de los datos durante las pruebas y evitar que errores de prueba afecten el estado de la base de datos.

- Plan de respaldo, ante cualquier daño de datos, re-ejecutar `modeloDiagrama.sql` (recrea el schema) y luego `poblacion.sql` (TRUNCATE guard + carga). Para hacer el TRUNCATE de todas las tablas, se puede usar `TRUNCATE TABLE logitrack.clientes, logitrack.envios CASCADE;` para vaciar todas las tablas relacionadas y mantener la integridad referencial. Esto es útil para reiniciar el estado de la base de datos antes de realizar nuevas pruebas o cargas de datos, es como un "reset" de la base de datos a su estado inicial o un "punto de partida limpio" para nuevas pruebas.

## Consultas de integridad (sin JOINs)

### Conteo de registros por tabla

```sql
SELECT 'clientes' AS tabla, count(*) AS registros FROM logitrack.clientes 
UNION ALL SELECT 'categorias', count(*) FROM logitrack.categorias
ORDER BY registros DESC;
```

Entendamos esta consulta como una forma de verificar que todas las tablas tienen la cantidad mínima de registros requeridos por el laboratorio. Se utiliza `UNION ALL` para combinar los resultados de múltiples consultas `SELECT`, cada una contando los registros de una tabla específica. El resultado final se ordena por el número de registros en orden descendente para facilitar la revisión, siendo estas en total 13 tablas, todas con 50 o más registros (6 tablas con 50, `detalle_ordenes` y `producto_proveedor` con 60). Con esto se cumple el requisito de "al menos 50 registros" cumplido.

Para entenderlo mejor con una analogía, es como si estuviéramos haciendo un inventario de todas las tablas de la base de datos, asegurándonos de que cada una tenga al menos 50 elementos, y luego organizando los resultados para ver cuáles tienen más o menos registros.

Esto nos da una visión general del estado de la base de datos y nos permite identificar rápidamente cualquier tabla que pueda estar por debajo del umbral requerido.

### Violaciones de restricciones CHECK (reglas de negocio)

```sql
SELECT 'stock_negativo' AS tipo, count(*) FROM logitrack.inventario WHERE stock < 0
UNION ALL SELECT 'cantidad_cero_o_menos', count(*) FROM logitrack.detalle_ordenes WHERE cantidad <= 0
```

Tenemos como resultado lo siguiente, 0 violaciones en los 10 CHECKs evaluados (stock, stock_minimo, cantidad, peso_kg, precio_unitario, costo_compra, tiempo_entrega_dias, capacidad_m3, estado de ordenes, estado de envios). Las reglas de negocio funcionan a nivel de base de datos.

Y, se cumple la regla de negocio "una orden debe tener al menos un producto" porque no hay órdenes sin detalle. Pero no se puede imponer un mínimo de filas hijas por fila padre en SQL, por lo que esta regla se controla a nivel de aplicación/transacción, y este nivel, el de aplicación o transacción, es el que garantiza que no existan órdenes sin detalle.

Otro ejemplo, para que se entiendan bien este tipo de testeo, es que si se permite que un producto tenga un precio unitario negativo, esto podría causar problemas en la gestión de inventario y ventas, ya que no se podría calcular correctamente el valor del inventario ni el total de las ventas.

Por consiguiente, esto podría llevar a errores en las consultas y reportes, así como a problemas en la lógica de negocio que dependa de estos valores. Por lo tanto, es muyyy importante asegurarse de que todas las restricciones CHECK estén correctamente implementadas y que no existan violaciones que puedan causar inconsistencias en la base de datos.

Además, nos quitamos un peso de encima al ver que no hay violaciones de las restricciones CHECK, ya que esto significa que los datos cumplen con las reglas de negocio definidas en la db y que no hay registros inválidos que puedan causar problemas en la gestión de inventario y ventas.

### Huérfanos de claves foráneas (los 13 pares FK)

```sql
SELECT 'ordenes->clientes' AS fk, count(*) FROM logitrack.ordenes o
LEFT JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente
WHERE c.id_cliente IS NULL;
-- ... 12 pares mas ...
```

Obtenemos, 0 huérfanos en los 13 pares FK (ordenes->clientes, productos->categoria, producto_proveedor->productos/proveedores, ubicaciones->bodega, inventario->productos/ubicaciones, empleados->bodega, detalle->ordenes/productos, envios->ordenes/transportistas/empleados). Toda fila hija apunta a un padre existente.

Esto confirma que las relaciones entre entidades están correctamente implementadas y que no hay registros huérfanos que puedan causar inconsistencias en la base de datos. Existe otra forma de hacerlo con `NOT EXISTS` en lugar de `LEFT JOIN`, pero el resultado es el mismo, y la sintaxis con `LEFT JOIN` es más fácil de leer y entender. Pero acá esta la sintaxis con `NOT EXISTS` para referencia:

```sql
SELECT 'ordenes->clientes' AS fk, count(*) FROM logitrack.ordenes o
WHERE NOT EXISTS (SELECT 1 FROM logitrack.clientes c WHERE c.id_cliente = o.id_cliente);
-- ... 12 pares mas como los ejemplos con cada tabla ...
```

Bueno, para este caso es más fácil de leer y entender la sintaxis con `LEFT JOIN`, pero en otros casos, `NOT EXISTS` puede ser más eficiente dependiendo del tamaño de las tablas y la complejidad de la consulta.

¿Por qué es importante conocer este tipo de testeo? Bueno lo es debido a qué si existen huérfanos de claves foráneas, esto puede causar problemas de integridad referencial y afectar la consistencia de los datos en la base de datos.

Por ejemplo, si se elimina un cliente que tiene órdenes asociadas, estas órdenes quedarían huérfanas y no tendrían un cliente válido asociado. Esto podría llevar a errores en las consultas y reportes, así como a problemas en la lógica de negocio que dependa de estas relaciones. Por lo tanto, es fundamental asegurarse de que todas las relaciones entre tablas estén correctamente implementadas y que no existan registros huérfanos.

### Duplicados en dominios únicos

```sql
SELECT 'clientes_rut' AS dominio, count(*) FROM (
  SELECT rut FROM logitrack.clientes GROUP BY rut HAVING count(*) > 1) x;
```

En general el uso de duplicación de dominios o valores únicos es importante para garantizar la integridad de los datos y evitar inconsistencias en la base de datos.

Por ejemplo, pensemos a escala de una empresa con miles de clientes, si se permite que dos clientes tengan el mismo RUT, esto podría causar confusión y errores en la gestión de pedidos y envíos, ya que no se podría identificar de manera única a cada cliente. Esto mismo sucede cuando tenemos, por ejemplo, una universidad, si se permite que dos estudiantes tengan el mismo número de identificación, esto podría causar problemas en la gestión de calificaciones y registros académicos, ya que no se podría identificar de manera única a cada estudiante. Por eso, para nosotros cuando nos dan un correo institucional tienen valores numéricos después del primer apellido y antes del @, esto es para evitar duplicados en el correo institucional, y así poder identificar de manera única a cada estudiante.

En este caso, conseguimos 0 duplicados en rut de clientes/empleados/proveedores/transportistas, sku de
productos y nombre de categorias. Lo que es importante para garantizar la integridad de los datos y evitar inconsistencias en la base de datos. Y, bueno si no se entiende, la integridad es la propiedad de los datos que asegura que estos son precisos, consistentes y confiables a lo largo del tiempo. La integridad de los datos es demasiado importante para garantizar la calidad de la información y la toma de decisiones basada en datos confiables.

La integridad es parte de la triada CID (Confidence, Integrity, Durability) de la teoría de bases de datos, que asegura que los datos son confiables y consistentes a lo largo del tiempo, y algo muyyy importante en el tema del ciclo de vida de los datos, ya que si los datos no son confiables, esto puede afectar la toma de decisiones y la eficiencia de los procesos de negocio.  

### Análisis de valores NULL

Bien, ahora veremos los valores NULL en las columnas opcionales, que son `tipo_vehiculo` en transportistas y `fecha_entrega` en envíos. Esto es importante para garantizar nuevamente la integridad de los datos y evitar inconsistencias en la base de datos. Como vimos antes, la integridad nos hace justificar que todo tiene que tener sentido, y si no tiene sentido, entonces es NULL.

Por ejemplo, si un transportista no tiene un tipo de vehículo asignado, entonces es NULL, y si un envío no tiene una fecha de entrega definida, entonces es NULL. Esto es importante para garantizar la integridad de los datos y evitar inconsistencias en la base de datos.

```sql
SELECT 'transportistas_sin_tipo_vehiculo' AS tipo, count(*)
FROM logitrack.transportistas WHERE tipo_vehiculo IS NULL;
```

En este caso usaremos siguiente de este código lo usaremos para verificar los valores NULL en la columna `tipo_vehiculo` de la tabla `transportistas`. El resultado esperado es que haya 4 transportistas sin tipo de vehículo asignado, lo cual es consistente con el diseño de la base de datos, ya que esta columna es opcional.

```sql
SELECT 'envios_sin_fecha_entrega' AS tipo, count(*)
FROM logitrack.envios WHERE fecha_entrega IS NULL;
```

Acá tenemos una consulta similar para verificar los valores NULL en la columna `fecha_entrega` de la tabla `envios`. El resultado esperado es que haya 28 envíos sin fecha de entrega definida, lo cual es consistente con el diseño de la base de datos, ya que esta columna es opcional y corresponde a los envíos que aún no han sido entregados. Y, esta es la razón por la que confirmamos que la integridad de los datos se mantiene, ya que los valores NULL en estas columnas opcionales son válidos y no violan ninguna restricción de la base de datos, y en los archivos poblados se ve que algunos son NULL y otros tienen datos.

## Consultas operativas con JOIN  

Entramos a consultas de tipo JOIN, para quien no recuerde los JOINs son una forma de combinar filas de dos o más tablas basadas en una relación entre ellas. Esto es demaaasiado útil para obtener información más completa y detallada de la base de datos, ya que nos permite combinar datos de diferentes tablas en una sola consulta.

De hecho, los ciberdelincuentes usan los JOINs para hacer ataques de inyección SQL, ya que les permite obtener información de varias tablas a la vez, y si no se tiene cuidado con la seguridad, esto puede ser un problema. Por eso es importante conocer los JOINs y cómo usarlos correctamente para evitar problemas de seguridad.

Un ejemplo, esto es por experiencia y malas amistades que he tenido, ellos usaban los JOINs con datos que no debían tener acceso, y esto les permitía obtener información confidencial de la base de datos, como contraseñas, datos personales, etc. Con datos que habían obtenido de credenciales comprometidas, y esto les permitía hacer ataques de phishing y otros tipos de ataques cibernéticos. En fin, un ejemplo de como funcionan los JOINs en cracking es de la siguiente forma, pero basado en la base de datos de este lab, y no en la vida real, ya que esto es solo un ejemplo "educativo" y no se debe usar para fines maliciosos.

```sql
SELECT * FROM logitrack.ordenes o
JOIN logitrack.clientes c ON o.id_cliente = c.id_cliente
JOIN logitrack.detalle_ordenes d ON o.id_orden = d.id_orden;
```

En este ejemplo que es uno muy simple, un atacante podría usar un JOIN para combinar la tabla de órdenes con la tabla de clientes y la tabla de detalle de órdenes, y así obtener información confidencial de los clientes, como sus nombres, direcciones, números de teléfono, etc. Aunque esto no es tan así, ya que en la vida real, los atacantes suelen usar técnicas más sofisticadas para obtener información confidencial, de hecho una vez con la credencial obtenida, solo tienes que hacer un proceso con ciertas herramientas de forma automatizada y llevarte los datos en formato .csv, y luego hacer un análisis de los datos obtenidos para encontrar información valiosa. Es más, luego con esta información, pueden hacer ataques de phishing más efectivos, ya que pueden personalizar los correos electrónicos y hacer que parezcan más legítimos. Pero si se poseen contraseñas, por ejemplo, podrías usar multiples gestores de contraseñas para ver si la contraseña es la misma en otros servicios, y así obtener acceso a más información confidencial. E ir probando entre cada uno de los sistemas, si ciertos correos existen, y si existen poder ir probando con otras herramientas propias o de terceros para ver si se puede obtener acceso a más información, bueno, por esto es importante saber que tan expuestos están las personas, para esto podrían usar OSINT (Open Source Intelligence) para obtener información pública de las personas, y así poder evitar en un futuro que este tipo de ataques sean más efectivos.  

Bueno mucho texto arriba. Veamos que son los JOINs como repaso. Tenemos INNER JOIN, LEFT JOIN, RIGHT JOIN y FULL OUTER JOIN. Aunque cada uno de estos JOINs tiene su propia sintaxis y uso, todos ellos nos permiten combinar filas de dos o más tablas basadas en una relación entre ellas.

Empezaremos con el INNER JOIN, que es el más común y el que se usa para obtener solo las filas que tienen coincidencias en ambas tablas.

Por ejemplo, si queremos obtener información de las órdenes junto con los clientes y los detalles de las órdenes, podemos usar un INNER JOIN para combinar estas tres tablas y obtener solo las filas que tienen coincidencias en todas ellas.

```sql
SELECT o.id_orden, c.nombre AS cliente, o.estado,
       d.id_producto, d.cantidad, d.precio_unitario
FROM logitrack.ordenes o 
JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente
JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden;
```

Este INNER JOIN combina las tablas `ordenes`, `clientes` y `detalle_ordenes` para obtener información completa de cada orden, incluyendo el nombre del cliente, el estado de la orden, los productos incluidos en la orden, la cantidad de cada producto y el precio unitario.

Continuaremos con el LEFT JOIN, que nos permite obtener todas las filas de la tabla de la izquierda y las filas coincidentes de la tabla de la derecha. Si no hay coincidencias, se rellenan con NULL.

Un ejemplo de LEFT JOIN sería si queremos obtener todas las órdenes, incluyendo aquellas que no tienen detalles de orden asociados. Esto nos permite ver todas las órdenes, incluso si no tienen productos asociados.

```sql
SELECT o.id_orden, c.nombre AS cliente, o.estado,
       d.id_producto, d.cantidad, d.precio_unitario
FROM logitrack.ordenes o
LEFT JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente
LEFT JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden;
```

Sigamos con el RIGHT JOIN, que es similar al LEFT JOIN, pero nos permite obtener todas las filas de la tabla de la derecha y las filas coincidentes de la tabla de la izquierda. Si no hay coincidencias, se rellenan con NULL.

Un ejemplo de RIGHT JOIN sería si queremos obtener todos los detalles de orden, incluyendo aquellos que no tienen órdenes asociadas. Esto nos permite ver todos los detalles de orden, incluso si no tienen órdenes asociadas.

```sql
SELECT o.id_orden, c.nombre AS cliente, o.estado,
       d.id_producto, d.cantidad, d.precio_unitario
FROM logitrack.ordenes o
RIGHT JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente
RIGHT JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden;
```

Aunque como puedes ver, existe LEFT JOIN y RIGHT JOIN, pero en la práctica, el LEFT JOIN es más comúnmente utilizado que el RIGHT JOIN, ya que es más fácil de leer y entender. Además, el LEFT JOIN es más eficiente en términos de rendimiento, ya que solo necesita escanear una tabla en lugar de dos.

Pero, para identificar mejor el RIGHT JOIN, podemos usar un ejemplo más claro. Supongamos que tenemos una tabla de clientes y una tabla de órdenes, y queremos obtener todos los clientes, incluso aquellos que no tienen órdenes asociadas. En este caso, podemos usar un RIGHT JOIN para obtener todos los clientes y las órdenes asociadas, si las hay.

```sql
SELECT c.nombre AS cliente, o.id_orden, o.estado
FROM logitrack.clientes c
RIGHT JOIN logitrack.ordenes o ON o.id_cliente = c.id_cliente;
```

Aunque al comienzo si no entiendes esto, podrías pensar en lo siguiente, "¿por qué no usar un LEFT JOIN en lugar de un RIGHT JOIN?" Bueno, la respuesta es que depende de la perspectiva que quieras tomar. Si quieres ver todos los clientes y sus órdenes asociadas, entonces usarías un LEFT JOIN. Pero si quieres ver todas las órdenes y los clientes asociados, entonces usarías un RIGHT JOIN. Pero acá no terminas sabiendo porqué usar uno u otro, ya que ambos te dan la misma información, pero desde diferentes perspectivas.

Bueno, también, pensemos que LEFT y RIGHT JOIN tienen una lógica algo diferente de entender la primera vez, dado que mucha gente se confunde con lo siguiente, ¿Cuando sabemos que una tabla tiene datos a la derecha y a la izquierda?, esto es más fácil de entender si pensamos en la consulta como una frase en inglés. Por ejemplo, si decimos "quiero todos los clientes y sus órdenes asociadas", entonces estamos hablando de los clientes primero, y luego de las órdenes asociadas. En este caso, los clientes están a la izquierda y las órdenes están a la derecha. Por lo tanto, usaríamos un LEFT JOIN para obtener todos los clientes y sus órdenes asociadas. Mientras que si decimos "quiero todas las órdenes y los clientes asociados", entonces estamos hablando de las órdenes primero, y luego de los clientes asociados. En este caso, las órdenes están a la izquierda y los clientes están a la derecha. Por lo tanto, usaríamos un RIGHT JOIN para obtener todas las órdenes y los clientes asociados. Esta es una mejor forma de entender la lógica de LEFT y RIGHT JOIN, ya que nos permite visualizar la relación entre las tablas y cómo se combinan los datos. Y, bueno es matemática pura, ya que si tenemos A LEFT JOIN B, es lo mismo que B RIGHT JOIN A, y viceversa. Esto es importante para entender la lógica de los JOINs y cómo se relacionan entre sí.

Pensemos en el álgebra relacional, donde tenemos conjuntos de datos y operaciones entre ellos. Recordemos los conceptos de unión, intersección y diferencia de conjuntos.

En este caso, el INNER JOIN representa la intersección de dos conjuntos, donde solo obtenemos los elementos que están presentes en ambos conjuntos. Mientras que el LEFT JOIN representa la unión de dos conjuntos, donde obtenemos todos los elementos del conjunto izquierdo y los elementos coincidentes del conjunto derecho. El RIGHT JOIN representa la unión de dos conjuntos, donde obtenemos todos los elementos del conjunto derecho y los elementos coincidentes del conjunto izquierdo.

Continuaremos con el FULL OUTER JOIN, que nos permite obtener todas las filas de ambas tablas, combinando las coincidencias y rellenando con NULL donde no hay coincidencias. Esto nos permite ver todos los datos de ambas tablas, incluso si no tienen coincidencias. Como vimos anteriormente, la visión de los LEFT y los RIGHT JOINs es más fácil de entender si pensamos en la consulta con una frase en la cabeza. Pero el uso del FULL OUTER JOIN es menos común en la práctica, ya que puede generar resultados más complejos y difíciles de interpretar. Sin embargo, puede ser útil en ciertos casos donde necesitamos ver todos los datos de ambas tablas, incluso si no tienen coincidencias.

Por ejemplo, si queremos obtener todos los clientes y todas las órdenes, incluso si no tienen coincidencias, podemos usar un FULL OUTER JOIN para combinar ambas tablas y obtener todos los datos. Esto nos permite ver todos los clientes y todas las órdenes, incluso si no tienen coincidencias.

```sql
SELECT c.nombre AS cliente, o.id_orden, o.estado
FROM logitrack.clientes c
FULL OUTER JOIN logitrack.ordenes o ON o.id_cliente = c.id_cliente;
```

Otro ejemplo, si queremos obtener todos los productos y todas las categorías, incluso si no tienen coincidencias, podemos usar un FULL OUTER JOIN para combinar ambas tablas y obtener todos los datos. Esto nos permite ver todos los productos y todas las categorías, incluso si no tienen coincidencias.

```sql
SELECT p.nombre AS producto, cat.nombre AS categoria
FROM logitrack.productos p
FULL OUTER JOIN logitrack.categorias cat ON cat.id_categoria = p.id_categoria;
```

Además, es importante mencionar, especialmente, dado que el LEFT JOIN y el RIGHT JOIN son comunes para el tema de ver ciertos datos, desde ciertas perspectivas, este último JOIN, no es tan común como recalco, pero, una técnica utilizada sería usar un FULL OUTER JOIN para obtener todos los datos de ambas tablas, y luego filtrar los resultados según nuestras necesidades. Mediante el uso de cláusulas WHERE y condiciones adicionales. Aunque también podríamos usar primero un FULL OUTER JOIN y luego un LEFT JOIN o RIGHT JOIN para obtener los datos que necesitamos. Esto nos permite tener más control sobre los resultados y asegurarnos de que estamos obteniendo la información correcta. Y es más entendible si tienes problemas con el uso de LEFT y RIGHT JOIN.

Aunque a nivel de optimización, el FULL OUTER JOIN puede ser más costoso en términos de rendimiento, ya que necesita escanear ambas tablas y combinar los resultados, pero si antes hacemos lo que mencione de usar posterior a un FULL OUTER JOIN un LEFT o RIGHT JOIN, podemos reducir la cantidad de datos que necesitamos procesar y mejorar el rendimiento de la consulta, sería como usar un LEFT o un RIGHT JOIN normal, pero con más control de lo que queremos.

Continuemos con lo que veníamos en realidad, ya se termino el repaso de los JOINs.

### Orden completa: cliente + productos + total por orden (3 JOINs + agregación)

En este caso, vamos a realizar una consulta que nos permita obtener información completa de las órdenes, incluyendo el cliente asociado, los productos incluidos en la orden y el total de la orden calculado a partir del detalle de la orden. Esto nos permite tener una visión completa de cada orden y nos ayuda a analizar las ventas y el rendimiento de los clientes.

Identificaremos primero las tablas involucradas en la consulta: `ordenes`, `clientes` y `detalle_ordenes`. Luego, realizaremos los JOINs necesarios para combinar estas tablas y obtener la información deseada. Finalmente, utilizaremos funciones de agregación para calcular el total de la orden y el número de líneas de detalle. En este caso si seguimos la frase "quiero todas las órdenes y sus clientes asociados, y los productos incluidos en la orden", entonces estamos hablando de las órdenes primero, luego de los clientes asociados, y finalmente de los productos incluidos en la orden. En este caso, las órdenes están a la izquierda, los clientes están en el medio, y los productos están a la derecha. Por lo tanto, usaremos un LEFT JOIN para obtener todas las órdenes y sus clientes asociados, y un INNER JOIN para obtener los productos incluidos en la orden.

Y además, podríamos usar un GROUP BY para agrupar los resultados por orden y cliente, y luego utilizar quizás un ORDER BY para ordenar los resultados según el total de la orden o el número de líneas de detalle. Esto nos permite tener una visión completa de cada orden y nos ayuda a analizar las ventas y el rendimiento de los clientes.

```sql
SELECT o.id_orden, c.nombre AS cliente, o.estado,
       count(d.id_producto) AS lineas,
       sum(d.cantidad * d.precio_unitario) AS total_orden
FROM logitrack.ordenes o
JOIN logitrack.clientes c  ON c.id_cliente = o.id_cliente
JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden
GROUP BY o.id_orden, c.nombre, o.estado
ORDER BY total_orden DESC;
```

Primero analizaremos esta consulta paso a paso. Veremos que se selecciona el "o" que es la tabla de órdenes, luego se selecciona el "c" que es la tabla de clientes, y finalmente se selecciona el "d" que corresponde a la tabla de detalle de órdenes.

Proceguimos con un count de los productos en cada orden, y luego se calcula el total de la orden multiplicando la cantidad por el precio unitario de cada producto. Con esto vemos el uso de las funciones de agregación COUNT y SUM, que nos permiten obtener información resumida de las órdenes y sus detalles.

Si no saben usar count , es como contar cuántos productos hay en cada orden, y si no saben usar sum, es como sumar el total de la orden multiplicando la cantidad por el precio unitario de cada producto.

Continuamos con el FROM que lo que hace es llamar a la tabla de órdenes, y luego se realizan los JOIN de las tablas de ordenes y clientes, aunque como vemos a detalle, en clientes vemos un "ON", esto indica que estamos uniendo las tablas de órdenes y clientes basándonos en la relación entre el id_cliente de ambas tablas. Luego vemos lo mismo en la tabla de detalle de órdenes, donde se hace el JOIN correspondiente y con los id_orden de ambas tablas. Finalmente, se utiliza el GROUP BY para agrupar los resultados por orden, cliente y estado de la orden, y se utiliza el ORDER BY para ordenar los resultados según el total de la orden en orden descendente. Esto nos permite ver las órdenes con mayor valor primero, lo cual es útil para priorizar su atención o seguimiento.

Como resultado, obtenemos 50 órdenes con su cliente asociado, 10 productos por orden y un total de $1.000.000 en ventas. Esto nos permite tener una visión completa de las órdenes y nos ayuda a analizar las ventas y el rendimiento de los clientes.

Este tipo de testeos nos sirven mucho para entender a fondo la lógica los JOINs. Aunque en el laboratorio 2, tenemos algo como listar las ordenes junto al nombre de los clientes que poseemos que podemos hacer con un JOIN del siguiente modo

```sql
SELECT o.id_orden, c.nombre AS cliente
FROM logitrack.ordenes o
JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente;
```

Este tipo de consulta es más simple, pero nos permite obtener información básica de las órdenes y sus clientes asociados. Sin embargo, si queremos obtener información más completa de las órdenes, incluyendo los productos incluidos en la orden y el total de la orden, necesitamos realizar una consulta más compleja con múltiples JOINs y funciones de agregación, como la que vimos anteriormente.

Como inciso b, podemos ver que solicita que se muestre un tipo de detalle de cada orden, incluyendo producto, categoría, cantidad solicitada y precio asociado. Si bien esto se puede hacer con un JOIN, también se puede hacer con una subconsulta, pero en este caso, el uso de JOINs es más eficiente y nos permite obtener la información deseada de manera más clara y concisa.

Haremos otro ejemplo para que se entienda mejor.

```sql
SELECT o.id_orden, c.nombre AS cliente, o.estado,
       d.id_producto, p.nombre AS producto, cat.nombre AS categoria,
       d.cantidad, d.precio_unitario
FROM logitrack.ordenes o
JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente
JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden
JOIN logitrack.productos p ON p.id_producto = d.id_producto
JOIN logitrack.categorias cat ON cat.id_categoria = p.id_categoria;
```

He aquí como sería una consulta más completa que nos permite obtener información detallada de cada orden, incluyendo el cliente asociado, el estado de la orden, los productos incluidos en la orden, la categoría de cada producto, la cantidad solicitada y el precio unitario.

De hecho esto se puede optimizar

```sql
SELECT o.id_orden, c.nombre AS cliente, o.estado,
       d.id_producto, p.nombre AS producto, cat.nombre AS categoria,
       d.cantidad, d.precio_unitario
FROM logitrack.ordenes o
JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente
JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden
JOIN logitrack.productos p ON p.id_producto = d.id_producto
JOIN logitrack.categorias cat ON cat.id_categoria = p.id_categoria
ORDER BY o.id_orden, d.id_producto;
```

A diferencia de la consulta anterior, esta consulta optimizada incluye un `ORDER BY` que nos permite ordenar los resultados por el ID de la orden y el ID del producto. Esto nos facilita la lectura y análisis de los datos, ya que podemos ver todas las órdenes y sus productos asociados de manera organizada, lo que es especialmente útil cuando estamos trabajando con un gran volumen de datos y necesitamos identificar patrones o tendencias en las órdenes y los productos vendidos.

### Inventario por centro de distribución (4 JOINs)

Usar 4 JOINs para obtener información del inventario por centro de distribución nos permite combinar datos de varias tablas relacionadas, como bodegas, ubicaciones, inventario y productos. Esto nos proporciona una visión completa del inventario disponible en cada bodega, incluyendo la cantidad de productos distintos, el total de unidades en stock y el valor total del inventario basado en el precio unitario de cada producto.

```sql
SELECT b.nombre AS bodega, count(DISTINCT i.id_producto) AS productos_distintos,
       sum(i.stock) AS unidades_totales,
       sum(i.stock * p.precio_unitario) AS valor_inventario
FROM logitrack.bodega b
JOIN logitrack.ubicaciones u  ON u.id_bodega = b.id_bodega
JOIN logitrack.inventario i   ON i.id_ubicacion = u.id_ubicacion
JOIN logitrack.productos p    ON p.id_producto = i.id_producto
GROUP BY b.nombre ORDER BY valor_inventario DESC;
```

Veremos como funciona este código a continuación, veamos primero por análisis que tenemos que seleccionar el nombre de la bodega, luego contamos los productos distintos en cada bodega usando `count(DISTINCT i.id_producto)`, sumamos las unidades totales en stock con `sum(i.stock)` y calculamos el valor total del inventario multiplicando el stock por el precio unitario de cada producto con `sum(i.stock * p.precio_unitario)`. Como vimos antes las funciones de agregación COUNT y SUM no las explicaré.

Quizás, el uso del DISTINCT no se entiende, es como contar cuántos productos distintos hay en cada bodega, sin contar los productos repetidos. A grandes rasgos, esto nos permite ver cuántos tipos diferentes de productos tenemos en cada bodega, lo cual es útil para analizar la diversidad del inventario y tomar decisiones sobre la gestión de productos.

En este caso, estamos agrupando por el nombre de la bodega y ordenando por el valor del inventario en orden descendente, lo que nos permite identificar rápidamente cuáles son las bodegas con mayor valor de inventario.

Finalmente, obtenemos 5 bodegas con inventario (10 productos cada una), en las que CD Santiago Norte lidera con $227.739.330 de valor.  

### Envío completo: orden + cliente + transportista + empleado (5 JOINs)

Haremos un ejemplo de 5 JOINs para obtener información completa de los envíos, incluyendo la orden asociada, el cliente, el transportista y el empleado responsable del envío. Esto nos permite tener una visión completa del proceso de envío y nos ayuda a analizar el rendimiento de los envíos y la eficiencia de los empleados y transportistas involucrados.

```sql
SELECT e.id_envio, c.nombre AS cliente, t.nombre AS transportista,
       em.nombre AS empleado, e.estado, e.fecha_despacho
FROM logitrack.envios e
JOIN logitrack.ordenes o        ON o.id_orden = e.id_orden
JOIN logitrack.clientes c       ON c.id_cliente = o.id_cliente
JOIN logitrack.transportistas t ON t.id_transportista = e.id_transportista
JOIN logitrack.empleados em     ON em.id_empleado = e.id_empleado;
```

En este caso identificamos las tablas involucradas en la consulta: `envios`, `ordenes`, `clientes`, `transportistas` y `empleados`. Luego, realizamos los JOINs necesarios para combinar estas tablas y obtener la información deseada. Finalmente, seleccionamos los campos relevantes de cada tabla para obtener una visión completa del envío. Como ya entendemos la lógica nos saltaremos la explicación de los JOINs y nos centraremos en el resultado de la consulta.

Nos va a entregar 50 envíos con su cliente, transportista y empleado asociado, y el estado de cada envío.

### Trazabilidad producto-categoría-proveedor (4 JOINs, N:N)

Explicaremos primero el concepto filosofico de la trazabilidad, que es la capacidad de rastrear y seguir el recorrido de un producto a lo largo de toda la cadena de suministro, desde su origen hasta su destino final. Por ejemplo, Amazon tiene un sistema de trazabilidad que permite rastrear los productos desde el proveedor hasta el cliente final, lo que les permite garantizar la calidad y seguridad de los productos, así como cumplir con las regulaciones y normativas aplicables.

Verifiquemos que esta prueba es para un N:N, es decir, un producto puede tener múltiples proveedores y un proveedor puede suministrar múltiples productos. Esto nos permite tener una visión completa de la relación entre productos, categorías y proveedores, lo que es útil para analizar la cadena de suministro y tomar decisiones sobre la gestión de proveedores y productos. Vamos a tener que usar en total 4 JOINs para combinar las tablas `productos`, `categorias`, `producto_proveedor` y `proveedores`. Esto nos permitirá obtener información detallada sobre cada producto, su categoría, los proveedores asociados y el costo de compra y tiempo de entrega de cada proveedor.

```sql
SELECT p.sku, p.nombre AS producto, cat.nombre AS categoria,
       prv.nombre AS proveedor, pp.costo_compra, pp.tiempo_entrega_dias
FROM logitrack.productos p
JOIN logitrack.categorias cat       ON cat.id_categoria = p.id_categoria
JOIN logitrack.producto_proveedor pp ON pp.id_producto = p.id_producto
JOIN logitrack.proveedores prv      ON prv.id_proveedor = pp.id_proveedor
ORDER BY pp.tiempo_entrega_dias DESC;
```

Acá en el comando podrán ver que tenemos 3 JOINs de forma visible entre el FROM y el ORDER BY, y uno implícito en el SELECT, que es el JOIN entre `producto_proveedor` y `proveedores`.

A ver, creo que acá los deje un poco confundidos, ya que en el SELECT estamos seleccionando campos de la tabla `proveedores`, pero no estamos haciendo un JOIN explícito con esta tabla.

Sin embargo, estamos haciendo un JOIN implícito a través de la tabla `producto_proveedor`, que tiene una relación con la tabla `proveedores` a través del campo `id_proveedor`.

Por lo tanto, aunque no veamos un JOIN explícito con la tabla `proveedores`, estamos obteniendo información de esta tabla a través de la relación con la tabla `producto_proveedor`.

Para entender esto, escribiré como hacer un JOIN implícito desde cero.

¿Qué es un JOIN implícito? Bueno, un JOIN implícito es una forma de combinar filas de dos o más tablas basadas en una relación entre ellas, pero sin usar la sintaxis explícita de JOIN. En lugar de eso, se utiliza la cláusula WHERE para especificar la relación entre las tablas.

Por ejemplo, si queremos obtener información de los productos y sus proveedores, podemos hacer un JOIN implícito de la siguiente manera:

```sql
SELECT p.sku, p.nombre AS producto, prv.nombre AS proveedor
FROM logitrack.productos p, logitrack.proveedores prv, logitrack.producto_proveedor pp
WHERE pp.id_producto = p.id_producto AND pp.id_proveedor = prv.id_proveedor;
```

Funciona igual que un JOIN explícito, pero la sintaxis es diferente. En este caso, estamos combinando las tablas `productos`, `proveedores` y `producto_proveedor` utilizando la cláusula WHERE para especificar la relación entre ellas.

La versión con JOIN explícito es más clara y fácil de leer, especialmente cuando se trabaja con múltiples tablas y relaciones complejas. Por eso, en la práctica, se recomienda utilizar JOIN explícitos en lugar de JOIN implícitos.

Miremos el mismo código para obtener información de los productos y sus proveedores, pero usando JOIN explícitos:

```sql
SELECT p.sku, p.nombre AS producto, prv.nombre AS proveedor
FROM logitrack.productos p
JOIN logitrack.producto_proveedor pp ON pp.id_producto = p.id_producto
JOIN logitrack.proveedores prv ON pp.id_proveedor = prv.id_proveedor;
```

Se dan cuenta que agrega el uso de dos JOINs explícitos para combinar las tablas `productos`, `producto_proveedor` y `proveedores`, lo que hace que la consulta sea más clara y fácil de entender. Pero también sabemos ahora que podemos hacer un JOIN implícito, pero no siempre es recomendable, pero saber que existen nos da más entendimiento de cómo funcionan los JOINs y cómo se pueden utilizar en diferentes situaciones. Pero para este ejemplo ambos funcionan, y nos permiten obtener la información deseada de los productos, categorías y proveedores.

Bueno, sigamos con los 4 JOINs para combinar las tablas `productos`, `categorias`, `producto_proveedor` y `proveedores`.

Al ver el código de este vemos que el ORDER BY pp.tiempo_entrega_dias DESC (el uso del DESC es para ordenar en orden descendente) nos permite ordenar los resultados según el tiempo de entrega de cada proveedor en orden descendente, lo que nos permite identificar rápidamente cuáles son los proveedores con mayor tiempo de entrega y tomar decisiones sobre la gestión de proveedores y productos. Pero también podemos ordenar por el costo de compra, para ver cuáles son los proveedores más caros y cuáles son los más baratos. Esto nos permite tomar decisiones sobre la gestión de proveedores y productos, y nos ayuda a optimizar la cadena de suministro y reducir costos.

### Cumplimiento de despacho (anti-JOIN)

¿Qué es un anti-JOIN? Esto es una técnica dentro de lo que es el testeo de SQL que nos permite identificar registros en una tabla que no tienen coincidencias en otra tabla. En este caso, queremos identificar las órdenes que no tienen un envío asociado, lo que nos permite evaluar el cumplimiento de despacho y tomar decisiones sobre la gestión de órdenes y envíos.

```sql
SELECT o.id_orden, o.estado
FROM logitrack.ordenes o
LEFT JOIN logitrack.envios e ON e.id_orden = o.id_orden
WHERE e.id_envio IS NULL;
```

Identifiquemos como lo hemos venido haciendo, primero seleccionamos el ID de la orden y el estado de la orden desde la tabla `ordenes`. Luego, realizamos un LEFT JOIN con la tabla `envios` para combinar las órdenes con sus envíos asociados. Finalmente, utilizamos la cláusula WHERE para filtrar los resultados y obtener solo las órdenes que no tienen un envío asociado, es decir, aquellas órdenes que no tienen coincidencias en la tabla `envios`.

El resultado esperado es que haya 0 órdenes sin envío, lo cual es consistente con el diseño de la base de datos, ya que todas las órdenes tienen un envío asociado.

¿Por qué usamos este tipo de testeo específicamente? Bueno, el uso de un anti-JOIN nos permite identificar rápidamente las órdenes que no tienen un envío asociado, lo que nos ayuda a evaluar el cumplimiento de despacho y tomar decisiones sobre la gestión de órdenes y envíos.

Además, el uso de un LEFT JOIN nos permite obtener todas las órdenes, incluso aquellas que no tienen un envío asociado, lo que nos proporciona una visión completa del estado de las órdenes y nos ayuda a identificar posibles problemas o áreas de mejora en el proceso de despacho.

Porque imaginemos en el caso hipotético si tenemos problemas con el cumplimiento de despacho, podríamos tener órdenes que no tienen un envío asociado, miremos el caso de Amazon de nuevo, si un cliente realiza un pedido y el sistema de Amazon no genera un envío asociado a esa orden, el cliente podría recibir un mensaje de error o una notificación de que su pedido no se ha procesado correctamente. Esto podría generar frustración y desconfianza en el cliente, lo que podría afectar negativamente la reputación de Amazon y su relación con los clientes. Es un gran ejemplo de cómo el uso de un anti-JOIN nos permite identificar rápidamente las órdenes que no tienen un envío asociado y tomar decisiones sobre la gestión de órdenes y envíos para evitar problemas de cumplimiento de despacho y mejorar la experiencia del cliente. Aunque si lo basamos en el código de Python un anti-JOIN es más como una excepción, ya que nos permite identificar registros que no cumplen con una condición específica, lo que nos ayuda a tomar decisiones sobre la gestión de datos y procesos en la base de datos.

## Consultas analíticas para la toma de decisiones

Hemos llegado a las consultas analíticas, que nos permiten obtener información valiosa para la toma de decisiones en la gestión de órdenes, clientes, productos y envíos.

Este tipo de consultas nos ayudan a identificar patrones, tendencias y áreas de mejora en el proceso de ventas y despacho, lo que nos permite optimizar la gestión de la cadena de suministro y mejorar la experiencia del cliente.

¿Por qué son importantes estas consultas?

Para ser honestos, las consultas analíticas nos permiten obtener información valiosa sobre el rendimiento de la empresa, identificar oportunidades de mejora y tomar decisiones informadas sobre la gestión de órdenes, clientes, productos y envíos. Complementemos esto con el uso de herramientas relacionados con Big Data, con las herramienta de Apache Spark, podemos procesar grandes volúmenes de datos y obtener información valiosa sobre el rendimiento de la empresa, lo que nos permite optimizar la gestión de la cadena de suministro y mejorar la experiencia del cliente. Pero mediante esto, podemos identificar patrones y tendencias en el comportamiento de los clientes, lo que nos permite personalizar la experiencia del cliente y mejorar la satisfacción del cliente. Obviamente, esto es a nivel demaaaasiado simplificado, en realidad es más complejo.

### Ventas por cliente (filtrando canceladas)

Llegamos a ventas por cliente, utilizaremos lo que se conoce como filtrando por canceladas, es decir, vamos a excluir las órdenes que han sido canceladas para obtener una visión más precisa de las ventas reales por cliente. Esto nos permite identificar a los clientes más valiosos y tomar decisiones sobre la gestión de relaciones con los clientes y la estrategia de ventas como un caso hipotético obviamente, porque son datos poblados.

```sql
SELECT c.nombre AS cliente, count(DISTINCT o.id_orden) AS ordenes_validas,
       sum(d.cantidad * d.precio_unitario) AS ventas_totales
FROM logitrack.clientes c
JOIN logitrack.ordenes o ON o.id_cliente = c.id_cliente AND o.estado <> 'cancelada'
JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden
GROUP BY c.nombre ORDER BY ventas_totales DESC;
```

Veamos detalladamente la consulta, primero seleccionamos el nombre del cliente desde la tabla `clientes`. Luego, contamos las órdenes válidas utilizando `count(DISTINCT o.id_orden)` para asegurarnos de no contar órdenes duplicadas. A continuación, calculamos las ventas totales sumando la cantidad de productos multiplicada por el precio unitario de cada detalle de orden. Luego realizamos los JOINs necesarios para combinar las tablas `clientes`, `ordenes` y `detalle_ordenes`, asegurándonos de excluir las órdenes canceladas mediante la condición `o.estado <> 'cancelada'`. Finalmente, agrupamos los resultados por el nombre del cliente y ordenamos por las ventas totales en orden descendente.

Nos debería de entregar un resultado relacionado con los clientes y sus ventas totales, excluyendo las órdenes canceladas. Esto nos permite identificar a los clientes más valiosos y tomar decisiones sobre la gestión de relaciones con los clientes y la estrategia de ventas. Pero si vemos los datos poblados de 'población.sql', nos damos cuenta que todas las órdenes tienen su envío asociado, por lo que no hay órdenes canceladas en este caso. Por lo tanto, el resultado de la consulta nos mostrará todas las órdenes válidas y sus ventas totales por cliente. Pero si modificaramos unos datos para tener órdenes canceladas, podríamos ver cómo la consulta excluye esas órdenes y nos proporciona una visión más precisa de las ventas reales por cliente.

### Productos más vendidos (TOP 5)

Ahora veremos esto de productos más vendidos, que nos permite identificar los productos más populares y tomar decisiones sobre la gestión de inventario y la estrategia de ventas en casos obviamente hipotéticos considerando que los datos son ficticios.  

```sql
SELECT p.sku, p.nombre, sum(d.cantidad) AS unidades_vendidas
FROM logitrack.detalle_ordenes d
JOIN logitrack.productos p ON p.id_producto = d.id_producto
GROUP BY p.sku, p.nombre ORDER BY unidades_vendidas DESC LIMIT 5;
```

Veamos que en esta consulta seleccionamos el SKU y el nombre del producto desde la tabla `productos`. Luego, sumamos la cantidad de unidades vendidas utilizando `sum(d.cantidad)` para obtener el total de unidades vendidas por producto. A continuación, realizamos un JOIN con la tabla `detalle_ordenes` para combinar los datos de productos y detalles de órdenes. Finalmente, agrupamos los resultados por SKU y nombre del producto, ordenamos por unidades vendidas en orden descendente y limitamos los resultados a los 5 productos más vendidos.

Con atención detengamonos en el "GROUP BY p.sku, p.nombre ORDER BY unidades_vendidas DESC LIMIT 5".

El GROUP BY nos permite agrupar los resultados por SKU y nombre del producto, lo que permite obtener el total de unidades vendidas por producto. A su vez, el ORDER BY permitirá ordenar los resultados por unidades vendidas en orden descendente (al usar el DESC), lo que nos permite identificar rápidamente los productos más populares. Pero además, tenemos un LIMIT 5, que nos permite limitar los resultados a los 5 productos más vendidos.

Ahora, como nunca he mostrado un LIMIT dentro de este archivo, veamos que el LIMIT nos permite limitar la cantidad de resultados devueltos por la consulta, lo que es útil cuando queremos obtener solo una parte de los resultados, como en este caso, donde queremos obtener solo los 5 productos más vendidos. Bueno, no solo productos obviamente, también podemos usar LIMIT para obtener los 10 clientes con mayores ventas, los 3 transportistas con más envíos, o cualquier otro conjunto de resultados que queramos limitar. Esto nos permite enfocarnos en los resultados más relevantes y tomar decisiones informadas sobre la gestión de inventario, ventas y relaciones con los clientes.

### Valor del inventario por bodega

En este caso queremos calcular el valor total del inventario en cada bodega, lo que nos permite identificar las bodegas con mayor valor de inventario.

```sql
SELECT b.nombre AS bodega, sum(i.stock * p.precio_unitario) AS valor_inventario
FROM logitrack.inventario i
JOIN logitrack.ubicaciones u ON u.id_ubicacion = i.id_ubicacion
JOIN logitrack.bodega b      ON b.id_bodega = u.id_bodega
JOIN logitrack.productos p   ON p.id_producto = i.id_producto
GROUP BY b.nombre ORDER BY valor_inventario DESC;
```

Ya vamos terminando (son las 01:49 A.M.), veremos que este código anterior dedicado a ver el valor del inventario por bodega, selecciona el nombre de la bodega desde la tabla `bodega`.

Luego, calcula el valor total del inventario multiplicando el stock de cada producto por su precio unitario y sumando los resultados utilizando `sum(i.stock * p.precio_unitario)`.

A continuación, realizamos los JOINs necesarios para combinar las tablas `inventario`, `ubicaciones`, `bodega` y `productos`. Finalmente, agrupamos los resultados por el nombre de la bodega y ordenamos por el valor del inventario en orden descendente (DESC).

Debería de entregar algo como: CD Santiago Norte $227.739.330, CD Santiago Sur $227.739.330, CD Santiago Centro $227.739.330, CD Santiago Este $227.739.330, CD Santiago Oeste $227.739.330.

Aunque para mi esto tendríamos que revisar bien todo, porque el valor del inventario por bodega debería variar según la cantidad de productos y su precio unitario en cada bodega. Pero como los datos son ficticios, es posible que todas las bodegas tengan el mismo valor de inventario en este caso.

Y, a su vez, puede generar confusión, ya que el valor del inventario por bodega debería reflejar la cantidad de productos y su precio unitario en cada bodega, lo que nos permitiría identificar las bodegas con mayor valor de inventario y tomar decisiones sobre la gestión de inventario y la estrategia de ventas.  

Este testeo creo que lo haré desde cero porque tengo dudas.

### Distribución de órdenes por estado

Acá tenemos una consulta que nos permite obtener la distribución de órdenes por estado, lo que nos permite identificar el estado de las órdenes y tomar decisiones respecto a la gestión de órdenes y envíos.

```sql
SELECT estado, count(*) AS ordenes FROM logitrack.ordenes
GROUP BY estado ORDER BY ordenes DESC;
```

Esta consulta selecciona el estado de la orden desde la tabla `ordenes`. Luego, cuenta la cantidad de órdenes en cada estado utilizando `count(*)`. A continuación, agrupamos los resultados por estado y ordenamos por la cantidad de órdenes en orden descendente (DESC). Es más fácil que todas las que hemos visto anteriormente a lo largo de todo el documento, pero nos permite obtener información valiosa sobre la distribución de órdenes por estado y tomar decisiones sobre la gestión de órdenes y envíos.

Considerando los datos de 'poblacion.sql' debería de entregar algo como: pendiente 50, despachada 50, entregada 22, cancelada 0. De no ser así, podríamos tener un problema con la población de datos o con la lógica de la consulta.

### Órdenes con más de una línea (valida el N:N Orden-Producto)

Esto de acá trata de validar el N:N entre órdenes y productos, es decir, identificar las órdenes que tienen más de una línea de detalle, lo que nos permite evaluar la complejidad de las órdenes y tomar decisiones sobre la gestión de órdenes y envíos.

```sql
SELECT count(*) FROM (
  SELECT id_orden FROM logitrack.detalle_ordenes
  GROUP BY id_orden HAVING count(*) > 1) x;
```

En la consulta anterior, primero seleccionamos el ID de la orden desde la tabla `detalle_ordenes`. Luego, agrupamos los resultados por ID de orden y utilizamos la cláusula HAVING para filtrar las órdenes que tienen más de una línea de detalle. Finalmente, contamos la cantidad de órdenes que cumplen con esta condición utilizando `count(*)`. Aunque consideremos que todo esto esta dentro de una subconsulta, lo que nos permite obtener el resultado final de la cantidad de órdenes con más de una línea de detalle. La consulta en sí es la del SELECT count(*) FROM ( ... ) x; y el resto es la subconsulta que nos permite obtener el resultado final.

Por ciert, el HAVING es una cláusula que nos permite filtrar los resultados de una consulta después de que se han agrupado, lo que nos permite aplicar condiciones a los resultados agrupados y obtener información más precisa sobre las órdenes y sus detalles.

En este caso, estamos utilizando HAVING para filtrar las órdenes que tienen más de una línea de detalle, lo que nos permite evaluar la complejidad de las órdenes y tomar decisiones sobre la gestión de órdenes y envíos.

Y, finalmente, el resultado esperado es que haya 10 órdenes con más de una línea de detalle, lo cual es consistente con el diseño de la base de datos, ya que todas las órdenes tienen al menos una línea de detalle y algunas tienen múltiples líneas de detalle.

### Tiempo promedio de entrega (OTIF base)

Acá entramos con el tiempo promedio de entrega, que nos permite evaluar el rendimiento de los envíos y tomar decisiones sobre la gestión de envíos y la estrategia de ventas.

Es muy importante considerar que el tiempo promedio de entrega se calcula como la diferencia entre la fecha de entrega y la fecha de despacho, lo que nos permite obtener una medida precisa del tiempo que tarda un envío en llegar a su destino. Además, esto también de acuerdo con la metodología OTIF (On Time In Full), que nos permite evaluar el cumplimiento de los envíos y tomar decisiones sobre la gestión de envíos y la estrategia de ventas.

Pero en mi enfoque que tampoco es tan avanzado, tenemos que tener bien en consideración las tablas que vamos a usar, dado que si estas tienen un conflicto con los parametros del DATE o el TIMESTAMP, podemos tener problemas con la consulta. Por lo tanto, es importante asegurarse de que las tablas involucradas en la consulta tengan los tipos de datos correctos y que los valores de fecha y hora estén en el formato adecuado para evitar errores en la consulta.

¿Y como podemos saber que no hay conflictos? Bueno, podemos revisar la estructura de las tablas involucradas en la consulta y verificar los tipos de datos de las columnas de fecha y hora. Esto quiere decir que tenemos que asegurarnos de que las columnas `fecha_despacho` y `fecha_entrega` en la tabla `envios` tengan el tipo de datos adecuado, como `DATE` o `TIMESTAMP`, para que podamos calcular correctamente la diferencia entre estas fechas y obtener el tiempo promedio de entrega. Ambos tienen que ser del mismo tipo de datos, ya que si uno es DATE y el otro es TIMESTAMP, podemos tener problemas al calcular la diferencia entre estas fechas, con esto ya aprendimos algo nuevo, y es que tenemos que tener cuidado con los tipos de datos de las columnas de fecha y hora en las tablas involucradas en la consulta para evitar errores y obtener resultados precisos en el cálculo del tiempo promedio de entrega.

Además, podemos realizar testeos con valores de fecha y hora para asegurarnos de que la consulta funcione correctamente y devuelva los resultados esperados.

También podemos utilizar funciones de conversión de fecha y hora para asegurarnos de que los valores estén en el formato adecuado para la consulta. Esto es algo que podemos hacer con la función `TO_TIMESTAMP` o `TO_DATE` en PostgreSQL, dependiendo del tipo de datos que estemos utilizando. Pero normalmente no es necesario, ya que si las columnas tienen el tipo de datos adecuado, la consulta debería funcionar correctamente sin necesidad de realizar conversiones adicionales.

¿Pero cuando usamos entonces TO_TIMESTAMP o TO_DATE? Estos se usan cuando tenemos valores de fecha y hora en un formato diferente al esperado por la base de datos, o cuando necesitamos convertir cadenas de texto a tipos de datos de fecha y hora para poder realizar cálculos o comparaciones. Por ejemplo, si tenemos una columna que almacena fechas como cadenas de texto en el formato 'YYYY-MM-DD', podemos utilizar `TO_DATE` para convertir esas cadenas a tipo de datos DATE y poder realizar cálculos de diferencia entre fechas. Aunque para ser más precisos, cuando la base de datos sea en tiempo real, es decir, que se actualice constantemente, es recomendable utilizar `TO_TIMESTAMP` para convertir las cadenas de texto a tipo de datos TIMESTAMP y poder realizar cálculos de diferencia entre fechas y horas. Esto nos permite obtener resultados más precisos y tomar decisiones informadas sobre la gestión de envíos y la estrategia de ventas.

Por ejemplo, imaginemos que poseemos un sistema de seguimiento de envíos en tiempo real, donde los datos se actualizan constantemente y necesitamos calcular el tiempo promedio de entrega de los envíos.

En este caso, podemos utilizar `TO_TIMESTAMP` para convertir las cadenas de texto que representan las fechas y horas de despacho y entrega a tipo de datos TIMESTAMP, y luego calcular la diferencia entre estas fechas y horas para obtener el tiempo promedio de entrega. Esto nos permite evaluar el rendimiento de los envíos en tiempo real y tomar decisiones informadas sobre la gestión de envíos y la estrategia de ventas.

```sql
SELECT round(EXTRACT(EPOCH FROM avg(e.fecha_entrega - e.fecha_despacho)) / 86400.0, 2)
       AS dias_promedio_entrega, count(*) AS envios_entregados
FROM logitrack.envios e WHERE e.estado = 'entregado';
```

Si bien este código nos permite calcular el tiempo promedio de entrega en días, es importante tener en cuenta que el resultado puede variar dependiendo de los datos de la tabla `envios`. Por lo tanto, es recomendable realizar pruebas con diferentes conjuntos de datos para asegurarse de que la consulta funcione correctamente y devuelva resultados precisos. Además, podemos utilizar funciones de agregación como `avg` y `count` para obtener información adicional sobre el rendimiento de los envíos y tomar decisiones informadas sobre la gestión de envíos y la estrategia de ventas.

Igualmente, revisemos que el uso de `EXTRACT(EPOCH FROM ...)` nos permite obtener la diferencia entre las fechas de entrega y despacho en segundos, lo que nos permite calcular el tiempo promedio de entrega en días dividiendo el resultado por 86400.0 (el número de segundos en un día).

Pero bueno, porque es importante el uso de `round(..., 2)`? Bueno, el uso de `round(..., 2)` nos permite redondear el resultado del tiempo promedio de entrega a 2 decimales, lo que nos permite obtener un resultado más legible y fácil de interpretar. Esto es especialmente útil cuando estamos trabajando con grandes volúmenes de datos y necesitamos presentar los resultados de manera clara y concisa. Además, el redondeo a 2 decimales nos permite evitar resultados con demasiados decimales, lo que puede dificultar la interpretación de los resultados y generar confusión en la toma de decisiones sobre la gestión de envíos y la estrategia de ventas.

### Actividad por transportista

```sql
SELECT t.nombre, count(e.id_envio) AS envios_atendidos
FROM logitrack.transportistas t
JOIN logitrack.envios e ON e.id_transportista = t.id_transportista
GROUP BY t.nombre ORDER BY envios_atendidos DESC;
```

Hubo un total de 50 envíos, y cada transportista atendió exactamente 1 envío (los datos asignan uno por transportista). La consulta funciona, pero los datos no ejercitan la regla "un transportista puede manejar múltiples envíos".

## Pruebas negativas (restricciones) con BEGIN...ROLLBACK

| Prueba | Restricción esperada | Resultado |
 -------- | ---------------------- | ----------- |
| INSERT inventario con stock = -5 | CHECK `inventario_stock_check` (stock >= 0) | **RECHAZADO** ✔ |
| INSERT cliente con rut duplicado | UNIQUE `clientes_rut_key` | **RECHAZADO** ✔ |
| INSERT detalle con par (1,1) duplicado | UNIQUE `detalle_ordenes_id_orden_id_producto_key` | **RECHAZADO** ✔ |
| INSERT orden con id_cliente 999 inexistente | FK `ordenes_id_cliente_fkey` | **RECHAZADO** ✔ |
| INSERT orden con estado 'en_el_aire' | CHECK `ordenes_estado_check` | **RECHAZADO** ✔ |
| UPDATE precio del producto 1 a $1 | snapshot del detalle | $1.00 vs detalle **$649.990 intacto** ✔ |

Veamos a fondo esto de las pruebas negativas, es decir, de las restricciones con BEGIN . . . ROLLBACK, que nos permite realizar pruebas de inserción y actualización de datos en la base de datos sin afectar los datos reales.

En este caso se hicieron las que se muestran en la tabla, pero se pueden hacer muchas más pruebas negativas para asegurarse de que las restricciones de la base de datos estén funcionando correctamente y que los datos sean consistentes y válidos.

Aunque destaquemos que la última prueba negativa es un ejemplo de cómo las restricciones de la base de datos pueden proteger la integridad de los datos y garantizar que los cambios realizados en los datos no afecten a otros registros relacionados.

En este caso, al intentar actualizar el precio del producto 1 a $1, la restricción de snapshot del detalle impidió que el cambio afectara al detalle de la orden, lo que garantiza que los datos sean consistentes y válidos.

Pero veamos que algunas tienen sentido, estas pruebas son para encontrar las fallas en las restricciones de la base de datos y asegurarse de que los datos sean consistentes y válidos. Por ejemplo, la prueba de insertar un inventario con stock negativo es una prueba negativa que nos permite asegurarnos de que la restricción CHECK `inventario_stock_check` esté funcionando correctamente y que no se puedan insertar valores negativos en la columna `stock`.

El SERIAL por ejemplo, es una restricción que nos permite asegurarnos de que los valores de la columna `id` sean únicos y se generen automáticamente, lo que garantiza que no haya duplicados en la columna `id`. Esta existe en la tabla `clientes`, y nos permite asegurarnos de que los valores de la columna `id_cliente` sean únicos y se generen automáticamente, lo que garantiza que no haya duplicados en la columna `id_cliente`. Pero nos trae un problema, y es que si hacemos un TRUNCATE de la tabla `clientes`, el SERIAL se desincroniza y tenemos que hacer un `setval` para sincronizar la secuencia y evitar errores de clave primaria al insertar nuevos registros. Esto es especialmente importante en entornos de prueba donde se realizan múltiples truncamientos y cargas de datos. Que bueno que lo hayamos aprendido, porque es una buena práctica para mantener la integridad de las secuencias y evitar errores de clave primaria al insertar nuevos registros.

En esta ocasión no creo necesariamente que quitemos el SERIAL, pero si es importante tener en cuenta que si hacemos un TRUNCATE de la tabla `clientes`, el SERIAL se desincroniza. Pero bueno, para evitar este tipo de prueba, consideremos todo lo mencionado.

Otro ejemplo es la prueba de insertar un cliente con un RUT duplicado, lo que nos permite asegurarnos de que la restricción UNIQUE `clientes_rut_key` esté funcionando correctamente y que no se puedan insertar valores duplicados en la columna `rut`. Esto garantiza que los datos sean consistentes y válidos, y que no haya duplicados en la columna `rut`. En este caso, la prueba fue rechazada correctamente, lo que indica que la restricción UNIQUE está funcionando como se esperaba.

Pero en general, la existencia de este tipo de pruebas en sencillas razones es para encontras fallas dentro de las excepciones de la db.

Bno, que pasaría si no existieran estas restricciones?

Bueno, seamos honestitos, si no existieran estas restricciones, podríamos tener datos inconsistentes y duplicados en la base de datos, lo que podría afectar la integridad de los datos y generar problemas en la gestión de órdenes, clientes, productos y envíos. Por ejemplo, si pudiéramos insertar un inventario con stock negativo, podríamos tener productos que aparecen como disponibles en el inventario cuando en realidad no lo están, lo que podría generar problemas en la gestión de inventario y la estrategia de ventas. Aunque técnicamente en fase de QA, esto no debería pasar, pero si no existieran estas restricciones, podríamos tener problemas en la gestión de inventario y la estrategia de ventas.  

## Rendimiento (EXPLAIN ANALYZE) e índices

Casi terminamos, acá veremos el rendimiento de la consulta de ventas por cliente, que nos permite evaluar el rendimiento de la base de datos y tomar decisiones sobre la optimización de consultas y la gestión de índices.

```sql
EXPLAIN ANALYZE SELECT o.id_orden, c.nombre, d.cantidad, d.precio_unitario
FROM logitrack.ordenes o
JOIN logitrack.clientes c       ON c.id_cliente = o.id_cliente
JOIN logitrack.detalle_ordenes d ON d.id_orden = o.id_orden;
```

Según esta consulta de EXPLAIN ANALYZE, podemos ver que la consulta utiliza Hash Joins para combinar las tablas `ordenes`, `clientes` y `detalle_ordenes`. Esto indica que la base de datos está utilizando un algoritmo de hash para combinar las filas de las tablas, lo que puede ser eficiente para conjuntos de datos grandes.

Primero explicaré mejor que hace EXPLAIN ANALYZE, esta cosa nos permite obtener información detallada sobre cómo se ejecuta una consulta en la base de datos. Incluye el plan de ejecución, el tiempo de ejecución y el número de filas procesadas en cada paso del plan. Esta información nos permite evaluar el rendimiento de la consulta y tomar decisiones sobre la optimización de consultas y la gestión de índices.

Pero arriba mencione que utiliza Hash Joins, y esto es importante porque nos permite combinar las filas de las tablas de manera eficiente, especialmente cuando se trabaja con conjuntos de datos grandes. El uso de Hash Joins puede mejorar significativamente el rendimiento de la consulta y reducir el tiempo de ejecución.

Pero que es un Hash Join? Comencemos a entender que un Hash Join es un algoritmo de combinación de tablas que utiliza una tabla hash para almacenar las filas de una tabla y luego busca las filas coincidentes en la otra tabla utilizando la tabla hash. Con esto en consideración tenemos más abierta la mente.

Como resultado obtenemos 3 Hash Joins sobre Secuencia Completa (Seq Scan) en las tablas, tiempo de ejecución 0.79 ms. Con 50-60 filas es irrelevante, pero el plan confirma:

- Existen 22 índices, 'todos PK o UNIQUE' (creados automáticamente por las restricciones).
   Porque funciona esto? Bueno, los índices PK y UNIQUE permiten a la base de datos buscar rápidamente filas específicas en las tablas, lo que mejora el rendimiento de las consultas y reduce el tiempo de ejecución. Esto es especialmente importante cuando se trabaja con conjuntos de datos grandes, donde la búsqueda de filas específicas puede ser costosa en términos de tiempo y recursos.
   Los índices son fundamentales para el rendimiento de la db.

- Ninguna columna FK tiene índice (`id_cliente`, `id_orden`, `id_producto`, `id_ubicacion`, `id_bodega`, `id_transportista`, `id_empleado`, `id_categoria`). Con volúmenes reales, los JOIN por FK requerirían escaneos costosos. Que quiere decir que ninguna columna FK tiene indice? Significa que las columnas que se utilizan para establecer relaciones entre tablas (FK) no tienen índices asociados, lo que puede afectar negativamente el rendimiento de las consultas que involucran JOINs entre estas tablas. Sin índices en las columnas FK, la base de datos tiene que realizar escaneos completos de las tablas para encontrar las filas coincidentes, es como un ordenamiento de búsqueda lineal, lo que puede ser costoso en términos de tiempo y recursos, especialmente cuando se trabaja con conjuntos de datos grandes.  

- Mejora recomendada, `CREATE INDEX` sobre las columnas FK. Esto se justifica porque la creación de índices en las columnas FK permite a la base de datos buscar rápidamente filas coincidentes en las tablas relacionadas, lo que mejora significativamente el rendimiento de las consultas y reduce el tiempo de ejecución. Esto es especialmente importante cuando se trabaja con conjuntos de datos grandes, donde la búsqueda de filas coincidentes puede ser costosa en términos de tiempo y recursos.

## Hallazgos generales del testeo

1. Integridad total de la base de datos 0 huérfanos FK, 0 duplicados, 0 violaciones CHECK, NULLs solo en
   columnas opcionales por diseño.

   Seamos sinceros este hallazgo se debe a qué el modelo de datos está bien diseñado y las restricciones de integridad están correctamente implementadas, lo que garantiza que los datos sean consistentes y válidos. Pero de ser un caso contrario, si el modelo de datos no estuviera bien diseñado o las restricciones de integridad no estuvieran correctamente implementadas, podríamos tener problemas de integridad en la base de datos, lo que podría afectar negativamente la gestión de órdenes, clientes, productos y envíos. Por lo tanto, es importante asegurarse de que el modelo de datos esté bien diseñado y las restricciones de integridad estén correctamente implementadas para garantizar la integridad de los datos y evitar problemas en la gestión de la base de datos. Además, ninguna de las consultas anteriores que se hicieron podrían haber funcionado correctamente si hubiera problemas de integridad en la base de datos, lo que demuestra la importancia de mantener la integridad de los datos para garantizar el correcto funcionamiento de las consultas y la gestión de la base de datos.

2. El modelo soporta consultas de decisión, es decir, el uso de JOINs de 3 a 5 tablas, agregaciones anti-JOINs y subconsultas funcionan según el enunciado.

   Con este hallazgo muyyy importante nos queda claro que el modelo de datos está bien diseñado y es capaz de soportar consultas complejas que involucran múltiples tablas, agregaciones y subconsultas.

   Siendo capaz de permitir obtener información valiosa para la toma de decisiones en la gestión de órdenes, clientes, productos y envíos.

   Además, el uso de JOINs, agregaciones y subconsultas nos permite combinar datos de diferentes tablas y obtener resultados más completos y precisos, lo que mejora la calidad de la información disponible para la toma de decisiones si pensamos esto como casos reales.  

3. N:N verificados en los datos, esto se puede  explicar por el hecho de que existen productos multi-proveedor (SKU-007) y órdenes multi-línea (10 órdenes).

   Dado este hallazgo, podemos concluir que el modelo de datos es capaz de manejar relaciones de muchos a muchos (N:N) entre productos y proveedores, así como entre órdenes y líneas de detalle. Esto nos permite representar escenarios más complejos y realistas en la gestión de órdenes, clientes, productos y envíos.

   Lo que asegura que el modelo de datos pueda manejar situaciones del mundo real y reflejar mejor la operación de un negocio logístico.

   Aunque, si bien de este modo podemos realizar testeos que no hemos visto aún, como por ejemplo, identificar los productos que tienen múltiples proveedores y las órdenes que tienen múltiples líneas de detalle, lo que nos permite evaluar la complejidad de las relaciones entre productos, proveedores y órdenes. De acuerdo a esto anterior, podemos pensar nuevamente con nuestro ejemlo recurrente, Amazon, donde un producto puede ser ofrecido por múltiples proveedores y una orden puede contener múltiples líneas de detalle, lo que refleja la complejidad de la gestión de órdenes y productos en un negocio logístico. Entre otros tipos de testeos funcionales que se podrían hacer.

4. Snapshot de precio confirmado, las órdenes conservan su precio aunque el producto cambie.

   Para dar consideración inicial, una snapshot es una copia de los datos en un momento específico en el tiempo, lo que nos permite mantener un registro histórico de los precios de los productos en las órdenes, o de la data en general.

   Para este hallazgo, podemos concluir que el modelo de datos es capaz de mantener un registro histórico de los precios de los productos en las órdenes, lo que nos permite conservar la información sobre los precios en el momento en que se realizó la orden, incluso si el precio del producto cambia posteriormente. Consideremos para este hallazgo, además, de que posteriormente podríamos hacer cambios dentro de la data al hacer nuevos datos de prueba, y que esto no llegase a afectar a las órdenes ya existentes. Es algo más complejo que llegaríamos a pensar.

   Para mostrarlo mejor, mostraré el código para que se entienda mejor, y es el siguiente:

   ```sql
   UPDATE logitrack.productos SET precio_unitario = 1 WHERE id_producto = 1;
   SELECT d.precio_unitario FROM logitrack.detalle_ordenes d
   WHERE d.id_orden = 1 AND d.id_producto = 1;
   ```

   En este caso, al actualizar el precio del producto con ID 1 a $1, la consulta de selección del detalle de la orden con ID 1 y producto con ID 1 nos devuelve el precio unitario original de $649.990, lo que demuestra que el modelo de datos conserva el precio confirmado en el momento en que se realizó la orden, incluso si el precio del producto cambia posteriormente.

   Esto nos permite mantener un registro histórico de los precios de los productos en las órdenes y tomar decisiones informadas sobre la gestión de órdenes, clientes, productos y envíos.

   Pero a su vez nos da la posibilidad de hacer testeos de regresión, es decir, podemos realizar pruebas para asegurarnos de que los cambios en los precios de los productos no afecten a las órdenes ya existentes y que el modelo de datos conserve correctamente el precio confirmado en el momento en que se realizó la orden.  

5. Ventas sin filtro de estado son engañosas, dada que la orden cancelada de mayor monto distorsionaría reportes, siempre filtrar `estado <> 'cancelada'`.

   Esto se puede mejorar con un CHECK adicional en la tabla `ordenes` que impida el cambio de estado de una orden cancelada a otro estado. Y, además, se podría agregar un trigger que registre la fecha de cancelación y el motivo, para tener un historial completo de las órdenes canceladas. Pero como es un laboratorio, se deja como hallazgo para futuras mejoras. Y, mejorar con el paso de las semanas.

   Como ejemplo en formato de código considerando el archivo 'poblacion.sql', si se ejecuta la consulta de ventas por cliente sin filtrar las órdenes canceladas, el resultado sería:

   ```sql
   SELECT c.nombre, SUM(o.monto) as total_ventas
   FROM clientes c
   JOIN ordenes o ON c.id = o.cliente_id
   WHERE o.estado <> 'cancelada'
   GROUP BY c.nombre;
   ```

   Esto explica que si no se filtran las órdenes canceladas, el resultado de la consulta podría incluir ventas que no se han concretado, lo que distorsionaría los reportes y podría llevar a tomar decisiones basadas en información incorrecta. Por lo tanto, es importante siempre filtrar las órdenes canceladas para obtener una visión precisa de las ventas reales por cliente. Aunque en realidad en el archivo de 'poblacion.sql' no hay órdenes canceladas, pero si las hubiera, el resultado de la consulta sin filtrar las órdenes canceladas podría incluir ventas que no se han concretado, lo que distorsionaría los reportes y podría llevar a tomar decisiones basadas en información incorrecta. Por lo tanto, es importante siempre filtrar las órdenes canceladas para obtener una visión precisa de las ventas reales por cliente.

6. Desincronización SERIAL tras TRUNCATE con ids explícitos, se recomienda `setval` para sincronizar secuencias si se mezclan estrategias de inserción, el uso de 'setval' es una buena práctica para mantener la integridad de las secuencias y evitar errores de clave primaria al insertar nuevos registros. Esto es especialmente importante en entornos de prueba donde se realizan múltiples truncamientos y cargas de datos.

   Bueno, esto lo explique un poco más arriba, pero es un hallazgo aún así, y es importante tener en cuenta que si se mezclan estrategias de inserción explícitas y automáticas, es recomendable utilizar `setval` para sincronizar las secuencias y evitar errores de clave primaria al insertar nuevos registros.

   En la práctica, nos permite mantener la integridad de las secuencias y garantizar que los valores de las columnas `id` sean únicos y se generen automáticamente, lo que evita problemas de duplicados en la base de datos.

7. Datos poco realistas en 3 dimensiones, por ejemplo, 1 orden por cliente (regla "múltiples órdenes" no ejercitada), 1 envío por transportista/empleado, 0 productos bajo stock mínimo (la alerta de reposición nunca se dispara) y solo 5 de 50 bodegas con stock.  

   Para ponernos en contexto, en el archivo 'poblacion.sql' se generaron datos de prueba que no reflejan escenarios realistas en la gestión de órdenes, clientes, productos y envíos. Considerando este dilema, lo que representamos también es un reflejo de las limitaciones del entorno de prueba y limita la capacidad de realizar pruebas y análisis precisos sobre el rendimiento de la base de datos y la gestión de inventario.

   Pero si llegaramos a hacer pruebas con ALTER TABLE y UPDATE, podríamos generar datos más realistas y reflejar escenarios más complejos y realistas en la gestión de órdenes, clientes, productos y envíos.

   Considerandolo, podríamos hacer algo como esto por ejemplo y aplicar las dimensiones de mejor forma:

   ```sql
   -- Generar múltiples órdenes por cliente
   INSERT INTO logitrack.ordenes (id_cliente, fecha_orden, estado, monto)
   SELECT id_cliente, NOW() - INTERVAL '1 day' * (random() * 10)::int, 'pendiente', (random() * 1000)::numeric(10,2)
   FROM logitrack.clientes
   WHERE id_cliente <= 10; -- Generar órdenes para los primeros 10 clientes

   -- Generar múltiples envíos por transportista/empleado
   INSERT INTO logitrack.envios (id_orden, id_transportista, id_empleado, fecha_despacho, fecha_entrega, estado)
   SELECT id_orden, id_transportista, id_empleado, NOW() - INTERVAL '1 day' * (random() * 10)::int, NOW() - INTERVAL '1 day' * (random() * 10)::int, 'entregado'
   FROM logitrack.ordenes
   JOIN logitrack.transportistas ON random() < 0.5 -- Asignar aleatoriamente transportistas
   JOIN logitrack.empleados ON random() < 0.5 -- Asignar aleatoriamente empleados
   WHERE id_orden <= 50; -- Generar envíos para las primeras 50 órdenes
   etc...
   ```

   Esta pequeña demostración de código lo que nos indica es que podemos generar datos más realistas. Pero explica el uso de ciertas funciones como `random()` para asignar aleatoriamente transportistas y empleados a los envíos. Además, podemos utilizar la función `NOW()` para generar fechas de orden y despacho aleatorias dentro de un rango de tiempo específico, lo que nos permite simular el flujo de órdenes y envíos en un período determinado. Por último, podemos utilizar la cláusula `WHERE` para limitar la cantidad de registros generados y asegurarnos de que los datos sean consistentes y válidos.

   Aunque también utilizamos la función `INTERVAL` para restar un número aleatorio de días a la fecha actual, lo que nos permite generar fechas de orden y despacho aleatorias dentro de un rango de tiempo específico.

   Bueno, tanto código para explicar poco, pero con este hallazgo en sí, podemos concluir que los datos generados en el archivo 'poblacion.sql' no reflejan escenarios realistas. Y si llegaramos a crear datos nuevos en base a la creación de nuevas órdenes, envíos y productos, podríamos aumentar la complejidad en múltiples aspectos.

8. FKs sin índice, correcto a este volumen, problemático a escala. Podemos arreglarlo con `CREATE INDEX` sobre las columnas FK, lo cual mejorará significativamente el rendimiento de las consultas JOIN en bases de datos más grandes. Pero, como es un laboratorio, se deja como hallazgo para futuras mejoras para ser arreglado en las futuras semanas.

   El comando `CREATE INDEX` nos permite crear un índice en una columna específica de una tabla, lo que mejora significativamente el rendimiento de las consultas JOIN al permitir a la base de datos buscar rápidamente filas coincidentes en las tablas relacionadas.

   Es especialmente importante cuando se trabaja con conjuntos de datos grandes, donde la búsqueda de filas coincidentes puede ser costosa en términos de tiempo y recursos. Por lo tanto, es recomendable crear índices en las columnas FK para mejorar el rendimiento de las consultas JOIN y garantizar que la base de datos pueda manejar eficientemente relaciones complejas entre tablas.

   Podemos usar el siguiente comando para crear un índice en la columna `id_cliente` de la tabla `ordenes`:

   ```sql
   CREATE INDEX idx_ordenes_cliente ON logitrack.ordenes (id_cliente);  
   ```

   Este comando crea un índice llamado `idx_ordenes_cliente` en la columna `id_cliente` de la tabla `ordenes`, lo que permite a la base de datos buscar rápidamente filas coincidentes en la tabla `clientes` al realizar consultas JOIN entre estas tablas. Para que ocasiones prodríamos utilizarlo, bueno, podríamos utilizar este índice en consultas que involucren la relación entre órdenes y clientes, como por ejemplo:

   ```sql
   SELECT o.id_orden, c.nombre, o.fecha_orden
   FROM logitrack.ordenes o
   JOIN logitrack.clientes c ON c.id_cliente = o.id_cliente
   WHERE c.nombre LIKE 'Juan%';
   ```

   Esto nos permite obtener información sobre las órdenes realizadas por clientes cuyo nombre comienza con 'Juan', utilizando el índice `idx_ordenes_cliente` para mejorar el rendimiento de la consulta y reducir el tiempo de ejecución.

   El comando anterior posee también algo que no hemos abordado antes, siendo el comando `LIKE`, que nos permite realizar búsquedas de patrones en cadenas de texto, lo que nos permite filtrar los resultados de la consulta según un patrón específico.  

   Si bien el problema inicial del hallazgo que los FKs no posean indice no es un problema a este volumen de datos, es importante tener en cuenta que a medida que la base de datos crece y se manejan conjuntos de datos más grandes, la falta de índices en las columnas FK puede afectar negativamente el rendimiento de las consultas JOIN y generar problemas de eficiencia en la gestión de órdenes, clientes, productos y envíos. Dado que estamos aprendiendo, es importante conocer esto, aunque existen formas en la fase de diseño que podemos pensarla en vez de agregar algo después, como por ejemplo, crear índices en las columnas FK desde el inicio del diseño de la base de datos para garantizar un rendimiento óptimo y evitar problemas de eficiencia en la gestión de órdenes, clientes, productos y envíos.

   Para nuestro caso dado que ya tenemos la base de datos creada, podemos crear índices en las columnas FK utilizando el comando `CREATE INDEX` para mejorar el rendimiento de las consultas JOIN y garantizar que la base de datos pueda manejar eficientemente relaciones complejas entre tablas.

   No es tan dificil de hacer, pero es importante tener en cuenta que la creación de índices puede afectar el rendimiento de las operaciones de inserción, actualización y eliminación en la base de datos, ya que la base de datos tiene que mantener los índices actualizados cada vez que se realizan cambios en los datos. Es como si tuvieramos que mantener un registro adicional de los datos, lo que puede generar una sobrecarga en términos de tiempo y recursos. Es algo un poco técnico el aspecto de la sobrecarga de tiempo y recursos, pero en las leyes de la continuidad del negocio, es algo sumamente importante a tener en cuenta.

## Consultas que se podrían hacer a futuro

En este apartado haremos las consultas que podríamos hacer a futuro, para obtener información valiosa sobre la gestión de órdenes, clientes, productos y envíos, entre otras cosas.

- Reporte mensual de ventas, usando `date_trunc('month', o.fecha_orden)` + estado <> cancelada, esto permitiría analizar las tendencias de ventas a lo largo del tiempo y tomar decisiones estratégicas basadas en datos históricos.

   Acá podemos utilizar la función `date_trunc` para agrupar las órdenes por mes y filtrar las órdenes canceladas, lo que nos permite obtener un reporte mensual de ventas más preciso y útil para la toma de decisiones estratégicas.

   Un ejemplo pequeño de esto con nuestros archivos de prueba podría ser el siguiente:

   ```sql
   SELECT date_trunc('month', o.fecha_orden) AS mes, SUM(o.monto) AS total_ventas
   FROM logitrack.ordenes o
   WHERE o.estado <> 'cancelada'
   GROUP BY mes
   ORDER BY mes;
   ```

   Lo anterior explica que podemos obtener un reporte mensual de ventas agrupando las órdenes por mes y filtrando las órdenes canceladas, lo que nos permite analizar las tendencias de ventas.

- Alertas de reposición, productos con `stock <= stock_minimo` por bodega (hoy devuelve 0 filas), usar 'stock <= stock_minimo' para identificar productos que necesitan ser reabastecidos y evitar rupturas de stock.

   Anteriormente en clases, quede en la duda por lo que comento Engel, como mencione muy arriba del documento, pero podemos utilizar la condición `stock <= stock_minimo` para identificar productos que necesitan ser reabastecidos y evitar rupturas de stock. Si bien podemos usar solamente uno en vez de dejar los otros, dado que no son lo mismo en la práctica. Pero al observar los datos del código el stock_minimo se cumple con la condición `stock (stock >= 0)`, aun quedo con la duda de si dejar o no de usar stock_minimo, aun así es una duda que me gustaría adoptar como grupo en completo.

- OTIF (On Time In Full), esto es un % de envíos entregados dentro del plazo estimado. Nos ayudaría a medir la eficiencia de la cadena de suministro y la satisfacción del cliente. Si es que queremos medir la eficiencia de la cadena de suministro y la satisfacción del cliente, podemos calcular el porcentaje de envíos entregados a tiempo y completos en comparación con el total de envíos realizados.

   Esto ya lo vimos un poco más arriba de hecho.

- Ranking de bodegas, rotación = unidades vendidas vs stock disponible por centro. Lo podemos hacer con una consulta que compare las unidades vendidas con el stock disponible en cada bodega, lo cual nos permitirá identificar qué bodegas tienen una mayor rotación de inventario y cuáles podrían necesitar ajustes en su gestión de stock.

- Trazabilidad completa, orden -> detalle -> producto -> proveedor -> envío -> transportista en un solo JOIN de 6+ tablas. Esto lo hacemos con una consulta de tipo JOIN que nos permitirá seguir el flujo completo de un pedido desde la orden inicial hasta la entrega final, incluyendo todos los actores involucrados en el proceso. Aunque requerira de una comprensión más profunda de las relaciones entre las tablas y cómo se conectan entre sí.

- Análisis ABC de inventario, productos que concentran el 80% del valor en stock. Nos ayudaría a identificar los productos más valiosos en nuestro inventario y priorizar su gestión para maximizar la eficiencia y rentabilidad del negocio. En un caso concreto obviamente.

   Para el que no sabe, un análisis ABC de inventario es una técnica de gestión de inventario que clasifica los productos en tres categorías (A, B y C) según su valor y volumen de ventas.

   Los productos de categoría A son los más valiosos y representan el 80% del valor total del inventario, mientras que los productos de categoría B representan el 15% y los productos de categoría C representan el 5%.

- Rechazos, % de envíos rechazados por transportista y motivo (requeriría columna motivo en Envios o futuro modelo de partes).

- Concentración geográfica, podemos hacer ventas por ciudad_envio para planificar bodegas y rutas de transporte.  

## Detalles a mejorar en la base de datos

1. Índices sobre FKs (siendo este el más importante a futuro):
   `CREATE INDEX idx_ordenes_cliente ON logitrack.ordenes (id_cliente);` y análogos en detalle_ordenes (id_orden, id_producto), inventario (id_producto, id_ubicacion), envios (id_orden, id_transportista, id_empleado), productos (id_categoria), ubicaciones (id_bodega), producto_proveedor (id_proveedor), empleados (id_bodega).

   Si bien esto ya se menciona recurrente a lo largo del documento, consideremos que debemos saber que este código se coloca siempre después de la creación de las tablas y antes de realizar cualquier inserción de datos, con la finalidad de garantizar que los índices estén disponibles para mejorar el rendimiento de las consultas JOIN.

2. Datos que ejerciten el 1:N real, clientes con 2-5 órdenes y transportistas con varios envíos, para validar las reglas de "múltiples".  

3. Poblar stock bajo el mínimo en 5-8 productos para que la alerta de reposición devuelva filas y se pueda demostrar. Dado que en sí esto se hace en laboratorios de trabajo, igual podríamos poblar algunos productos con stock bajo el mínimo para poder probar la funcionalidad de alerta de reposición y asegurarnos de que el sistema puede identificar correctamente los productos que necesitan ser reabastecidos, y, en cierto caso a final de semestre colocarlo en todo el inventario para que se pueda demostrar la funcionalidad de alerta de reposición y asegurarnos de que el sistema puede identificar correctamente los productos que necesitan ser reabastecidos.

4. Distribuir inventario en más bodegas (hoy solo 5 de 50 tienen stock) para ejercitar la logística multi-centro que describe el contexto, considerando que en la vida real, las empresas suelen tener múltiples centros de distribución y es importante que el modelo de datos pueda manejar esta complejidad. Esto nos permitirá probar la capacidad del sistema para gestionar inventarios distribuidos y optimizar la logística de almacenamiento y entrega. Ya esto le agrega complejidad al modelo de datos, podríamos hacer una rama en GitHub de testeo para modificar las tablas y agregar más bodegas con inventario, y, a su vez nos da una perspectiva única de cómo se puede mejorar la gestión de inventario.

5. Sincronizar secuencias si se mezclan inserciones explícitas y automáticas, con
   `SELECT setval('clientes_id_cliente_seq', (SELECT max(id_cliente) FROM logitrack.clientes));`, por tabla.

6. `ciudad_envio` vs `ciudad` del cliente, dado que hoy coinciden en casi todos los registros, para probar la justificación de la columna convendría envíos a ciudades distintas. Esto nos permitirá evaluar la funcionalidad de la columna `ciudad_envio` y asegurarnos de que el sistema puede manejar correctamente los casos en los que la ciudad de envío difiere de la ciudad del cliente, lo cual es común en operaciones logísticas.

   Expliquemos esto a fondo, vale, la columna `ciudad_envio` se utiliza para registrar la ciudad a la que se envía un pedido en la tabla `envios`, mientras que la columna `ciudad` del cliente se utiliza para registrar la ciudad en la que se encuentra el cliente en la tabla de `clientes`. En muchos casos, estas dos ciudades pueden coincidir, pero en otros casos pueden ser diferentes, especialmente si el cliente realiza pedidos desde una ubicación diferente a su ciudad de residencia o si el pedido se envía a una dirección de envío diferente. Pero estos parámetros son diferentes y es importante que el sistema pueda manejar correctamente los casos en los que la ciudad de envío difiere de la ciudad del cliente, para garantizar que los pedidos se envíen a la ubicación correcta y se gestionen adecuadamente. Por ejemplo si queremos usar JOINs para encontrar la ciudad de envío de un pedido y la ciudad del cliente que realizó el pedido, podemos utilizar la siguiente consulta:

   ```sql
   SELECT e.ciudad_envio, c.ciudad
   FROM logitrack.envios e
   JOIN logitrack.ordenes o ON e.id_orden = o.id_orden
   JOIN logitrack.clientes c ON o.id_cliente = c.id_cliente
   WHERE e.id_envio = 1; -- Reemplazar con el ID del envío
   ```

   Este pequeña consulta nos dice que podemos obtener la ciudad de envío de un pedido y la ciudad del cliente que realizó el pedido utilizando JOINs entre las tablas `envios`, `ordenes` y `clientes`. Esta consulta nos permite verificar si la ciudad de envío difiere de la ciudad del cliente y asegurarnos de que el sistema pueda manejar correctamente estos casos.

   Aunque, si tuvieramos el mismo atributo de ciudad en la tabla de `ordenes`, podríamos simplificar la consulta y obtener la ciudad de envío y la ciudad del cliente directamente desde la tabla de `ordenes`, lo que nos permitiría evaluar la funcionalidad de la columna `ciudad_envio` y asegurarnos de que el sistema pueda manejar correctamente los casos en los que la ciudad de envío difiere de la ciudad del cliente. Y sí, cambiaramos `ciudad_envio` por `ciudad` en la tabla de `ordenes`, podríamos simplificar la consulta y obtener la ciudad de envío y la ciudad del cliente directamente desde la tabla de `ordenes`, pero es algo que quiero testear más a futuro con una rama de testeo en GitHub, para poder hacer pruebas y asegurarnos de que el sistema pueda manejar correctamente los casos en los que la ciudad de envío difiere de la ciudad del cliente, sin problemas, de manera eficiente y sin complicaciones.

Si bien he pensado en que podríamos hacer detrás de cada uno de los laboratorios una integración unica y luego un testeo final, lo que nos permitiría validar la integridad y funcionalidad del sistema en su conjunto, esto podría ser un proyecto más grande y complejo que requeriría una planificación cuidadosa y una ejecución meticulosa para asegurar que todas las partes del sistema funcionen correctamente juntas.

Pero, tendríamos que delegar tareas y responsabilidades, establecer un cronograma de trabajo y definir claramente los objetivos y criterios de éxito para el proyecto.

Aunque sí, espero que les haya gustado, es más como un resumen del proyecto, y, a su vez, un análisis de los hallazgos y mejoras que se podrían implementar en la base de datos para optimizar su rendimiento y funcionalidad. Con algunos pequeños ejemplos, probablemente más de alguno este basado en como sea el laboratorio 2 que tendremos que hacer, y, a su vez, es un resumen de lo que hemos aprendido en el laboratorio 1 y cómo podemos aplicar ese conocimiento para mejorar la base de datos y la gestión de las tablas.

Por lo tanto, este archivo estará sujeto a mejoras y actualizaciones a medida que avancemos en el proyecto y realicemos más pruebas y análisis sobre la base de datos. En la carpeta de Lab02, pues claro.
