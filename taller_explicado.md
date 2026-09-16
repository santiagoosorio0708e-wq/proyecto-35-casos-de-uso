# 📘 Taller Práctico: Fechas e Intervalos en PostgreSQL

## Sistema de Reservas de Hotel

Este documento explica paso a paso la lógica detrás de cada uno de los **35 casos de uso**, el **Reto Integrador** y el **Caso de Uso Avanzado (Reporte Gerencial)** del taller.

> **Nota:** Este archivo es exclusivamente analítico. Para la creación de la tabla y los datos de prueba, consulta el archivo `database_y_consultas.sql`.

---

## 📑 Índice

| Sección | Casos |
|---------|-------|
| Funciones de extracción (`EXTRACT`) | 1 – 6 |
| Aritmética de fechas y diferencias | 7 – 9 |
| Filtros con `INTERVAL` y `CURRENT_TIMESTAMP` | 10 – 11 |
| Operaciones con `INTERVAL` | 12 – 13 |
| Función `AGE()` y comparaciones temporales | 14 – 15 |
| Formateo con `TO_CHAR` | 16 – 19 |
| Filtros temporales avanzados | 20 – 21 |
| Cálculos y agregaciones | 22 – 23 |
| Operaciones con `EPOCH` | 24 |
| Comparaciones entre campos de fecha | 25 – 26 |
| Ordenamientos y agrupaciones | 27 – 31 |
| Casting de fechas | 32 |
| Sentencias `UPDATE` con fechas | 33 – 35 |
| Reto Integrador | — |
| Caso de Uso Avanzado | — |

---

## 🔹 Caso de uso 1: Obtener la fecha y hora actual del servidor

**Concepto:** `CURRENT_TIMESTAMP` es una función que devuelve la fecha y hora actuales del servidor PostgreSQL, incluyendo la zona horaria. Es útil para comparaciones dinámicas y registros de auditoría.

```sql
SELECT CURRENT_TIMESTAMP AS fecha_hora_actual;
```

**¿Por qué se usa?** Permite verificar la hora del servidor y sirve como base para cálculos relativos como "los últimos 30 días" o "los próximos 7 días".

---

## 🔹 Caso de uso 2: Extraer el año de la fecha de reserva

**Concepto:** `EXTRACT(YEAR FROM campo)` extrae el componente numérico del año desde un campo de tipo `TIMESTAMP` o `DATE`. Devuelve un valor numérico (ej: `2026`).

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    EXTRACT(YEAR FROM fecha_reserva) AS anio_reserva
FROM reservas;
```

**¿Por qué se usa?** Es fundamental para agrupar o filtrar datos por año sin necesidad de formatear el campo completo.

---

## 🔹 Caso de uso 3: Extraer el mes de la fecha de check-in

**Concepto:** `EXTRACT(MONTH FROM campo)` obtiene el número del mes (1 a 12) de un campo temporal. Es ideal para análisis estacionales o filtros mensuales.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    EXTRACT(MONTH FROM fecha_checkin) AS mes_checkin
FROM reservas;
```

**¿Por qué se usa?** Permite segmentar reservas por mes para identificar temporadas altas y bajas.

---

## 🔹 Caso de uso 4: Extraer el día del mes de la fecha de checkout

**Concepto:** `EXTRACT(DAY FROM campo)` devuelve el número del día dentro del mes (1 a 31).

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkout,
    EXTRACT(DAY FROM fecha_checkout) AS dia_checkout
FROM reservas;
```

**¿Por qué se usa?** Útil para identificar patrones, como si los huéspedes tienden a irse a principio o final de mes.

---

## 🔹 Caso de uso 5: Extraer el día de la semana de la fecha de reserva

**Concepto:** `EXTRACT(DOW FROM campo)` devuelve el día de la semana como número (0 = Domingo, 1 = Lunes, ..., 6 = Sábado). Se combina con `TO_CHAR(campo, 'Day')` para obtener el nombre del día.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    EXTRACT(DOW FROM fecha_reserva) AS dia_semana_numero,
    TO_CHAR(fecha_reserva, 'Day') AS dia_semana_nombre
FROM reservas;
```

**¿Por qué se usa?** Permite analizar en qué días de la semana se hacen más reservas para optimizar campañas.

---

