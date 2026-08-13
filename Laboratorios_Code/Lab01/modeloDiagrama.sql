DROP SCHEMA IF EXISTS logitrack CASCADE;
-- esto elimina el esquema logitrack y todo lo que contiene, incluyendo tablas, vistas, funciones, etc.

CREATE SCHEMA logitrack;

SET search_path TO logitrack; -- establece el esquema logitrack como el esquema predeterminado para las operaciones posteriores

-- Creación de la tabla Clientes | empresas que contratan servicios logísticos

CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre varchar(150) NOT NULL,
    rut varchar(12) UNIQUE NOT NULL,
    direccion varchar(200) NOT NULL,
    ciudad varchar(80) NOT NULL,
    telefono varchar(20) NOT NULL,
    email varchar(120) NOT NULL,
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE
);
-- el uso de DATE NOT NULL DEFAULT CURRENT_DATE permite que la fecha de registro se establezca automáticamente en la fecha actual si no se proporciona un valor al insertar un nuevo cliente.
-- además, el uso de SERIAL para id_cliente permite que se genere automáticamente un valor único para cada nuevo cliente insertado en la tabla.
-- y, por último, el uso de UNIQUE para rut garantiza que no se puedan insertar dos clientes con el mismo rut en la tabla.
-- Nota de corrección colocada para esta versión la columna se llama fecha_registro (en lugar de date_registro) para mantener una nomenclatura uniforme en español con las demás columnas de fecha del modelo.

-- Creación de la tabla Categorias | clasificación de productos
CREATE TABLE Categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL UNIQUE,
    descripcion varchar(255)
);
-- la restricción NOT NULL UNIQUE sobre nombre garantiza que cada categoría tenga un nombre obligatorio y que no existan dos categorías duplicadas, ya que no tendría sentido registrar la misma clasificación más de una vez.

-- Creación de la tabla Productos | ítems almacenados y distribuidos | además, se establece una relación con la tabla Categorias mediante la clave foránea id_categoria
-- la relación entre Productos y Categorias es de uno a muchos, es decir, un producto pertenece a una única categoría (regla de negocio), pero una categoría puede tener muchos productos.
CREATE TABLE Productos (
    id_producto SERIAL PRIMARY KEY,
    sku varchar(50) NOT NULL UNIQUE, -- sku es un identificador único para cada producto, que se utiliza para rastrear y gestionar el inventario de productos, también llamado en español como "unidad de mantenimiento de existencias" o "código de referencia de producto"
    nombre varchar(150) NOT NULL,
    descripcion varchar(255),
    peso_kg numeric(8,2) NOT NULL CHECK (peso_kg > 0), -- se establece un CHECK para que el peso del producto sea mayor a 0
    precio_unitario numeric(12,2) NOT NULL CHECK (precio_unitario >= 0), -- se establece un CHECK para que el precio del producto sea mayor o igual a 0
    id_categoria INTEGER NOT NULL REFERENCES Categorias(id_categoria) -- clave foránea que relaciona el producto con una categoría
);
-- En este caso de la Tabla Productos, el NUMERIC nos sirve para almacenar valores numéricos con una precisión y escala específicas, lo que es útil para representar cantidades monetarias o medidas precisas, como el peso de un producto.
-- Normalmente, NUMERIC se utiliza cuando se requiere una mayor precisión en los cálculos y se desea evitar errores de redondeo que pueden ocurrir con otros tipos de datos numéricos, como FLOAT o DOUBLE PRECISION.
-- Se usa en ejemplos de tipo de datos como precio_unitario y peso_kg, donde es importante mantener la precisión de los valores almacenados para evitar problemas en cálculos financieros o de inventario.

-- Creación de la tabla Proveedores | empresas que suministran productos
CREATE TABLE Proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre varchar(150) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    telefono varchar(20),
    email varchar(120),
    pais_origen varchar(60)
);
-- Los campos telefono, email y pais_origen son opcionales (pueden ser NULL) porque no todos los proveedores cuentan con esa información completa al momento de su registro, y esa información no es crítica para poder inscribirlos en el sistema.

