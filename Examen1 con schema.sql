USE master;
IF DB_ID('Examen1') IS NOT NULL
BEGIN
    ALTER DATABASE Examen1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Examen1;
END
GO

CREATE DATABASE Examen1;
GO

USE Examen1;
GO

CREATE SCHEMA ClientesSQ;
GO

CREATE SCHEMA Inventarios;
GO

IF OBJECT_ID('ClientesSQ.CorreosCliente', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.CorreosCliente;
END
GO

IF OBJECT_ID('ClientesSQ.TelefonosClientes', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.TelefonosClientes;
END
GO

IF OBJECT_ID('ClientesSQ.Turnos', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.Turnos;
END
GO

IF OBJECT_ID('ClientesSQ.Ventas', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.Ventas;
END
GO

IF OBJECT_ID('ClientesSQ.DetalleVentas', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.DetalleVentas;
END
GO

IF OBJECT_ID('ClientesSQ.Cobros', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.Cobros;
END
GO

IF OBJECT_ID('ClientesSQ.Pagos', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.Pagos;
END
GO

IF OBJECT_ID('ClientesSQ.Clientes', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.Clientes;
END
GO

IF OBJECT_ID('ClientesSQ.Usuarios', 'U') IS NOT NULL
BEGIN
    DROP TABLE ClientesSQ.Usuarios;
END
GO

CREATE TABLE ClientesSQ.Clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
	empresa VARCHAR(50),
    nombre1 VARCHAR(50),
	nombre2 VARCHAR(50),
	apellido1 VARCHAR(50),
	apellido2 VARCHAR(50),
	limite_credito decimal(10,2),
	saldo_actual decimal(10,2),
);
GO

CREATE TABLE ClientesSQ.CorreosClientes (
    id_cliente INT,
    correo VARCHAR(50),
    PRIMARY KEY (id_cliente, correo),
    FOREIGN KEY (id_cliente) REFERENCES ClientesSQ.Clientes(id)
);
GO

CREATE TABLE ClientesSQ.TelefonosClientes (
    id_cliente INT,
    telefono VARCHAR(10),
    PRIMARY KEY (id_cliente, telefono),
    FOREIGN KEY (id_cliente) REFERENCES ClientesSQ.Clientes(id)
);
GO

CREATE TABLE ClientesSQ.Gastos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL UNIQUE,
);
GO

CREATE TABLE ClientesSQ.Usuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE,
	clave VARCHAR(20) NOT NULL,
);
GO

CREATE TABLE ClientesSQ.Turnos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
	descripcion varchar(20) NOT NULL,
    id_usuario int NOT NULL,
	inicio datetime,
	final datetime,
    FOREIGN KEY (id_usuario) REFERENCES ClientesSQ.Usuarios(id)
);
GO

CREATE TABLE ClientesSQ.Ventas (
	id INT IDENTITY(1,1) PRIMARY KEY,
	fecha datetime NOT NULL,
	id_cliente int NOT NULL,
	tipo_venta int NOT NULL,
	vencimiento datetime NOT NULL,
	id_turno int NOT NULL,
	FOREIGN KEY (id_cliente) REFERENCES ClientesSQ.Clientes(id),
	FOREIGN KEY (id_turno) REFERENCES ClientesSQ.Turnos(id),
);
GO

CREATE TABLE ClientesSQ.DetalleVentas (
    id_venta int,
	linea INT,
	id_producto INT not null,
    cantidad INT not null,
    precio_venta decimal(10,2) not null,
    CONSTRAINT PK_DetalleVentas PRIMARY KEY (id_venta, linea),
    CONSTRAINT FK_VentaId FOREIGN KEY (id_venta) REFERENCES ClientesSQ.Ventas(id)
);
GO

CREATE TABLE ClientesSQ.Cobros (
	id INT IDENTITY(1,1) PRIMARY KEY,
	monto decimal(10,2) not null,
	id_venta int not null,
	fecha datetime not null
	CONSTRAINT FK_VentaIdCobros FOREIGN KEY (id_venta) REFERENCES ClientesSQ.Ventas(id),
);
GO

CREATE TABLE ClientesSQ.Pagos (
	id INT IDENTITY(1,1) PRIMARY KEY,
	monto decimal(10,2) not null,
	fecha datetime not null,
	id_gasto int not null,
	id_turno int not null,
	CONSTRAINT FK_GastoId FOREIGN KEY (id_gasto) REFERENCES ClientesSQ.Gastos(id),
	CONSTRAINT FK_TurnoId FOREIGN KEY (id_turno) REFERENCES ClientesSQ.Turnos(id),
);
GO

IF OBJECT_ID('Inventarios.Productos', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.Productos;
END
GO

IF OBJECT_ID('Inventarios.Ubicaciones', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.Ubicaciones;
END
GO

IF OBJECT_ID('Inventarios.Existencias', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.Existencias;
END
GO

IF OBJECT_ID('Inventarios.Proveedores', 'U') IS NOT NULL
BEGIN
    DROP TABLE Proveedores;
END
GO

IF OBJECT_ID('Inventarios.CorreosProveedores', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.CorreosProveedores;
END
GO

IF OBJECT_ID('Inventarios.TelefonosProveedores', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.TelefonosProveedores;
END
GO

IF OBJECT_ID('Inventarios.Compras', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.Compras;
END
GO

IF OBJECT_ID('Inventarios.DetalleCompras', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.DetalleCompras;
END
GO

IF OBJECT_ID('Inventarios.Pedidos', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.Pedidos;
END
GO

IF OBJECT_ID('Inventarios.DetallePedidos', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.DetallePedidos;
END
GO

IF OBJECT_ID('Inventarios.Remisiones', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.Remisiones;
END
GO

IF OBJECT_ID('Inventarios.DetalleRemisiones', 'U') IS NOT NULL
BEGIN
    DROP TABLE Inventarios.DetalleRemisiones;
END
GO

CREATE TABLE Inventarios.Productos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) not null unique,
    precio_de_venta DECIMAL(10, 2) not null,
    punto_de_reorden int,
	cantidad_minima int,
	cantidad_maxima int,
);
GO

CREATE TABLE Inventarios.Ubicaciones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) not null unique,
);
GO

CREATE TABLE Inventarios.Existencias (
    id_producto INT not null,
    id_ubicacion INT not null,
    existencia INT,
    PRIMARY KEY (id_producto, id_ubicacion),
    FOREIGN KEY (id_producto) REFERENCES Inventarios.Productos(id),
    FOREIGN KEY (id_ubicacion) REFERENCES Inventarios.Ubicaciones(id)
);
GO

CREATE TABLE Inventarios.Proveedores (
    id INT IDENTITY(1,1) PRIMARY KEY,
	empresa VARCHAR(50),
    nombre1 VARCHAR(50),
	nombre2 VARCHAR(50),
	apellido1 VARCHAR(50),
	apellido2 VARCHAR(50),
	limite_credito decimal(10,2),
	saldo_actual decimal(10,2),
);
GO

CREATE TABLE Inventarios.CorreosProveedores (
	id_proveedor INT,
    correo VARCHAR(50) not null unique,
    PRIMARY KEY (id_proveedor, correo),
    FOREIGN KEY (id_proveedor) REFERENCES Inventarios.Proveedores(id)
);
GO

CREATE TABLE Inventarios.TelefonosProveedores (
    id_proveedor INT,
    telefono VARCHAR(10) not null,
    PRIMARY KEY (id_proveedor, telefono),
    FOREIGN KEY (id_proveedor) REFERENCES Inventarios.Proveedores(id)
);
GO

CREATE TABLE Inventarios.Compras (
	id INT IDENTITY(1,1) PRIMARY KEY,
	fecha datetime NOT NULL,
	id_proveedor int NOT NULL,
	id_turno int NOT NULL,
	FOREIGN KEY (id_proveedor) REFERENCES Inventarios.Proveedores(id),
	FOREIGN KEY (id_turno) REFERENCES ClientesSQ.Turnos(id),
);
GO

CREATE TABLE Inventarios.DetalleCompras (
    id_compra int,
	linea INT,
	id_producto INT not null,
    cantidad INT not null,
    precio_costo decimal(10,2) not null,
	precio_sugerido decimal(10,2) not null,
    CONSTRAINT PK_DetalleCompras PRIMARY KEY (id_compra, linea),
    CONSTRAINT FK_CompraId FOREIGN KEY (id_compra) REFERENCES Inventarios.Compras(id),
    CONSTRAINT FK_ProductoId FOREIGN KEY (id_producto) REFERENCES Inventarios.Productos(id)
);
GO

CREATE TABLE Inventarios.Pedidos (
	id INT IDENTITY(1,1) PRIMARY KEY,
	fecha datetime NOT NULL,
	estado bit not null,
	id_proveedor int NOT NULL,
	id_turno int NOT NULL,
	FOREIGN KEY (id_proveedor) REFERENCES Inventarios.Proveedores(id),
	FOREIGN KEY (id_turno) REFERENCES ClientesSQ.Turnos(id),
);
GO

CREATE TABLE Inventarios.DetallePedidos (
    id_pedido int,
	linea INT,
	id_producto INT not null,
    cantidad INT not null,
    precio_costo decimal(10,2) not null,
	precio_sugerido decimal(10,2) not null,
    CONSTRAINT PK_DetallePedido PRIMARY KEY (id_pedido, linea),
    CONSTRAINT FK_PedidoId FOREIGN KEY (id_pedido) REFERENCES Inventarios.Pedidos(id),
    CONSTRAINT FK_ProductoId2 FOREIGN KEY (id_producto) REFERENCES Inventarios.Productos(id),
);
GO

CREATE TABLE Inventarios.Remisiones (
	id INT IDENTITY(1,1) PRIMARY KEY,
	fecha datetime NOT NULL,
	id_origen int not null,
	id_destino int not null,
	id_turno int NOT NULL,
	FOREIGN KEY (id_turno) REFERENCES ClientesSQ.Turnos(id),
	FOREIGN KEY (id_origen) REFERENCES Inventarios.Ubicaciones(id),
	FOREIGN KEY (id_destino) REFERENCES Inventarios.Ubicaciones(id),
	CONSTRAINT CHK_Origen_Destino CHECK (id_origen <> id_destino)
);
GO

CREATE TABLE Inventarios.DetalleRemisiones (
    id_remision int,
	linea INT,
	id_producto INT not null,
    cantidad INT not null,
    precio_costo decimal(10,2) not null,
	precio_sugerido decimal(10,2) not null,
    CONSTRAINT PK_DetalleRemisiones PRIMARY KEY (id_remision, linea),
    CONSTRAINT FK_RemisionId FOREIGN KEY (id_remision) REFERENCES Inventarios.Remisiones(id),
    CONSTRAINT FK_ProductoId3 FOREIGN KEY (id_producto) REFERENCES Inventarios.Productos(id)
);
GO

ALTER TABLE ClientesSQ.DetalleVentas
ADD CONSTRAINT FK_ProductoId_DV FOREIGN KEY (id_producto) REFERENCES Inventarios.Productos(id);
GO

use Examen1
GO

INSERT INTO ClientesSQ.Clientes (empresa, nombre1, nombre2, apellido1, apellido2, limite_credito, saldo_actual)
VALUES
('Acme Corp', 'Lucia', 'Margarita', 'Garcia', 'Rojas', 5000.00, 2500.00),
('Belleza Latina', 'Juan', 'Pablo', 'Diaz', 'Gonzalez', 10000.00, 5000.00),
('Casa Verde', 'Miguel', 'Angel', 'Rodriguez', 'Hernandez', 7500.00, 1500.00),
('Delicias de Maria', 'Maria', 'Fernanda', 'Perez', 'Lopez', 1000.00, 250.00),
('Estilos de Moda', 'Luisa', 'Isabel', 'Herrera', 'Gomez', 5000.00, 2000.00),
('Floreria Flores', 'Antonio', 'Jose', 'Martinez', 'Sanchez', 1500.00, 1000.00),
('Globos y Fiestas', 'Carolina', 'Maria', 'Ruiz', 'Gutierrez', 2000.00, 500.00),
('Hogar y Mas', 'Roberto', 'Carlos', 'Vargas', 'Castro', 3000.00, 1500.00),
('Inversiones Garcia', 'Ana', 'Maria', 'Garcia', 'Ramirez', 50000.00, 10000.00),
('Joyas del Caribe', 'Fernando', 'Javier', 'Castillo', 'Ortega', 20000.00, 5000.00);
GO

-- Insertar correos electrónicos de los clientes
INSERT INTO ClientesSQ.CorreosClientes (id_cliente, correo)
VALUES
(1, 'lgarcia23@example.com'),
(1, 'lmgarcia92@example.com'),
(2, 'jpdiaz74@example.com'),
(3, 'marodriguez86@example.com'),
(3, 'mahernandez71@example.com'),
(4, 'mfperez13@example.com'),
(5, 'liherrera55@example.com'),
(6, 'ajmartinez79@example.com'),
(7, 'cmruiz47@example.com'),
(8, 'rcvargas63@example.com'),
(9, 'amgarcia38@example.com'),
(10, 'fjcastillo24@example.com');
GO

-- Insertar números de teléfono de los clientes
INSERT INTO ClientesSQ.TelefonosClientes (id_cliente, telefono)
VALUES
(1, '5551234567'),
(1, '5559876543'),
(2, '5552345678'),
(3, '5558765432'),
(4, '5553456789'),
(5, '5557654321'),
(6, '5554567890'),
(7, '5556543210'),
(8, '5557890123'),
(9, '5558901234'),
(10, '5553214567');
GO

-- Insertar 10 registros en la tabla Inventarios.Proveedores
INSERT INTO Inventarios.Proveedores (empresa, nombre1, nombre2, apellido1, apellido2, limite_credito, saldo_actual)
VALUES
('Acme Inc.', 'Juan', 'Carlos', 'Gómez', 'Pérez', 5000.00, 2500.00),
('Inversiones Alfa', 'María', 'Elena', 'García', 'Martínez', 10000.00, 8000.00),
('Productos de Calidad S.A.', 'Pedro', 'Antonio', 'Rodríguez', 'Sánchez', 8000.00, 5000.00),
('Alimentos Latinoamericanos', 'Laura', 'Isabel', 'Hernández', 'Ramírez', 12000.00, 7000.00),
('Distribuidora Nacional', 'Miguel', 'Ángel', 'Torres', 'Jiménez', 15000.00, 10000.00),
('Comercializadora del Norte', 'Ana', 'María', 'Ruiz', 'Gutiérrez', 9000.00, 6000.00),
('Suministros Industriales S.A.', 'Jorge', 'Alberto', 'López', 'González', 12000.00, 8000.00),
('Almacenes Unidos', 'Fernando', 'Antonio', 'Díaz', 'Pérez', 7000.00, 4000.00),
('Proveeduría Nacional', 'Gustavo', 'Adolfo', 'Castillo', 'Vargas', 10000.00, 7000.00),
('Distribuidora de Productos Frescos', 'Carolina', 'Isabella', 'Fuentes', 'Paz', 11000.00, 8000.00);
GO

-- Insertar 10 registros en la tabla Inventarios.CorreosProveedores
INSERT INTO Inventarios.CorreosProveedores (id_proveedor, correo)
VALUES
(1, 'juan.carlos@acme.com'),
(1, 'jcarlos@gmail.com'),
(2, 'me.garcia@inversionesalfa.com'),
(2, 'info@inversionesalfa.com'),
(3, 'prodcaldad@prodcaldad.com'),
(3, 'pedroantonio@prodcaldad.com'),
(4, 'lahernandez@alimentoslatam.com'),
(4, 'laura.ramirez@alimentoslatam.com'),
(5, 'miguel.torres@distribnacional.com'),
(5, 'distribnacional@correo.com');
GO

-- Insertar 10 registros en la tabla Inventarios.TelefonosProveedores
INSERT INTO Inventarios.TelefonosProveedores (id_proveedor, telefono)
VALUES
(1, '555-1234'),
(1, '555-5678'),
(2, '555-2468'),
(2, '555-3698'),
(3, '555-1357'),
(3, '555-2468'),
(4, '555-2468'),
(4, '555-8023'),
(5, '555-1357'),
(5, '555-8023'),
(6, '555-2468'),
(6, '555-5678'),
(7, '555-5698'),
(8, '555-5699'),
(9, '555-5698'),
(10, '555-5578');
GO

-- Insertar 10 registros de productos en la tabla "Inventarios.Productos"
INSERT INTO Inventarios.Productos (nombre, precio_de_venta, punto_de_reorden, cantidad_minima, cantidad_maxima)
VALUES
('Arroz', 6.50, 50, 10, 100),
('Frijoles', 4.00, 30, 5, 50),
('Harina de trigo', 4.25, 40, 8, 80),
('Azúcar', 3.00, 35, 7, 70),
('Sal', 1.75, 25, 6, 60),
('Aceite de oliva', 15.00, 20, 4, 40),
('Leche en polvo', 10.50, 15, 3, 30),
('Café', 7.75, 10, 2, 20),
('Harina de maíz', 3.50, 45, 9, 90),
('Aceite vegetal', 6.00, 55, 11, 110);
GO

-- Insertar las ubicaciones "Sala de Ventas" y "Bodega #1"
INSERT INTO Inventarios.Ubicaciones (nombre) VALUES ('Sala de Ventas'), ('Bodega #1');
GO

-- Insertar las existencias de los productos en cada ubicación
INSERT INTO Inventarios.Existencias (id_producto, id_ubicacion, existencia)
SELECT p.id, u.id, ROUND(RAND()*50, 0) -- cantidad aleatoria entre 0 y 50
FROM Inventarios.Productos p, Inventarios.Ubicaciones u;
GO

INSERT INTO ClientesSQ.Gastos (descripcion)
VALUES 
('Energía eléctrica'),
('Agua'),
('Telefonía'),
('Alcaldía');
GO

INSERT INTO ClientesSQ.Usuarios (nombre, clave)
VALUES
('Gates', '1234'),
('Jobs', '5678'),
('Torvalds', '9101');
GO

INSERT INTO ClientesSQ.Turnos (descripcion, id_usuario, inicio, final)
VALUES
('Turno 1', 1, '2023-02-17 09:00:00', '2023-02-17 13:00:00'),
('Turno 2', 2, '2023-02-17 14:00:00', '2023-02-17 18:00:00'),
('Turno 3', 3, '2023-02-17 19:00:00', '2023-02-17 23:00:00');
GO

-- Inserción de registros en la tabla maestra Ventas
INSERT INTO ClientesSQ.Ventas (fecha, id_cliente, tipo_venta, vencimiento, id_turno)
VALUES 
	('2022-02-10 08:30:00', 2, 1, '2022-03-10 08:30:00', 1),
	('2022-02-10 09:30:00', 4, 1, '2022-03-10 09:30:00', 2),
	('2022-02-11 10:00:00', 3, 2, '2022-03-11 10:00:00', 1),
	('2022-02-11 11:30:00', 2, 1, '2022-03-11 11:30:00', 2),
	('2022-02-12 12:00:00', 1, 2, '2022-03-12 12:00:00', 1),
	('2022-02-12 13:00:00', 4, 1, '2022-03-12 13:00:00', 2),
	('2022-02-13 14:00:00', 2, 2, '2022-03-13 14:00:00', 1),
	('2022-02-13 15:30:00', 1, 1, '2022-03-13 15:30:00', 2),
	('2022-02-14 16:00:00', 3, 1, '2022-03-14 16:00:00', 1),
	('2022-02-14 17:00:00', 4, 2, '2022-03-14 17:00:00', 2)
GO

-- Inserción de registros en la tabla detalle DetalleVentas
INSERT INTO ClientesSQ.DetalleVentas (id_venta, linea, id_producto, cantidad, precio_venta)
VALUES
	(1, 1, 1, 5, 10.50),
	(1, 2, 2, 3, 15.25),
	(1, 3, 4, 2, 20.00),
	(2, 1, 1, 2, 11.00),
	(2, 2, 3, 4, 8.75),
	(3, 1, 2, 1, 12.50),
	(3, 2, 3, 2, 8.75),
	(4, 1, 1, 3, 10.50),
	(4, 2, 2, 2, 15.25),
	(5, 1, 4, 1, 20.00),
	(6, 1, 3, 3, 8.75),
	(7, 1, 1, 4, 10.50),
	(8, 1, 2, 2, 15.25),
	(9, 1, 4, 3, 20.00),
	(10, 1, 5, 5, 10.50);
GO

INSERT INTO ClientesSQ.Pagos (monto, fecha, id_gasto, id_turno)
VALUES (125.00, '2023-02-15', 1, 1),
       (90.50, '2023-02-14', 2, 2),
       (150.00, '2023-02-12', 3, 3),
       (200.00, '2023-02-10', 4, 1),
       (50.25, '2023-02-08', 1, 2),
       (75.60, '2023-02-07', 2, 3),
       (120.00, '2023-02-05', 3, 1),
       (80.00, '2023-02-03', 4, 2),
       (100.00, '2023-02-01', 1, 3),
       (95.75, '2023-01-31', 2, 1);
GO

-- Inserción de datos en la tabla maestro de Compras
INSERT INTO Inventarios.Compras (fecha, id_proveedor, id_turno)
VALUES 
	('2022-01-01', 2, 2),
	('2022-01-03', 1, 1),
	('2022-01-06', 3, 3),
	('2022-01-08', 4, 1),
	('2022-01-10', 5, 2),
	('2022-01-15', 6, 3),
	('2022-01-18', 7, 1),
	('2022-01-20', 8, 1),
	('2022-01-22', 9, 2),
	('2022-01-25', 10, 2);
GO

-- Inserción de datos en la tabla de detalle de Compras
-- Detalle de la compra con id=1
INSERT INTO Inventarios.DetalleCompras (id_compra, linea, id_producto, cantidad, precio_costo, precio_sugerido)
VALUES
	(1, 1, 1, 10, 100.00, 0.00),
	(1, 2, 2, 5, 50.00, 0.00),
	(1, 3, 4, 2, 25.00, 0.00),
	(2, 1, 3, 20, 25.00, 0.00),
	(2, 2, 2, 15, 50.00, 0.00),
	(3, 1, 1, 30, 90.00, 0.00),
	(3, 2, 2, 25, 45.00, 0.00),
	(3, 3, 3, 15, 20.00, 0.00),
	(4, 1, 4, 4, 30.00, 40.00),
	(5, 1, 1, 15, 85.00, 0.00),
	(5, 2, 4, 10, 20.00, 0.00),
	(5, 3, 5, 5, 10.00, 0.00),
	(6, 1, 1, 10, 100.00, 0.00),
	(6, 2, 2, 5, 50.00, 70.00),
	(6, 3, 4, 2, 25.00, 40.00),
	(7, 1, 3, 20, 25.00, 0.00),
	(7, 2, 2, 15, 50.00, 0.00),
	(8, 1, 1, 30, 90.00, 0.00),
	(8, 2, 2, 25, 45.00, 0.00),
	(8, 3, 3, 15, 20.00, 0.00),
	(9, 1, 4, 4, 30.00, 0.00),
	(10, 1, 1, 15, 85.00, 90.00),
	(10, 2, 4, 10, 20.00, 30.00),
	(10, 3, 5, 5, 10.00, 20.00);
GO

-- Inserción en la tabla maestro de pedidos
INSERT INTO Inventarios.Pedidos (fecha, estado, id_proveedor, id_turno)
VALUES 
    ('2022-02-10', 0, 1, 1),
    ('2022-02-12', 0, 2, 2),
    ('2022-02-13', 0, 1, 3),
    ('2022-02-14', 0, 3, 1),
    ('2022-02-15', 0, 2, 2),
    ('2022-02-16', 0, 3, 3),
    ('2022-02-17', 0, 1, 1),
    ('2022-02-18', 0, 2, 2),
    ('2022-02-19', 0, 1, 3),
    ('2022-02-20', 0, 3, 1);
GO

-- Inserción en la tabla detalle de pedidos
INSERT INTO Inventarios.DetallePedidos (id_pedido, linea, id_producto, cantidad, precio_costo, precio_sugerido)
VALUES
    -- Detalle del pedido 1
    (1, 1, 1, 20, 100.00, 0.00),
    (1, 2, 2, 30, 50.00, 0.00),
    (1, 3, 3, 10, 200.00, 0.00),
    -- Detalle del pedido 2
    (2, 1, 4, 15, 150.00, 0.00),
    (2, 2, 5, 5, 500.00, 0.00),
    -- Detalle del pedido 3
    (3, 1, 3, 15, 200.00, 0.00),
    (3, 2, 6, 25, 75.00, 90.00),
    -- Detalle del pedido 4
    (4, 1, 2, 40, 50.00, 70.00),
    (4, 2, 4, 20, 150.00, 0.00),
    -- Detalle del pedido 5
    (5, 1, 1, 10, 100.00, 0.00),
    (5, 2, 6, 15, 75.00, 90.00),
    -- Detalle del pedido 6
    (6, 1, 5, 8, 500.00, 0.00),
    (6, 2, 2, 10, 50.00, 70.00),
    (6, 3, 3, 5, 200.00, 0.00),
    -- Detalle del pedido 7
    (7, 1, 1, 15, 100.00, 0.00),
    (7, 2, 4, 10, 150.00, 0.00),
    (7, 3, 6, 5, 75.00, 90.00),
    -- Detalle del pedido 8
    (8, 1, 2, 25, 50.00, 70.00),
    (8, 2, 3, 20, 200.00, 0.00),
    -- Detalle del pedido 9
    (9, 1, 6, 30, 75.00, 90.00),
    -- Detalle del pedido 10
    (10, 1, 1, 5, 100.00, 0.00),
    (10, 2, 4, 15, 150.00, 0.00),
    (10, 3, 5, 20, 500.00, 0.00);
GO

-- Inserción en maestro Remisiones
INSERT INTO Inventarios.Remisiones (fecha, id_origen, id_destino, id_turno)
VALUES 
    ('2023-02-01', 1, 2, 1),
    ('2023-02-02', 2, 1, 2),
    ('2023-02-03', 1, 2, 3),
    ('2023-02-04', 2, 1, 1),
    ('2023-02-05', 2, 1, 2),
    ('2023-02-06', 1, 2, 3),
    ('2023-02-07', 1, 2, 1),
    ('2023-02-08', 2, 1, 2),
    ('2023-02-09', 1, 2, 3),
    ('2023-02-10', 2, 1, 1);
GO

-- Inserción en detalle Remisiones
-- Para cada remisión se insertan dos registros en la tabla de detalle
-- utilizando un producto diferente en cada registro

INSERT INTO Inventarios.DetalleRemisiones (id_remision, linea, id_producto, cantidad, precio_costo, precio_sugerido)
VALUES 
    (1, 1, 1, 1, 5.00, 7.50),
    (1, 2, 2, 2, 10.00, 15.00),
    (2, 1, 3, 3, 7.00, 9.00),
    (2, 2, 4, 4, 20.00, 25.00),
	(3, 1, 5, 5, 3.50, 5.00),
    (3, 2, 6, 6, 8.00, 12.00),
	(4, 1, 7, 7, 1.50, 2.50),
    (4, 2, 8, 8, 6.00, 8.00),
	(5, 1, 1, 9, 5.00, 7.50),
    (5, 2, 2, 10, 10.00, 15.00),
    (6, 1, 3, 1, 7.00, 9.00),
    (6, 2, 4, 2, 20.00, 25.00),
	(7, 1, 5, 3, 3.50, 5.00),
    (7, 2, 6, 4, 8.00, 12.00),
	(8, 1, 7, 5, 1.50, 2.50),
    (8, 2, 8, 6, 6.00, 8.00),
	(9, 1, 1, 7, 5.00, 7.50),
    (9, 2, 2, 8, 10.00, 15.00),
    (10, 1, 3, 9, 7.00, 9.00),
    (10, 2, 4, 10, 20.00, 25.00);
GO