## 🔹 Caso de uso 6: Extraer la hora de la fecha de reserva

**Concepto:** `EXTRACT(HOUR FROM campo)` extrae la hora (0 a 23) de un `TIMESTAMP`. Solo funciona con campos que incluyan componente de hora.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    EXTRACT(HOUR FROM fecha_reserva) AS hora_reserva
FROM reservas;
```

**¿Por qué se usa?** Permite identificar las horas pico en que los clientes realizan sus reservas.

---

## 🔹 Caso de uso 7: Calcular la cantidad de noches de estadía

**Concepto:** La resta entre dos fechas casteadas a `DATE` (`::DATE`) devuelve un entero con la diferencia en días. El operador `::DATE` elimina la parte de hora del `TIMESTAMP`.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS cantidad_noches
FROM reservas;
```

**¿Por qué se usa?** Es la forma más directa en PostgreSQL de calcular días entre dos fechas. El cast a `DATE` asegura que la diferencia sea un entero limpio.

---

## 🔹 Caso de uso 8: Filtrar reservas por año específico

**Concepto:** Se usa `EXTRACT(YEAR FROM campo) = valor` en la cláusula `WHERE` para filtrar registros de un año particular.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    estado
FROM reservas
WHERE EXTRACT(YEAR FROM fecha_reserva) = 2026;
```

**¿Por qué se usa?** Permite aislar datos de un año fiscal o calendario específico para reportes anuales.

---

## 🔹 Caso de uso 9: Filtrar reservas con check-in en septiembre

**Concepto:** Similar al caso anterior, `EXTRACT(MONTH FROM campo) = 9` filtra registros del mes de septiembre.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado
FROM reservas
WHERE EXTRACT(MONTH FROM fecha_checkin) = 9;
```

**¿Por qué se usa?** Ideal para analizar la ocupación de un mes específico y planificar recursos.

---

## 🔹 Caso de uso 10: Reservas realizadas en los últimos 30 días

**Concepto:** `CURRENT_TIMESTAMP - INTERVAL '30 days'` calcula un punto en el pasado restando un intervalo a la fecha actual. `INTERVAL` es un tipo de dato que representa una duración de tiempo.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    estado
FROM reservas
WHERE fecha_reserva >= CURRENT_TIMESTAMP - INTERVAL '30 days';
```

**¿Por qué se usa?** Es la técnica estándar para crear ventanas de tiempo dinámicas que se actualizan automáticamente.

---

## 🔹 Caso de uso 11: Reservas con check-in en los próximos 7 días

**Concepto:** `BETWEEN` define un rango inclusivo. Combinado con `CURRENT_TIMESTAMP + INTERVAL '7 days'`, crea una ventana de tiempo futura.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado
FROM reservas
WHERE fecha_checkin BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '7 days';
```

**¿Por qué se usa?** Permite al equipo operativo prepararse para las llegadas próximas y verificar la disponibilidad de habitaciones.

---

## 🔹 Caso de uso 12: Sumar 5 días a la fecha de checkout

**Concepto:** El operador `+` con `INTERVAL` permite sumar tiempo a un `TIMESTAMP`. Se puede usar con `days`, `hours`, `minutes`, `months`, `years`, etc.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkout AS checkout_original,
    fecha_checkout + INTERVAL '5 days' AS checkout_extendido
FROM reservas;
```

**¿Por qué se usa?** Simula extensiones de estadía sin modificar datos reales. Es una proyección calculada.

---

## 🔹 Caso de uso 13: Restar 3 horas a la fecha de check-in

**Concepto:** El operador `-` con `INTERVAL '3 hours'` resta horas a un `TIMESTAMP`, manteniendo la precisión temporal completa.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin AS checkin_original,
    fecha_checkin - INTERVAL '3 hours' AS checkin_anticipado
FROM reservas;
```

**¿Por qué se usa?** Podría usarse para calcular la hora en que deben prepararse las habitaciones antes de la llegada del huésped.

---

## 🔹 Caso de uso 14: Calcular la antigüedad de cada reserva

