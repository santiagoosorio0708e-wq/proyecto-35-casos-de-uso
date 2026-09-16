-- ============================================================
-- TALLER PRÁCTICO: FECHAS E INTERVALOS EN POSTGRESQL
-- Archivo 2 de 3: Datos de Prueba (DML)
-- ============================================================
-- Ejecutar este archivo DESPUÉS de database.sql
-- Inserta 20 registros de prueba en la tabla "reservas".
-- ============================================================

INSERT INTO reservas (nombre_cliente, tipo_habitacion, numero_habitacion, fecha_reserva, fecha_checkin, fecha_checkout, tarifa_noche, estado)
VALUES
-- Reservas antiguas (más de 90 días)
('Carlos Méndez',     'individual', 101, '2026-03-10 09:30:00', '2026-03-15 14:00:00', '2026-03-18 12:00:00', 85.00,  'completada'),
('María López',       'doble',      202, '2026-04-05 11:00:00', '2026-04-10 15:00:00', '2026-04-17 11:00:00', 120.00, 'completada'),
('Andrés Gómez',      'suite',      301, '2026-04-20 16:45:00', '2026-04-25 14:00:00', '2026-05-02 12:00:00', 250.00, 'completada'),
('Lucía Fernández',   'individual', 102, '2026-05-01 08:00:00', '2026-05-01 14:00:00', '2026-05-03 12:00:00', 85.00,  'cancelada'),

-- Reservas de meses intermedios
('Pedro Ramírez',     'doble',      203, '2026-06-10 10:15:00', '2026-06-15 15:00:00', '2026-06-22 11:00:00', 130.00, 'completada'),
('Sofía Torres',      'suite',      302, '2026-06-20 14:30:00', '2026-06-25 14:00:00', '2026-07-02 12:00:00', 260.00, 'completada'),
('Diego Herrera',     'individual', 103, '2026-07-04 09:00:00', '2026-07-05 14:00:00', '2026-07-06 12:00:00', 90.00,  'cancelada'),
('Valentina Ruiz',    'doble',      204, '2026-07-15 17:20:00', '2026-07-20 15:00:00', '2026-07-27 11:00:00', 125.00, 'completada'),

-- Reservas recientes (últimos 30 días aprox.)
('Javier Morales',    'suite',      303, '2026-08-20 12:00:00', '2026-08-25 14:00:00', '2026-09-01 12:00:00', 270.00, 'completada'),
('Camila Ortega',     'individual', 104, '2026-08-28 10:00:00', '2026-09-01 14:00:00', '2026-09-04 12:00:00', 95.00,  'confirmada'),
('Roberto Díaz',      'doble',      205, '2026-09-01 09:30:00', '2026-09-05 15:00:00', '2026-09-12 11:00:00', 135.00, 'confirmada'),
('Ana Castillo',      'suite',      304, '2026-09-05 15:45:00', '2026-09-10 14:00:00', '2026-09-15 12:00:00', 280.00, 'completada'),

-- Reservas actuales y futuras
('Fernando Silva',    'individual', 105, '2026-09-10 08:30:00', '2026-09-14 14:00:00', '2026-09-17 12:00:00', 90.00,  'confirmada'),
('Paula Vargas',      'doble',      206, '2026-09-12 11:00:00', '2026-09-16 15:00:00', '2026-09-21 11:00:00', 140.00, 'pendiente'),
('Gabriel Navarro',   'suite',      305, '2026-09-13 14:00:00', '2026-09-18 14:00:00', '2026-09-25 12:00:00', 290.00, 'confirmada'),

-- Reservas futuras
('Laura Peña',        'individual', 106, '2026-09-14 16:00:00', '2026-09-20 14:00:00', '2026-09-22 12:00:00', 88.00,  'pendiente'),
('Miguel Ángel Ríos', 'doble',      207, '2026-09-15 07:45:00', '2026-09-22 15:00:00', '2026-09-29 11:00:00', 132.00, 'pendiente'),
('Isabella Fuentes',  'suite',      306, '2026-09-15 10:00:00', '2026-09-28 14:00:00', '2026-10-05 12:00:00', 275.00, 'pendiente'),

-- Reserva de fin de semana (sábado)
('Tomás Acosta',      'doble',      208, '2026-09-12 20:30:00', '2026-09-19 15:00:00', '2026-09-21 11:00:00', 145.00, 'pendiente'),

-- Reserva cancelada reciente
('Elena Montoya',     'individual', 107, '2026-09-08 13:00:00', '2026-09-12 14:00:00', '2026-09-14 12:00:00', 92.00,  'cancelada');
