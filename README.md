# hito_individual_base_de_datos

Nombre del proyecto: HITOBD.
Tipo de conexión: JDBC (Java Database Connectivity).
Base de datos: Oracle.
Versión de la base de datos: Oracle 11g o superior (debido al uso de tipos de objetos).
Nombre del esquema de la base de datos: HITO2.
Información de conexión:
Tipo de conexión de Oracle: BASIC.
Tipo de conexión de Raptor: Oracle.
Nombre de host: localhost.
Puerto: 1521.
SID: xe.
Controlador (Driver): oracle.jdbc.OracleDriver.
URL personalizada: jdbc:oracle:thin:@localhost:1521:xe.
Usuario: HITO2.
Contraseña guardada: No (SavePassword: false).

El proyecto implica el desarrollo de una aplicación o sistema basado en una base de datos Oracle.
La base de datos se utiliza para almacenar información relacionada con clientes, pedidos, productos, transporte y facturas.
Se han definido tipos de objetos (Cliente, Pedido, DetallePedido, Producto, OrdenTransporte, Factura) para modelar las entidades y sus relaciones en la base de datos.
Cada entidad tiene sus respectivas tablas en la base de datos (TablaCliente, TablaPedido, TablaDetallePedido, TablaProducto, TablaOrdenTransporte, TablaFactura).
La tabla TablaPedido tiene una clave primaria (ID_Pedido) y una referencia a la tabla TablaCliente a través del campo NIF.
La tabla TablaDetallePedido tiene una clave primaria (ID_Detalle) y referencias a las tablas TablaPedido y TablaProducto.
La tabla TablaFactura tiene una clave primaria (ID_Factura) y una referencia a la tabla TablaPedido.
Se han definido dos procedimientos almacenados:
CalcularTotalFactura: Calcula el monto total de una factura y actualiza el valor en la tabla TablaFactura.
CambiarEstadoPedido: Cambia el estado de un pedido en la tabla TablaPedido.
