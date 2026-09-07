-- ---------------------------------------------------------------------
-- Rol 1: ROL_CONSULTA_FIFA - solo lectura sobre todo el modelo.
-- ---------------------------------------------------------------------
CREATE ROLE ROL_CONSULTA_FIFA;

GRANT SELECT ON EDICION_MUNDIAL TO ROL_CONSULTA_FIFA;
GRANT SELECT ON ESTADIO TO ROL_CONSULTA_FIFA;
GRANT SELECT ON SELECCION TO ROL_CONSULTA_FIFA;
GRANT SELECT ON PARTIDO TO ROL_CONSULTA_FIFA;
GRANT SELECT ON PARTICIPACION_PARTIDO TO ROL_CONSULTA_FIFA;
GRANT SELECT ON ASISTENCIA_PARTIDO    TO ROL_CONSULTA_FIFA;



-- ---------------------------------------------------------------------
-- Rol 2: ROL_OPERATIVO_FIFA - registra partidos y sus participaciones.
-- ---------------------------------------------------------------------
CREATE ROLE ROL_OPERATIVO_FIFA;

GRANT SELECT ON EDICION_MUNDIAL TO ROL_OPERATIVO_FIFA;
GRANT SELECT ON ESTADIO         TO ROL_OPERATIVO_FIFA;
GRANT SELECT ON SELECCION       TO ROL_OPERATIVO_FIFA;

GRANT SELECT, INSERT, UPDATE ON PARTIDO               TO ROL_OPERATIVO_FIFA;
GRANT SELECT, INSERT, UPDATE ON PARTICIPACION_PARTIDO TO ROL_OPERATIVO_FIFA;
GRANT SELECT, INSERT, UPDATE ON ASISTENCIA_PARTIDO    TO ROL_OPERATIVO_FIFA;

-- ---------------------------------------------------------------------
-- Asignacion de los roles 
-- ---------------------------------------------------------------------
GRANT ROL_CONSULTA_FIFA  TO REEMPLAZAR_USUARIO_CONSULTA;   -- ej: IS101002
GRANT ROL_OPERATIVO_FIFA TO REEMPLAZAR_USUARIO_OPERATIVO;  -- ej: IS101003


-- ---------------------------------------------------------------------
-- Demostracion de REVOKE (exigido por el enunciado junto con GRANT):
-- se revoca temporalmente el UPDATE del rol operativo, se verifica que
-- ya no puede actualizar marcadores, y se vuelve a otorgar.
-- Ver tests/pruebas_privilegios.md para la evidencia completa de cada
-- prueba (que operacion se ejecuto y que resultado dio).
-- ---------------------------------------------------------------------
REVOKE UPDATE ON PARTIDO FROM ROL_OPERATIVO_FIFA;
-- (en este punto, el usuario operativo ya no puede hacer UPDATE sobre
--  PARTIDO -- ver Caso 5 en tests/pruebas_privilegios.md)
GRANT UPDATE ON PARTIDO TO ROL_OPERATIVO_FIFA;
-- (se restaura el privilegio para que el ciclo de vida del partido siga
--  funcionando con normalidad)


-- ---------------------------------------------------------------------
-- Verificacion rapida de lo otorgado (ejecutar como el dueno de las
-- tablas, es decir, la cuenta que corrio este script):
-- ---------------------------------------------------------------------
SELECT role, table_name, privilege
FROM ROLE_TAB_PRIVS
WHERE role IN ('ROL_CONSULTA_FIFA', 'ROL_OPERATIVO_FIFA')
ORDER BY role, table_name, privilege;