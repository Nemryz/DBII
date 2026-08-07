
DROP SCHEMA IF EXISTS logitrack CASCADE; 
-- esto elimina el esquema logitrack y todo lo que contiene, incluyendo tablas, vistas, funciones, etc.

CREATE SCHEMA logitrack;

SET search_path TO logitrack; -- establece el esquema logitrack como el esquema predeterminado para las operaciones posteriores

-- Creación de la tabla clientes | empresas que contratan logísticos 

CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre varchar(150), NOT NULL, 
    rut varchar(12) UNIQUE NOT NULL,
    direccion varchar(200) NOT NULL,
    ciudad varchar(80) NOT NULL,
    telefono varchar(20) NOT NULL,
    email varchar(120) NOT NULL,
    date_registro DATE NOT NULL DEFAULT CURRENT_DATE
);
-- el uso de DATE NOT NULL DEFAULT CURRENT_DATE permite que la fecha de registro se establezca automáticamente en la fecha actual si no se proporciona un valor al insertar un nuevo cliente.
-- además, el uso de SERIAL para id_cliente permite que se genere automáticamente un valor único para cada nuevo cliente insertado en la tabla.
-- y, por último, el uso de UNIQUE para rut garantiza que no se puedan insertar dos clientes con el mismo rut en la tabla.

-- Creación de la tabla Categoria | clasificación de productos

CREATE TABLE Categorias (
    id_categoria SERIAL PRIMARY KEY, 
    nombre varchar(100) NOT NULL UNIQUE,
    descripcion varchar(255)
); 

-- Creación de la tabla productos | productos que se transportan | además, se establece una relación con la tabla Categorias mediante la clave foránea id_categoria
-- la relación entre productos y Categorias es de uno a muchos, es decir, un producto pertenece a una categoría, pero una categoría puede tener muchos productos.

CREATE TABLE Productos (
    id_producto SERIAL PRIMARY KEY,
    sku varchar(50) NOT NULL UNIQUE, -- sku es un identificador único para cada producto, que se utiliza para rastrear y gestionar el inventario de productos, también llamado en español como "unidad de mantenimiento de existencias" o "código de referencia de producto"
    nombre varchar(150) NOT NULL,
    descripcion varchar(255),
    peso_kg numeric(8,2) NOT NULL CHECK (peso_kg > 0), -- se establece un CHECK para que el peso del producto sea mayor a 0
    precio_unitario numeric(12,2) NOT NULL CHECK (precio_unitario >= 0), -- se establece un CHECK para que el precio del producto sea mayor o igual a 0
    id_categoria INTEGER NOT NULL REFERENCES Categorias(id_categoria), -- clave foránea que relaciona el producto con una categoría   
);

-- En este caso de la Tabla Productos, el NUMERIC nos sirve para almacenar valores numéricos con una precisión y escala específicas, lo que es útil para representar cantidades monetarias o medidas precisas, como el peso de un producto.
-- Normalmente, NUMERIC se utiliza cuando se requiere una mayor precisión en los cálculos y se desea evitar errores de redondeo que pueden ocurrir con otros tipos de datos numéricos, como FLOAT o DOUBLE PRECISION. 
-- Se usa en ejemplos de tipo de datos como precio_unitario y peso_kg, donde es importante mantener la precisión de los valores almacenados para evitar problemas en cálculos financieros o de inventario.

-- Creación de la tabla Proveedores 

CREATE TABLE Proveedores (
    id_proveedor SERIAL PRIMARY KEY, 
    nombre varchar(150) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    telefono varchar(20),
    email varchar(120),
    pais_origen varchar(60),
);

-- Tabla asociativa (intermedia) para establecer la relación muchos a muchos entre productos y proveedores
-- tabla Producto_Proveedor

CREATE TABLE Producto_Proveedor (
    id_producto INTEGER NOT NULL REFERENCES Productos(id_producto),
    id_proveedor INTEGER NOT NULL REFERENCES Proveedores(id_proveedor),
    costo_compra numeric(12,2) NOT NULL CHECK (costo_compra >= 0), -- otro CHECK para que el costo de compra sea mayor o igual a 0
    tiempo_entrega_dias INTEGER NOT NULL CHECK (tiempo_entrega_dias >= 0), -- Haremos un CHECK para que el tiempo de entrega sea mayor o igual a 0
    PRIMARY KEY (id_producto, id_proveedor) -- mientras qu eaca habrá una clave primaria compuesta por id_producto e id_proveedor para garantizar que no se repitan combinaciones de producto y proveedor´
);

-- Tabla Bodega 

CREATE TABLE Bodega (
    id_bodega SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    direccion varchar(200) NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    capacidad_m3 NUMERIC(12,2) NOT NULL CHECK (capacidad_m3 > 0),
);

-- Tabla Ubicaciones 

