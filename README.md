# 🗓️ Taller Práctico: Fechas e Intervalos en PostgreSQL

## Sistema de Reservas de Hotel

Este proyecto contiene la solución completa de un **taller práctico de bases de datos** enfocado en el manejo de **fechas, timestamps e intervalos en PostgreSQL**, aplicado a un sistema de reservas hoteleras.

---

## 📁 Estructura del Proyecto

```
casos de uso/
├── .devcontainer/
│   ├── Dockerfile             ← Imagen del workspace (cliente psql)
│   └── devcontainer.json      ← Configuración para VS Code
├── init/
│   ├── 01_database.sql        ← DDL auto-ejecutado por Docker al iniciar
│   └── 02_datos_prueba.sql    ← DML auto-ejecutado por Docker al iniciar
├── .env                       ← Variables de entorno (credenciales)
├── docker-compose.yml         ← Orquestación de servicios Docker
├── README.md                  ← Este archivo (instrucciones)
├── database.sql               ← Estructura de la base de datos (DDL)
├── datos_prueba.sql           ← Datos de prueba (DML - INSERT)
├── consultas.sql              ← 35 consultas + reto integrador + reporte gerencial
└── taller_explicado.md        ← Explicación analítica de cada caso de uso
```

| Archivo | Contenido |
|---------|-----------|
| `database.sql` | Creación de la tabla `reservas` con todos sus campos, tipos de dato y restricciones (`CHECK`, `PRIMARY KEY`) |
| `datos_prueba.sql` | 20 registros `INSERT INTO` con datos variados: distintos estados, tipos de habitación y fechas distribuidas entre marzo y octubre 2026 |
| `consultas.sql` | Las 35 consultas resueltas (comentadas por caso), el reto integrador y las 4 secciones del reporte gerencial |
| `taller_explicado.md` | Explicación paso a paso de la lógica detrás de cada consulta (sin DDL ni DML, solo parte analítica) |
| `init/` | Scripts SQL numerados que Docker ejecuta automáticamente al crear el contenedor por primera vez |
| `.env` | Credenciales de PostgreSQL y pgAdmin |
| `docker-compose.yml` | Define los servicios: PostgreSQL 16, pgAdmin 4 y workspace de desarrollo |

---

## 🧰 Requisitos Previos

### Opción A: Con Docker (recomendado)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y corriendo

