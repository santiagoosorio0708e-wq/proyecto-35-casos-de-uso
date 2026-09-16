-- ============================================================
-- TALLER PRÁCTICO: FECHAS E INTERVALOS EN POSTGRESQL
-- Archivo 3 de 3: Consultas (35 Casos de Uso + Reto + Reporte)
-- ============================================================
-- Ejecutar este archivo DESPUÉS de database.sql y datos_prueba.sql
-- Ejecutar cada consulta por separado para ver los resultados.
-- ============================================================


-- ============================================================
-- Caso de uso 1: Obtener la fecha y hora actual del servidor
-- ============================================================
SELECT CURRENT_TIMESTAMP AS fecha_hora_actual;


-- ============================================================
-- Caso de uso 2: Extraer el año de la fecha de reserva
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    EXTRACT(YEAR FROM fecha_reserva) AS anio_reserva
FROM reservas;


-- ============================================================
-- Caso de uso 3: Extraer el mes de la fecha de check-in
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    EXTRACT(MONTH FROM fecha_checkin) AS mes_checkin
FROM reservas;


-- ============================================================
-- Caso de uso 4: Extraer el día del mes de la fecha de checkout
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkout,
    EXTRACT(DAY FROM fecha_checkout) AS dia_checkout
FROM reservas;


-- ============================================================
-- Caso de uso 5: Extraer el día de la semana de la fecha de reserva
-- ============================================================
-- DOW = Day Of Week (0 = domingo, 1 = lunes, ..., 6 = sábado)
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    EXTRACT(DOW FROM fecha_reserva) AS dia_semana_numero,
    TO_CHAR(fecha_reserva, 'Day') AS dia_semana_nombre
FROM reservas;


-- ============================================================
-- Caso de uso 6: Extraer la hora de la fecha de reserva
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    EXTRACT(HOUR FROM fecha_reserva) AS hora_reserva
FROM reservas;


-- ============================================================
-- Caso de uso 7: Calcular la cantidad de noches de estadía
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS cantidad_noches
FROM reservas;


-- ============================================================
-- Caso de uso 8: Filtrar reservas realizadas en un año específico (2026)
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    estado
FROM reservas
WHERE EXTRACT(YEAR FROM fecha_reserva) = 2026;


-- ============================================================
-- Caso de uso 9: Filtrar reservas con check-in en un mes específico (septiembre)
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado
FROM reservas
WHERE EXTRACT(MONTH FROM fecha_checkin) = 9;


-- ============================================================
-- Caso de uso 10: Reservas realizadas en los últimos 30 días
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    estado
FROM reservas
WHERE fecha_reserva >= CURRENT_TIMESTAMP - INTERVAL '30 days';


-- ============================================================
-- Caso de uso 11: Reservas con check-in en los próximos 7 días
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado
FROM reservas
WHERE fecha_checkin BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '7 days';


-- ============================================================
-- Caso de uso 12: Sumar 5 días a la fecha de checkout
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkout AS checkout_original,
    fecha_checkout + INTERVAL '5 days' AS checkout_extendido
FROM reservas;


-- ============================================================
-- Caso de uso 13: Restar 3 horas a la fecha de check-in
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin AS checkin_original,
    fecha_checkin - INTERVAL '3 hours' AS checkin_anticipado
FROM reservas;


-- ============================================================
-- Caso de uso 14: Calcular la antigüedad de cada reserva
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    AGE(CURRENT_TIMESTAMP, fecha_reserva) AS antiguedad_reserva
FROM reservas;


-- ============================================================
-- Caso de uso 15: Reservas donde el huésped se quedó más de 5 noches
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS noches
FROM reservas
WHERE (fecha_checkout::DATE - fecha_checkin::DATE) > 5;


-- ============================================================
-- Caso de uso 16: Formatear la fecha de reserva como 'DD/MM/YYYY'
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    TO_CHAR(fecha_reserva, 'DD/MM/YYYY') AS fecha_formateada
FROM reservas;


-- ============================================================
-- Caso de uso 17: Obtener el nombre del mes de la fecha de check-in
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    TO_CHAR(fecha_checkin, 'TMMonth') AS nombre_mes
FROM reservas;


-- ============================================================
-- Caso de uso 18: Obtener el nombre del día de la semana del check-in
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    TO_CHAR(fecha_checkin, 'TMDay') AS nombre_dia
FROM reservas;


