CREATE DATABASE cafeteria_escolar;
USE cafeteria_escolar;


CREATE TABLE ALUMNO (
id_alumno INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
grupo VARCHAR(20) NOT NULL,
correo VARCHAR(100) NOT NULL
);


CREATE TABLE EMPLEADO (
id_empleado INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
turno ENUM('Matutino','Vespertino') NOT NULL,
puesto VARCHAR(50) NOT NULL
);
CREATE TABLE PRODUCTO (
id_producto INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
precio DECIMAL(6,2) NOT NULL CHECK (precio > 0),
categoria VARCHAR(50) NOT NULL
);


CREATE TABLE PEDIDO (
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
fecha DATETIME NOT NULL,
total DECIMAL(8,2) NOT NULL,
estado ENUM('Pendiente','Pagado','Cancelado') NOT NULL,
id_alumno INT NOT NULL,
id_empleado INT NOT NULL,
FOREIGN KEY (id_alumno) REFERENCES ALUMNO(id_alumno),
FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);
CREATE TABLE DETALLE_PEDIDO (
id_detalle INT AUTO_INCREMENT PRIMARY KEY,
cantidad INT NOT NULL CHECK (cantidad > 0),
subtotal DECIMAL(8,2) NOT NULL,
id_pedido INT NOT NULL,
id_producto INT NOT NULL,
FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);
ALTER TABLE PEDIDO
MODIFY estado ENUM('Pendiente','Pagado','Entregado');

CREATE INDEX idx_producto_nombre ON PRODUCTO(nombre);
CREATE INDEX idx_pedido_alumno ON PEDIDO(id_alumno);

EXPLAIN SELECT * FROM PRODUCTO WHERE nombre = 'Sandwich';
EXPLAIN SELECT * FROM PEDIDO WHERE id_alumno = 1;
USE cafeteria_escolar;

INSERT INTO ALUMNO (nombre, grupo, correo)
VALUES ('Carlos López', '4A', 'carlos@escuela.com');
INSERT INTO ALUMNO (id_alumno, nombre, grupo, correo)
VALUES (2, 'Ana Martínez', '4B', 'ana@escuela.com');
INSERT INTO ALUMNO (nombre, grupo, correo)
VALUES ('Luis Gómez', '4A', 'luis@escuela.com');
INSERT INTO PRODUCTO (id_producto, nombre, precio, categoria)
VALUES (1, 'Torta', 25.00, 'Comida');
INSERT INTO PRODUCTO (id_producto, nombre, precio, categoria)
VALUES (2, 'Refresco', 18.00, 'Bebida');
INSERT INTO PRODUCTO (id_producto, nombre, precio, categoria)
VALUES (3, 'Galletas', 12.00, 'Snack');
INSERT INTO EMPLEADO (id_empleado, nombre, turno, puesto)
VALUES (1, 'María Torres', 'Matutino', 'Cajera');
INSERT INTO EMPLEADO (id_empleado, nombre, turno, puesto)
VALUES (2, 'Jorge Ruiz', 'Vespertino', 'Encargado');
INSERT INTO PEDIDO (id_pedido, fecha, total, estado, id_alumno, id_empleado)
VALUES (1, '2026-02-17', 43.00, 'Pagado', 1, 1);
INSERT INTO DETALLE_PEDIDO (id_detalle, cantidad, subtotal, id_pedido, id_producto)
VALUES (1, 1, 25.00, 1, 1);
INSERT INTO DETALLE_PEDIDO (id_detalle, cantidad, subtotal, id_pedido, id_producto)
VALUES (2, 1, 18.00, 1, 2);

UPDATE PRODUCTO
SET precio = 20.00
WHERE id_producto = 2;
UPDATE ALUMNO
SET correo = 'carlos_actualizado@escuela.com'
WHERE id_alumno = 1;
UPDATE PEDIDO
SET estado = 'Entregado'
WHERE id_pedido = 1;

DELETE FROM PRODUCTO
WHERE id_producto = 3;
DELETE FROM DETALLE_PEDIDO
WHERE id_detalle = 2;

SELECT * FROM ALUMNO;
SELECT nombre, precio
FROM PRODUCTO;
SELECT *
FROM PRODUCTO
WHERE precio > 20;
SELECT *
FROM ALUMNO
ORDER BY nombre ASC;
SELECT *
FROM PEDIDO
WHERE estado = 'Entregado'
ORDER BY fecha DESC;

SELECT 
    P.id_pedido,
    A.nombre AS alumno,
    P.fecha,
    P.total,
    P.estado
FROM PEDIDO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno;

SELECT 
    P.id_pedido,
    A.nombre AS alumno,
    PR.nombre AS producto,
    D.cantidad,
    D.subtotal
FROM PEDIDO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno
JOIN DETALLE_PEDIDO D ON P.id_pedido = D.id_pedido
JOIN PRODUCTO PR ON D.id_producto = PR.id_producto;

SELECT nombre
FROM ALUMNO
WHERE id_alumno = (
    SELECT id_alumno
    FROM PEDIDO
    GROUP BY id_alumno
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

SELECT nombre
FROM PRODUCTO
WHERE id_producto IN (
    SELECT id_producto
    FROM DETALLE_PEDIDO
);

SELECT COUNT(*) AS total_pedidos
FROM PEDIDO;

SELECT SUM(total) AS total_vendido
FROM PEDIDO;

SELECT AVG(precio) AS precio_promedio
FROM PRODUCTO;

SELECT 
    A.nombre,
    COUNT(P.id_pedido) AS total_pedidos
FROM PEDIDO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno
GROUP BY A.nombre;

SELECT 
    A.nombre,
    COUNT(P.id_pedido) AS total_pedidos
FROM PEDIDO P
JOIN ALUMNO A ON P.id_alumno = A.id_alumno
GROUP BY A.nombre
HAVING COUNT(P.id_pedido) > 1;