### Opción B: Sin Docker (instalación local)
- **PostgreSQL** instalado (versión 12 o superior recomendada)
- Una herramienta de administración de bases de datos:
  - [pgAdmin 4](https://www.pgadmin.org/) (interfaz gráfica oficial)
  - [DBeaver](https://dbeaver.io/) (alternativa multiplataforma)
  - O cualquier cliente SQL compatible con PostgreSQL

---

## 🐳 Opción A: Guía con Docker

### Paso 1: Levantar los contenedores

Abre una terminal en la carpeta del proyecto y ejecuta:

```bash
docker compose up -d
```

Esto levanta 3 servicios:

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| `postgres_db` | `5433` | Servidor PostgreSQL 16 |
| `pgadmin_web` | `8081` | Interfaz web pgAdmin 4 |
| `workspace` | — | Contenedor de desarrollo con `psql` |

> 💡 **La tabla `reservas` y los 20 registros de prueba se crean automáticamente** gracias a los scripts en la carpeta `init/`. No necesitas ejecutar `database.sql` ni `datos_prueba.sql` manualmente.

---

### Paso 2: Acceder a pgAdmin

1. Abre tu navegador en: **http://localhost:8081**
2. Inicia sesión con las credenciales del `.env`:
   - **Email:** `danielosoriog2008@gmail.com`
   - **Password:** `Santiago0724.`

---

### Paso 3: Registrar el servidor en pgAdmin

1. Click derecho en **Servers** → **Register** → **Server...**
2. Pestaña **General**:
   - **Name:** `Taller Fechas`
3. Pestaña **Connection**:
   - **Host name:** `postgres_db` (nombre del servicio en Docker, NO `localhost`)
   - **Port:** `5432` (puerto interno del contenedor)
   - **Maintenance database:** `bkddb`
   - **Username:** `bkseducate`
   - **Password:** `bkseducate2026`
   - ✅ Marcar **Save password**
4. Click en **Save**

---

### Paso 4: Ejecutar las consultas

1. En pgAdmin, navega a: **Servers → Taller Fechas → Databases → bkddb**
2. Click derecho en **bkddb** → **Query Tool**
3. Abre el archivo **`consultas.sql`** o copia y pega las consultas una por una
4. Lee la explicación de cada caso en **`taller_explicado.md`** en paralelo

> 💡 **Tip:** Selecciona solo la consulta que quieres ejecutar y presiona **F5** para ejecutar solo la selección.

---

### Paso 5: Reiniciar los datos (si es necesario)

Si necesitas volver al estado original después de ejecutar los UPDATE (casos 33-35):

```bash
# Detener y eliminar contenedores + volúmenes
docker compose down -v

# Volver a levantar (recrea todo desde cero)
docker compose up -d
```

> El flag `-v` elimina los volúmenes de datos, forzando a Docker a re-ejecutar los scripts de `init/`.

---

## 🖥️ Opción B: Guía sin Docker (Instalación Local)

### Paso 1: Crear la base de datos

Abre tu herramienta de administración y crea una nueva base de datos para el taller:

```sql
CREATE DATABASE taller_fechas;
```

Luego conéctate a esa base de datos.

---

### Paso 2: Ejecutar `database.sql` (estructura)

1. Abre el archivo **`database.sql`** en tu herramienta (pgAdmin, DBeaver, etc.)
2. Ejecuta todo el contenido del archivo (F5 en pgAdmin o Ctrl+Enter en DBeaver)
3. Esto creará la tabla `reservas` con todos sus campos y restricciones

> 💡 **Tip:** Si necesitas empezar de cero en cualquier momento, vuelve a ejecutar este archivo. El `DROP TABLE IF EXISTS` al inicio eliminará la tabla anterior.

---

### Paso 3: Ejecutar `datos_prueba.sql` (datos de prueba)

1. Abre el archivo **`datos_prueba.sql`**
2. Ejecuta todo el contenido del archivo
3. Esto insertará los 20 registros de prueba necesarios para que todas las consultas funcionen

4. Verifica que los datos se insertaron correctamente:
   ```sql
   SELECT * FROM reservas;
   ```
   Deberías ver 20 registros.

---

### Paso 4: Probar las consultas caso por caso con `consultas.sql`

1. Abre el archivo **`taller_explicado.md`** para leer la explicación de cada caso de uso
2. En paralelo, abre **`consultas.sql`** en tu herramienta SQL
3. Cada consulta está identificada con un comentario:
   ```sql
   -- ============================================================
   -- Caso de uso X: Título del caso
   -- ============================================================
   ```

4. **Flujo recomendado:**
   - Lee la explicación del caso en `taller_explicado.md`
   - Selecciona y ejecuta la consulta correspondiente en `consultas.sql`
   - Observa los resultados
   - Pasa al siguiente caso

> 💡 **Tip en pgAdmin:** Selecciona solo las líneas de la consulta que quieres ejecutar y presiona **F5** o el botón ▶ para ejecutar solo la selección.
>
> 💡 **Tip en DBeaver:** Selecciona el texto deseado y presiona **Ctrl + Enter** para ejecutar solo la selección.

---

### Paso 5: Ejecutar el Reto Integrador y el Reporte Gerencial

Estos se encuentran al final del archivo `consultas.sql`. Son consultas más complejas que combinan múltiples funciones:

- **Reto Integrador:** Una sola consulta que genera un resumen ejecutivo por tipo de habitación
- **Reporte Gerencial:** 4 secciones con CTEs, funciones de ventana y alertas operativas

> ⚠️ **Nota:** El reporte gerencial tiene 4 secciones independientes. Ejecuta cada `SELECT` por separado para ver los resultados de cada sección.

---

## ⚠️ Nota Importante: Evidencias para los UPDATE (Casos 33, 34 y 35)

Los casos de uso 33, 34 y 35 involucran sentencias `UPDATE` que **modifican datos** en la tabla. Para tomar correctamente las evidencias:

### Procedimiento para cada UPDATE:

```
1️⃣  Ejecutar el SELECT "ANTES" → Tomar captura de pantalla
2️⃣  Ejecutar el UPDATE → Verificar que dice "UPDATE X" (filas afectadas)
3️⃣  Ejecutar el SELECT "DESPUÉS" → Tomar captura de pantalla
```

### Detalle por caso:

| Caso | Qué hace el UPDATE | Qué observar en las evidencias |
|------|-------------------|-------------------------------|
| **33** | Extiende el checkout de la reserva #14 sumando 2 días | La columna `fecha_checkout` debe mostrar 2 días más en el "después" |
| **34** | Cancela reservas con más de 90 días de antigüedad | La columna `estado` debe cambiar a `'cancelada'` en el "después" |
| **35** | Incrementa la tarifa en 15% para suites | La columna `tarifa_noche` debe ser 1.15x mayor en el "después" |

> 🔴 **¡IMPORTANTE!** Los UPDATE son **irreversibles** (a menos que estés dentro de una transacción).
>
> - **Con Docker:** Ejecuta `docker compose down -v` y luego `docker compose up -d` para reiniciar todo.
> - **Sin Docker:** Ejecuta nuevamente `database.sql` y luego `datos_prueba.sql` para recrear la tabla.

> 💡 **Tip profesional:** Puedes usar transacciones para proteger tus datos:
> ```sql
> BEGIN;          -- Inicia la transacción
> -- Ejecuta el SELECT antes
> -- Ejecuta el UPDATE
> -- Ejecuta el SELECT después
> COMMIT;         -- Confirma los cambios (o ROLLBACK para deshacer)
> ```

---

## 📋 Contenido del Taller

### 35 Casos de Uso

| # | Tema | Función principal |
|---|------|-------------------|
| 1 | Fecha y hora actual del servidor | `CURRENT_TIMESTAMP` |
| 2 | Extraer año de la fecha de reserva | `EXTRACT(YEAR)` |
| 3 | Extraer mes del check-in | `EXTRACT(MONTH)` |
| 4 | Extraer día del checkout | `EXTRACT(DAY)` |
| 5 | Día de la semana de la reserva | `EXTRACT(DOW)`, `TO_CHAR` |
| 6 | Hora de la reserva | `EXTRACT(HOUR)` |
| 7 | Cantidad de noches de estadía | `::DATE`, resta de fechas |
| 8 | Reservas de un año específico | `EXTRACT(YEAR) = 2026` |
| 9 | Reservas con check-in en septiembre | `EXTRACT(MONTH) = 9` |
| 10 | Reservas de los últimos 30 días | `INTERVAL '30 days'` |
| 11 | Check-in en los próximos 7 días | `BETWEEN`, `INTERVAL` |
| 12 | Sumar 5 días al checkout | `+ INTERVAL '5 days'` |
| 13 | Restar 3 horas al check-in | `- INTERVAL '3 hours'` |
| 14 | Antigüedad de la reserva | `AGE()` |
| 15 | Estadías mayores a 5 noches | Resta de fechas + `WHERE` |
| 16 | Formato DD/MM/YYYY | `TO_CHAR(fecha, 'DD/MM/YYYY')` |
| 17 | Nombre del mes del check-in | `TO_CHAR(fecha, 'TMMonth')` |
| 18 | Nombre del día del check-in | `TO_CHAR(fecha, 'TMDay')` |
| 19 | Reservas de fin de semana | `EXTRACT(DOW) IN (0, 6)` |
| 20 | Checkout ya pasó | `< CURRENT_TIMESTAMP` |
| 21 | Check-in aún no llega | `> CURRENT_TIMESTAMP` |
| 22 | Ingreso total por reserva | Tarifa × noches |
| 23 | Truncar fecha al mes | `DATE_TRUNC('month')` |
| 24 | Horas entre reserva y check-in | `EXTRACT(EPOCH) / 3600` |
| 25 | Check-in y checkout en el mismo mes | Doble `EXTRACT` |
| 26 | Estadías de exactamente 7 días | Resta `= 7` |
| 27 | Orden por proximidad al check-in | `ABS()`, `EPOCH` |
| 28 | Promedio de noches por tipo | `AVG()`, `GROUP BY` |
| 29 | Agrupación por trimestre | `EXTRACT(QUARTER)` |
| 30 | Cancelaciones recientes | `INTERVAL '2 weeks'` |
| 31 | Conteo por estado | `COUNT()`, `GROUP BY` |
| 32 | Reserva el mismo día del check-in | `::DATE = ::DATE` |
| 33 | UPDATE: Extender checkout | `+ INTERVAL '2 days'` |
| 34 | UPDATE: Cancelar antiguas (+90 días) | `AGE() > INTERVAL` |
| 35 | UPDATE: Subir tarifa 15% a suites | `ROUND(campo * 1.15, 2)` |

### Reto Integrador
Resumen ejecutivo por tipo de habitación combinando `FILTER`, `CASE`, `EXTRACT(EPOCH)`, `TO_CHAR`, y múltiples funciones de agregación.

### Caso de Uso Avanzado (Reporte Gerencial)
Reporte completo con **CTEs**, **funciones de ventana** (`RANK`, `ROW_NUMBER`, `SUM OVER`), tendencia mensual, ocupación semanal y alertas operativas.

---

## 🛠️ Funciones PostgreSQL Cubiertas

| Categoría | Funciones |
|-----------|-----------|
| **Fecha actual** | `CURRENT_TIMESTAMP`, `NOW()` |
| **Extracción** | `EXTRACT(YEAR\|MONTH\|DAY\|HOUR\|DOW\|QUARTER\|EPOCH)` |
| **Diferencia** | `AGE()`, resta de fechas, `EPOCH` |
| **Truncamiento** | `DATE_TRUNC()` |
| **Formateo** | `TO_CHAR()` con patrones `DD`, `MM`, `YYYY`, `TMMonth`, `TMDay` |
| **Intervalos** | `INTERVAL '... days\|hours\|weeks\|months'` |
| **Casting** | `::DATE`, `::NUMERIC` |
| **Agregación** | `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`, `ROUND()` |
| **Condicionales** | `CASE WHEN`, `FILTER (WHERE ...)` |
| **Ventana** | `RANK() OVER()`, `ROW_NUMBER() OVER()`, `SUM() OVER()` |

---

## 📝 Licencia

Este proyecto es material educativo de uso libre para fines académicos.