-- ============================================================
-- Caso de uso 19: Reservas realizadas en fin de semana (sábado o domingo)
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    TO_CHAR(fecha_reserva, 'TMDay') AS dia_semana
FROM reservas
WHERE EXTRACT(DOW FROM fecha_reserva) IN (0, 6);


-- ============================================================
-- Caso de uso 20: Reservas cuyo checkout ya pasó (huéspedes que ya se fueron)
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkout,
    estado
FROM reservas
WHERE fecha_checkout < CURRENT_TIMESTAMP;


-- ============================================================
-- Caso de uso 21: Reservas cuyo check-in aún no ha llegado
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado
FROM reservas
WHERE fecha_checkin > CURRENT_TIMESTAMP;


-- ============================================================
-- Caso de uso 22: Calcular el ingreso total estimado por reserva
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    tipo_habitacion,
    tarifa_noche,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS noches,
    tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE) AS ingreso_total
FROM reservas;


-- ============================================================
-- Caso de uso 23: Truncar la fecha de reserva al inicio del mes
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    DATE_TRUNC('month', fecha_reserva) AS inicio_mes
FROM reservas;


-- ============================================================
-- Caso de uso 24: Diferencia en horas entre la reserva y el check-in
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    fecha_checkin,
    EXTRACT(EPOCH FROM (fecha_checkin - fecha_reserva)) / 3600 AS horas_anticipacion
FROM reservas;


-- ============================================================
-- Caso de uso 25: Reservas con check-in y checkout en el mismo mes
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    TO_CHAR(fecha_checkin, 'TMMonth') AS mes
FROM reservas
WHERE EXTRACT(MONTH FROM fecha_checkin) = EXTRACT(MONTH FROM fecha_checkout)
  AND EXTRACT(YEAR FROM fecha_checkin) = EXTRACT(YEAR FROM fecha_checkout);


-- ============================================================
-- Caso de uso 26: Reservas que duran exactamente 7 días (1 semana)
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS noches
FROM reservas
WHERE (fecha_checkout::DATE - fecha_checkin::DATE) = 7;


-- ============================================================
-- Caso de uso 27: Listar reservas ordenadas por proximidad al check-in
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado,
    ABS(EXTRACT(EPOCH FROM (fecha_checkin - CURRENT_TIMESTAMP))) / 86400 AS dias_diferencia
FROM reservas
WHERE estado IN ('pendiente', 'confirmada')
ORDER BY ABS(EXTRACT(EPOCH FROM (fecha_checkin - CURRENT_TIMESTAMP))) ASC;


-- ============================================================
-- Caso de uso 28: Promedio de noches de estadía por tipo de habitación
-- ============================================================
SELECT
    tipo_habitacion,
    ROUND(AVG(fecha_checkout::DATE - fecha_checkin::DATE), 2) AS promedio_noches
FROM reservas
GROUP BY tipo_habitacion
ORDER BY promedio_noches DESC;


-- ============================================================
-- Caso de uso 29: Reservas agrupadas por trimestre del año
-- ============================================================
SELECT
    EXTRACT(QUARTER FROM fecha_reserva) AS trimestre,
    COUNT(*) AS total_reservas,
    SUM(tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE)) AS ingresos_trimestre
FROM reservas
GROUP BY EXTRACT(QUARTER FROM fecha_reserva)
ORDER BY trimestre;


-- ============================================================
-- Caso de uso 30: Reservas canceladas en las últimas 2 semanas
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    estado
FROM reservas
WHERE estado = 'cancelada'
  AND fecha_reserva >= CURRENT_TIMESTAMP - INTERVAL '2 weeks';


-- ============================================================
-- Caso de uso 31: Contar reservas por estado
-- ============================================================
SELECT
    estado,
    COUNT(*) AS total_reservas
FROM reservas
GROUP BY estado
ORDER BY total_reservas DESC;


-- ============================================================
-- Caso de uso 32: Reservas donde la fecha de reserva coincide
--                 con la fecha de check-in (mismo día)
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    fecha_checkin
FROM reservas
WHERE fecha_reserva::DATE = fecha_checkin::DATE;


-- ============================================================
-- Caso de uso 33: UPDATE — Extender el checkout sumando 2 noches
-- NOTA: Ejecutar el SELECT antes y después del UPDATE como evidencia.
-- ============================================================

-- ANTES del UPDATE (evidencia):
SELECT id_reserva, nombre_cliente, fecha_checkout
FROM reservas
WHERE id_reserva = 14;

-- UPDATE:
UPDATE reservas
SET fecha_checkout = fecha_checkout + INTERVAL '2 days'
WHERE id_reserva = 14;