**Concepto:** `AGE(timestamp1, timestamp2)` devuelve un `INTERVAL` que representa la diferencia detallada entre dos momentos (años, meses, días, horas, etc.). Siempre muestra el resultado en la unidad más legible.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    AGE(CURRENT_TIMESTAMP, fecha_reserva) AS antiguedad_reserva
FROM reservas;
```

**¿Por qué se usa?** A diferencia de la resta simple de fechas, `AGE()` devuelve un desglose humano como `5 mons 10 days 03:30:00`, ideal para reportes.

---

## 🔹 Caso de uso 15: Reservas con más de 5 noches

**Concepto:** Se reutiliza la técnica de resta de fechas con `::DATE` y se aplica un filtro `WHERE` con operador `>`.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS noches
FROM reservas
WHERE (fecha_checkout::DATE - fecha_checkin::DATE) > 5;
```

**¿Por qué se usa?** Identifica estadías largas para ofrecer tarifas especiales o servicios premium.

---

## 🔹 Caso de uso 16: Formatear fecha como 'DD/MM/YYYY'

**Concepto:** `TO_CHAR(campo, 'patrón')` convierte un `TIMESTAMP` a texto formateado. Los patrones principales son: `DD` (día), `MM` (mes numérico), `YYYY` (año de 4 dígitos).

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    TO_CHAR(fecha_reserva, 'DD/MM/YYYY') AS fecha_formateada
FROM reservas;
```

**¿Por qué se usa?** Genera salidas legibles para reportes o interfaces que requieren un formato específico regional.

---

## 🔹 Caso de uso 17: Obtener el nombre del mes del check-in

**Concepto:** `TO_CHAR(campo, 'TMMonth')` devuelve el nombre completo del mes localizado. El prefijo `TM` (Translation Mode) aplica la localización configurada en PostgreSQL (ej: "Septiembre" en español).

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    TO_CHAR(fecha_checkin, 'TMMonth') AS nombre_mes
FROM reservas;
```

**¿Por qué se usa?** Muestra el nombre del mes en texto legible en vez de un número, ideal para reportes de presentación.

---

## 🔹 Caso de uso 18: Obtener el nombre del día de la semana

**Concepto:** `TO_CHAR(campo, 'TMDay')` devuelve el nombre del día de la semana localizado (ej: "Lunes", "Martes").

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    TO_CHAR(fecha_checkin, 'TMDay') AS nombre_dia
FROM reservas;
```

**¿Por qué se usa?** Complementa al caso 5 pero devuelve texto en lugar de un número, mejorando la legibilidad de los resultados.

---

## 🔹 Caso de uso 19: Reservas realizadas en fin de semana

**Concepto:** `EXTRACT(DOW FROM campo) IN (0, 6)` filtra por domingo (0) y sábado (6). Combinado con `TO_CHAR`, se muestra el nombre del día.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    TO_CHAR(fecha_reserva, 'TMDay') AS dia_semana
FROM reservas
WHERE EXTRACT(DOW FROM fecha_reserva) IN (0, 6);
```

**¿Por qué se usa?** Analiza el comportamiento de reservas en fin de semana versus días laborales para ajustar estrategias de marketing.

---

## 🔹 Caso de uso 20: Reservas cuyo checkout ya pasó

**Concepto:** La comparación directa `fecha_checkout < CURRENT_TIMESTAMP` filtra registros cuya fecha de salida es anterior al momento actual.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkout,
    estado
FROM reservas
WHERE fecha_checkout < CURRENT_TIMESTAMP;
```

**¿Por qué se usa?** Identifica huéspedes que ya se fueron, permitiendo verificar si su estado fue actualizado a "completada".

---

## 🔹 Caso de uso 21: Reservas cuyo check-in aún no ha llegado

**Concepto:** `fecha_checkin > CURRENT_TIMESTAMP` filtra reservas futuras cuya fecha de llegada aún no se ha alcanzado.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado
FROM reservas
WHERE fecha_checkin > CURRENT_TIMESTAMP;
```

**¿Por qué se usa?** Permite ver las llegadas pendientes para planificación de personal y limpieza.

---

## 🔹 Caso de uso 22: Calcular el ingreso total estimado por reserva

**Concepto:** Se multiplica la `tarifa_noche` por la cantidad de noches (diferencia de fechas casteadas). Esta columna calculada no existe en la tabla sino que se genera al vuelo.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    tipo_habitacion,
    tarifa_noche,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS noches,
    tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE) AS ingreso_total
