# Examen1_386_AdmonDB

Examen 1
386 Administración de Bases de Datos
Israel Antonio Salinas Salinas
Cuenta: 620111290

El desarrollo del examen contiene un archivo docker-compose.yml para preparar el contenedor docker
que contiene el SQL server 2019 de Microsoft, también incluye el archivo "Examen1 con schema..sql" 
que contiene el script T-SQL para crear la base de datos Examen1, la base de datos tiene dos esquemas
llamadas ClientesSQ e Inventarios para organizar las tablas por módulos, finalmente están las instrucciones
para realizar las inserciones de registros en las tablas.
El tercer archivo es "Database Diagrama.pdf" que muestra el diagrama de la relación de todas las tablas 
de la base de datos.

La base de datos contiene dos esquemas. El primero es 'ClientesSQ' para el módulo de clientes, y contiene 
10 tablas para registrar las operaciones de la sala de ventas, incluyendo ventas, cobros y gastos. 
El segundo esquema es 'Inventarios' y contiene 22 tablas para registrar los movimientos del inventario, 
como productos, proveedores, compras, pedidos, remisiones, existencia y ubicaciones de los productos.

Ambos esquemas contienen tablas que están relacionadas entre sí. Por ejemplo, las ventas del módulo de clientes 
se relacionan con los productos del módulo de inventarios, y las compras del módulo de inventarios se relacionan 
con los turnos del módulo de clientes, entre otras relaciones.
