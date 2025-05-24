CREATE OR REPLACE VIEW vw_Lista_Presencas AS
SELECT
    a.CodAluno AS CodAluno,
    a.Nm_Aluno AS NomeAluno,
    cf.Falta AS Presenca,
    m.CodModalidade,
    im.CodTurno,  
    cf.DataFalta AS DataFalta,  
    cf.CodInscricaoModalidade
FROM ControleFalta cf
JOIN InscricaoModalidade im ON cf.CodInscricaoModalidade = im.CodInscricaoModalidade
JOIN Aluno a ON im.CodAluno = a.CodAluno
JOIN Modalidade m ON im.CodModalidade = m.CodModalidade
JOIN Turno t ON im.CodTurno = t.CodTurno
WHERE
	a.Status = 'A'
    AND m.Status = 'A'
    AND t.Status = 'A'
	AND im.Status = 'A'
ORDER BY 
    FIELD(m.CodModalidade, 1, 2, 3, 4, 5),
    a.Nm_Aluno,
    im.CodTurno;

DELIMITER //

CREATE PROCEDURE sp_Controle_Presenca (
    IN p_CodModalidade INT,
    IN p_CodTurno INT,
    IN p_Data DATE
)
BEGIN
    SELECT * 
    FROM vw_Lista_Presencas
    WHERE 
        (p_CodModalidade IS NULL OR CodModalidade = p_CodModalidade)
        AND (p_CodTurno IS NULL OR CodTurno = p_CodTurno)
        AND (p_Data IS NULL OR DataFalta = p_Data);  
END //

DELIMITER ;


CALL sp_Controle_Presenca(@p_CodModalidade, @p_CodTurno, @ p_Data);

-- FILTRAR TODOS
CALL sp_Controle_Presenca(NULL, NULL, '2025-04-30');

-- FILTRAR DE ACORDO COM A MODALIDADE, TURNO E DATA ATUAL
CALL sp_Controle_Presenca(NULL, NULL, NULL);

-- TESTE PARA VISUALIZARA DO DIA SEGUINTE
CALL ssp_Controle_Presenca(NULL, 3, CURDATE() + INTERVAL 1 DAY);

SELECT DISTINCT DataFalta FROM ControleFalta;
