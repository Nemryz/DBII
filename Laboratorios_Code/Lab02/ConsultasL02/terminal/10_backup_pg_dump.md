# Laboratorio 02 - Consultas SQL Terminal

Esto se hizo de este modo dado que para evitar confusión, además, como tenemos que hacer consultas SQL por medio de la terminal, es mejor que el respaldo de la base de datos se haga también por medio de la terminal, para que no haya confusión entre los distintos métodos de respaldo y restauración.

## 10. Respaldo (backup) de la base de datos

### Opción A: pg_dump desde terminal

Ruta de pg_dump en PostgreSQL 15 (Windows): `C:\Program Files\PostgreSQL\15\bin\pg_dump.exe`

Formato SQL (texto plano, legible y editable):

```powershell
pg_dump -U postgres -h localhost -p 5432 -d lab_db -f respaldo.sql
```

Formato custom (comprimido, recomendado para restaurar con pg_restore):

```powershell
pg_dump -U postgres -h localhost -p 5432 -d lab_db -Fc -f respaldo.backup
```

Donde:
`-U`: usuario (postgres) | `-h`: host (localhost) | `-p`: puerto (5432) | `-d`: base de datos | `-f`: archivo de salida

Notas:

- Si psql/pg_dump no están en el PATH de Windows, usar la ruta completa:

`& "C:\Program Files\PostgreSQL\15\bin\pg_dump.exe" ...`

- Solicita la contraseña interactivamente, o defínela antes en la sesión:
  `$env:PGPASSWORD = "postgre"` (PowerShell) — la variable se pierde al cerrar la terminal.

  La constraseña es diferente depende del dispositivo de cada uno, en mi caso es postgre por defecto, pero en las pcs de otros pueden cambiar dependiendo de como se estableció la contraseña al instalar PostgreSQL, así tmb en la u puede que sean diferentes, por lo que cada uno debe saber cual es la contraseña de su base de datos para poder hacer el respaldo.

- El respaldo incluye el esquema `logitrack`, tablas, restricciones, secuencias (con su valor actual) y datos.

## Opción B: pgAdmin4 (interfaz gráfica)

1. Clic derecho sobre la base de datos `lab_db` → Backup...
2. Formato: `Plain` (SQL) o `Custom`
3. Indicar nombre del archivo y clic en Backup

Si bien es más fácil de hacer, se hace por medio de la interfaz gráfica, y no por la terminal, por lo que no es lo que se pide en el laboratorio, pero se deja como referencia para quien quiera usarlo. Pero en esencia es lo mismo que la opción A, solo que se hace por medio de la interfaz gráfica y no por la terminal.
