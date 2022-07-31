######################################################
/*                                                  ##
/FECHA           : 31-JUL-2022                      ##
/@AUTOR          : Angel Alberto De La Cruz Garcia  ##
*/                                                  ##
######################################################
CREATE DATABASE almacenes_bd;
USE almacenes_bd;

CREATE TABLE cajeros(
    Cajero INT(20) NOT NULL,
    NomApels VARCHAR(255) NOT NULL,
    PRIMARY KEY(Cajero)
);
CREATE TABLE productos(
    Producto INT(20) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Precio DOUBLE,
    PRIMARY KEY(Producto)
);
CREATE TABLE maquinas_registradoras(
      Maquina INT(20) NOT NULL,
      Piso INT(20) NOT NULL,
      PRIMARY KEY(Maquina)
);
CREATE TABLE venta(
    Cajero INT(20) NOT NULL,
    Maquina INT(20) NOT NULL,
    Producto INT(20) NOT NULL,
    CONSTRAINT FK_Cajero_Cajeros FOREIGN KEY (Cajero) REFERENCES Cajeros(Cajero),
    CONSTRAINT FK_Maquina_Maquinas FOREIGN KEY (Maquina) REFERENCES Maquinas_Registradoras(Maquina),
    CONSTRAINT FK_Producto_Productos FOREIGN KEY (Producto) REFERENCES Productos(Producto)
);

INSERT INTO cajeros(Cajero, NomApels) VALUES
(1, 'Romario Saldierna'),
(2, 'Roberto Hernandez'),
(3, 'Vanesa Perez'),
(4, 'Rocio Cardenas'),
(5, 'Jose Carmona'),
(6, 'Vicente Fernandez'),
(7, 'Pablo Troncoso'),
(8, 'Romeo Romero'),
(9, 'Panfilo');

INSERT INTO productos(Producto, Nombre, Precio) VALUES
(1, 'Asus Reatail', 17000),
(2, 'Notebook GUI', 7000),
(3, 'Acer Nitro', 18000),
(4, 'Hp Oelfen', 10000),
(5, 'Lenovo Port', 13000),
(6, 'Asus Republic', 20000),
(7, 'Open Craft', 9000),
(8, 'Hp EliteBook', 12000),
(9, 'Dell Inspiron 15000', 15000),
(10, 'Rocket', 16000),
(11, 'TLCAN', 7000),
(12, 'Dell Inspiron 1000', 8000);

INSERT INTO maquinas_registradoras(Maquina, Piso) VALUES
(1, 2),
(2, 3),
(3, 8),
(4, 7),
(5, 5),
(6, 4),
(7, 7),
(8, 5);

INSERT INTO venta(Cajero, Maquina, Producto) VALUES
(1, 3, 9),
(5, 6, 4),
(2, 8, 9),
(9, 6, 11),
(4, 2, 5),
(7, 2, 7),
(6, 1, 9),
(1, 3, 5),
(5, 4, 6),
(1, 8, 8),
(5, 2, 1),
(9, 6, 2),
(4, 4, 10),
(7, 8, 4),
(8, 1, 3),
(5, 8, 12);

###2.-Mostrar el número de ventas de cada producto, ordenado de más a menos ventas.
SELECT DISTINCT(productos.Producto),
    (SELECT COUNT(venta.Producto) FROM venta where venta.Producto = productos.Producto) as Productos_Vendidos
    FROM venta INNER JOIN productos ON venta.Producto = productos.Producto
    ORDER BY Productos_Vendidos DESC;

###3.-Obtener un informe completo de ventas, indicando el nombre del cajero que realizo la venta,
###nombre y precios de los productos vendidos, y el piso en el que se encuentra la máquina registradora
###donde se realizó la venta.
SELECT cajeros.NomApels as Cajero, productos.Nombre, productos.Precio, maquinas_registradoras.Maquina,
    maquinas_registradoras.Piso FROM venta INNER JOIN productos ON venta.Producto = productos.Producto
    INNER JOIN cajeros ON venta.Cajero = cajeros.Cajero
    INNER JOIN maquinas_registradoras ON venta.Maquina = maquinas_registradoras.Maquina;

###4.-Obtener las ventas totales realizadas en cada piso.
SELECT Piso, SUM(Precio) FROM venta, productos, maquinas_registradoras
    WHERE venta.Producto = productos.Producto AND
    venta.Maquina = maquinas_registradoras.Maquina
    GROUP BY Piso;

###5.-Obtener el código y nombre de cada cajero junto con el importe total de sus ventas.
SELECT cajeros.Cajero, cajeros.NomApels, SUM(Precio) FROM venta, productos, cajeros
    WHERE venta.Producto = productos.Producto AND
    venta.Cajero = cajeros.Cajero
    GROUP BY Cajero, NomApels;


###6.Obtener el código y nombre de aquellos cajeros que hayan realizado
###ventas en pisos cuyas ventas totales sean inferiores a los 5000 pesos.
SELECT cajeros.Cajero, cajeros.NomApels FROM cajeros
    WHERE cajeros.Cajero IN (
        SELECT Cajero FROM venta WHERE Maquina IN (
            SELECT Maquina FROM maquinas_registradoras WHERE Piso IN (
                SELECT Piso FROM venta, productos, maquinas_registradoras
                WHERE venta.Producto = productos.Producto AND
                venta.Maquina = maquinas_registradoras.Maquina
                GROUP BY PISO
                HAVING SUM(Precio) < 5000
            )
        )
    );