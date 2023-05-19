-- Crear el tipo de objeto Cliente
CREATE TYPE Cliente AS OBJECT (
  NIF VARCHAR2(10),
  Nombre VARCHAR2(100),
  Direccion VARCHAR2(200),
  NumeroTelefono VARCHAR2(20),
  NumeroCuentaBancaria VARCHAR2(20)
);
/

-- Crear la tabla Cliente
CREATE TABLE TablaCliente OF Cliente (
  PRIMARY KEY (NIF)
);
/

-- Crear el tipo de objeto Pedido
CREATE TYPE Pedido AS OBJECT (
  ID_Pedido NUMBER,
  NIF REF Cliente,
  FechaPedido DATE,
   FechaEntrega DATE,
  FechaDevolucion DATE,
  EstadoPedido VARCHAR2(50)
);
/

-- Crear la tabla Pedido
CREATE TABLE TablaPedido OF Pedido (
  PRIMARY KEY (ID_Pedido),
  FOREIGN KEY (NIF) REFERENCES TablaCliente
);
/

-- Crear el tipo de objeto DetallePedido
CREATE TYPE DetallePedido AS OBJECT (
  ID_Detalle NUMBER,
  ID_Pedido REF Pedido,
  ID_Producto NUMBER,
  Cantidad NUMBER,
  PrecioCalculado NUMBER
);
/

-- Crear la tabla DetallePedido
CREATE TABLE TablaDetallePedido OF DetallePedido (
  PRIMARY KEY (ID_Detalle),
  FOREIGN KEY (ID_Pedido) REFERENCES TablaPedido,
  FOREIGN KEY (ID_Producto) REFERENCES TablaProducto
);
/

-- Crear el tipo de objeto Producto
CREATE TYPE Producto AS OBJECT (
  ID_Producto NUMBER,
  NombreProducto VARCHAR2(100),
  Descripcion VARCHAR2(200),
  Unidades NUMBER,
  Disponible NUMBER
);
/

-- Crear la tabla Producto
CREATE TABLE TablaProducto OF Producto (
  PRIMARY KEY (ID_Producto)
);
/

-- Crear el tipo de objeto OrdenTransporte
CREATE TYPE OrdenTransporte AS OBJECT (
  ID_Transporte NUMBER,
  ID_Pedido REF Pedido,
  FechaEntrega DATE,
  FechaDevolucion DATE
);
/

-- Crear la tabla OrdenTransporte
CREATE TABLE TablaOrdenTransporte OF OrdenTransporte (
  PRIMARY KEY (ID_Transporte),
  FOREIGN KEY (ID_Pedido) REFERENCES TablaPedido
);
/

-- Crear el tipo de objeto Factura
CREATE TYPE Factura AS OBJECT (
  ID_Factura NUMBER,
  ID_Pedido REF Pedido,
  Monto NUMBER,
  FechaPago DATE
);
/

-- Crear la tabla Factura
CREATE TABLE TablaFactura OF Factura (
  PRIMARY KEY (ID_Factura),
  FOREIGN KEY (ID_Pedido) REFERENCES TablaPedido
);


-- Procedimiento para calcular el total de la factura

CREATE OR REPLACE PROCEDURE CalcularTotalFactura(p_ID_Factura IN NUMBER) AS
  v_Monto NUMBER;
BEGIN
  SELECT Monto INTO v_Monto
  FROM TablaFactura
  WHERE ID_Factura = p_ID_Factura;
  
  -- Realizar cálculos adicionales si es necesario
  
  -- Actualizar el monto en la factura
  UPDATE TablaFactura
  SET Monto = v_Monto
  WHERE ID_Factura = p_ID_Factura;
  
  COMMIT;
END;
/

-- Procedimiento para cambiar el estado del pedido
CREATE OR REPLACE PROCEDURE CambiarEstadoPedido(p_ID_Pedido IN NUMBER, p_EstadoPedido IN VARCHAR2) AS
BEGIN
  UPDATE TablaPedido
  SET EstadoPedido = p_EstadoPedido
  WHERE ID_Pedido = p_ID_Pedido;
  
  COMMIT;
