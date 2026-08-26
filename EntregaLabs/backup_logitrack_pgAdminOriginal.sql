--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5 (Ubuntu 15.5-0ubuntu0.23.04.1)
-- Dumped by pg_dump version 15.5 (Ubuntu 15.5-0ubuntu0.23.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: logitrack; Type: SCHEMA; Schema: -; Owner: ua_eq06
--

CREATE SCHEMA logitrack;


ALTER SCHEMA logitrack OWNER TO ua_eq06;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bodega; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.bodega (
    id_bodega integer NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion character varying(200) NOT NULL,
    ciudad character varying(80) NOT NULL,
    capacidad_m3 numeric(12,2) NOT NULL,
    CONSTRAINT bodega_capacidad_m3_check CHECK ((capacidad_m3 > (0)::numeric))
);


ALTER TABLE logitrack.bodega OWNER TO ua_eq06;

--
-- Name: bodega_id_bodega_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.bodega_id_bodega_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.bodega_id_bodega_seq OWNER TO ua_eq06;

--
-- Name: bodega_id_bodega_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.bodega_id_bodega_seq OWNED BY logitrack.bodega.id_bodega;


--
-- Name: categorias; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.categorias (
    id_categoria integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(255)
);


ALTER TABLE logitrack.categorias OWNER TO ua_eq06;

--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.categorias_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.categorias_id_categoria_seq OWNER TO ua_eq06;

--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.categorias_id_categoria_seq OWNED BY logitrack.categorias.id_categoria;


--
-- Name: clientes; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.clientes (
    id_cliente integer NOT NULL,
    nombre character varying(150) NOT NULL,
    rut character varying(12) NOT NULL,
    direccion character varying(200) NOT NULL,
    ciudad character varying(80) NOT NULL,
    telefono character varying(20) NOT NULL,
    email character varying(120) NOT NULL,
    fecha_registro date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE logitrack.clientes OWNER TO ua_eq06;

--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.clientes_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.clientes_id_cliente_seq OWNER TO ua_eq06;

--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.clientes_id_cliente_seq OWNED BY logitrack.clientes.id_cliente;


--
-- Name: detalle_ordenes; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.detalle_ordenes (
    id_detalle integer NOT NULL,
    id_orden integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    CONSTRAINT detalle_ordenes_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT detalle_ordenes_precio_unitario_check CHECK ((precio_unitario >= (0)::numeric))
);


ALTER TABLE logitrack.detalle_ordenes OWNER TO ua_eq06;

--
-- Name: detalle_ordenes_id_detalle_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.detalle_ordenes_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.detalle_ordenes_id_detalle_seq OWNER TO ua_eq06;

--
-- Name: detalle_ordenes_id_detalle_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.detalle_ordenes_id_detalle_seq OWNED BY logitrack.detalle_ordenes.id_detalle;


--
-- Name: empleados; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.empleados (
    id_empleado integer NOT NULL,
    nombre character varying(120) NOT NULL,
    rut character varying(12) NOT NULL,
    cargo character varying(60) NOT NULL,
    id_bodega integer NOT NULL,
    fecha_contratacion date NOT NULL
);


ALTER TABLE logitrack.empleados OWNER TO ua_eq06;

--
-- Name: empleados_id_empleado_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.empleados_id_empleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.empleados_id_empleado_seq OWNER TO ua_eq06;

--
-- Name: empleados_id_empleado_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.empleados_id_empleado_seq OWNED BY logitrack.empleados.id_empleado;


--
-- Name: envios; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.envios (
    id_envio integer NOT NULL,
    id_orden integer NOT NULL,
    id_transportista integer NOT NULL,
    id_empleado integer NOT NULL,
    fecha_despacho timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_entrega date,
    estado character varying(20) NOT NULL,
    CONSTRAINT envios_estado_check CHECK (((estado)::text = ANY ((ARRAY['programado'::character varying, 'en_transito'::character varying, 'entregado'::character varying, 'rechazado'::character varying])::text[])))
);


ALTER TABLE logitrack.envios OWNER TO ua_eq06;

--
-- Name: envios_id_envio_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.envios_id_envio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.envios_id_envio_seq OWNER TO ua_eq06;

--
-- Name: envios_id_envio_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.envios_id_envio_seq OWNED BY logitrack.envios.id_envio;


--
-- Name: inventario; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.inventario (
    id_inventario integer NOT NULL,
    id_producto integer NOT NULL,
    id_ubicacion integer NOT NULL,
    stock integer NOT NULL,
    stock_minimo integer NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT inventario_stock_check CHECK ((stock >= 0)),
    CONSTRAINT inventario_stock_minimo_check CHECK ((stock_minimo >= 0))
);


ALTER TABLE logitrack.inventario OWNER TO ua_eq06;

--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.inventario_id_inventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.inventario_id_inventario_seq OWNER TO ua_eq06;

--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.inventario_id_inventario_seq OWNED BY logitrack.inventario.id_inventario;


--
-- Name: ordenes; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.ordenes (
    id_orden integer NOT NULL,
    id_cliente integer NOT NULL,
    fecha_orden timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado character varying(20) NOT NULL,
    direccion_envio character varying(200) NOT NULL,
    ciudad_envio character varying(80) NOT NULL,
    CONSTRAINT ordenes_estado_check CHECK (((estado)::text = ANY ((ARRAY['pendiente'::character varying, 'procesando'::character varying, 'despachada'::character varying, 'entregada'::character varying, 'cancelada'::character varying])::text[])))
);


ALTER TABLE logitrack.ordenes OWNER TO ua_eq06;

--
-- Name: ordenes_id_orden_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.ordenes_id_orden_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.ordenes_id_orden_seq OWNER TO ua_eq06;

--
-- Name: ordenes_id_orden_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.ordenes_id_orden_seq OWNED BY logitrack.ordenes.id_orden;


--
-- Name: producto_proveedor; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.producto_proveedor (
    id_producto integer NOT NULL,
    id_proveedor integer NOT NULL,
    costo_compra numeric(12,2) NOT NULL,
    tiempo_entrega_dias integer NOT NULL,
    CONSTRAINT producto_proveedor_costo_compra_check CHECK ((costo_compra >= (0)::numeric)),
    CONSTRAINT producto_proveedor_tiempo_entrega_dias_check CHECK ((tiempo_entrega_dias >= 0))
);


ALTER TABLE logitrack.producto_proveedor OWNER TO ua_eq06;

--
-- Name: productos; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.productos (
    id_producto integer NOT NULL,
    sku character varying(50) NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(255),
    peso_kg numeric(8,2) NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    id_categoria integer NOT NULL,
    CONSTRAINT productos_peso_kg_check CHECK ((peso_kg > (0)::numeric)),
    CONSTRAINT productos_precio_unitario_check CHECK ((precio_unitario >= (0)::numeric))
);


ALTER TABLE logitrack.productos OWNER TO ua_eq06;

--
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.productos_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.productos_id_producto_seq OWNER TO ua_eq06;

--
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.productos_id_producto_seq OWNED BY logitrack.productos.id_producto;


--
-- Name: proveedores; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.proveedores (
    id_proveedor integer NOT NULL,
    nombre character varying(150) NOT NULL,
    rut character varying(12) NOT NULL,
    telefono character varying(20),
    email character varying(120),
    pais_origen character varying(60)
);


ALTER TABLE logitrack.proveedores OWNER TO ua_eq06;

--
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.proveedores_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.proveedores_id_proveedor_seq OWNER TO ua_eq06;

--
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.proveedores_id_proveedor_seq OWNED BY logitrack.proveedores.id_proveedor;


--
-- Name: transportistas; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.transportistas (
    id_transportista integer NOT NULL,
    nombre character varying(150) NOT NULL,
    rut character varying(12) NOT NULL,
    telefono character varying(20) NOT NULL,
    tipo_vehiculo character varying(50)
);


ALTER TABLE logitrack.transportistas OWNER TO ua_eq06;

--
-- Name: transportistas_id_transportista_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.transportistas_id_transportista_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.transportistas_id_transportista_seq OWNER TO ua_eq06;

--
-- Name: transportistas_id_transportista_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.transportistas_id_transportista_seq OWNED BY logitrack.transportistas.id_transportista;


--
-- Name: ubicaciones; Type: TABLE; Schema: logitrack; Owner: ua_eq06
--

CREATE TABLE logitrack.ubicaciones (
    id_ubicacion integer NOT NULL,
    id_bodega integer NOT NULL,
    pasillo character varying(10) NOT NULL,
    estante character varying(10) NOT NULL,
    nivel character varying(10) NOT NULL
);


ALTER TABLE logitrack.ubicaciones OWNER TO ua_eq06;

--
-- Name: ubicaciones_id_ubicacion_seq; Type: SEQUENCE; Schema: logitrack; Owner: ua_eq06
--

CREATE SEQUENCE logitrack.ubicaciones_id_ubicacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logitrack.ubicaciones_id_ubicacion_seq OWNER TO ua_eq06;

--
-- Name: ubicaciones_id_ubicacion_seq; Type: SEQUENCE OWNED BY; Schema: logitrack; Owner: ua_eq06
--

ALTER SEQUENCE logitrack.ubicaciones_id_ubicacion_seq OWNED BY logitrack.ubicaciones.id_ubicacion;


--
-- Name: bodega id_bodega; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.bodega ALTER COLUMN id_bodega SET DEFAULT nextval('logitrack.bodega_id_bodega_seq'::regclass);


--
-- Name: categorias id_categoria; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('logitrack.categorias_id_categoria_seq'::regclass);


--
-- Name: clientes id_cliente; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('logitrack.clientes_id_cliente_seq'::regclass);


--
-- Name: detalle_ordenes id_detalle; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.detalle_ordenes ALTER COLUMN id_detalle SET DEFAULT nextval('logitrack.detalle_ordenes_id_detalle_seq'::regclass);


--
-- Name: empleados id_empleado; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.empleados ALTER COLUMN id_empleado SET DEFAULT nextval('logitrack.empleados_id_empleado_seq'::regclass);


--
-- Name: envios id_envio; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.envios ALTER COLUMN id_envio SET DEFAULT nextval('logitrack.envios_id_envio_seq'::regclass);


--
-- Name: inventario id_inventario; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.inventario ALTER COLUMN id_inventario SET DEFAULT nextval('logitrack.inventario_id_inventario_seq'::regclass);


--
-- Name: ordenes id_orden; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.ordenes ALTER COLUMN id_orden SET DEFAULT nextval('logitrack.ordenes_id_orden_seq'::regclass);


--
-- Name: productos id_producto; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.productos ALTER COLUMN id_producto SET DEFAULT nextval('logitrack.productos_id_producto_seq'::regclass);


--
-- Name: proveedores id_proveedor; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.proveedores ALTER COLUMN id_proveedor SET DEFAULT nextval('logitrack.proveedores_id_proveedor_seq'::regclass);


--
-- Name: transportistas id_transportista; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.transportistas ALTER COLUMN id_transportista SET DEFAULT nextval('logitrack.transportistas_id_transportista_seq'::regclass);


--
-- Name: ubicaciones id_ubicacion; Type: DEFAULT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.ubicaciones ALTER COLUMN id_ubicacion SET DEFAULT nextval('logitrack.ubicaciones_id_ubicacion_seq'::regclass);


--
-- Data for Name: bodega; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.bodega (id_bodega, nombre, direccion, ciudad, capacidad_m3) FROM stdin;
1	Centro de Distribución Santiago Norte	Av. Américo Vespucio Norte 1999	Quilicura	45000.00
2	CD Santiago Sur	Camino a Melipilla 9500	Cerrillos	38000.00
3	CD Valparaíso	Camino La Pólvora 2400	Valparaíso	22000.00
4	CD Concepción	Autopista Concepción-Talcahuano 3500	Talcahuano	26000.00
5	CD Antofagasta	Av. Pedro Aguirre Cerda 6020	Antofagasta	18000.00
6	CD La Serena	Ruta 5 Norte km 475	La Serena	15000.00
7	CD Temuco	Camino Cajón 1200	Temuco	20000.00
8	CD Puerto Montt	Camino Chinquihue 4560	Puerto Montt	16000.00
9	CD Rancagua	Av. La Compañía 1400	Rancagua	19000.00
10	CD Iquique	Zona Franca 2300	Iquique	21000.00
11	Bodega Maipú 1	Av. Pajaritos 5200	Maipú	12500.00
12	Bodega Maipú 2	Av. Los Pajaritos 4800	Maipú	9800.00
13	Bodega San Bernardo	Camino Longuén 480	San Bernardo	11000.00
14	Bodega Puente Alto	Av. Concha y Toro 4300	Puente Alto	13500.00
15	Bodega Colina	Ruta 57 km 15	Colina	17500.00
16	Bodega Lampa	Camino a Batuco 800	Lampa	14500.00
17	Bodega Quilicura 2	Av. Lo Campino 1100	Quilicura	16500.00
18	Bodega Cerrillos 2	Av. Pedro Aguirre Cerda 7300	Cerrillos	12900.00
19	Bodega Viña del Mar	Av. Edmundo Eluchans 950	Viña del Mar	8800.00
20	Bodega Quilpué	Camino El Sauce 700	Quilpué	7400.00
21	Bodega San Antonio	Av. Barros Luco 2200	San Antonio	9300.00
22	Bodega Rengo	Ruta 5 Sur km 117	Rengo	6900.00
23	Bodega Curicó	Camino a San Clemente 1200	Curicó	8200.00
24	Bodega Talca	Av. 2 Norte 1500	Talca	9900.00
25	Bodega Chillán	Camino a Coihueco 900	Chillán	7700.00
26	Bodega Los Ángeles	Camino Santa Fe 1400	Los Ángeles	8600.00
27	Bodega Valdivia	Camino a Los Lagos 1100	Valdivia	8100.00
28	Bodega Osorno	Ruta 215 km 8	Osorno	7800.00
29	Bodega Coyhaique	Camino a Puerto Aysén 630	Coyhaique	5200.00
30	Bodega Punta Arenas	Av. Presidente Manuel Bulnes 350	Punta Arenas	5400.00
31	Bodega Copiapó	Av. La Paz 780	Copiapó	7100.00
32	Bodega Calama	Av. Granaderos 2100	Calama	7900.00
33	Bodega Arica	Av. Comandante San Martín 1000	Arica	6800.00
34	Bodega Vallenar	Ruta 5 Norte km 674	Vallenar	4600.00
35	Bodega Ovalle	Camino a Combarbalá 500	Ovalle	4800.00
36	Bodega San Felipe	Camino El Tambo 850	San Felipe	5900.00
37	Bodega Los Andes	Av. Argentina 1800	Los Andes	6100.00
38	Bodega Cartagena	Camino a Cartagena 1200	Cartagena	4400.00
39	Bodega Melipilla	Camino a Pomaire 700	Melipilla	5600.00
40	Bodega Talagante	Camino a Naltagua 450	Talagante	4300.00
41	Bodega Buin	Camino Viejo a Valparaíso 900	Buin	5800.00
42	Bodega Paine	Ruta 5 Sur km 35	Paine	6700.00
43	Bodega San Fernando	Camino a Tinguiririca 1300	San Fernando	6400.00
44	Bodega Santa Cruz	Camino a Nancagua 600	Santa Cruz	4700.00
45	Bodega Linares	Camino Panamericana 1550	Linares	6200.00
46	Bodega Parral	Ruta 5 Sur km 341	Parral	4100.00
47	Bodega Los Ángeles 2	Camino Antuco 950	Los Ángeles	7200.00
48	Bodega Villarrica	Camino a Pucón 380	Villarrica	5300.00
49	Bodega Pucón	Camino Lago Caburgua 420	Pucón	4500.00
50	Bodega Frutillar	Camino a Llanquihue 700	Frutillar	4900.00
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.categorias (id_categoria, nombre, descripcion) FROM stdin;
1	Electrónica	Productos de consumo electrónico
2	Electrodomésticos	Artefactos para el hogar
3	Computación	Hardware, software y accesorios de computación
4	Telefonía	Smartphones y accesorios de telefonía
5	Fotografía	Cámaras y equipos fotográficos
6	Audio y Video	Equipos de sonido e imagen
7	Gaming	Consolas, videojuegos y periféricos gamer
8	Juguetes	Juguetería general
9	Deportes	Artículos deportivos y fitness
10	Vestuario	Ropa para hombres y mujeres
11	Calzado	Zapatos, zapatillas y botas
12	Accesorios de Moda	Carteras, mochilas y complementos
13	Relojería	Relojes y accesorios
14	Joyería	Joyas y bijouterie
15	Belleza	Perfumes y cosmética
16	Cuidado Personal	Productos de higiene y cuidado
17	Salud y Farmacia	Medicamentos y productos farmacéuticos
18	Alimentos No Perecederos	Alimentos de larga duración
19	Bebidas	Bebidas gaseosas, aguas y jugos
20	Vinos y Licores	Bebidas alcohólicas
21	Lácteos	Leche, quesos, yogur y derivados
22	Carnes	Carnes rojas y blancas
23	Pescados y Mariscos	Productos del mar
24	Frutas y Verduras	Productos agrícolas frescos
25	Congelados	Alimentos congelados
26	Panadería	Pan y productos de panadería
27	Repostería	Productos de repostería y pastelería
28	Condimentos	Especias y condimentos
29	Limpieza	Productos de aseo del hogar
30	Papelería	Artículos de papelería
31	Librería Escolar	Útiles escolares
32	Oficina	Insumos y artículos de oficina
33	Ferretería	Artículos de ferretería
34	Herramientas	Herramientas manuales y eléctricas
35	Materiales de Construcción	Materiales para la construcción
36	Jardinería	Productos para jardín y exteriores
37	Mascotas	Alimentos y accesorios para mascotas
38	Muebles	Mobiliario para el hogar y oficina
39	Decoración del Hogar	Artículos decorativos
40	Iluminación	Lámparas, ampolletas e iluminación
41	Textil Hogar	Ropa de cama, toallas y cortinas
42	Cocina y Menaje	Utensilios de cocina
43	Vajilla	Platos, cubiertos y vajilla
44	Bebé	Productos para bebés
45	Automotriz	Repuestos y accesorios automotrices
46	Agricultura	Insumos agrícolas
47	Seguridad	Cámaras, alarmas y seguridad
48	Bazar	Artículos variados de bazar
49	Arte y Manualidades	Materiales para arte y manualidades
50	Instrumentos Musicales	Instrumentos y accesorios musicales
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.clientes (id_cliente, nombre, rut, direccion, ciudad, telefono, email, fecha_registro) FROM stdin;
1	Minera Austral SpA	76.000.001-1	Av. Bernardo O'Higgins 1234	Santiago	+56 2 2123 4501	contacto@mineraaustral.cl	2024-01-15
2	Falabella Retail S.A.	76.000.002-2	Manuel Rodríguez Sur 313	Santiago	+56 2 2125 4502	servicios@falabella.cl	2024-01-22
3	Sodimac Chile S.A.	76.000.003-3	Av. Américo Vespucio 1500	Las Condes	+56 2 2103 4503	ventas@sodimac.cl	2024-02-01
4	Supermercados Líder	76.000.004-4	Av. Kennedy 9001	Las Condes	+56 2 2600 4504	compras@lider.cl	2024-02-10
5	SMU S.A. (Unimarc)	76.000.005-5	Av. Libertador B. O'Higgins 1410	Santiago	+56 2 2530 4505	facturacion@smu.cl	2024-02-18
6	Cencosud SpA	76.000.006-6	Av. Kennedy 4001	Las Condes	+56 2 2620 4506	proveedores@cencosud.cl	2024-03-02
7	AB InBev Chile	76.000.007-7	Av. Del Valle 730	Huechuraba	+56 2 2840 4507	logistica@abinbev.cl	2024-03-12
8	CCU Chile S.A.	76.000.008-8	Av. Vitacura 2673	Las Condes	+56 2 2710 4508	despachos@ccu.cl	2024-03-25
9	CMPC S.A.	76.000.009-9	Agustinas 1343	Santiago	+56 2 2440 4509	abastecimiento@cmpc.cl	2024-04-03
10	SQM S.A.	76.000.010-0	El Trovador 4285	Las Condes	+56 2 2425 4510	compras@sqm.com	2024-04-14
11	Aguas Andinas S.A.	76.000.011-1	Av. Presidente Balmaceda 1398	Santiago	+56 2 2787 4511	soporte@aguasandinas.cl	2024-04-21
12	Enel Chile	76.000.012-2	Santa Rosa 76	Santiago	+56 2 2463 4512	logistica@enel.cl	2024-05-05
13	Entel S.A.	76.000.013-3	Av. Vitacura 2700	Las Condes	+56 2 2709 4513	bodega@entel.cl	2024-05-16
14	Movistar Chile	76.000.014-4	Av. Providencia 111	Providencia	+56 2 2467 4514	almacen@movistar.cl	2024-05-27
15	Banco Santander	76.000.015-5	Bandera 140	Santiago	+56 2 2320 4515	operaciones@santander.cl	2024-06-02
16	Banco de Chile	76.000.016-6	Ahumada 251	Santiago	+56 2 2653 4516	servicios@bancochile.cl	2024-06-11
17	Ripley Chile	76.000.017-7	Av. O'Higgins 482	Concepción	+56 41 234 517	tiendas@ripley.cl	2024-06-23
18	París Cencosud	76.000.018-8	Av. Libertador B. O'Higgins 555	Santiago	+56 2 2680 4518	stock@paris.cl	2024-07-01
19	Farmacias Cruz Verde	76.000.019-9	Av. Providencia 1059	Providencia	+56 2 2480 4519	centro@farmacias.com	2024-07-12
20	Farmacias Ahumada	76.000.020-0	Av. Ahumada 278	Santiago	+56 2 2670 4520	logistica@farmaciasahumada.cl	2024-07-24
21	Pullman Bus	76.000.021-1	Av. Matucana 81	Estación Central	+56 2 2776 4521	despacho@pullman.cl	2024-08-03
22	Tur Bus S.A.	76.000.022-2	Av. Padre Alberto Hurtado 1429	Estación Central	+56 2 2703 4522	proveedores@turbus.cl	2024-08-15
23	Latam Airlines Group	76.000.023-3	Av. Presidente Riesco 5711	Las Condes	+56 2 2565 4523	proveedores@latam.com	2024-08-26
24	Decathlon Chile	76.000.024-4	Av. La Dehesa 1385	Lo Barnechea	+56 2 2953 4524	logistica@decathlon.cl	2024-09-04
25	H&M Chile	76.000.025-5	Av. Isidora Goyenechea 2800	Las Condes	+56 2 2910 4525	inbound@hm.cl	2024-09-17
26	Zara Chile	76.000.026-6	Av. Nueva Providencia 2220	Providencia	+56 2 2740 4526	stores@zara.cl	2024-09-29
27	Hites S.A.	76.000.027-7	Av. Vicuña Mackenna 7240	La Florida	+56 2 2813 4527	bodega@hites.cl	2024-10-08
28	Easy S.A.	76.000.028-8	Av. Manquehue Sur 31	Las Condes	+56 2 2900 4528	tiendas@easy.cl	2024-10-20
29	Constructora Salfa	76.000.029-9	Av. Providencia 2601	Providencia	+56 2 2720 4529	admin@salfa.cl	2024-11-01
30	Bip & Go	76.000.030-0	Av. Apoquindo 3111	Las Condes	+56 2 2693 4530	clientes@bipgo.cl	2024-11-12
31	Automotora Interbike	76.000.031-1	Av. Américo Vespucio 1600	Quilicura	+56 2 2984 4531	ventas@interbike.cl	2024-11-25
32	Dercocenter	76.000.032-2	Av. Pajaritos 4100	Maipú	+56 2 2540 4532	reclamos@derco.cl	2024-12-03
33	Klarstore	76.000.033-3	Av. Matta 666	Santiago	+56 2 2760 4533	compras@klarstore.cl	2024-12-16
34	FullProduct Chile	76.000.034-4	Camino a Melipilla 12000	Padre Hurtado	+56 2 2860 4534	logistica@fullproduct.cl	2025-01-06
35	Alimentos Polar Chile	76.000.035-5	Av. Del Valle 1000	Huechuraba	+56 2 2820 4535	ventas@polar.cl	2025-01-19
36	Watt's S.A.	76.000.036-6	Av. San Martín 1450	Macul	+56 2 2388 4536	despachos@watts.cl	2025-02-02
37	Carozzi S.A.	76.000.037-7	Camino a Melipilla 6654	Cerrillos	+56 2 2799 4537	abastecimiento@carozzi.cl	2025-02-14
38	Soprole S.A.	76.000.038-8	Av. Nueva Providencia 2493	Providencia	+56 2 2500 4538	stock@soprole.cl	2025-02-27
39	Cervecería Kunstmann	76.000.039-9	Ruta 5 Sur km 828	Valdivia	+56 63 234 539	ventas@kunstmann.cl	2025-03-10
40	Viña Concha y Toro	76.000.040-0	Av. Virginia Subercaseaux 210	Puente Alto	+56 2 2821 4540	exportaciones@conchaytoro.cl	2025-03-24
41	Viña Santa Rita	76.000.041-1	Camino Santa Rita s/n	Alto Jahuel	+56 2 2300 4541	enoturismo@santarita.cl	2025-04-07
42	Pesquera Camanchaca	76.000.042-2	Av. Colón 5130	Las Condes	+56 2 2726 4542	produccion@camanchaca.cl	2025-04-20
43	AquaChile S.A.	76.000.043-3	Carmen 630	Puerto Montt	+56 65 248 543	plantas@aquachile.cl	2025-05-02
44	Agrosuper S.A.	76.000.044-4	Av. Andrés Bello 2687	Las Condes	+56 2 2711 4544	comercial@agrosuper.cl	2025-05-16
45	Embotelladora Andina	76.000.045-5	Los Militares 6191	Las Condes	+56 2 2621 4545	distribucion@coca-cola.cl	2025-05-29
46	Nestlé Chile	76.000.046-6	Av. Del Valle 730	Huechuraba	+56 2 2841 4546	cadena@nestle.cl	2025-06-09
47	Unilever Chile	76.000.047-7	Av. Andrés Bello 2687	Las Condes	+56 2 2712 4547	proveedores@unilever.com	2025-06-22
48	Procter & Gamble Chile	76.000.048-8	Av. Vitacura 2905	Las Condes	+56 2 2330 4548	centro@pg.cl	2025-07-04
49	Laboratorio SAVAL	76.000.049-9	Av. General Bustamante 26	Providencia	+56 2 2370 4549	farmacovigilancia@saval.cl	2025-07-18
50	Laboratorio Andrómaco	76.000.050-0	Av. Marcoleta 342	Santiago	+56 2 2666 4550	comercial@andromaco.cl	2025-08-01
53	Carlos García	33.333.333-3	Calle del Sol 789	Santiago	555-9876	carlos.garcia@example.com	2026-08-25
\.


--
-- Data for Name: detalle_ordenes; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.detalle_ordenes (id_detalle, id_orden, id_producto, cantidad, precio_unitario) FROM stdin;
1	1	1	2	649990.00
2	2	2	1	349990.00
3	3	3	1	429990.00
4	4	4	2	579990.00
5	5	5	3	549990.00
6	6	6	1	89990.00
7	7	7	2	249990.00
8	8	8	4	79990.00
9	9	9	5	19990.00
10	10	10	1	15990.00
11	11	11	2	159990.00
12	12	12	3	109990.00
13	13	13	1	29990.00
14	14	14	5	7990.00
15	15	15	1	199990.00
16	16	16	2	39990.00
17	17	17	3	24990.00
18	18	18	1	449990.00
19	19	19	1	549990.00
20	20	20	4	69990.00
21	21	21	1	129990.00
22	22	22	2	19990.00
23	23	23	3	64990.00
24	24	24	1	15990.00
25	25	25	5	24990.00
26	26	26	1	29990.00
27	27	27	2	49990.00
28	28	28	3	9990.00
29	29	29	4	1990.00
30	30	30	5	1890.00
31	31	31	1	2990.00
32	32	32	2	3990.00
33	33	33	3	4990.00
34	34	34	1	6990.00
35	35	35	2	8990.00
36	36	36	3	3990.00
37	37	37	6	1090.00
38	38	38	2	9990.00
39	39	39	4	2990.00
40	40	40	1	2490.00
41	41	41	5	2490.00
42	42	42	3	1290.00
43	43	43	2	8990.00
44	44	44	1	1790.00
45	45	45	2	7990.00
46	46	46	1	7990.00
47	47	47	3	3990.00
48	48	48	2	19990.00
49	49	49	4	2990.00
50	50	50	2	89990.00
51	1	26	2	29990.00
52	2	27	1	49990.00
53	3	28	3	9990.00
54	4	29	2	1990.00
55	5	30	4	1890.00
56	6	31	2	2990.00
57	7	32	3	3990.00
58	8	33	2	4990.00
59	9	34	1	6990.00
60	10	35	2	8990.00
61	51	1	2	10.99
\.


--
-- Data for Name: empleados; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.empleados (id_empleado, nombre, rut, cargo, id_bodega, fecha_contratacion) FROM stdin;
1	Juan Pérez González	77.000.001-1	Operador de Bodega	1	2022-03-01
2	María Torres Díaz	77.000.002-2	Jefe de Bodega	1	2021-06-15
3	Carlos Rojas Muñoz	77.000.003-3	Supervisor Logístico	1	2020-11-20
4	Ana Castro Silva	77.000.004-4	Encargado de Inventario	1	2022-08-10
5	Luis Fuentes Riquelme	77.000.005-5	Analista de Despacho	1	2023-01-05
6	Francisca Morales Vera	77.000.006-6	Coordinador de Transporte	1	2021-04-22
7	Pedro Herrera Contreras	77.000.007-7	Recepcionista de Mercadería	1	2023-05-02
8	Camila Navarrete Pinto	77.000.008-8	Operador de Picking	1	2022-10-17
9	Diego Soto Cabrera	77.000.009-9	Operador de Bodega	2	2023-02-13
10	Valentina Vargas Molina	77.000.010-0	Jefe de Bodega	2	2020-07-01
11	Rodrigo Ibáñez Salas	77.000.011-1	Supervisor Logístico	2	2021-09-14
12	Javiera Paredes Cáceres	77.000.012-2	Encargado de Inventario	2	2022-05-30
13	Matías Vidal Sepúlveda	77.000.013-3	Analista de Despacho	2	2023-03-20
14	Constanza Lira Araya	77.000.014-4	Coordinador de Transporte	2	2021-12-06
15	Felipe Godoy Rojas	77.000.015-5	Recepcionista de Mercadería	3	2023-06-11
16	Ignacia Salamanca Vera	77.000.016-6	Operador de Picking	3	2022-04-18
17	Sebastián Mardones Peña	77.000.017-7	Operador de Bodega	3	2023-04-03
18	Antonia Figueroa Leiva	77.000.018-8	Jefe de Bodega	3	2021-02-09
19	Benjamín Espinoza Acuña	77.000.019-9	Supervisor Logístico	3	2020-08-24
20	Catalina Bustos Carmona	77.000.020-0	Encargado de Inventario	3	2022-09-15
21	Vicente Alarcón Fuentes	77.000.021-1	Analista de Despacho	4	2023-07-02
22	Isidora Manríquez Núñez	77.000.022-2	Coordinador de Transporte	4	2021-11-08
23	Tomás Retamal Vega	77.000.023-3	Recepcionista de Mercadería	4	2023-08-14
24	Amanda Jara Guzmán	77.000.024-4	Operador de Picking	4	2022-07-25
25	Maximiliano Opazo Ríos	77.000.025-5	Operador de Bodega	4	2023-01-30
26	Fernanda Villanueva Ulloa	77.000.026-6	Jefe de Bodega	5	2020-05-11
27	Cristóbal Tapia Flores	77.000.027-7	Supervisor Logístico	5	2021-10-19
28	Josefa Gutiérrez Rojas	77.000.028-8	Encargado de Inventario	5	2022-12-12
29	Nicolás Barrera Cofré	77.000.029-9	Analista de Despacho	5	2023-05-22
30	Trinidad Sanhueza Pino	77.000.030-0	Coordinador de Transporte	6	2021-07-27
31	Martín Cifuentes Paredes	77.000.031-1	Operador de Bodega	6	2023-09-04
32	Emilia Zamora Cid	77.000.032-2	Jefe de Bodega	7	2021-03-16
33	Joaquín Mondaca Riquelme	77.000.033-3	Supervisor Logístico	7	2020-09-28
34	Florencia Riquelme Arriagada	77.000.034-4	Encargado de Inventario	8	2022-06-06
35	Alonso Garrido Farías	77.000.035-5	Analista de Despacho	8	2023-10-10
36	Rayén Mancilla Salazar	77.000.036-6	Coordinador de Transporte	8	2021-05-31
37	Gaspar Fuenzalida Castro	77.000.037-7	Operador de Bodega	9	2023-02-20
38	Laura Riffo Orellana	77.000.038-8	Jefe de Bodega	9	2020-12-07
39	Simón Vásquez Arellano	77.000.039-9	Supervisor Logístico	9	2021-08-12
40	Paz Cornejo Molina	77.000.040-0	Encargado de Inventario	10	2022-11-21
41	Bruno Cárdenas Jopia	77.000.041-1	Analista de Despacho	10	2023-03-27
42	Agustina Valenzuela Mora	77.000.042-2	Coordinador de Transporte	10	2021-01-18
43	Emilio Saavedra Godoy	77.000.043-3	Operador de Bodega	11	2023-04-11
44	Colomba Gallardo Sepúlveda	77.000.044-4	Jefe de Bodega	12	2021-06-29
45	Rafael Pino Alvarado	77.000.045-5	Supervisor Logístico	13	2020-10-05
46	Amparo Curihuentro Sandoval	77.000.046-6	Encargado de Inventario	14	2022-03-08
47	Gaspar Sandoval Moya	77.000.047-7	Analista de Despacho	15	2023-06-19
48	Isabela Henríquez Faúndez	77.000.048-8	Coordinador de Transporte	16	2021-09-06
49	Thiago Poblete Jara	77.000.049-9	Operador de Bodega	17	2023-07-24
50	Julieta Morales Fuentes	77.000.050-0	Jefe de Bodega	18	2020-04-13
\.


--
-- Data for Name: envios; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.envios (id_envio, id_orden, id_transportista, id_empleado, fecha_despacho, fecha_entrega, estado) FROM stdin;
1	1	1	1	2026-07-02 09:00:00	2026-07-05	entregado
2	2	2	2	2026-07-02 11:00:00	\N	en_transito
3	3	3	3	2026-07-03 08:30:00	\N	programado
4	4	4	4	2026-07-03 10:00:00	2026-07-06	entregado
5	5	5	5	2026-07-04 09:15:00	\N	rechazado
6	6	6	6	2026-07-04 13:00:00	\N	en_transito
7	7	7	7	2026-07-05 08:45:00	\N	programado
8	8	8	8	2026-07-05 11:30:00	2026-07-08	entregado
9	9	9	9	2026-07-06 09:30:00	2026-07-09	entregado
10	10	10	10	2026-07-06 12:00:00	\N	en_transito
11	11	11	11	2026-07-07 08:20:00	\N	programado
12	12	12	12	2026-07-07 10:45:00	2026-07-10	entregado
13	13	13	13	2026-07-08 09:10:00	2026-07-11	entregado
14	14	14	14	2026-07-08 12:30:00	\N	rechazado
15	15	15	15	2026-07-09 08:50:00	\N	en_transito
16	16	16	16	2026-07-09 11:20:00	\N	programado
17	17	17	17	2026-07-10 09:25:00	2026-07-13	entregado
18	18	18	18	2026-07-10 13:10:00	2026-07-14	entregado
19	19	19	19	2026-07-11 08:35:00	\N	en_transito
20	20	20	20	2026-07-11 12:40:00	\N	programado
21	21	21	21	2026-07-12 09:05:00	2026-07-15	entregado
22	22	22	22	2026-07-12 11:55:00	2026-07-16	entregado
23	23	23	23	2026-07-13 08:15:00	\N	rechazado
24	24	24	24	2026-07-13 13:25:00	\N	en_transito
25	25	25	25	2026-07-14 09:45:00	\N	programado
26	26	26	26	2026-07-14 12:10:00	2026-07-17	entregado
27	27	27	27	2026-07-15 08:30:00	2026-07-18	entregado
28	28	28	28	2026-07-15 13:45:00	\N	en_transito
29	29	29	29	2026-07-16 09:20:00	\N	programado
30	30	30	30	2026-07-16 12:50:00	2026-07-19	entregado
31	31	31	31	2026-07-17 08:40:00	2026-07-20	entregado
32	32	32	32	2026-07-17 11:05:00	\N	rechazado
33	33	33	33	2026-07-18 09:15:00	\N	en_transito
34	34	34	34	2026-07-18 13:35:00	\N	programado
35	35	35	35	2026-07-19 08:55:00	2026-07-22	entregado
36	36	36	36	2026-07-19 12:20:00	2026-07-23	entregado
37	37	37	37	2026-07-20 09:30:00	\N	en_transito
38	38	38	38	2026-07-20 14:00:00	\N	programado
39	39	39	39	2026-07-21 08:10:00	2026-07-24	entregado
40	40	40	40	2026-07-21 11:45:00	2026-07-25	entregado
41	41	41	41	2026-07-22 09:50:00	\N	rechazado
42	42	42	42	2026-07-22 13:05:00	\N	en_transito
43	43	43	43	2026-07-23 08:25:00	\N	programado
44	44	44	44	2026-07-23 12:30:00	2026-07-26	entregado
45	45	45	45	2026-07-24 09:00:00	2026-07-27	entregado
46	46	46	46	2026-07-24 13:15:00	\N	en_transito
47	47	47	47	2026-07-25 08:35:00	\N	programado
48	48	48	48	2026-07-25 12:10:00	2026-07-28	entregado
49	49	49	49	2026-07-26 09:05:00	2026-07-29	entregado
50	50	50	50	2026-07-26 13:40:00	\N	rechazado
51	51	1	1	2026-08-25 04:58:30.33874	\N	programado
\.


--
-- Data for Name: inventario; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.inventario (id_inventario, id_producto, id_ubicacion, stock, stock_minimo, fecha_actualizacion) FROM stdin;
2	2	2	85	20	2026-08-25 04:55:03.161923
3	3	3	45	10	2026-08-25 04:55:03.161923
4	4	4	32	8	2026-08-25 04:55:03.161923
5	5	5	60	12	2026-08-25 04:55:03.161923
6	6	6	150	25	2026-08-25 04:55:03.161923
7	7	7	55	10	2026-08-25 04:55:03.161923
8	8	8	200	30	2026-08-25 04:55:03.161923
9	9	9	180	20	2026-08-25 04:55:03.161923
10	10	10	140	25	2026-08-25 04:55:03.161923
11	11	11	75	15	2026-08-25 04:55:03.161923
12	12	12	95	18	2026-08-25 04:55:03.161923
13	13	13	210	35	2026-08-25 04:55:03.161923
14	14	14	320	50	2026-08-25 04:55:03.161923
15	15	15	40	10	2026-08-25 04:55:03.161923
16	16	16	165	28	2026-08-25 04:55:03.161923
17	17	17	190	30	2026-08-25 04:55:03.161923
18	18	18	25	6	2026-08-25 04:55:03.161923
19	19	19	18	5	2026-08-25 04:55:03.161923
20	20	20	70	12	2026-08-25 04:55:03.161923
21	21	21	48	10	2026-08-25 04:55:03.161923
22	22	22	230	40	2026-08-25 04:55:03.161923
23	23	23	110	20	2026-08-25 04:55:03.161923
24	24	24	260	45	2026-08-25 04:55:03.161923
25	25	25	90	15	2026-08-25 04:55:03.161923
26	26	26	175	30	2026-08-25 04:55:03.161923
27	27	27	135	22	2026-08-25 04:55:03.161923
28	28	28	300	55	2026-08-25 04:55:03.161923
29	29	29	400	60	2026-08-25 04:55:03.161923
30	30	30	500	80	2026-08-25 04:55:03.161923
31	31	31	350	55	2026-08-25 04:55:03.161923
32	32	32	280	45	2026-08-25 04:55:03.161923
33	33	33	160	25	2026-08-25 04:55:03.161923
34	34	34	145	25	2026-08-25 04:55:03.161923
35	35	35	78	15	2026-08-25 04:55:03.161923
36	36	36	66	12	2026-08-25 04:55:03.161923
37	37	37	420	70	2026-08-25 04:55:03.161923
38	38	38	52	10	2026-08-25 04:55:03.161923
39	39	39	240	40	2026-08-25 04:55:03.161923
40	40	40	310	50	2026-08-25 04:55:03.161923
41	41	41	270	45	2026-08-25 04:55:03.161923
42	42	42	380	60	2026-08-25 04:55:03.161923
43	43	43	98	18	2026-08-25 04:55:03.161923
44	44	44	440	70	2026-08-25 04:55:03.161923
45	45	45	88	15	2026-08-25 04:55:03.161923
46	46	46	62	12	2026-08-25 04:55:03.161923
47	47	47	130	22	2026-08-25 04:55:03.161923
48	48	48	76	14	2026-08-25 04:55:03.161923
49	49	49	500	85	2026-08-25 04:55:03.161923
50	50	50	35	8	2026-08-25 04:55:03.161923
1	1	1	115	15	2026-08-25 04:55:03.161923
\.


--
-- Data for Name: ordenes; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.ordenes (id_orden, id_cliente, fecha_orden, estado, direccion_envio, ciudad_envio) FROM stdin;
1	1	2026-07-01 09:00:00	pendiente	Av. El Llano 101	Santiago
2	2	2026-07-01 10:15:00	procesando	Cerro El Plomo 420	Las Condes
3	3	2026-07-02 08:30:00	despachada	Pasaje Los Aromos 155	Maipú
4	4	2026-07-02 11:45:00	entregada	Av. Libertador 2100	Santiago
5	5	2026-07-03 09:20:00	cancelada	Calle Uno 330	Concepción
6	6	2026-07-03 12:10:00	pendiente	Av. Los Leones 886	Providencia
7	7	2026-07-04 08:50:00	procesando	Camino El Alba 640	Huechuraba
8	8	2026-07-04 13:05:00	despachada	Paseo Valparaíso 900	Valparaíso
9	9	2026-07-05 09:40:00	entregada	Agustinas 2500	Santiago
10	10	2026-07-05 14:20:00	pendiente	Av. Apoquindo 4800	Las Condes
11	11	2026-07-06 08:25:00	procesando	Calle Santa Rosa 1550	Santiago
12	12	2026-07-06 10:55:00	despachada	Av. Santa María 4200	Vitacura
13	13	2026-07-07 09:10:00	entregada	Av. Vitacura 3400	Vitacura
14	14	2026-07-07 11:30:00	cancelada	Av. Providencia 900	Providencia
15	15	2026-07-08 08:45:00	pendiente	Bandera 500	Santiago
16	16	2026-07-08 12:25:00	procesando	Ahumada 400	Santiago
17	17	2026-07-09 09:35:00	despachada	Av. Prat 750	Concepción
18	18	2026-07-09 13:15:00	entregada	Huérfanos 1200	Santiago
19	19	2026-07-10 08:15:00	pendiente	Av. Providencia 1600	Providencia
20	20	2026-07-10 10:40:00	procesando	Merced 300	Santiago
21	21	2026-07-11 09:05:00	despachada	Av. Matucana 500	Estación Central
22	22	2026-07-11 11:50:00	entregada	Av. Las Torres 222	Estación Central
23	23	2026-07-12 08:35:00	cancelada	Av. Presidente Riesco 6000	Las Condes
24	24	2026-07-12 12:00:00	pendiente	Av. La Dehesa 2000	Lo Barnechea
25	25	2026-07-13 09:25:00	procesando	Av. Isidora Goyenechea 3100	Las Condes
26	26	2026-07-13 13:30:00	despachada	Av. Nueva Providencia 2500	Providencia
27	27	2026-07-14 08:55:00	entregada	Av. Vicuña Mackenna 8000	La Florida
28	28	2026-07-14 11:10:00	pendiente	Av. Manquehue Norte 1500	Las Condes
29	29	2026-07-15 09:45:00	procesando	Av. Providencia 2800	Providencia
30	30	2026-07-15 14:35:00	despachada	Av. Apoquindo 3500	Las Condes
31	31	2026-07-16 08:20:00	entregada	Av. Américo Vespucio 2500	Quilicura
32	32	2026-07-16 12:45:00	cancelada	Av. Pajaritos 5000	Maipú
33	33	2026-07-17 09:15:00	pendiente	Av. Matta 1000	Santiago
34	34	2026-07-17 13:40:00	procesando	Camino a Melipilla 13000	Padre Hurtado
35	35	2026-07-18 08:30:00	despachada	Av. Del Valle 1500	Huechuraba
36	36	2026-07-18 11:55:00	entregada	Av. San Martín 1800	Macul
37	37	2026-07-19 09:50:00	pendiente	Camino a Melipilla 7500	Cerrillos
38	38	2026-07-19 14:05:00	procesando	Av. Nueva Providencia 2800	Providencia
39	39	2026-07-20 08:10:00	despachada	Ruta 5 Sur km 900	Valdivia
40	40	2026-07-20 12:30:00	entregada	Av. Virginia Subercaseaux 400	Puente Alto
41	41	2026-07-21 09:30:00	cancelada	Camino Santa Rita 500	Alto Jahuel
42	42	2026-07-21 13:20:00	pendiente	Av. Colón 5500	Las Condes
43	43	2026-07-22 08:40:00	procesando	Carmen 800	Puerto Montt
44	44	2026-07-22 12:15:00	despachada	Av. Andrés Bello 3000	Las Condes
45	45	2026-07-23 09:00:00	entregada	Los Militares 6500	Las Condes
46	46	2026-07-23 13:50:00	pendiente	Av. Del Valle 1000	Huechuraba
47	47	2026-07-24 08:25:00	procesando	Av. Andrés Bello 2900	Las Condes
48	48	2026-07-24 11:35:00	despachada	Av. Vitacura 3200	Las Condes
49	49	2026-07-25 09:55:00	entregada	Av. General Bustamante 200	Providencia
50	50	2026-07-25 14:15:00	cancelada	Av. Marcoleta 500	Santiago
51	1	2026-08-25 04:58:30.33874	pendiente	Av. Bernardo O'Higgins 1234	Santiago
\.


--
-- Data for Name: producto_proveedor; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.producto_proveedor (id_producto, id_proveedor, costo_compra, tiempo_entrega_dias) FROM stdin;
1	1	455000.00	5
2	2	245000.00	3
3	3	301000.00	7
4	4	406000.00	9
5	5	385000.00	8
6	6	63000.00	4
7	7	175000.00	10
8	8	56000.00	6
9	9	14000.00	2
10	10	11200.00	3
11	11	112000.00	12
12	12	77000.00	6
13	13	21000.00	4
14	14	5600.00	2
15	15	140000.00	11
16	16	28000.00	5
17	17	17500.00	4
18	18	315000.00	13
19	19	385000.00	9
20	20	49000.00	5
21	21	91000.00	14
22	22	14000.00	3
23	23	45500.00	6
24	24	11200.00	2
25	25	17500.00	4
26	26	21000.00	3
27	27	35000.00	5
28	28	7000.00	2
29	29	1400.00	1
30	30	1300.00	1
31	31	2100.00	1
32	32	2800.00	2
33	33	3500.00	3
34	34	4900.00	2
35	35	6300.00	15
36	36	2800.00	2
37	37	760.00	1
38	38	7000.00	4
39	39	2100.00	2
40	40	1700.00	1
41	41	1700.00	1
42	42	900.00	1
43	43	6300.00	3
44	44	1250.00	2
45	45	5600.00	5
46	46	5600.00	4
47	47	2800.00	3
48	48	14000.00	6
49	49	2100.00	2
50	50	63000.00	7
1	26	460000.00	6
2	27	248000.00	4
3	28	305000.00	8
4	29	410000.00	10
5	30	388000.00	9
6	31	64000.00	5
7	32	178000.00	11
8	33	57000.00	7
9	34	14200.00	3
10	35	11500.00	4
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.productos (id_producto, sku, nombre, descripcion, peso_kg, precio_unitario, id_categoria) FROM stdin;
1	SKU-001	Laptop HP 15-dy2004la	Notebook 15.6 pulgadas, 8GB RAM, 256GB SSD	2.10	649990.00	3
2	SKU-002	Smartphone Samsung Galaxy A54	Celular 6.4 pulgadas, 128GB	0.19	349990.00	4
3	SKU-003	Televisor LG 55 pulgadas 4K	Smart TV UHD, HDR10	14.50	429990.00	6
4	SKU-004	Refrigerador No Frost Samsung	Refrigerador 310 litros, inoxidable	62.00	579990.00	2
5	SKU-005	Lavadora Secadora LG 14kg	Lavado y secado integrado	70.00	549990.00	2
6	SKU-006	Microondas Whirlpool 25L	Horno microondas 1100W	12.80	89990.00	2
7	SKU-007	Aspiradora Robot Roomba i3	Robots de limpieza inteligente	3.10	249990.00	2
8	SKU-008	Cafetera Nespresso Essenza	Cafetera de cápsulas compacta	2.40	79990.00	42
9	SKU-009	Plancha Oster DuraCeramic	Plancha a vapor de cerámica	1.10	19990.00	2
10	SKU-010	Secadora de Pelo Philips	Secador 2200W con difusor	0.65	15990.00	15
11	SKU-011	Impresora Epson EcoTank L3250	Impresora multifuncional sin cartuchos	4.20	159990.00	3
12	SKU-012	Monitor LG 24 pulgadas Full HD	Monitor IPS 1920x1080	3.50	109990.00	3
13	SKU-013	Teclado Logitech K380	Teclado bluetooth compacto	0.42	29990.00	3
14	SKU-014	Mouse Inalámbrico Logitech M185	Mouse óptico 2.4GHz	0.11	7990.00	3
15	SKU-015	Tablet Samsung Tab A8	Tablet 10.5 pulgadas, 64GB	0.55	199990.00	3
16	SKU-016	Audífonos Sony WH-CH520	Audífonos over-ear inalámbricos	0.20	39990.00	6
17	SKU-017	Parlante JBL Go 3	Parlante bluetooth portátil	0.21	24990.00	6
18	SKU-018	Cámara Canon EOS 2000D	Cámara réflex 24.1MP con lente 18-55mm	0.60	449990.00	5
19	SKU-019	Consola PlayStation 5	Consola de última generación 825GB	4.50	549990.00	7
20	SKU-020	Control DualSense PS5	Control inalámbrico oficial	0.37	69990.00	7
21	SKU-021	Silla Gamer Reclinable XT	Silla ergonómica con reposabrazos	21.00	129990.00	7
22	SKU-022	Balón de Fútbol Adidas	Balón oficial tamaño 5	0.45	19990.00	9
23	SKU-023	Zapatilla Running Nike Air Zoom	Zapatilla de running liviana	0.75	64990.00	11
24	SKU-024	Polera Deportiva Under Armour	Polera técnica de secado rápido	0.25	15990.00	10
25	SKU-025	Mochila Urbana Clásica	Mochila 25L con puerto USB	0.80	24990.00	12
26	SKU-026	Reloj Casio Vintage	Reloj analógico retro	0.05	29990.00	13
27	SKU-027	Perfume 1 Million 100ml	Perfume masculino de lujo	0.35	49990.00	15
28	SKU-028	Crema Facial Neutrogena 50g	Crema hidratante facial	0.20	9990.00	16
29	SKU-029	Paracetamol 500mg (caja 20)	Analgésico y antipirético	0.15	1990.00	17
30	SKU-030	Arroz Grado 1 Bolsa 1kg	Arroz grano largo	1.00	1890.00	18
31	SKU-031	Aceite Maravilla Botella 1L	Aceite vegetal 100% maravilla	0.92	2990.00	18
32	SKU-032	Café Molido Nescafé 170g	Café instantáneo en polvo	0.17	3990.00	18
33	SKU-033	Agua Mineral Cachantun 1.5L	Pack de 6 botellas sin gas	9.00	4990.00	19
34	SKU-034	Bebida Cola Zero 1.5L	Pack de 6 botellas	9.15	6990.00	19
35	SKU-035	Vino Tinto Carmenère 750ml	Vino reserva variedad Carmenère	1.20	8990.00	20
36	SKU-036	Queso Mantecoso 500g	Queso mantecoso laminado	0.50	3990.00	21
37	SKU-037	Leche Entera 1L	Leche en caja UHT	1.03	1090.00	21
38	SKU-038	Filete de Salmón 500g	Salmón atlántico fresco	0.50	9990.00	23
39	SKU-039	Manzanas Roja (bandeja 1kg)	Manzanas variedad Royal Gala	1.00	2990.00	24
40	SKU-040	Papas Congeladas 1kg	Papas pre-fritas congeladas	1.00	2490.00	25
41	SKU-041	Pan de Molde Integral 600g	Pan de molde con fibra	0.60	2490.00	26
42	SKU-042	Harina de Trigo 1kg	Harina todo uso	1.00	1290.00	28
43	SKU-043	Detergente Líquido 3L	Detergente concentrado multiuso	3.20	8990.00	29
44	SKU-044	Cuaderno Universitario 100 hojas	Cuaderno cuadriculado tapa dura	0.30	1790.00	31
45	SKU-045	Martillo de Uña 500g	Martillo de acero con mango	0.80	7990.00	34
46	SKU-046	Cemento Especial 42.5kg	Saco de cemento de fraguado normal	42.50	7990.00	35
47	SKU-047	Tierra de Hojas 10L	Sustrato orgánico para jardines	4.00	3990.00	36
48	SKU-048	Alimento Perro Adulto 15kg	Alimento completo sabor pollo	15.00	19990.00	37
49	SKU-049	Lámpara LED E27	Ampolleta LED 9W luz cálida	0.12	2990.00	40
50	SKU-050	Guitarra Acústica Yamaha F310	Guitarra acústica 4/4	2.10	89990.00	50
51	SKU-TEST-001	Producto A	Descripción del Producto A	1.00	10.99	1
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.proveedores (id_proveedor, nombre, rut, telefono, email, pais_origen) FROM stdin;
2	Exportadora Frutícola del Sur	75.000.002-2	+56 42 250 002	ventas@efsur.cl	Chile
3	Textil Cotton Ltda	75.000.003-3	+55 11 2345 5003	textil@cotton.com.br	Brasil
4	Maderas del Bío Bío	75.000.004-4	+56 41 261 004	maderas@biobio.cl	Chile
5	Metalurgia Andina	75.000.005-5	+56 2 2345 005	ventas@metalurgia.cl	Chile
6	Química Global S.A.	75.000.006-6	+49 30 1234 5006	sales@chemglobal.de	Alemania
7	AgroPec Chile	75.000.007-7	+54 11 2345 5007	agropec@argentina.com.ar	Argentina
8	PescaSur	75.000.008-8	+51 1 2345 5008	pescasur@peru.com.pe	Perú
9	Electrónica Asia Import	75.000.009-9	+86 20 1234 5009	asiaimport@china.com	China
10	Insumos Médicos Ltda	75.000.010-0	+1 305 234 5010	medical@insumos.com	Estados Unidos
11	Empaques Nacionales	75.000.011-1	+56 2 2400 011	empaques@nacional.cl	Chile
12	Papeles Cordillera	75.000.012-2	+56 2 2788 012	papel@cordillera.cl	Chile
13	Fertilizantes del Norte	75.000.013-3	+52 55 1234 5013	fertilizantes@norte.mx	México
14	Cauchos Patagonia	75.000.014-4	+54 11 2345 5014	cauchos@patagonia.com.ar	Argentina
15	Vidrio Templado Sur	75.000.015-5	+56 2 2850 015	vidrio@templadosur.cl	Chile
16	Cerámica Bío Bío	75.000.016-6	+55 11 2345 5016	ceramica@biobio.com.br	Brasil
17	Repuestos El Cóndor	75.000.017-7	+81 3 1234 5017	repuestos@condor.jp	Japón
18	Herramientas Max Líder	75.000.018-8	+82 2 1234 5018	tools@maxlider.kr	Corea del Sur
19	Iluminación LED Pro	75.000.019-9	+86 755 1234 5019	led@prolighting.com	China
20	Muebles Rústicos Ltda	75.000.020-0	+56 2 2410 020	muebles@rusticos.cl	Chile
21	Colchones Andinos	75.000.021-1	+54 11 2345 5021	colchones@andinos.com.ar	Argentina
22	Textil del Maule	75.000.022-2	+56 71 234 022	textilmaule@maule.cl	Chile
23	Calzados del Pacífico	75.000.023-3	+84 28 1234 5023	calzados@pacifico.vn	Vietnam
24	Cuero y Talabartería	75.000.024-4	+598 2 234 5024	cuero@talabarteria.uy	Uruguay
25	Productos Lácteos Toltén	75.000.025-5	+56 45 240 025	lacteos@tolten.cl	Chile
26	Carnes del Sur	75.000.026-6	+56 2 2610 026	carnes@delsur.cl	Chile
27	Mariscos Austral	75.000.027-7	+56 61 234 027	mariscos@austral.cl	Chile
28	Frutas Exóticas Import	75.000.028-8	+593 2 234 5028	frutas@exoticas.ec	Ecuador
29	Vinos Boutique	75.000.029-9	+54 261 234 5029	vinos@boutique.com.ar	Argentina
30	Cervecería Artesanal Patagonia	75.000.030-0	+56 2 2760 030	cerveza@artesanal.cl	Chile
31	Confitería La Dulce	75.000.031-1	+57 1 234 5031	confiteria@ladulce.co	Colombia
32	Galletas del Pacífico	75.000.032-2	+51 1 2345 5032	galletas@pacifico.pe	Perú
33	Aceites Andinos	75.000.033-3	+34 91 1234 5033	aceites@andinos.es	España
34	Arroceras del Norte	75.000.034-4	+56 2 2450 034	arroz@norte.cl	Chile
35	Café Monteverde	75.000.035-5	+57 6 234 5035	cafe@monteverde.co	Colombia
36	Té del Sur	75.000.036-6	+91 11 234 5036	te@delsur.in	India
37	Distribuidora Química Nacional	75.000.037-7	+55 11 2345 5037	quimica@nacional.com.br	Brasil
38	Farmacéutica Biogen	75.000.038-8	+41 21 234 5038	pharma@biogen.ch	Suiza
39	Cosméticos Naturales	75.000.039-9	+33 1 2345 5039	cosmeticos@naturales.fr	Francia
40	Aceros del Pacífico	75.000.040-0	+82 2 1234 5040	aceros@pacifico.kr	Corea del Sur
41	Plásticos RIM	75.000.041-1	+56 32 234 041	plasticos@rim.cl	Chile
42	Packaging Verde	75.000.042-2	+56 2 2550 042	packaging@verde.cl	Chile
43	Logística Fría S.A.	75.000.043-3	+56 2 2700 043	logistica@fria.cl	Chile
44	Transportes Refrigerados Andes	75.000.044-4	+56 2 2570 044	transporte@andes.cl	Chile
45	Maquinaria Agrícola Ltda	75.000.045-5	+39 02 1234 5045	maquinaria@agricola.it	Italia
46	Semillas Genéticas	75.000.046-6	+31 20 234 5046	semillas@geneticas.nl	Países Bajos
47	Insumos Veterinarios	75.000.047-7	+1 212 234 5047	veterinaria@insumos.com	Estados Unidos
48	Mascotas Premium	75.000.048-8	+56 2 2580 048	mascotas@premium.cl	Chile
49	Juguetes Creativos	75.000.049-9	+86 21 1234 5049	juguetes@creativos.com	China
50	Instrumentos Musicales del Sur	75.000.050-0	+49 89 234 5050	musica@delsur.de	Alemania
1	Industrial de Alimentos AG	75.000.001-1	555-5678	proveedor@example.com	China
\.


--
-- Data for Name: transportistas; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.transportistas (id_transportista, nombre, rut, telefono, tipo_vehiculo) FROM stdin;
1	Transportes Pérez Limitada	78.000.001-1	+56 2 2345 0001	Camión 3/4
2	Cargo Express Chile	78.000.002-2	+56 2 2345 0002	Camión 5 Ejes
3	Fletes del Norte	78.000.003-3	+56 2 2345 0003	Furgón
4	Transportes Austral	78.000.004-4	+56 2 2345 0004	\N
5	Logística Ruta Norte	78.000.005-5	+56 2 2345 0005	Camioneta
6	Transportes Valle Central	78.000.006-6	+56 2 2345 0006	Camión 3/4
7	Mensajería Urbana Ltda	78.000.007-7	+56 2 2345 0007	Motocicleta
8	Transportes Cóndor	78.000.008-8	+56 2 2345 0008	Camión 5 Ejes
9	Red Sur de Transportes	78.000.009-9	+56 2 2345 0009	Camión 3/4
10	Transportes Mineros Limitada	78.000.010-0	+56 2 2345 0010	Camión 5 Ejes
11	Fletes Patagonia	78.000.011-1	+56 2 2345 0011	Furgón
12	Transportes del Bío Bío	78.000.012-2	+56 2 2345 0012	Camión 3/4
13	Express Encomiendas SA	78.000.013-3	+56 2 2345 0013	Camioneta
14	Transportes Amistad	78.000.014-4	+56 2 2345 0014	Camión 3/4
15	Mudanzas y Fletes Ruta 5	78.000.015-5	+56 2 2345 0015	\N
16	Logística Fría Patagonia	78.000.016-6	+56 2 2345 0016	Camión Refrigerado
17	Transportes Cordillera	78.000.017-7	+56 2 2345 0017	Camión 5 Ejes
18	Cargo Pacífico	78.000.018-8	+56 2 2345 0018	Contenedor
19	Transportes del Maule	78.000.019-9	+56 2 2345 0019	Camión 3/4
20	Fletes Granizo	78.000.020-0	+56 2 2345 0020	Camioneta
21	Transportes Nahuel	78.000.021-1	+56 2 2345 0021	Furgón
22	Logística Omega	78.000.022-2	+56 2 2345 0022	Camión 5 Ejes
23	Transportes del Desierto	78.000.023-3	+56 2 2345 0023	Camión 3/4
24	Ruta 60 Transportes	78.000.024-4	+56 2 2345 0024	Camión 3/4
25	Fletes Estrella del Sur	78.000.025-5	+56 2 2345 0025	Camión 5 Ejes
26	Transportes Limitada Los Andes	78.000.026-6	+56 2 2345 0026	Camioneta
27	Cargo Refrigerado Austral	78.000.027-7	+56 2 2345 0027	Camión Refrigerado
28	Transportes El Rayo	78.000.028-8	+56 2 2345 0028	\N
29	Mensajería Metro Express	78.000.029-9	+56 2 2345 0029	Motocicleta
30	Fletes del Valle	78.000.030-0	+56 2 2345 0030	Furgón
31	Transportes Toltén	78.000.031-1	+56 2 2345 0031	Camión 3/4
32	Cargo Norte Grande	78.000.032-2	+56 2 2345 0032	Camión 5 Ejes
33	Transportes Huemul	78.000.033-3	+56 2 2345 0033	Camioneta
34	Logística Andina	78.000.034-4	+56 2 2345 0034	Camión 3/4
35	Fletes del Pacífico	78.000.035-5	+56 2 2345 0035	Contenedor
36	Transportes Rapel	78.000.036-6	+56 2 2345 0036	Camión 5 Ejes
37	Express Bío Bío	78.000.037-7	+56 2 2345 0037	Furgón
38	Transportes Llanquihue	78.000.038-8	+56 2 2345 0038	Camión 3/4
39	Cargo Frío Sur	78.000.039-9	+56 2 2345 0039	Camión Refrigerado
40	Transportes Ranco	78.000.040-0	+56 2 2345 0040	Camioneta
41	Fletes del Litoral	78.000.041-1	+56 2 2345 0041	Camión 3/4
42	Transportes Aconcagua	78.000.042-2	+56 2 2345 0042	Camión 5 Ejes
43	Logística Maule Express	78.000.043-3	+56 2 2345 0043	Camión 3/4
44	Transportes Tinguiririca	78.000.044-4	+56 2 2345 0044	Furgón
45	Cargo Central	78.000.045-5	+56 2 2345 0045	Camión 3/4
46	Fletes del Choapa	78.000.046-6	+56 2 2345 0046	\N
47	Transportes Baker	78.000.047-7	+56 2 2345 0047	Camión 5 Ejes
48	Express Punta Arenas	78.000.048-8	+56 2 2345 0048	Camioneta
49	Transportes Temuco Express	78.000.049-9	+56 2 2345 0049	Camión 3/4
50	Fletes Villarrica	78.000.050-0	+56 2 2345 0050	Camión 3/4
\.


--
-- Data for Name: ubicaciones; Type: TABLE DATA; Schema: logitrack; Owner: ua_eq06
--

COPY logitrack.ubicaciones (id_ubicacion, id_bodega, pasillo, estante, nivel) FROM stdin;
1	1	A	1	N1
2	1	A	2	N1
3	1	A	3	N1
4	1	A	4	N1
5	1	A	5	N1
6	1	B	1	N2
7	1	B	2	N2
8	1	B	3	N2
9	1	B	4	N2
10	1	B	5	N2
11	2	A	1	N1
12	2	A	2	N1
13	2	A	3	N1
14	2	A	4	N1
15	2	A	5	N1
16	2	B	1	N2
17	2	B	2	N2
18	2	B	3	N2
19	2	B	4	N2
20	2	B	5	N2
21	3	A	1	N1
22	3	A	2	N1
23	3	A	3	N1
24	3	A	4	N1
25	3	A	5	N1
26	3	B	1	N2
27	3	B	2	N2
28	3	B	3	N2
29	3	B	4	N2
30	3	B	5	N2
31	4	A	1	N1
32	4	A	2	N1
33	4	A	3	N1
34	4	A	4	N1
35	4	A	5	N1
36	4	B	1	N2
37	4	B	2	N2
38	4	B	3	N2
39	4	B	4	N2
40	4	B	5	N2
41	5	A	1	N1
42	5	A	2	N1
43	5	A	3	N1
44	5	A	4	N1
45	5	A	5	N1
46	5	B	1	N2
47	5	B	2	N2
48	5	B	3	N2
49	5	B	4	N2
50	5	B	5	N2
\.


--
-- Name: bodega_id_bodega_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.bodega_id_bodega_seq', 50, true);


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.categorias_id_categoria_seq', 50, true);


--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.clientes_id_cliente_seq', 53, true);


--
-- Name: detalle_ordenes_id_detalle_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.detalle_ordenes_id_detalle_seq', 61, true);


--
-- Name: empleados_id_empleado_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.empleados_id_empleado_seq', 50, true);


--
-- Name: envios_id_envio_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.envios_id_envio_seq', 51, true);


--
-- Name: inventario_id_inventario_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.inventario_id_inventario_seq', 50, true);


--
-- Name: ordenes_id_orden_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.ordenes_id_orden_seq', 51, true);


--
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.productos_id_producto_seq', 51, true);


--
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.proveedores_id_proveedor_seq', 50, true);


--
-- Name: transportistas_id_transportista_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.transportistas_id_transportista_seq', 50, true);


--
-- Name: ubicaciones_id_ubicacion_seq; Type: SEQUENCE SET; Schema: logitrack; Owner: ua_eq06
--

SELECT pg_catalog.setval('logitrack.ubicaciones_id_ubicacion_seq', 50, true);


--
-- Name: bodega bodega_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.bodega
    ADD CONSTRAINT bodega_pkey PRIMARY KEY (id_bodega);


--
-- Name: categorias categorias_nombre_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.categorias
    ADD CONSTRAINT categorias_nombre_key UNIQUE (nombre);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- Name: clientes clientes_rut_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.clientes
    ADD CONSTRAINT clientes_rut_key UNIQUE (rut);


--
-- Name: detalle_ordenes detalle_ordenes_id_orden_id_producto_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.detalle_ordenes
    ADD CONSTRAINT detalle_ordenes_id_orden_id_producto_key UNIQUE (id_orden, id_producto);


--
-- Name: detalle_ordenes detalle_ordenes_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.detalle_ordenes
    ADD CONSTRAINT detalle_ordenes_pkey PRIMARY KEY (id_detalle);


--
-- Name: empleados empleados_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.empleados
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (id_empleado);


--
-- Name: empleados empleados_rut_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.empleados
    ADD CONSTRAINT empleados_rut_key UNIQUE (rut);


--
-- Name: envios envios_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.envios
    ADD CONSTRAINT envios_pkey PRIMARY KEY (id_envio);


--
-- Name: inventario inventario_id_producto_id_ubicacion_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.inventario
    ADD CONSTRAINT inventario_id_producto_id_ubicacion_key UNIQUE (id_producto, id_ubicacion);


--
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);


--
-- Name: ordenes ordenes_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.ordenes
    ADD CONSTRAINT ordenes_pkey PRIMARY KEY (id_orden);


--
-- Name: producto_proveedor producto_proveedor_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.producto_proveedor
    ADD CONSTRAINT producto_proveedor_pkey PRIMARY KEY (id_producto, id_proveedor);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- Name: productos productos_sku_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.productos
    ADD CONSTRAINT productos_sku_key UNIQUE (sku);


--
-- Name: proveedores proveedores_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.proveedores
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor);


