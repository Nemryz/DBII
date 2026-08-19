# Laboratorio 02 - Consultas SQL Terminal

Igual que el 10_backup_pg_dump.md, esto se hizo de este modo dado que para evitar confusión, además, como tenemos que hacer consultas SQL por medio de la terminal. A continuación tenemos los pasos para restaurar el respaldo de la base de datos que se hizo en el laboratorio anterior, también por medio de la terminal.

## 11. Crear una nueva base de datos y restaurar en ella el respaldo generado

## Paso 1: crear la nueva base de datos

```powershell
psql -U postgres -h localhost -p 5432 -c "CREATE DATABASE lab_db_restaurada;"
```

## Paso 2a: restaurar un respaldo en formato SQL (texto plano)

```powershell
psql -U postgres -h localhost -p 5432 -d lab_db_restaurada -f respaldo.sql
```

## Paso 2b: restaurar un respaldo en formato custom (con pg_restore)

```powershell
pg_restore -U postgres -h localhost -p 5432 -d lab_db_restaurada respaldo.backup
```

## Paso 3: verificar que tablas, restricciones y registros se restauraron correctamente

```powershell
psql -U postgres -h localhost -p 5432 -d lab_db_restaurada -c "SELECT count(*) FROM logitrack.clientes;" -c "SELECT count(*) FROM logitrack.productos;"
```

Resultado esperado:

50 clientes y 50 productos (las 13 tablas del esquema `logitrack` con sus registros; `producto_proveedor` y `detalle_ordenes` con 60).

Verificación adicional de restricciones (debe devolver 0 violaciones y 0 huérfanos):

```powershell
psql -U postgres -h localhost -p 5432 -d lab_db_restaurada -c "SET search_path TO logitrack;" -c "SELECT count(*) FROM ordenes o LEFT JOIN clientes c ON c.id_cliente = o.id_cliente WHERE c.id_cliente IS NULL;"
```

## Opción pgAdmin4 (interfaz gráfica)

1. Crear base de datos nueva: clic derecho en Databases luego hacer click en Create, posteriormente en Database...
2. Restaurar: clic derecho sobre la base nueva y presionar Restore..., luego en seleccionar el archivo de respaldo (Formato: Custom o Plain) y, finalmente en Restore
3. Verificar en el árbol, es decir, el esquema `logitrack` con sus 13 tablas, abrir una tabla con View/Edit Data para revisar registros.
