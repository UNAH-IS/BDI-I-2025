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
-- 5. Mostrar los usuarios que han creado más de 5 tarjetas, para estos usuarios mostrar:
-- Nombre completo, correo, cantidad de tarjetas creadas
-- 6. Un usuario puede estar suscrito a tableros, listas y tarjetas, de tal forma que si hay algún cambio
-- se le notifica en su teléfono o por teléfono, sabiendo esto, se necesita mostrar los nombres de
-- todos los usuarios con la cantidad de suscripciones de cada tipo, en la consulta se debe mostrar:
-- • Nombre completo del usuario
-- • Cantidad de tableros a los cuales está suscrito
-- • Cantidad de listas a las cuales está suscrito
-- • Cantidad de tarjetas a las cuales está suscrito
-- 7. Consultar todas las organizaciones con los siguientes datos:
-- • Nombre de la organización
-- • Cantidad de usuarios registrados en cada organización
-- • Cantidad de Tableros por cada organización
-- • Cantidad de Listas asociadas a cada organización
-- • Cantidad de Tarjetas asociadas a cada organización