--
-- Name: proveedores proveedores_rut_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.proveedores
    ADD CONSTRAINT proveedores_rut_key UNIQUE (rut);


--
-- Name: transportistas transportistas_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.transportistas
    ADD CONSTRAINT transportistas_pkey PRIMARY KEY (id_transportista);


--
-- Name: transportistas transportistas_rut_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.transportistas
    ADD CONSTRAINT transportistas_rut_key UNIQUE (rut);


--
-- Name: ubicaciones ubicaciones_id_bodega_pasillo_estante_nivel_key; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.ubicaciones
    ADD CONSTRAINT ubicaciones_id_bodega_pasillo_estante_nivel_key UNIQUE (id_bodega, pasillo, estante, nivel);


--
-- Name: ubicaciones ubicaciones_pkey; Type: CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.ubicaciones
    ADD CONSTRAINT ubicaciones_pkey PRIMARY KEY (id_ubicacion);


--
-- Name: detalle_ordenes detalle_ordenes_id_orden_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.detalle_ordenes
    ADD CONSTRAINT detalle_ordenes_id_orden_fkey FOREIGN KEY (id_orden) REFERENCES logitrack.ordenes(id_orden);


--
-- Name: detalle_ordenes detalle_ordenes_id_producto_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.detalle_ordenes
    ADD CONSTRAINT detalle_ordenes_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES logitrack.productos(id_producto);