FROM reservas;
```

**¿Por qué se usa?** Demuestra cómo las funciones de fecha pueden integrarse en cálculos financieros sin almacenar datos redundantes.

---

## 🔹 Caso de uso 23: Truncar la fecha al inicio del mes

**Concepto:** `DATE_TRUNC('month', campo)` redondea un `TIMESTAMP` hacia abajo al primer día del mes, poniendo día=01 y hora=00:00:00.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    DATE_TRUNC('month', fecha_reserva) AS inicio_mes
FROM reservas;
```

**¿Por qué se usa?** Es esencial para agrupar registros por período (mes, trimestre, año) en reportes agregados. Garantiza que todos los registros del mismo mes tengan el mismo valor de referencia.

---

## 🔹 Caso de uso 24: Diferencia en horas entre la reserva y el check-in

**Concepto:** `EXTRACT(EPOCH FROM intervalo)` convierte un `INTERVAL` a su equivalente total en **segundos**. Al dividir entre 3600, se obtiene la diferencia en horas.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    fecha_checkin,
    EXTRACT(EPOCH FROM (fecha_checkin - fecha_reserva)) / 3600 AS horas_anticipacion
FROM reservas;
```

**¿Por qué se usa?** `EPOCH` es la herramienta para convertir intervalos a una unidad numérica precisa y continua (no fragmentada como `AGE()`). Dividir entre 3600 convierte segundos a horas; entre 86400 a días.

---

## 🔹 Caso de uso 25: Check-in y checkout en el mismo mes

**Concepto:** Se comparan los `EXTRACT(MONTH ...)` y `EXTRACT(YEAR ...)` de ambos campos para asegurar que no solo el mes sino el año coincidan.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    TO_CHAR(fecha_checkin, 'TMMonth') AS mes
FROM reservas
WHERE EXTRACT(MONTH FROM fecha_checkin) = EXTRACT(MONTH FROM fecha_checkout)
  AND EXTRACT(YEAR FROM fecha_checkin) = EXTRACT(YEAR FROM fecha_checkout);
```

**¿Por qué se usa?** Importante verificar también el año, ya que septiembre de 2026 y septiembre de 2027 son meses distintos. Este patrón previene errores lógicos sutiles.

---

## 🔹 Caso de uso 26: Reservas que duran exactamente 7 días

**Concepto:** Se usa la diferencia de fechas con igualdad estricta `= 7` para buscar estadías de exactamente una semana.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    fecha_checkout,
    (fecha_checkout::DATE - fecha_checkin::DATE) AS noches
FROM reservas
WHERE (fecha_checkout::DATE - fecha_checkin::DATE) = 7;
```

**¿Por qué se usa?** Permite identificar paquetes semanales o patrones de estadía comunes.

---

## 🔹 Caso de uso 27: Ordenar reservas por proximidad al check-in

**Concepto:** `ABS()` calcula el valor absoluto de la diferencia en segundos (via `EPOCH`), dividido entre 86400 para expresar en días. Esto ordena tanto check-ins pasados como futuros por cercanía al momento actual.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_checkin,
    estado,
    ABS(EXTRACT(EPOCH FROM (fecha_checkin - CURRENT_TIMESTAMP))) / 86400 AS dias_diferencia
FROM reservas
WHERE estado IN ('pendiente', 'confirmada')
ORDER BY ABS(EXTRACT(EPOCH FROM (fecha_checkin - CURRENT_TIMESTAMP))) ASC;
```

**¿Por qué se usa?** Prioriza la atención operativa mostrando primero las reservas más cercanas al check-in, independientemente de si ya pasaron o no.

---

## 🔹 Caso de uso 28: Promedio de noches por tipo de habitación

**Concepto:** `AVG()` calcula el promedio y `ROUND(valor, decimales)` redondea. Se agrupa con `GROUP BY` por tipo de habitación.

```sql
SELECT
    tipo_habitacion,
    ROUND(AVG(fecha_checkout::DATE - fecha_checkin::DATE), 2) AS promedio_noches
FROM reservas
GROUP BY tipo_habitacion
ORDER BY promedio_noches DESC;
```

**¿Por qué se usa?** Revela si los huéspedes de suite se quedan más tiempo que los de habitaciones individuales, información clave para pricing.

---

## 🔹 Caso de uso 29: Reservas agrupadas por trimestre