END;
/

-- Procedimiento para consultar el estado de un pedido
CREATE OR REPLACE PROCEDURE ConsultarEstadoPedido(p_ID_Pedido IN NUMBER, p_Estado OUT VARCHAR2) AS
BEGIN
  SELECT EstadoPedido INTO p_Estado
  FROM TablaPedido
  WHERE ID_Pedido = p_ID_Pedido;
END;
/





-- Insertar datos de prueba en la tabla TablaCliente
INSERT INTO TablaCliente VALUES (Cliente('1234567890', 'Teatro Wang', 'Calle Mayor', '123456789', '9876543210'));
INSERT INTO TablaCliente VALUES( Cliente('8967854603', 'Teatro Margeson', 'La Calleja de la Flores', '789112456', '5555555555'));

  

-- Insertar datos de prueba en la tabla TablaProducto
INSERT INTO TablaProducto VALUES (Producto(1, 'CLAQUETA ESTÁNDAR ', 'Plancha de  madera y láminas de color', 10, 1));
INSERT INTO TablaProducto VALUES (Producto(2, 'LINTERNA FLEXIBLE IMANTADA ', 'linterna telescópica, flexible y magnética', 10, 1));
INSERT INTO TablaProducto VALUES (Producto(3, 'LINTERNA ENORME ', 'linterna grande que alumbra mucho', 10, 0));

-- Insertar datos de prueba en la tabla TablaPedido
INSERT INTO TablaPedido VALUES (Pedido(1, (SELECT REF(c) FROM TablaCliente c WHERE c.NIF = '1234567890'), DATE '2023-05-01', DATE '2023-05-08', DATE '2023-05-15', 'Pendiente'));
INSERT INTO TablaPedido VALUES (Pedido(2, (SELECT REF(c) FROM TablaCliente c WHERE c.NIF = '8967854603'), DATE '2023-05-02', DATE '2023-05-09', DATE '2023-05-16', 'Pendiente'));


-- Insertar datos de prueba en la tabla TablaDetallePedido
INSERT INTO TablaDetallePedido VALUES (DetallePedido(1, (SELECT REF(p) FROM TablaPedido p WHERE p.ID_Pedido = 1), 1, 5, 100));
INSERT INTO TablaDetallePedido VALUES (DetallePedido(2, (SELECT REF(p) FROM TablaPedido p WHERE p.ID_Pedido = 2), 2, 5, 100));
-- Insertar datos de prueba en la tabla TablaOrdenTransporte
INSERT INTO TablaOrdenTransporte VALUES (OrdenTransporte(1, (SELECT REF(p) FROM TablaPedido p WHERE p.ID_Pedido = 1), DATE '2023-05-08', DATE '2023-05-15'));
INSERT INTO TablaOrdenTransporte VALUES (OrdenTransporte(2, (SELECT REF(p) FROM TablaPedido p WHERE p.ID_Pedido = 2), DATE '2023-05-09', DATE '2023-05-16'));

-- Insertar datos de prueba en la tabla TablaFactura
INSERT INTO TablaFactura VALUES (Factura(1, (SELECT REF(p) FROM TablaPedido p WHERE p.ID_Pedido = 1), 200, DATE '2023-05-15'));
INSERT INTO TablaFactura VALUES (Factura(2, (SELECT REF(p) FROM TablaPedido p WHERE p.ID_Pedido = 2), 300, DATE '2023-05-16'));


--El primero
SELECT c.*, p.*
FROM TablaCliente c
JOIN TablaPedido p ON c.NIF = p.NIF.NIF;

--el segundo
SELECT pr.*, dp.*
FROM TablaProducto pr
JOIN TablaDetallePedido dp ON pr.ID_Producto = dp.ID_Producto;


