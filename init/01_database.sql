-- ============================================================
-- SCRIPT DE INICIALIZACIÓN 1 de 2: Estructura (DDL)
-- ============================================================

DROP TABLE IF EXISTS reservas;

CREATE TABLE reservas (
    id_reserva      SERIAL       PRIMARY KEY,
    nombre_cliente  VARCHAR(100) NOT NULL,
    tipo_habitacion VARCHAR(20)  NOT NULL CHECK (tipo_habitacion IN ('individual', 'doble', 'suite')),
    numero_habitacion INT        NOT NULL,
    fecha_reserva   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_checkin   TIMESTAMP    NOT NULL,
    fecha_checkout  TIMESTAMP    NOT NULL,
    tarifa_noche    NUMERIC(10,2) NOT NULL,
    estado          VARCHAR(20)  NOT NULL DEFAULT 'pendiente'
                    CHECK (estado IN ('pendiente', 'confirmada', 'cancelada', 'completada')),
    CONSTRAINT chk_fechas CHECK (fecha_checkout > fecha_checkin)
);
