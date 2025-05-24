DELIMITER //

CREATE PROCEDURE sp_InserirFaltasPorModalidadeDia(
    IN p_dia_semana VARCHAR(10),
    IN p_modalidade INT
)
BEGIN
    INSERT INTO ControleFalta (Falta, DataFalta, CodInscricaoModalidade, Status)
    SELECT 
        'P',
        CURDATE() + INTERVAL 1 DAY,
        I.CodInscricaoModalidade,
        'A'
    FROM InscricaoModalidade I
    JOIN Aluno A ON A.CodAluno = I.CodAluno
    WHERE 
        I.CodModalidade = p_modalidade
        AND I.Status = 'A'
        AND A.Status = 'A';
END //

DELIMITER ;

CREATE EVENT IF NOT EXISTS EventoFaltas_Segunda
ON SCHEDULE EVERY 1 WEEK
STARTS (TIMESTAMP(CURRENT_DATE + INTERVAL ((1 - DAYOFWEEK(CURRENT_DATE) + 7) % 7) DAY)) -- Domingo 00:00
ENABLE
DO
CALL sp_InserirFaltasPorModalidadeDia('Segunda', 1); -- Reforço

DELIMITER //

CREATE EVENT IF NOT EXISTS EventoFaltas_Terca
ON SCHEDULE EVERY 1 WEEK
STARTS (TIMESTAMP(CURRENT_DATE + INTERVAL ((2 - DAYOFWEEK(CURRENT_DATE) + 7) % 7) DAY)) -- Segunda 00:00
ENABLE
DO
BEGIN
    CALL sp_InserirFaltasPorModalidadeDia('Terça', 1); -- Reforço
    CALL sp_InserirFaltasPorModalidadeDia('Terça', 5); -- Judô
END //

DELIMITER ;

DELIMITER //

CREATE EVENT IF NOT EXISTS EventoFaltas_Sexta
ON SCHEDULE EVERY 1 WEEK
STARTS (TIMESTAMP(CURRENT_DATE + INTERVAL ((5 - DAYOFWEEK(CURRENT_DATE) + 7) % 7) DAY)) -- Quinta 00:00
ENABLE
DO
BEGIN
    CALL sp_InserirFaltasPorModalidadeDia('Sexta', 4); -- Ballet
    CALL sp_InserirFaltasPorModalidadeDia('Sexta', 5); -- Judô
END //

DELIMITER ;

CREATE EVENT IF NOT EXISTS EventoFaltas_Sabado
ON SCHEDULE EVERY 1 WEEK
STARTS (TIMESTAMP(CURRENT_DATE + INTERVAL ((6 - DAYOFWEEK(CURRENT_DATE) + 7) % 7) DAY)) -- Sexta 00:00
ENABLE
DO
CALL sp_InserirFaltasPorModalidadeDia('Sábado', 4); -- Ballet

-- TESTE
CALL sp_InserirFaltasPorModalidadeDia('Segunda', 5);

DELIMITER //

SHOW EVENTS;

SET GLOBAL event_scheduler = ON;

SHOW VARIABLES LIKE 'event_scheduler';