**Concepto:** `EXTRACT(QUARTER FROM campo)` devuelve el trimestre (1 a 4). Combinado con `SUM()` y `COUNT()`, permite análisis trimestrales.

```sql
SELECT
    EXTRACT(QUARTER FROM fecha_reserva) AS trimestre,
    COUNT(*) AS total_reservas,
    SUM(tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE)) AS ingresos_trimestre
FROM reservas
GROUP BY EXTRACT(QUARTER FROM fecha_reserva)
ORDER BY trimestre;
```

**¿Por qué se usa?** El análisis trimestral es estándar en reportes financieros y gerenciales.

---

## 🔹 Caso de uso 30: Cancelaciones en las últimas 2 semanas

**Concepto:** Se combina un filtro de estado con `INTERVAL '2 weeks'`. PostgreSQL acepta unidades como `weeks`, `months`, `years` además de `days` y `hours`.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    estado
FROM reservas
WHERE estado = 'cancelada'
  AND fecha_reserva >= CURRENT_TIMESTAMP - INTERVAL '2 weeks';
```

**¿Por qué se usa?** Monitorea la tasa de cancelaciones recientes para detectar problemas operativos o estacionales.

---

## 🔹 Caso de uso 31: Contar reservas por estado

**Concepto:** `COUNT(*)` cuenta filas por grupo. Con `GROUP BY estado` se obtiene la distribución por estado.

```sql
SELECT
    estado,
    COUNT(*) AS total_reservas
FROM reservas
GROUP BY estado
ORDER BY total_reservas DESC;
```

**¿Por qué se usa?** Dashboard básico del estado operativo del hotel.

---

## 🔹 Caso de uso 32: Reservas hechas el mismo día del check-in

**Concepto:** `campo::DATE` castea un `TIMESTAMP` a `DATE`, eliminando la parte de hora. Al comparar dos campos casteados, se verifica si ocurrieron el mismo día calendario.

```sql
SELECT
    id_reserva,
    nombre_cliente,
    fecha_reserva,
    fecha_checkin
FROM reservas
WHERE fecha_reserva::DATE = fecha_checkin::DATE;
```

**¿Por qué se usa?** Identifica reservas de último momento (walk-ins), que pueden indicar oportunidades de revenue management.

---

## 🔹 Caso de uso 33: UPDATE — Extender checkout sumando 2 noches

**Concepto:** `UPDATE ... SET campo = campo + INTERVAL '2 days'` modifica directamente el valor del campo sumando un intervalo. El `WHERE` asegura que solo se actualice un registro específico.

> ⚠️ **Evidencia:** Ejecutar un `SELECT` antes y después del `UPDATE` para comparar resultados.

**ANTES del UPDATE:**
```sql
SELECT id_reserva, nombre_cliente, fecha_checkout
FROM reservas
WHERE id_reserva = 14;
```

**UPDATE:**
```sql
UPDATE reservas
SET fecha_checkout = fecha_checkout + INTERVAL '2 days'
WHERE id_reserva = 14;
```

**DESPUÉS del UPDATE:**
```sql
SELECT id_reserva, nombre_cliente, fecha_checkout
FROM reservas
WHERE id_reserva = 14;
```

**¿Por qué se usa?** Demuestra cómo la aritmética de intervalos funciona no solo en `SELECT` sino también en `UPDATE`, siendo un caso real de extensión de estadía.

---

## 🔹 Caso de uso 34: UPDATE — Cancelar reservas antiguas (+90 días)

**Concepto:** `AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '90 days'` calcula la antigüedad de cada reserva y la compara con un umbral. Solo afecta reservas que aún estén activas (`pendiente` o `confirmada`).

> ⚠️ **Evidencia:** Ejecutar un `SELECT` antes y después del `UPDATE` para comparar resultados.

**ANTES del UPDATE:**
```sql
SELECT id_reserva, nombre_cliente, fecha_reserva, estado,
       AGE(CURRENT_TIMESTAMP, fecha_reserva) AS antiguedad
FROM reservas
WHERE AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '90 days'
  AND estado IN ('pendiente', 'confirmada');
```

**UPDATE:**
```sql
UPDATE reservas
SET estado = 'cancelada'
WHERE AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '90 days'
  AND estado IN ('pendiente', 'confirmada');