--el tercero
SELECT * FROM TablaProducto WHERE Disponible = 1;



--el cuarto
SELECT * FROM TablaPedido WHERE EstadoPedido = 'Pendiente';




--el quinto
SELECT * FROM TablaDetallePedido dp
JOIN TablaPedido p ON dp.ID_Pedido = REF(p) -- Utilizamos REF para obtener la referencia al objeto Pedido
WHERE p.ID_Pedido = 2; -- Comparamos con el campo ID_Pedido del objeto Pedido




--el sexto
SELECT p.* FROM TablaProducto p
JOIN TablaDetallePedido d ON p.ID_Producto = d.ID_Producto
JOIN TablaPedido ped ON d.ID_Pedido = REF(ped) -- Utilizamos REF para obtener la referencia al objeto Pedido
WHERE ped.ID_Pedido = 1; -- Comparamos con el campo ID_Pedido del objeto Pedido

--el septimo
SELECT f.ID_Factura, f.Monto, c.Nombre
FROM TablaFactura f
JOIN TablaPedido p ON DEREF(f.ID_Pedido).ID_Pedido = p.ID_Pedido
JOIN TablaCliente c ON DEREF(p.NIF).NIF = c.NIF;


-- el octavo 

SELECT p.*
FROM TablaPedido p
WHERE TRUNC(p.FechaPedido) = TO_DATE('2023-05-01', 'YYYY-MM-DD');


--el noveno
SELECT pr.NombreProducto, pr.Disponible
FROM TablaProducto pr;

--el decimo
SELECT p.*
FROM TablaPedido p
JOIN TablaCliente c ON p.NIF = (SELECT REF(c2) FROM TablaCliente c2 WHERE c2.NIF = '8967854603')
ORDER BY p.FechaPedido DESC;


-- el onceavo
SELECT c.Nombre, COUNT(*) AS TotalPedidos
FROM TablaCliente c
JOIN TablaPedido p ON c.NIF = DEREF(p.NIF).NIF
GROUP BY c.Nombre;


--el doceabo 
SELECT dp.ID_Producto, pr.NombreProducto, dp.Cantidad
FROM TablaDetallePedido dp
JOIN TablaPedido p ON dp.ID_Pedido = (SELECT REF(ped) FROM TablaPedido ped WHERE ped.ID_Pedido = p.ID_Pedido)
JOIN TablaProducto pr ON dp.ID_Producto = pr.ID_Producto
WHERE p.FechaEntrega BETWEEN DATE '2023-05-01' AND DATE '2023-05-31';






--el treceabo 
SELECT SUM(dp.Cantidad) AS TotalProductosAlquilados
FROM TablaDetallePedido dp
WHERE dp.ID_Pedido = (SELECT REF(p) FROM TablaPedido p WHERE p.ID_Pedido = 2);





--catorce
SELECT p.*
FROM TablaPedido p
WHERE p.FechaDevolucion < SYSDATE;


--quince
SELECT pr.NombreProducto, dp.PrecioCalculado
FROM TablaDetallePedido dp
JOIN TablaProducto pr ON dp.ID_Producto = pr.ID_Producto
WHERE dp.PrecioCalculado > 50;



--dieciseis
SELECT ot.FechaEntrega
FROM TablaOrdenTransporte ot
WHERE ot.ID_Transporte = 1;




--diecisiete 

SELECT ot.FechaDevolucion
FROM TablaOrdenTransporte ot
WHERE ot.ID_Transporte = 1;



--dieciocho

SELECT pr.NombreProducto, pr.Disponible
FROM TablaProducto pr
WHERE pr.Disponible < 10;


--diecinueve 
SELECT c.*
FROM TablaCliente c
WHERE c.NumeroCuentaBancaria IS NOT NULL;



--veinte

SELECT SUM(f.Monto) AS TotalMontoPagado
FROM TablaFactura f
WHERE TRUNC(f.FechaPago) = TO_DATE('2023-05-16', 'YYYY-MM-DD');
