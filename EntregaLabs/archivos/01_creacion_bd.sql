DROP SCHEMA IF EXISTS logitrack CASCADE;

CREATE SCHEMA logitrack;

SET search_path TO logitrack;

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

CREATE TABLE Categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL UNIQUE,
    descripcion varchar(255)
);

CREATE TABLE Productos (
    id_producto SERIAL PRIMARY KEY,
    sku varchar(50) NOT NULL UNIQUE,
    nombre varchar(150) NOT NULL,
    descripcion varchar(255),
    peso_kg numeric(8,2) NOT NULL CHECK (peso_kg > 0),
    precio_unitario numeric(12,2) NOT NULL CHECK (precio_unitario >= 0),
    id_categoria INTEGER NOT NULL REFERENCES Categorias(id_categoria)
);

CREATE TABLE Proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre varchar(150) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    telefono varchar(20),
    email varchar(120),
    pais_origen varchar(60)
);

CREATE TABLE Producto_Proveedor (
    id_producto INTEGER NOT NULL REFERENCES Productos(id_producto),
    id_proveedor INTEGER NOT NULL REFERENCES Proveedores(id_proveedor),
    costo_compra numeric(12,2) NOT NULL CHECK (costo_compra >= 0),
    tiempo_entrega_dias INTEGER NOT NULL CHECK (tiempo_entrega_dias >= 0),
    PRIMARY KEY (id_producto, id_proveedor)
);

CREATE TABLE Bodega (
    id_bodega SERIAL PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    direccion varchar(200) NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    capacidad_m3 NUMERIC(12,2) NOT NULL CHECK (capacidad_m3 > 0)
);

CREATE TABLE Ubicaciones (
    id_ubicacion SERIAL PRIMARY KEY,
    id_bodega INTEGER NOT NULL REFERENCES Bodega(id_bodega),
    pasillo VARCHAR(10) NOT NULL,
    estante VARCHAR(10) NOT NULL,
    nivel VARCHAR(10) NOT NULL,
    UNIQUE (id_bodega, pasillo, estante, nivel)
);

CREATE TABLE Inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INTEGER NOT NULL REFERENCES Productos(id_producto),
    id_ubicacion INTEGER NOT NULL REFERENCES Ubicaciones(id_ubicacion),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    stock_minimo INTEGER NOT NULL CHECK (stock_minimo >= 0),
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_producto, id_ubicacion)
);

CREATE TABLE Empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre varchar(120) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    cargo varchar(60) NOT NULL,
    id_bodega INTEGER NOT NULL REFERENCES Bodega(id_bodega),
    fecha_contratacion DATE NOT NULL
);

CREATE TABLE Transportistas (
    id_transportista SERIAL PRIMARY KEY,
    nombre varchar(150) NOT NULL,
    rut varchar(12) NOT NULL UNIQUE,
    telefono varchar(20) NOT NULL,
    tipo_vehiculo varchar(50)
);

CREATE TABLE Ordenes (
    id_orden SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES Clientes(id_cliente),
    fecha_orden TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('pendiente', 'procesando', 'despachada', 'entregada', 'cancelada')),
    direccion_envio VARCHAR(200) NOT NULL,
    ciudad_envio VARCHAR(80) NOT NULL
);

CREATE TABLE Detalle_Ordenes (
    id_detalle SERIAL PRIMARY KEY,
    id_orden INTEGER NOT NULL REFERENCES Ordenes(id_orden),
    id_producto INTEGER NOT NULL REFERENCES Productos(id_producto),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
    UNIQUE (id_orden, id_producto)
);

CREATE TABLE Envios (
    id_envio SERIAL PRIMARY KEY,
    id_orden INTEGER NOT NULL REFERENCES Ordenes(id_orden),
    id_transportista INTEGER NOT NULL REFERENCES Transportistas(id_transportista),
    id_empleado INTEGER NOT NULL REFERENCES Empleados(id_empleado),
    fecha_despacho TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('programado', 'en_transito', 'entregado', 'rechazado'))
);
