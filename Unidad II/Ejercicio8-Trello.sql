-- Desarrollar las siguientes consultas:
-- 1. Mostrar todos los usuarios que no han creado ningún tablero, 
-- para dichos usuarios mostrar el
-- nombre completo y correo, utilizar producto cartesiano con el operador (+).


SELECT *
FROM TBL_USUARIOS A
LEFT JOIN TBL_TABLERO B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO_CREA)
WHERE B.CODIGO_TABLERO IS NULL;

SELECT  A.CODIGO_USUARIO,
        A.NOMBRE || ' ' || A.APELLIDO AS NOMBRE_COMPLETO,
        A.CORREO
FROM    TBL_USUARIOS A, 
        TBL_TABLERO B
WHERE A.CODIGO_USUARIO = B.CODIGO_USUARIO_CREA (+)
AND B.CODIGO_TABLERO IS NULL;




SELECT * 
FROM TBL_TABLERO;

-- 2. Mostrar la cantidad de usuarios que se han registrado por cada 
---red social, mostrar inclusive la
-- cantidad de usuarios que no están registrados con redes sociales.

SELECT NVL(B.NOMBRE_RED_SOCIAL,'SIN RED SOCIAL') AS NOMBRE_RED_SOCIAL,
       COUNT(*) AS CANTIDAD_USUARIOS
FROM TBL_USUARIOS A
LEFT JOIN TBL_REDES_SOCIALES B
ON (A.CODIGO_RED_SOCIAL = B.CODIGO_RED_SOCIAL)
GROUP BY NVL(B.NOMBRE_RED_SOCIAL,'SIN RED SOCIAL'); 


-- 3. Consultar el usuario que ha hecho más comentarios sobre una tarjeta 
--(El más prepotente), para
-- este usuario mostrar el nombre completo, correo, cantidad de
-- comentarios y cantidad de
-- tarjetas a las que ha comentado (pista: una posible solución 
---para este último campo es utilizar
-- count(distinct campo))

SELECT *
FROM TBL_USUARIOS;

WITH USUARIOS_COMENTARIOS AS (
    SELECT  CODIGO_USUARIO, 
            COUNT(*) AS CANTIDAD_COMENTARIOS,
            COUNT(DISTINCT CODIGO_TARJETA) AS CANTIDAD_TARJETAS_COMENTADAS
    FROM    TBL_COMENTARIOS
    GROUP BY CODIGO_USUARIO
    ORDER BY CODIGO_USUARIO
)
SELECT B.NOMBRE || ' ' || B.APELLIDO AS NOMBRE_COMPLETO,
       B.CORREO,
       A.CANTIDAD_COMENTARIOS,
       A.CANTIDAD_TARJETAS_COMENTADAS
FROM USUARIOS_COMENTARIOS A
INNER JOIN TBL_USUARIOS B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
WHERE CANTIDAD_COMENTARIOS = (SELECT MAX(CANTIDAD_COMENTARIOS) FROM USUARIOS_COMENTARIOS);


-- 4. Mostrar TODOS los usuarios con plan FREE, de dichos usuarios mostrar la siguiente información:
-- • Nombre completo
-- • Correo
-- • Red social (En caso de estar registrado con una)
-- • Cantidad de organizaciones que ha creado, mostrar 0 si no ha creado ninguna.

SELECT A.CODIGO_USUARIO,
        A.NOMBRE || ' ' || A.APELLIDO AS NOMBRE_COMPLETO,
       A.CORREO,
       NVL(B.NOMBRE_RED_SOCIAL,'SIN RED SOCIAL') AS NOMBRE_RED_SOCIAL,
       NVL(C.CANTIDAD_ORGANIZACIONES,0) AS CANTIDAD_ORGANIZACIONES
FROM TBL_USUARIOS A
LEFT JOIN TBL_REDES_SOCIALES B
ON (A.CODIGO_RED_SOCIAL = B.CODIGO_RED_SOCIAL)
LEFT JOIN (
    SELECT CODIGO_ADMINISTRADOR, COUNT(*) AS CANTIDAD_ORGANIZACIONES
    FROM TBL_ORGANIZACIONES
    GROUP BY CODIGO_ADMINISTRADOR
) C
ON (A.CODIGO_USUARIO = C.CODIGO_ADMINISTRADOR)
WHERE A.CODIGO_PLAN = 1
ORDER BY A.CODIGO_USUARIO;