```

**DESPUÉS del UPDATE:**
```sql
SELECT id_reserva, nombre_cliente, fecha_reserva, estado,
       AGE(CURRENT_TIMESTAMP, fecha_reserva) AS antiguedad
FROM reservas
WHERE AGE(CURRENT_TIMESTAMP, fecha_reserva) > INTERVAL '90 days';
```

**¿Por qué se usa?** Automatiza la limpieza de reservas abandonadas. `AGE()` es más preciso que restar fechas porque considera meses de diferente longitud.

---

## 🔹 Caso de uso 35: UPDATE — Incrementar tarifa 15% para suites

**Concepto:** `ROUND(tarifa_noche * 1.15, 2)` aplica un incremento del 15% y redondea a 2 decimales. La condición `WHERE tipo_habitacion = 'suite'` delimita qué registros se actualizan.

> ⚠️ **Evidencia:** Ejecutar un `SELECT` antes y después del `UPDATE` para comparar resultados.

**ANTES del UPDATE:**
```sql
SELECT id_reserva, nombre_cliente, tipo_habitacion, tarifa_noche
FROM reservas
WHERE tipo_habitacion = 'suite';
```

**UPDATE:**
```sql
UPDATE reservas
SET tarifa_noche = ROUND(tarifa_noche * 1.15, 2)
WHERE tipo_habitacion = 'suite';
```

**DESPUÉS del UPDATE:**
```sql
SELECT id_reserva, nombre_cliente, tipo_habitacion, tarifa_noche
FROM reservas
WHERE tipo_habitacion = 'suite';
```

**¿Por qué se usa?** Combina funciones matemáticas (`ROUND`) con `UPDATE` para ajustar precios masivamente por categoría. Un caso real de gestión de tarifas.

---

## 🏆 Reto Integrador: Resumen ejecutivo por tipo de habitación

**Concepto:** Este reto combina múltiples funciones en una sola consulta: `COUNT()` con `FILTER`, `AVG()`, `MIN()`, `MAX()`, `SUM()` con `CASE`, `EXTRACT(EPOCH ...)`, `TO_CHAR()` y `GROUP BY`.

La cláusula `FILTER (WHERE condición)` es exclusiva de PostgreSQL y permite contar o sumar solo los registros que cumplen una condición, sin necesidad de `CASE WHEN`.

```sql
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
    TO_CHAR(MIN(fecha_reserva), 'DD/MM/YYYY') AS reserva_mas_antigua,
    TO_CHAR(MAX(fecha_reserva), 'DD/MM/YYYY') AS reserva_mas_reciente
FROM reservas
GROUP BY tipo_habitacion
ORDER BY ingresos_efectivos DESC;
```

### Desglose de la lógica:

| Elemento | Función | Propósito |
|----------|---------|-----------|
| `COUNT(*) FILTER (WHERE ...)` | Agregación condicional | Contar reservas por estado sin subconsultas |
| `AVG(fecha_checkout::DATE - fecha_checkin::DATE)` | Promedio de diferencia de fechas | Estadía promedio por tipo |
| `SUM(CASE WHEN ...)` | Suma condicional | Excluir canceladas del cálculo de ingresos |
| `EXTRACT(EPOCH FROM ...) / 3600` | Conversión a horas | Anticipación promedio de reserva |
| `TO_CHAR(MIN(...), 'DD/MM/YYYY')` | Formato de fecha | Presentación legible de fechas extremas |

---

## 🧠 Caso de Uso Avanzado: Reporte Gerencial

**Concepto:** Este reporte usa **CTEs (Common Table Expressions)** con `WITH ... AS` para organizar consultas complejas en pasos lógicos reutilizables. También incorpora **funciones de ventana** (`RANK()`, `ROW_NUMBER()`, `SUM() OVER()`) para cálculos acumulados y rankings.

### Sección 1 — Top 5 clientes por ingreso

Se usan las funciones de ventana `RANK()` y `ROW_NUMBER()` con `OVER()` para crear rankings. `PARTITION BY` genera rankings separados por tipo de habitación.

```sql
WITH metricas_reserva AS (
    SELECT
        nombre_cliente,
        tipo_habitacion,
        estado,
        tarifa_noche * (fecha_checkout::DATE - fecha_checkin::DATE) AS ingreso_bruto
    FROM reservas
),
ranking_clientes AS (
    SELECT
        nombre_cliente,
        tipo_habitacion,
        ingreso_bruto,
        RANK() OVER (PARTITION BY tipo_habitacion ORDER BY ingreso_bruto DESC) AS ranking_por_tipo,
        ROW_NUMBER() OVER (ORDER BY ingreso_bruto DESC) AS ranking_general
    FROM metricas_reserva
    WHERE estado != 'cancelada'
)
SELECT ranking_general, nombre_cliente, tipo_habitacion, ingreso_bruto, ranking_por_tipo
FROM ranking_clientes
WHERE ranking_general <= 5
ORDER BY ranking_general;
```

### Sección 2 — Tendencia mensual con ingresos acumulados

`DATE_TRUNC('month', ...)` agrupa por mes. `SUM(...) OVER (ORDER BY mes)` crea un acumulado progresivo que muestra la tendencia de ingresos.

```sql
WITH metricas_reserva AS (
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
        ROUND(COUNT(*) FILTER (WHERE estado = 'cancelada')::NUMERIC / COUNT(*) * 100, 2) AS tasa_cancelacion
    FROM metricas_reserva
    GROUP BY DATE_TRUNC('month', fecha_reserva), TO_CHAR(fecha_reserva, 'YYYY - TMMonth')
)
SELECT
    periodo, reservas_mes, ingresos_mes, promedio_noches_mes,
    cancelaciones_mes, tasa_cancelacion || '%' AS tasa_cancelacion,
    SUM(ingresos_mes) OVER (ORDER BY mes) AS ingresos_acumulados
