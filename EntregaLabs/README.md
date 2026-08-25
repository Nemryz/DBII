LogiTrack - Laboratorio - Base de Datos II

Nombre Equipo: [PENDIENTE]

1. Descripcion general

La base de datos se llama logitrack y esta implementada en PostgreSQL
version 15.x. El esquema contiene 13 tablas normalizadas hasta Tercera
Forma Normal, con restricciones de integridad referencial en todas las
relaciones y una validacion que impide registrar stock negativo en la
tabla inventario.

1. Archivos incluidos

archivos/01_creacion_bd.sql    Crea el esquema y las 13 tablas con sus restricciones
archivos/02_carga_datos.sql    Pobla todas las tablas con 50 a 60 registros cada una
archivos/03_ddl.sql            Demuestra operaciones DDL sobre una tabla temporal
archivos/04_dml.sql            Demuestra inserciones, actualizaciones y eliminaciones
archivos/05_consultas.sql      Contiene siete consultas que utilizan JOINs y agrupaciones
archivos/06_transacciones.sql  Muestra tres transacciones con COMMIT, ROLLBACK y SAVEPOINT
modelo_relacional.png          Diagrama entidad-relacion en formato imagen
modelo_relacional.drawio       Diagrama editable para abrir en draw.io
backup_logitrack.sql           Respaldo completo de la base con todas las tablas y datos
evidencias/                    Carpeta donde se almacenan las capturas de pantalla
README.md                      Este archivo con instrucciones generales
Integrantes.txt                Informacion del equipo y sus integrantes

1. Estructura de carpetas

DBII_Lab/
  archivos/
    01_creacion_bd.sql
    02_carga_datos.sql
    03_ddl.sql
    04_dml.sql
    05_consultas.sql
    06_transacciones.sql
  evidencias/
  modelo_relacional.png
  modelo_relacional.drawio
  backup_logitrack.sql
  README.md
  Integrantes.txt

1. Ejecucion de los scripts

Para trabajar con la base de datos, ejecuten los archivos SQL en este
orden exacto desde pgAdmin o desde la consola psql:

  1. 01_creacion_bd.sql
  2. 02_carga_datos.sql
  3. 03_ddl.sql
  4. 04_dml.sql
  5. 05_consultas.sql
  6. 06_transacciones.sql

Si algun script produce un error, verifiquen que el anterior ejecuto
correctamente antes de intentar el siguiente. La causa mas comun de
fallo es que el esquema logitrack no exista aun, lo cual se resuelve
ejecutando nuevamente el primer script.

1. Consideraciones para la restauracion

Si necesitan recrear la base de datos desde cero, pueden utilizar el
archivo de respaldo. Antes de restaurar, asegurese de que la base
destino exista y de que no haya otras sesiones activas sobre ella.

Si la restauracion falla porque las tablas ya existen, eliminen el
esquema completo antes de volver a intentar:

  DROP SCHEMA logitrack CASCADE;

Despues ejecuten la restauracion con el comando correspondiente
(indicado en el archivo de instrucciones del servidor remoto).

Para confirmar que todo quedo bien, pueden contar los registros en
algunas tablas principales. El resultado esperado es de 50 registros
en la mayoria de las tablas, y 60 en detalle_ordenes y
producto_proveedor.

Si el resultado es menor o si aparece un mensaje de tipo "relation
does not exist", significa que la restauracion no se completo y
deben intentar nuevamente.

1. Comandos alternativos

Si el comando \i no esta disponible en su entorno, pueden usar la
ruta absoluta del archivo o subir los scripts al servidor con scp
antes de ejecutarlos.

Si pg_dump no esta instalado en su maquina local, pueden generar el
respaldo directamente desde pgAdmin usando la herramienta de
respaldo incluida en el menu de herramientas.

Si la conexion al servidor remoto falla, verifiquen que tengan
acceso a internet y que las credenciales sean correctas antes de
reintentar.