WITH USUARIOS_ORGANIZACIONES AS (
    SELECT CODIGO_ADMINISTRADOR, COUNT(*) AS CANTIDAD_ORGANIZACIONES
    FROM TBL_ORGANIZACIONES
    GROUP BY CODIGO_ADMINISTRADOR
)
SELECT A.CODIGO_USUARIO,
        A.NOMBRE || ' ' || A.APELLIDO AS NOMBRE_COMPLETO,
       A.CORREO,
       NVL(B.NOMBRE_RED_SOCIAL,'SIN RED SOCIAL') AS NOMBRE_RED_SOCIAL,
       NVL(C.CANTIDAD_ORGANIZACIONES,0) AS CANTIDAD_ORGANIZACIONES
FROM TBL_USUARIOS A
LEFT JOIN TBL_REDES_SOCIALES B
ON (A.CODIGO_RED_SOCIAL = B.CODIGO_RED_SOCIAL)
LEFT JOIN USUARIOS_ORGANIZACIONES C
ON (A.CODIGO_USUARIO = C.CODIGO_ADMINISTRADOR)
WHERE A.CODIGO_PLAN = 1
ORDER BY A.CODIGO_USUARIO;

SELECT CODIGO_ADMINISTRADOR, COUNT(*) AS CANTIDAD_ORGANIZACIONES
FROM TBL_ORGANIZACIONES
GROUP BY CODIGO_ADMINISTRADOR;

SELECT *
FROM TBL_ORGANIZACIONES
WHERE CODIGO_ADMINISTRADOR = 245;

SELECT * 
FROM TBL_PLANES; 


-- 5. Mostrar los usuarios que han creado más de 5 tarjetas, para estos usuarios mostrar:
-- Nombre completo, correo, cantidad de tarjetas creadas


SELECT A.CODIGO_USUARIO,
       A.NOMBRE || ' ' || A.APELLIDO AS NOMBRE_COMPLETO,
       A.CORREO,
       COUNT(*) AS CANTIDAD_TARJETAS
FROM TBL_USUARIOS A
INNER JOIN TBL_TARJETAS B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
GROUP BY A.CODIGO_USUARIO,
       A.NOMBRE || ' ' || A.APELLIDO,
       A.CORREO
HAVING COUNT(*) > 5;

SELECT *
FROM TBL_TARJETAS;


-- 6. Un usuario puede estar suscrito a tableros, listas y tarjetas, de tal forma que si hay algún cambio
-- se le notifica en su teléfono, sabiendo esto, se necesita mostrar los nombres de
-- todos los usuarios con la cantidad de suscripciones de cada tipo, en la consulta se debe mostrar:
-- • Nombre completo del usuario
-- • Cantidad de tableros a los cuales está suscrito
-- • Cantidad de listas a las cuales está suscrito
-- • Cantidad de tarjetas a las cuales está suscrito

SELECT A.CODIGO_USUARIO,
       A.NOMBRE || ' ' || A.APELLIDO AS NOMBRE_COMPLETO,
       COUNT(DISTINCT B.CODIGO_TABLERO) AS CANTIDAD_TABLEROS,
       COUNT(DISTINCT B.CODIGO_LISTA) AS CANTIDAD_LISTAS,
       COUNT(DISTINCT B.CODIGO_TARJETA) AS CANTIDAD_TARJETAS
FROM   TBL_USUARIOS A
LEFT JOIN TBL_SUSCRIPCIONES B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
GROUP BY A.CODIGO_USUARIO,
       A.NOMBRE || ' ' || A.APELLIDO
ORDER BY    A.CODIGO_USUARIO;



-- 24, --- 0 LISTAS, 1 TABLERO, 3 TARJETAS
-- 263 --- 1 LISTA, 2 TABLEROS, 2 TARJETAS


-- 7. Consultar todas las organizaciones con los siguientes datos:
-- • Nombre de la organización
-- • Cantidad de usuarios registrados en cada organización
-- • Cantidad de Tableros por cada organización
-- • Cantidad de Listas asociadas a cada organización
-- • Cantidad de Tarjetas asociadas a cada organización