FROM estadisticas_mensuales
ORDER BY mes;
```

### Sección 3 — Ocupación por día de la semana

El `CASE` convierte el número del día (de `EXTRACT(DOW ...)`) en texto legible.

```sql
SELECT
    CASE EXTRACT(DOW FROM fecha_checkin)
        WHEN 0 THEN 'Domingo'   WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'    WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'    WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
    END AS dia_semana,
    COUNT(*) AS total_checkins,
    ROUND(AVG(fecha_checkout::DATE - fecha_checkin::DATE), 2) AS promedio_noches
FROM reservas
GROUP BY EXTRACT(DOW FROM fecha_checkin)
ORDER BY EXTRACT(DOW FROM fecha_checkin);
```

### Sección 4 — Alertas operativas

Un `CASE` con múltiples condiciones genera alertas visuales basadas en la proximidad temporal de cada reserva.

```sql
SELECT
    id_reserva, nombre_cliente, tipo_habitacion,
    fecha_checkin, estado,
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
```

---

## 📚 Resumen de funciones utilizadas

| Función | Descripción | Ejemplo |
|---------|-------------|---------|
| `CURRENT_TIMESTAMP` | Fecha y hora actual del servidor | `SELECT CURRENT_TIMESTAMP` |
| `EXTRACT(parte FROM campo)` | Extrae un componente (YEAR, MONTH, DAY, HOUR, DOW, QUARTER, EPOCH) | `EXTRACT(MONTH FROM fecha)` |
| `AGE(t1, t2)` | Diferencia detallada entre dos timestamps | `AGE(NOW(), fecha_reserva)` |
| `DATE_TRUNC('unidad', campo)` | Trunca al inicio de la unidad (month, year, etc.) | `DATE_TRUNC('month', fecha)` |
| `TO_CHAR(campo, 'patrón')` | Formatea fecha como texto | `TO_CHAR(fecha, 'DD/MM/YYYY')` |
| `INTERVAL 'cantidad unidad'` | Define una duración de tiempo | `INTERVAL '30 days'` |
| `::DATE` | Cast de TIMESTAMP a DATE | `fecha_checkin::DATE` |
| `FILTER (WHERE ...)` | Agregación condicional (PostgreSQL) | `COUNT(*) FILTER (WHERE estado = 'x')` |
| `RANK() OVER(...)` | Ranking con empates | `RANK() OVER (ORDER BY ingreso DESC)` |
| `ROW_NUMBER() OVER(...)` | Numeración secuencial | `ROW_NUMBER() OVER (ORDER BY col)` |
| `SUM() OVER(ORDER BY ...)` | Suma acumulada (ventana) | `SUM(ingreso) OVER (ORDER BY mes)` |
