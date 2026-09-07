# Álgebra Relacional — Entrega 1

El presente documento traduce a notación de álgebra relacional cuatro de las quince consultas SQL solicitadas en la Sección 9.1.9 del enunciado, como ejercicio conceptual previo a su implementación en SQL, conforme a lo indicado en la Sección 8.1.7.

Convenciones notacionales empleadas:


 σ -->Selección (filtrado de filas según una condición) |
 π -->Proyección (selección de columnas) |
 ⋈ -->Junta natural / theta-junta |
 ρ -->Renombre (de relación o de atributo) |
 γ -->Agrupamiento con funciones de agregación (extensión práctica del álgebra relacional clásica, empleada de forma estándar en los cursos de bases de datos para expresar `GROUP BY`) |
| τ -->Ordenamiento (extensión práctica, equivalente a `ORDER BY`) |

Por brevedad notacional, se abrevian las relaciones del esquema de referencia `MORENOLUIS.FIFA_*` como `SELECCION`, `PARTICIPACION_PARTIDO`, `PARTIDO` y `ESTADIO`, y la tabla auxiliar propia como `ASISTENCIA`.



## Consulta 1 — Top 5 selecciones con más goles marcados en la edición modelada

                            -----Consulta 1-----

R1 = SELECCION ⋈₍SELECCION.id_seleccion = PARTICIPACION_PARTIDO.id_seleccion₎ PARTICIPACION_PARTIDO
R2 = γ₍pais; SUM(goles_marcados) → goles_totales₎ (R1)
Resultado = π₍pais, goles_totales₎ ( τ₍goles_totales DESC₎ (R2) )

## Consulta 2 — Porcentaje de ocupación estimado por estadio

                            -----Consulta 2------

R1=ESTADIO ⋈₍ESTADIO.id_estadio=PARTIDO.id_estadio₎ PARTIDO
R2 = R1 ⋈₍R1.id_partido = ASISTENCIA.id_partido₎ ASISTENCIA
R3 = γ₍nombre, ciudad, capacidad; COUNT(id_partido) → partidos_jugados,
AVG(asistencia_real / capacidad × 100) → ocupacion_pct₎ (R2)

Resultado = τ₍ocupacion_pct DESC₎ (R3)

## Consulta 4 — Partidos jugados por fase

                            -------Consulta 4-----

R1 = γ₍fase; COUNT(*) → num_partidos₎ (PARTIDO)
Resultado = τ₍num_partidos DESC₎ (R1)

## Consulta 7 — Selecciones invictas

                            -------Consulta 7-------

P1 = ρ₍P1₎ (PARTICIPACION_PARTIDO)
P2 = ρ₍P2₎ (PARTICIPACION_PARTIDO)
Perdedores = π₍P1.id_seleccion₎ (
σ₍P1.id_partido = P2.id_partido ∧ P1.id_seleccion ≠ P2.id_seleccion ∧ P1.goles_marcados < P2.goles_marcados₎
(P1 × P2)
)
Jugaron = π₍id_seleccion₎ (PARTICIPACION_PARTIDO)
Invictas_ids = Jugaron − Perdedores
Resultado = π₍pais₎ ( Invictas_ids ⋈₍id_seleccion₎ SELECCION )
                    