CREATE TABLE Ubicaciones (
    id_ubicacion SERIAL PRIMARY KEY,
    id_bodega INTEGER NOT NULL REFERENCES Bodega(id_bodega),
    pasillo VARCHAR(10) NOT NULL,
    estante VARCHAR(10) NOT NULL,
    nivel VARCHAR(10) NOT NULL,
    UNIQUE (id_bodega, pasillo, estante, nivel)
    -- la restricción UNIQUE garantiza que no se puedan insertar dos ubicaciones con la misma combinación de bodega, pasillo, estante y nivel. 
);

-- Tabla Inventario, consideremos la regla de negocio que nos dice que el stock no puede ser negativo.

CREATE TABLE Inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INTEGER NOT NULL REFERENCES Productos(id_producto),
    id_ubicacion INTEGER NOT NULL REFERENES Ubicaciones(id_ubicacion),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    stock_minimo INTEGER NOT NULL CHECK (stock_minimo >= 0),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_producto, id_ubicacion) 
);

-- Aclaremos que el uso del TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP permite que la fecha de actualización se establezca automáticamente en la fecha y hora actual si no se proporciona un valor al insertar un nuevo registro en la tabla Inventario.
-- Se usa generalmente en casos donde se desea llevar un registro de cuándo se realizó la última actualización de un registro en la tabla, lo que puede ser útil para fines de auditoría o para determinar la antigüedad de los datos.
-- Y nos ayuda a llevar un control de cuándo se actualizó por última vez el stock de un producto en una ubicación específica.
-- El uso del DEFAULT normalmente en SQL permite establecer un valor predeterminado para una columna cuando se inserta un nuevo registro en la tabla y no se proporciona un valor explícito para esa columna.
-- En palabras sencillas DEFAULT permite que la base de datos asigne automáticamente un valor a una columna si no se especifica uno al insertar un nuevo registro, lo que puede ser útil para garantizar que ciertas columnas tengan valores válidos sin requerir que el usuario los proporcione manualmente. 
-- Nos evita a tener que preocuparnos por establecer un valor para esa columna cada vez que se inserta un nuevo registro, lo que puede ahorrar tiempo y reducir errores.

-- Tabla Empleados 

CREATE TABLE Empleados (
    id_empleado SERIAL PRIMARY KEY, 
    nombre varchar(120) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    cargo varchar(60) NOT NULL,
    id_bodega INTEGER NOT NULL REFERENCES Bodega(id_bodega),
    fecha_contratacion DATE NOT NULL,
);

-- Acá otra pequeña explicación sencilla, el uso de DATE NOT NULL permite que la fecha de contratación sea obligatoria al insertar un nuevo empleado en la tabla Empleados, lo que garantiza que siempre se registre la fecha en que un empleado fue contratado.
-- DATE lo usamos para almacenar solo la fecha (sin la hora) de contratación del empleado, lo que es suficiente para fines de registro y seguimiento de la antigüedad del empleado en la empresa.
-- Por lo general, DATE es más eficiente en términos de almacenamiento y rendimiento que TIMESTAMP cuando solo se necesita la fecha sin la hora.

-- Tabla Transportistas 

CREATE TABLE Transportistas (
    id_transportista SERIAL PRIMARY KEY,
    nombre varchar(150) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    telefono varchar(20) NOT NULL,
    tipo_vehiculo varchar(50),
);

-- Porque tipo_vehiculo no lleva NOT NULL ? Bueno, esto se debe a que no todos los transportistas pueden tener un tipo de vehículo específico asignado al momento de su registro en la base de datos. Algunos transportistas pueden operar con diferentes tipos de vehículos según la necesidad del transporte, o pueden no tener un vehículo propio y trabajar con vehículos proporcionados por la empresa o terceros. Por lo tanto, permitir que el campo tipo_vehiculo sea opcional (es decir, que pueda ser NULL) brinda flexibilidad en el registro de transportistas y evita restricciones innecesarias que podrían dificultar la inserción de datos válidos en la tabla Transportistas.

-- Tabla Órdenes de Pedido 

CREATE TABLE Ordenes (
    id_orden SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES Clientes(id_cliente),
    fecha_orden TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('pendiente', 'procesando', 'despachada', 'entregada', 'cancelada'),
    direccion_envio VARCHAR(200) NOT NULL,
);

-- Tenemos que ver si colocar un atributo llamado "ciudad_envio" para almacenar la ciudad de destino del envío, ya que actualmente solo tenemos la dirección de envío. 
-- Esto podría ser útil para fines de logística y seguimiento de envíos, así como para análisis de datos relacionados con la distribución geográfica de los pedidos. 
-- Además, como ya tenemos marcado en "Clientes" la ciudad, podríamos considerar si es necesario almacenar la ciudad de envío por separado o si podemos inferirla a partir de la dirección de envío proporcionada.

-- Tabla Detalle de Órdenes 

-- Este tenemos que revisarlo bien donde lo iriamos a colocar dado que en sí, como discutimos todo eso, podríamos tampoco hacer necesario el uso de Producto-Proveedores como tabla intermedia, así que buscar el modelo ER real. 

-- Pero tenemos todo antes de hacer algo como tal.

-- Con lo que tenemos, podemos usar de inspiración algunas consultas para ingresar las tablas de mejor forma.