-- DESPUÉS del UPDATE (evidencia):
SELECT id_reserva, nombre_cliente, fecha_checkout
FROM reservas
WHERE id_reserva = 14;


-- ============================================================
-- Caso de uso 34: UPDATE — Cancelar reservas con más de 90 días
--                 de antigüedad que aún estén pendientes o confirmadas
-- NOTA: Ejecutar el SELECT antes y después del UPDATE como evidencia.
-- ============================================================

-- ANTES del UPDATE (evidencia):
SELECT id_reserva, nombre_cliente, fecha_reserva, estado,
       AGE(CURRENT_TIMESTAMP, fecha_reserva) AS antiguedad
FROM reservas
WHERE AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '90 days'
  AND estado IN ('pendiente', 'confirmada');

-- UPDATE:
UPDATE reservas
SET estado = 'cancelada'
WHERE AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '90 days'
  AND estado IN ('pendiente', 'confirmada');

-- DESPUÉS del UPDATE (evidencia):
SELECT id_reserva, nombre_cliente, fecha_reserva, estado,
       AGE(CURRENT_TIMESTAMP, fecha_reserva) AS antiguedad
FROM reservas
WHERE AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '90 days';


-- ============================================================
-- Caso de uso 35: UPDATE — Incrementar tarifa en 15% para suites
-- NOTA: Ejecutar el SELECT antes y después del UPDATE como evidencia.
-- ============================================================

-- ANTES del UPDATE (evidencia):
SELECT id_reserva, nombre_cliente, tipo_habitacion, tarifa_noche
FROM reservas
WHERE tipo_habitacion = 'suite';

-- UPDATE:
UPDATE reservas
SET tarifa_noche = ROUND(tarifa_noche * 1.15, 2)
WHERE tipo_habitacion = 'suite';

-- DESPUÉS del UPDATE (evidencia):
SELECT id_reserva, nombre_cliente, tipo_habitacion, tarifa_noche
FROM reservas
WHERE tipo_habitacion = 'suite';


-- ************************************************************
-- RETO INTEGRADOR
-- ************************************************************
-- Objetivo: Generar un resumen ejecutivo por tipo de habitación
-- que combine múltiples funciones de fecha, agregaciones y cálculos.
-- ************************************************************

-- ============================================================
-- Reto Integrador: Resumen ejecutivo por tipo de habitación
-- ============================================================
SELECT
    tipo_habitacion,
    COUNT(*) AS total_reservas,
    COUNT(*) FILTER (WHERE estado = 'completada') AS reservas_completadas,
    COUNT(*) FILTER (WHERE estado = 'cancelada') AS reservas_canceladas,
    COUNT(*) FILTER (WHERE estado IN ('pendiente', 'confirmada')) AS reservas_activas,
    ROUND(AVG(fecha_checkout::DATE - fecha_checkin::DATE), 2) AS promedio_noches,
    MIN(fecha_checkin) AS primer_checkin,
    MAX(fecha_checkout) AS ultimo_checkout,
    SUM(
        CASE
            WHEN estado != 'cancelada'
            THEN tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE)
            ELSE 0
        END
    ) AS ingresos_efectivos,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (fecha_checkin - fecha_reserva)) / 3600
    ), 2) AS promedio_horas_anticipacion,
    TO_CHAR(
        MIN(fecha_reserva), 'DD/MM/YYYY'
    ) AS reserva_mas_antigua,
    TO_CHAR(
        MAX(fecha_reserva), 'DD/MM/YYYY'
    ) AS reserva_mas_reciente
FROM reservas
GROUP BY tipo_habitacion
ORDER BY ingresos_efectivos DESC;


-- ************************************************************
-- CASO DE USO AVANZADO — REPORTE GERENCIAL
-- ************************************************************
-- Objetivo: Construir un reporte gerencial completo usando CTEs,
-- subconsultas, funciones de ventana y todas las funciones de
-- fecha vistas en el taller.
-- ************************************************************

