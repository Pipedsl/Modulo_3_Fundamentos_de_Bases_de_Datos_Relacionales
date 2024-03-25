-- CRACIÓN BASE DE DATOS ALKE WALLET
CREATE SCHEMA alke_wallet;

-- INGRESAR A BASE DE DATOS
use alke_wallet;

-- CREAR TABLA DE USUARIO
CREATE TABLE usuario (
	user_id int primary key auto_increment,
    nombre varchar(100), 
    correo_electronico varchar(150),
    contraseña varchar(50),
    saldo decimal(10,2)
);

-- CREAR TABLA MONEDA
CREATE TABLE moneda (
	currency_id int primary key auto_increment,
    currency_name varchar(10),
    currency_symbol varchar(5)
);

alter table moneda 
modify column currency_name varchar(100);

-- CREAR TABLA TRANSACCIÓN
CREATE TABLE transaccion (
	transaction_id int primary key auto_increment,
    sender_user_id int not null,
    constraint fk_sender_user foreign key(sender_user_id)
    references usuario (user_id),
    receiver_user_id int not null,
    constraint fk_receiver_user foreign key(receiver_user_id)
    references usuario (user_id),
    importe decimal(10,2) not null,
    transaction_date datetime default current_timestamp,
    currency_id int not null,
    constraint fk_currency foreign key(currency_id)
    references moneda (currency_id)
);

-- INSERTAR DATOS EJEMPLO MONEDAS
INSERT INTO moneda (currency_name, currency_symbol)
VALUES ('Peso Chileno', 'CLP'),('Dólar Estadounidense', 'CLP');

-- COMPROBAR DATOS INSERTADOS DE MONEDA
SELECT * FROM moneda;

-- INSERTAR DATOS EJEMPLO USUARIO
INSERT INTO usuario (nombre, correo_electronico,contraseña,saldo)
VALUES ('Matias Fernandez', 'matigol@ejemplo.cl','mati123', 100000.00),
('Jorge Valdivia', 'mago@ejemplo.cl','mago123', 50000.00),
('Humberto Suazo', 'chupete@ejemplo.cl','chupete123', 20000.00),
('Claudio Bravo', 'capi@ejemplo.cl','capi123', 80000.00);

-- COMPROBAR DATOS INSERTADOS DE USUARIO
SELECT * FROM usuario;

-- INSERTAR DATOS EJEMPLO DE TRANSACCION
INSERT INTO transaccion(sender_user_id,receiver_user_id,importe,currency_id)
VALUES (1,2,20000.00,1),
(3,4,50.00,2),
(2,1,10000.00,1);

-- COMPROBAR DATOS INSERTADOS EN TRANSACCION
SELECT * FROM transaccion;

-- Consulta para obtener el nombre de la moneda elegida por un usuario específico

SELECT u.nombre, m.currency_name as 'Moneda Elegida'
FROM usuario u
INNER JOIN transaccion t ON u.user_id = t.sender_user_id
INNER JOIN moneda m ON t.currency_id = m.currency_id
WHERE u.user_id = 1;

-- Consulta para obtener todas las transacciones registradas
SELECT transaction_id, 
us.nombre AS 'Envia', 
ur.nombre AS 'Recibe', 
importe, transaction_date, currency_name
FROM transaccion t
INNER JOIN moneda m ON t.currency_id = m.currency_id
INNER JOIN usuario us ON us.user_id = t.sender_user_id
INNER JOIN usuario ur ON ur.user_id = t.receiver_user_id;

-- Consulta para obtener todas las transacciones realizadas por un usuario específico
SELECT transaction_id, 
us.nombre AS 'Envia', 
ur.nombre AS 'Recibe', 
importe, transaction_date, currency_name
FROM transaccion t
INNER JOIN moneda m ON t.currency_id = m.currency_id
INNER JOIN usuario us ON us.user_id = t.sender_user_id
INNER JOIN usuario ur ON ur.user_id = t.receiver_user_id
WHERE sender_user_id = 1;

-- Sentencia DML para modificar el campo correo electrónico de un usuario específico
UPDATE usuario SET correo_electronico = 'elcapi@ejemplo.cl'
WHERE nombre = 'Claudio Bravo';

-- COMPROBAR CAMBIO REALIZADO
SELECT * FROM usuario
WHERE nombre = 'Claudio Bravo';

-- Revisar transacciones antes de eliminar fila
select * from transaccion;
-- Sentencia para eliminar los datos de una transacción (eliminado de la fila completa)
DELETE FROM transaccion
WHERE transaction_id = 2;
-- Revisar transacciones despues de eliminar fila
select * from transaccion;