-- Tabla asociativa (intermedia) para establecer la relación muchos a muchos entre Productos y Proveedores
CREATE TABLE Producto_Proveedor (
    id_producto INTEGER NOT NULL REFERENCES Productos(id_producto),
    id_proveedor INTEGER NOT NULL REFERENCES Proveedores(id_proveedor),
    costo_compra numeric(12,2) NOT NULL CHECK (costo_compra >= 0), -- otro CHECK para que el costo de compra sea mayor o igual a 0
    tiempo_entrega_dias INTEGER NOT NULL CHECK (tiempo_entrega_dias >= 0), -- Haremos un CHECK para que el tiempo de entrega sea mayor o igual a 0
    PRIMARY KEY (id_producto, id_proveedor) -- clave primaria compuesta por id_producto e id_proveedor para garantizar que no se repitan combinaciones de producto y proveedor
);
/*El uso de una clave primaria compuesta en esta tabla intermedia es lo que resuelve formalmente la relación muchos a muchos dado que cada fila representa un vínculo único entre un producto y un proveedor.
Además, los atributos costo_compra y tiempo_entrega_dias son propios de la relación (no del producto ni del proveedor), por lo que pertenecen aquí y no en las entidades individuales.
Creación de la tabla Bodega | centros de almacenamiento */
CREATE TABLE Bodega (
    id_bodega SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    direccion varchar(200) NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    capacidad_m3 NUMERIC(12,2) NOT NULL CHECK (capacidad_m3 > 0)
);
/* El uso de NUMERIC(12,2) con un CHECK (capacidad_m3 > 0) garantiza que la capacidad de almacenamiento sea siempre un valor positivo y con precisión de hasta dos decimales, lo que permite representar metros cúbicos fraccionarios.
Creación de la tabla Ubicaciones | secciones específicas dentro de cada bodega */
CREATE TABLE Ubicaciones (
    id_ubicacion SERIAL PRIMARY KEY,
    id_bodega INTEGER NOT NULL REFERENCES Bodega(id_bodega),
    pasillo VARCHAR(10) NOT NULL,
    estante VARCHAR(10) NOT NULL,
    nivel VARCHAR(10) NOT NULL,
    UNIQUE (id_bodega, pasillo, estante, nivel)
);
/* La restricción UNIQUE (id_bodega, pasillo, estante, nivel) garantiza que no se puedan insertar dos ubicaciones con la misma combinación de bodega, pasillo, estante y nivel, es decir, que una ubicación física no pueda registrarse dos veces.

Mientras que la relación entre Bodega y Ubicaciones es de uno a muchos, una bodega tiene múltiples ubicaciones (regla de negocio), pero cada ubicación pertenece a una sola bodega.

Creación de la tabla Inventario | cantidad disponible de cada producto por ubicación | consideremos la regla de negocio que nos dice que el stock no puede ser negativo. */
CREATE TABLE Inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INTEGER NOT NULL REFERENCES Productos(id_producto),
    id_ubicacion INTEGER NOT NULL REFERENCES Ubicaciones(id_ubicacion),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    stock_minimo INTEGER NOT NULL CHECK (stock_minimo >= 0),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_producto, id_ubicacion)
);
/*
Como en clases la Engel tuvo la duda de porque existen stock y stock_minimo, aclaremos que el stock representa la cantidad actual de un producto disponible en una ubicación específica, mientras que el stock_minimo representa la cantidad mínima requerida para mantener un nivel adecuado de inventario y evitar quedarse sin existencias.  

Si bien las reglas del negocio se pueden controlar a nivel de aplicación, es una buena práctica también aplicarlas a nivel de base de datos para garantizar la integridad de los datos y evitar inconsistencias.

Pero esto también nos permite que si la aplicación no controla correctamente el stock, la base de datos lo hará por nosotros, evitando que se registren valores inválidos, aunque de ser posible, podemos hacer que se elimine stock_minimo y depender unica y exclusivamente de stock, dado que la regla de stock mínimo igualmente se cumple gracias a la condición de stock >= 0, y el control de stock mínimo se puede hacer a nivel de aplicación. Pero podemos dejarlo para tener un control más estricto y explícito de la cantidad mínima de inventario que se debe mantener. 

El CHECK (stock >= 0) aplica directamente la regla de negocio "el stock no puede ser negativo" a nivel de base de datos, y no solo a nivel de aplicación.

El UNIQUE (id_producto, id_ubicacion) garantiza que el inventario se registre una sola vez por producto y por ubicación, cumpliendo la regla de negocio: el inventario debe registrarse por producto y ubicación dentro de una bodega.

Aclaremos que el uso del TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP permite que la fecha de actualización se establezca automáticamente en la fecha y hora actual si no se proporciona un valor al insertar un nuevo registro en la tabla Inventario. 

Se usa generalmente en casos donde se desea llevar un registro de cuándo se realizó la última actualización de un registro en la tabla, lo que puede ser útil para fines de auditoría o para determinar la antigüedad de los datos.

Y nos ayuda a llevar un control de cuándo se actualizó por última vez el stock de un producto en una ubicación específica.

El uso del DEFAULT normalmente en SQL permite establecer un valor predeterminado para una columna cuando se inserta un nuevo registro en la tabla y no se proporciona un valor explícito para esa columna.

En palabras sencillas DEFAULT permite que la base de datos asigne automáticamente un valor a una columna si no se especifica uno al insertar un nuevo registro, lo que puede ser útil para garantizar que ciertas columnas tengan valores válidos sin requerir que el usuario los proporcione manualmente.

Nos evita a tener que preocuparnos por establecer un valor para esa columna cada vez que se inserta un nuevo registro, lo que puede ahorrar tiempo y reducir errores.

-- Creación de la tabla Empleados | personal que opera en la logística */
CREATE TABLE Empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre varchar(120) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    cargo varchar(60) NOT NULL,
    id_bodega INTEGER NOT NULL REFERENCES Bodega(id_bodega),
    fecha_contratacion DATE NOT NULL
);
-- el uso de DATE NOT NULL permite que la fecha de contratación sea obligatoria al insertar un nuevo empleado en la tabla Empleados, lo que garantiza que siempre se registre la fecha en que un empleado fue contratado.
-- DATE lo usamos para almacenar solo la fecha (sin la hora) de contratación del empleado, lo que es suficiente para fines de registro y seguimiento de la antigüedad del empleado en la empresa.
-- Por lo general, DATE es más eficiente en términos de almacenamiento y rendimiento que TIMESTAMP cuando solo se necesita la fecha sin la hora.
-- la relación entre Empleados y Bodega es de uno a muchos, es decir, un empleado opera en una bodega específica y una bodega tiene múltiples empleados.