-- ============================================================
-- Reporte Gerencial — Sección 1: Top 5 clientes por ingreso
-- ============================================================
WITH
metricas_reserva AS (
    SELECT
        id_reserva,
        nombre_cliente,
        tipo_habitacion,
        numero_habitacion,
        estado,
        fecha_reserva,
        fecha_checkin,
        fecha_checkout,
        tarifa_noche,
        (fecha_checkout::DATE - fecha_checkin::DATE) AS noches,
        tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE) AS ingreso_bruto,
        EXTRACT(EPOCH FROM (fecha_checkin - fecha_reserva)) / 3600 AS horas_anticipacion,
        EXTRACT(QUARTER FROM fecha_reserva) AS trimestre,
        TO_CHAR(fecha_reserva, 'TMMonth') AS mes_reserva,
        EXTRACT(DOW FROM fecha_checkin) AS dia_semana_checkin,
        AGE(CURRENT_TIMESTAMP, fecha_reserva) AS antiguedad
    FROM reservas
),
ranking_clientes AS (
    SELECT
        nombre_cliente,
        tipo_habitacion,
        ingreso_bruto,
        RANK() OVER (
            PARTITION BY tipo_habitacion
            ORDER BY ingreso_bruto DESC
        ) AS ranking_por_tipo,
        ROW_NUMBER() OVER (
            ORDER BY ingreso_bruto DESC
        ) AS ranking_general
    FROM metricas_reserva
    WHERE estado != 'cancelada'
)
SELECT
    ranking_general,
    nombre_cliente,
    tipo_habitacion,
    ingreso_bruto,
    ranking_por_tipo
FROM ranking_clientes
WHERE ranking_general <= 5
ORDER BY ranking_general;


-- ============================================================
-- Reporte Gerencial — Sección 2: Tendencia mensual
-- ============================================================
WITH
metricas_reserva AS (
    SELECT
        fecha_reserva,
        estado,
        (fecha_checkout::DATE - fecha_checkin::DATE) AS noches,
        tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE) AS ingreso_bruto
    FROM reservas
),
estadisticas_mensuales AS (
    SELECT
        DATE_TRUNC('month', fecha_reserva) AS mes,
        TO_CHAR(fecha_reserva, 'YYYY - TMMonth') AS periodo,
        COUNT(*) AS reservas_mes,
        SUM(CASE WHEN estado != 'cancelada' THEN ingreso_bruto ELSE 0 END) AS ingresos_mes,
        ROUND(AVG(noches), 2) AS promedio_noches_mes,
        COUNT(*) FILTER (WHERE estado = 'cancelada') AS cancelaciones_mes,
        ROUND(
            COUNT(*) FILTER (WHERE estado = 'cancelada')::NUMERIC / COUNT(*) * 100, 2
        ) AS tasa_cancelacion
    FROM metricas_reserva
    GROUP BY DATE_TRUNC('month', fecha_reserva), TO_CHAR(fecha_reserva, 'YYYY - TMMonth')
)
SELECT
    periodo,
    reservas_mes,
    ingresos_mes,
    promedio_noches_mes,
    cancelaciones_mes,
    tasa_cancelacion || '%' AS tasa_cancelacion,
    SUM(ingresos_mes) OVER (ORDER BY mes) AS ingresos_acumulados
FROM estadisticas_mensuales
ORDER BY mes;


-- ============================================================
-- Reporte Gerencial — Sección 3: Ocupación por día de la semana
-- ============================================================
SELECT
    CASE EXTRACT(DOW FROM fecha_checkin)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
    END AS dia_semana,
    COUNT(*) AS total_checkins,
    ROUND(AVG(fecha_checkout::DATE - fecha_checkin::DATE), 2) AS promedio_noches
FROM reservas
GROUP BY EXTRACT(DOW FROM fecha_checkin)
ORDER BY EXTRACT(DOW FROM fecha_checkin);


-- ============================================================
-- Reporte Gerencial — Sección 4: Alertas operativas
-- ============================================================
SELECT
    id_reserva,
    nombre_cliente,
    tipo_habitacion,
    fecha_checkin,
    estado,
    CASE
        WHEN fecha_checkin BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '3 days'
            THEN '⚠️ CHECK-IN MUY PRÓXIMO'
        WHEN fecha_checkin BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '7 days'
            THEN '📋 CHECK-IN ESTA SEMANA'
        WHEN fecha_checkout < CURRENT_TIMESTAMP AND estado = 'confirmada'
            THEN '🔴 CHECKOUT VENCIDO SIN COMPLETAR'
        WHEN AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '60 days' AND estado = 'pendiente'
            THEN '🟡 RESERVA PENDIENTE ANTIGUA'
        ELSE '✅ SIN ALERTAS'
    END AS alerta
FROM reservas
WHERE estado IN ('pendiente', 'confirmada')
ORDER BY fecha_checkin;


-- ============================================================
-- FIN DEL SCRIPT DE CONSULTAS
-- ============================================================