--
-- Name: empleados empleados_id_bodega_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.empleados
    ADD CONSTRAINT empleados_id_bodega_fkey FOREIGN KEY (id_bodega) REFERENCES logitrack.bodega(id_bodega);


--
-- Name: envios envios_id_empleado_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.envios
    ADD CONSTRAINT envios_id_empleado_fkey FOREIGN KEY (id_empleado) REFERENCES logitrack.empleados(id_empleado);


--
-- Name: envios envios_id_orden_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.envios
    ADD CONSTRAINT envios_id_orden_fkey FOREIGN KEY (id_orden) REFERENCES logitrack.ordenes(id_orden);


--
-- Name: envios envios_id_transportista_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.envios
    ADD CONSTRAINT envios_id_transportista_fkey FOREIGN KEY (id_transportista) REFERENCES logitrack.transportistas(id_transportista);


--
-- Name: inventario inventario_id_producto_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.inventario
    ADD CONSTRAINT inventario_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES logitrack.productos(id_producto);


--
-- Name: inventario inventario_id_ubicacion_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.inventario
    ADD CONSTRAINT inventario_id_ubicacion_fkey FOREIGN KEY (id_ubicacion) REFERENCES logitrack.ubicaciones(id_ubicacion);


--
-- Name: ordenes ordenes_id_cliente_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.ordenes
    ADD CONSTRAINT ordenes_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES logitrack.clientes(id_cliente);


--
-- Name: producto_proveedor producto_proveedor_id_producto_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.producto_proveedor
    ADD CONSTRAINT producto_proveedor_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES logitrack.productos(id_producto);


--
-- Name: producto_proveedor producto_proveedor_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.producto_proveedor
    ADD CONSTRAINT producto_proveedor_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES logitrack.proveedores(id_proveedor);


--
-- Name: productos productos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.productos
    ADD CONSTRAINT productos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES logitrack.categorias(id_categoria);


--
-- Name: ubicaciones ubicaciones_id_bodega_fkey; Type: FK CONSTRAINT; Schema: logitrack; Owner: ua_eq06
--

ALTER TABLE ONLY logitrack.ubicaciones
    ADD CONSTRAINT ubicaciones_id_bodega_fkey FOREIGN KEY (id_bodega) REFERENCES logitrack.bodega(id_bodega);


--
-- PostgreSQL database dump complete
--