-- Creación de la tabla Transportistas | empresas encargadas del transporte
CREATE TABLE Transportistas (
    id_transportista SERIAL PRIMARY KEY,
    nombre varchar(150) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    telefono varchar(20) NOT NULL,
    tipo_vehiculo varchar(50)
);
-- Porque tipo_vehiculo no lleva NOT NULL? Bueno, esto se debe a que no todos los transportistas pueden tener un tipo de vehículo específico asignado al momento de su registro en la base de datos. Algunos transportistas pueden operar con diferentes tipos de vehículos según la necesidad del transporte, o pueden no tener un vehículo propio y trabajar con vehículos proporcionados por la empresa o terceros. Por lo tanto, permitir que el campo tipo_vehiculo sea opcional (es decir, que pueda ser NULL) brinda flexibilidad en el registro de transportistas y evita restricciones innecesarias que podrían dificultar la inserción de datos válidos en la tabla Transportistas.

-- Creación de la tabla Ordenes | solicitudes de despacho realizadas por clientes
-- la relación entre Clientes y Ordenes es de uno a muchos, un cliente puede generar múltiples órdenes (regla de negocio), pero cada orden pertenece a un único cliente.
CREATE TABLE Ordenes (
    id_orden SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES Clientes(id_cliente),
    fecha_orden TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('pendiente', 'procesando', 'despachada', 'entregada', 'cancelada')),
    direccion_envio VARCHAR(200) NOT NULL,
    ciudad_envio VARCHAR(80) NOT NULL
);
/* El CHECK sobre estado restringe los valores permitidos a un catálogo cerrado de estados posibles, lo que evita errores de tipeo y valores inconsistentes en el ciclo de vida de una orden.
El TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP registra automáticamente la fecha y hora en que se crea la orden, sin necesidad de que la aplicación lo indique.
Nota de diseño, se agregó la columna ciudad_envio para almacenar la ciudad de destino del envío, ya que en la versión anterior solo existía la dirección de envío. 
Esto es útil para fines de logística y seguimiento de envíos, así como para el análisis de la distribución geográfica de los pedidos, y no puede inferirse de forma confiable desde la ciudad del cliente porque un cliente puede solicitar envíos a destinos distintos.

Detalle de órdenes | Productos incluidos en cada orden (N:N Orden-Producto)
Cada orden debe tener al menos un producto (se controla a nivel de aplicación/transacción) */
CREATE TABLE Detalle_Ordenes (
    id_detalle      SERIAL PRIMARY KEY,
    id_orden        INTEGER NOT NULL REFERENCES Ordenes(id_orden),
    id_producto     INTEGER NOT NULL REFERENCES Productos(id_producto),
    cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
    UNIQUE (id_orden, id_producto)
);
/* En esta ocasión la tabla Detalle_Ordenes es la resolución formal de la relación muchos a muchos entre Ordenes y Productos (N:N), porque, una orden contiene muchos productos y un producto puede aparecer en muchas órdenes.
Según el diagrama ER, Ordenes 1 -> N Detalle y Detalle N---1 Productos, por lo que esta entidad es necesaria y no puede eliminarse del modelo.
El uso del UNIQUE (id_orden, id_producto) garantiza que un mismo producto no se repita como línea dentro de una misma orden, y obliga a sumar cantidades en una sola línea en lugar de duplicarlas.
Mientras que el CHECK (cantidad > 0) junto con la regla de negocio "cada orden debe tener al menos un producto asociado" asegura que ninguna línea de detalle sea vacía, en sí, por eso el mínimo de una línea por orden se controla a nivel de aplicación/transacción, ya que SQL no permite imponer un mínimo de filas hijas por fila padre.
Por último, el precio_unitario se guarda aquí (y no solo en Productos) como una instantánea del precio al momento de la orden, si el precio del producto cambia luego, las órdenes históricas conservan el valor con el que fueron registradas, lo que es clave para la trazabilidad.
-- Envíos, información de despacho de órdenes (relación Orden-Envio 1:N)
-- Un envío está asociado a una orden y a un transportista
-- Un empleado puede gestionar múltiples envíos */
CREATE TABLE Envios (
    id_envio SERIAL PRIMARY KEY,
    id_orden INTEGER NOT NULL REFERENCES Ordenes(id_orden),
    id_transportista INTEGER NOT NULL REFERENCES Transportistas(id_transportista),
    id_empleado INTEGER NOT NULL REFERENCES Empleados(id_empleado),
    fecha_despacho TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('programado', 'en_transito', 'entregado', 'rechazado'))
);
/* Esta tabla corresponde a la duodécima entidad, que era la única faltante en la versión anterior del modelo, y cubre las reglas de negocio "un envío está asociado a una orden y a un transportista" y "un empleado puede gestionar múltiples envíos".

Podemos denotar además, que la relación entre Ordenes y Envios se adopta como 1:N, fiel al trazo del diagrama ER del laboratorio, dado que en general, una orden puede despacharse en uno o más envíos (por ejemplo, despachos parciales o reenvíos), y cada envío pertenece a una única orden.

Las relaciones Envios N:1 Transportistas y Envios N:1 Empleados también son fieles al diagrama, un transportista puede manejar múltiples envíos y un empleado puede gestionar múltiples envíos.

Mientras que la columna fecha_despacho con TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP registra automáticamente cuándo sale el despacho.

Y, por consiguiente, la columna fecha_entrega es opcional (puede ser NULL) porque no todos los envíos tienen una fecha de entrega definida al momento de su registro, solo la tendrá aquel envío que ya haya sido entregado.

Para finalizar, el CHECK sobre estado restringe el ciclo de vida del envío a un catálogo cerrado: programado, en tránsito, entregado o rechazado. 

Este check es necesario para algo final que habrá que ir arreglando. 
*/