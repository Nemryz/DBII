# Base de Datos II, proyectos y laboratorios semestrales

Este repositorio alberga los proyectos y laboratorios de la asignatura Base de Datos II impartida en la Universidad Autónoma de Chile, su contenido refleja la estructura real de las carpetas del proyecto, a saber, la carpeta Apuntes_Archivos con los recursos de estudio y la carpeta Laboratorios_Code que agrupa los laboratorios desarrollados durante el semestre, cada laboratorio dispone de los scripts de creación de la base de datos, de los datos de población y de los ejercicios de consulta, por lo tanto, esta documentación busca orientar al lector sobre cada archivo y sobre la manera de poner en marcha el entorno completo en PostgreSQL 15-17 y en pgAdmin4.

## Estructura del repositorio

El repositorio se organiza en las siguientes carpetas principales

`Apuntes_Archivos`
  contiene los apuntes y los recursos de aprendizaje, entre ellos el archivo Lab01 (en formato .pdf, si se clona el repositorio debe instalarse la extensión para lectura de archivos .pdf) y la carpeta Aprendizaje con material complementario como la guía de SSH, entre otros.

`Laboratorios_Code`
  agrupa los laboratorios del curso, cada uno en su propia carpeta numerada, a saber, la carpeta Lab01 y la carpeta Lab02

### Laboratorios_Code/Lab01

El primer laboratorio implementa el modelo relacional de un sistema logístico, sus archivos principales son los siguientes

`modeloDiagrama.sql`
  define el esquema logitrack y las trece tablas del modelo con sus restricciones de integridad

`poblacion.sql`
  limpia el esquema y carga los datos de ejemplo, alrededor de cincuenta registros por tabla, además sincroniza las secuencias con setval para que los insertos posteriores no colisionen y no generen errores de clave primaria duplicada

`modeloBorrador.sql`
  conserva una versión previa del modelo a modo de respaldo

`modeloER.png`
  muestra el diagrama entidad relación del laboratorio

`analisisTesteo.md`
  documenta el testeo de integridad, las consultas de verificación y los resultados obtenidos (es más complejo que un simple script de verificación, por lo tanto, se recomienda su lectura, además que posee contenido de aprendizaje para desarrollar consultas analíticas y de agregación, así como de joins y subconsultas para comprobar la integridad de los datos, entre otros aspectos)

`LAB01-PARTE01.pdf`
  contiene el enunciado del primer laboratorio

### Laboratorios_Code/Lab02/ConsultasL02

El segundo laboratorio desarrolla las consultas sobre el modelo creado en el laboratorio anterior, su estructura interna separa los ejercicios por tipo de uso:

`consultas`
  carpeta con nueve archivos definitivos, uno por ejercicio numerado del 04 al 14, cada archivo contiene su enunciado, su solución y sus verificaciones

`Consultas pgadmin`
  carpeta con versiones de las consultas preparadas para ejecutarse directamente en el Query Tool de pgAdmin4

`terminal`
  carpeta con la documentación de los comandos de respaldo y restauración de la base de datos mediante pg_dump y psql

`consultas.sql`, `parte_6.sql` y `tarea4_ddl.sql`
  versiones consolidadas de los ejercicios, corregidas y compatibles tanto con psql como con pgAdmin4

`DBIILab02_10_backup.sql`
  respaldo completo de la base de datos generado con pg_dump, sirve como evidencia del ejercicio de respaldo

## Cómo ejecutar el entorno

Se necesita contar con PostgreSQL 15 y pgAdmin4 instalados, la ruta habitual de las herramientas en Windows es C:\Program Files\PostgreSQL\15\bin, de no estar agregada al PATH se invoca cada comando con la ruta completa

El primer paso consiste en crear la base de datos, se abre una terminal y se ingresa lo siguiente

```powershell
$env:PGPASSWORD = "[PASSWORD]" # reemplazar [PASSWORD] por la contraseña del usuario postgres
"C:\Program Files\PostgreSQL\15\bin\psql.exe" -U postgres -h localhost -p 5432 -c "CREATE DATABASE lab_db;"
```

Después se cargan el modelo y los datos en orden, primero el esquema con sus tablas y luego la población

```powershell
"C:\Program Files\PostgreSQL\15\bin\psql.exe" -U postgres -h localhost -p 5432 -d lab_db -f "Laboratorios_Code\Lab01\modeloDiagrama.sql"
"C:\Program Files\PostgreSQL\15\bin\psql.exe" -U postgres -h localhost -p 5432 -d lab_db -f "Laboratorios_Code\Lab01\poblacion.sql"
```

La carga debe terminar con trece tablas pobladas, once de ellas con cincuenta registros y dos de ellas, producto_proveedor y detalle_ordenes, con sesenta registros.

Para ejecutar los ejercicios se corren los archivos de la carpeta consultas en orden numérico ascendente, del 04 al 14.

Los mismos archivos pueden ejecutarse pegando su contenido en el Query Tool de pgAdmin4, se abre la base creada, se pega el script y se presiona el botón de ejecución, el resultado se observa en la pestaña de datos.

## Correcciones aplicadas

Durante la revisión se detectaron y corrigieron varios problemas de compatibilidad, el primero fue el desajuste de las secuencias serial en poblacion.sql, los insertos usaban identificadores explícitos sin actualizar las secuencias, por lo tanto, cualquier inserto nuevo generaba un identificador repetido y violaba la clave primaria, la solución consiste en sincronizar las secuencias con setval al final del script. Lo que permitió que los insertos posteriores generen identificadores únicos y no colisionen con los existentes. Y, se pudiera ejecutar la consulta 5 sin errores de clave primaria duplicada.

El segundo problema fue la ausencia del search_path en las consultas, los nombres de las tablas sin esquema no se resolvían fuera del esquema logitrack, la solución fue añadir la instrucción SET search_path TO logitrack al inicio de cada archivo. De esta manera, las consultas funcionan correctamente tanto en psql como en pgAdmin4. Evitando errores de tabla inexistente y de ambigüedad de nombres.

El tercer problema fue el uso de comandos exclusivos de psql, tales como \set y \gset, que pgAdmin4 no reconoce, la solución consistió en reemplazarlos por alternativas portables, de modo que los scripts funcionan en ambos entornos, por ejemplo, currval en lugar de \gset. Para ser honestos, la solución no es perfecta, ya que algunas consultas requieren de un trabajo adicional para adaptarlas a pgAdmin4, pero al menos se puede ejecutar la mayoría de los ejercicios sin errores.

El cuarto problema fue el uso de la palabra reservada DO como alias de la tabla detalle_ordenes, la consulta fallaba con un error de sintaxis, la solución fue renombrar el alias a do_ para evitar el conflicto. También se aprendió que es mejor evitar el uso de palabras reservadas como alias, ya que pueden generar problemas de compatibilidad y confusión.

## Recursos y referencias

Para profundizar se recomienda revisar los enunciados oficiales de cada laboratorio, siendo estos, LAB01_PARTE01.pdf y LAB01_PARTE02.pdf. Así como algunos de los presentes documentos extras para ir aprendiendo sobre el uso de PostgreSQL y pgAdmin4, entre ellos, la guía de SSH, la guía de respaldo y restauración, y la guía de consultas analíticas y de agregación.  
