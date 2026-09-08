
-- ROLES Y PRIVILEGIOS - ENTREGA 1

-- =====================================================
-- 1. Creación de roles

CREATE ROLE rol_consulta;

CREATE ROLE rol_operativo;

-- =====================================================
-- 2. Rol de solo consulta

GRANT SELECT
ON EDICION_MUNDIAL
TO rol_consulta;

GRANT SELECT
ON ESTADIO
TO rol_consulta;

GRANT SELECT
ON SELECCION
TO rol_consulta;

GRANT SELECT
ON PARTIDO
TO rol_consulta;

GRANT SELECT
ON PARTICIPACION_PARTIDO
TO rol_consulta;


-- =====================================================
-- 3. Rol operativo

GRANT SELECT
ON EDICION_MUNDIAL
TO rol_operativo;

GRANT SELECT
ON ESTADIO
TO rol_operativo;

GRANT SELECT
ON SELECCION
TO rol_operativo;

GRANT SELECT
ON PARTIDO
TO rol_operativo;

GRANT SELECT
ON PARTICIPACION_PARTIDO
TO rol_operativo;

-- Puede registrar y modificar información
-- sobre las tablas transaccionales

GRANT INSERT, UPDATE
ON PARTIDO
TO rol_operativo;

GRANT INSERT, UPDATE
ON PARTICIPACION_PARTIDO
TO rol_operativo;

-- =====================================================
-- 4. Restriccion de privilegios
-- El rol operativo no puede eliminar información

REVOKE DELETE
ON EDICION_MUNDIAL,
ESTADIO,
SELECCION,
PARTIDO,
PARTICIPACION_PARTIDO
FROM rol_operativo;

-- El rol de consulta no puede modificar información

REVOKE INSERT, UPDATE, DELETE
ON EDICION_MUNDIAL,
ESTADIO,
SELECCION,
PARTIDO,
PARTICIPACION_PARTIDO
FROM rol_consulta;
-- =====================================================