WITH USUARIOS_ORGANIZACIONES AS (
    SELECT CODIGO_ORGANIZACION, COUNT(*) AS CANTIDAD_USUARIOS
    FROM TBL_USUARIOS_X_ORGANIZACION
    GROUP BY CODIGO_ORGANIZACION
),
TABLEROS_ORGANIZACIONES AS (
    SELECT CODIGO_ORGANIZACION, COUNT(*) AS CANTIDAD_TABLEROS
    FROM TBL_TABLERO
    GROUP BY CODIGO_ORGANIZACION
),
LISTAS_ORGANIZACIONES AS (
    SELECT B.CODIGO_ORGANIZACION, COUNT(*) AS CANTIDAD_LISTAS
    FROM TBL_LISTAS A
    INNER JOIN TBL_TABLERO B
    ON (A.CODIGO_TABLERO = B.CODIGO_TABLERO)
    GROUP BY B.CODIGO_ORGANIZACION
),
TARJETAS_ORGANIZACIONES AS (
    SELECT C.CODIGO_ORGANIZACION, COUNT(*) AS CANTIDAD_TARJETAS
    FROM TBL_TARJETAS A
    INNER JOIN TBL_LISTAS B
    ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
    INNER JOIN TBL_TABLERO C
    ON (B.CODIGO_TABLERO = C.CODIGO_TABLERO)
    GROUP BY C.CODIGO_ORGANIZACION
)
SELECT  A.NOMBRE_ORGANIZACION,
        NVL(B.CANTIDAD_USUARIOS,0) AS CANTIDAD_USUARIOS,
        NVL(C.CANTIDAD_TABLEROS,0) AS CANTIDAD_TABLEROS,
        NVL(D.CANTIDAD_LISTAS,0) AS CANTIDAD_LISTAS,
        NVL(E.CANTIDAD_TARJETAS,0) AS CANTIDAD_TARJETAS
FROM TBL_ORGANIZACIONES A
LEFT JOIN USUARIOS_ORGANIZACIONES B
ON (A.CODIGO_ORGANIZACION = B.CODIGO_ORGANIZACION)
LEFT JOIN TABLEROS_ORGANIZACIONES C
ON (A.CODIGO_ORGANIZACION = C.CODIGO_ORGANIZACION)
LEFT JOIN LISTAS_ORGANIZACIONES D
ON (A.CODIGO_ORGANIZACION = D.CODIGO_ORGANIZACION)
LEFT JOIN TARJETAS_ORGANIZACIONES E
ON (A.CODIGO_ORGANIZACION = E.CODIGO_ORGANIZACION);


SELECT *
FROM TBL_TARJETAS
WHERE CODIGO_LISTA IN (
    SELECT CODIGO_LISTA
    FROM TBL_LISTAS
    WHERE CODIGO_TABLERO IN (
        SELECT CODIGO_TABLERO
        FROM TBL_TABLERO
        WHERE CODIGO_ORGANIZACION = 8
    )
);

-- Crear una vista materializada con la información de facturación, los campos a incluir son los
-- siguientes:
-- • Código factura
-- • Nombre del plan a facturar
-- • Nombre completo del usuario
-- • Fecha de pago (Utilizar fecha inicio, mostrarla en formato Día-Mes-Año)
-- • Año y Mes de pago (basado en la fecha inicio)
-- • Monto de la factura
-- • Descuento
-- • Total neto
-- Crear una tabla dinámica en Excel que consulte la información de la vista materializada del inciso
-- anterior, de dicha tabla dinámica crear un gráfico de línea que muestre en el eje X el campo Año/mes de
-- pago y en el eje Y los nombres de los planes, el valor numérico a mostrar en la gráfica deberá ser el Total
-- neto.


CREATE MATERIALIZED VIEW MVW_FACTURACION AS
SELECT A.CODIGO_FACTURA,
       B.NOMBRE_PLAN,
       C.NOMBRE || ' ' || C.APELLIDO AS NOMBRE_COMPLETO,
        TO_CHAR(A.FECHA_INICIO, 'DD-MON-YYYY') AS FECHA_PAGO,
        TO_CHAR(A.FECHA_INICIO, 'YYYY/MM') AS ANIO_MES_PAGO,
        A.MONTO,
        A.DESCUENTO,
        A.MONTO - A.DESCUENTO AS TOTAL_NETO
FROM TBL_FACTURACION_PAGOS A
INNER JOIN TBL_PLANES B
ON (A.CODIGO_PLAN = B.CODIGO_PLAN)
INNER JOIN TBL_USUARIOS C
ON (A.CODIGO_USUARIO = C.CODIGO_USUARIO);

SELECT *
FROM MVW_FACTURACION;