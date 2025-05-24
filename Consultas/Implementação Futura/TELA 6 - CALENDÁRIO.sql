DELIMITER //

CREATE PROCEDURE Buscar_Faltas_Por_Aluno(
    IN pCodAluno INT,
    IN pCodModalidade INT,
    IN p_DataFalta DATE
)
BEGIN
    SELECT 
        a.CodAluno,
        m.Nm_Modalidade AS Modalidade,
        cf.Falta,
        DAY(cf.DataFalta) AS Dia,
        MONTH(cf.DataFalta) AS Mes,
        YEAR(cf.DataFalta) AS Ano,
        cf.CodControleFalta
    FROM ControleFalta cf
    INNER JOIN InscricaoModalidade im ON cf.CodInscricaoModalidade = im.CodInscricaoModalidade
    INNER JOIN Modalidade m ON im.CodModalidade = m.CodModalidade
    INNER JOIN Aluno a ON im.CodAluno = a.CodAluno
    WHERE a.CodAluno = pCodAluno
      AND a.Status = 'A'
      AND im.Status = 'A'
      AND m.Status = 'A'
      AND cf.Falta = 'F'
      AND (pCodModalidade IS NULL OR m.CodModalidade = pCodModalidade)
      AND (p_DataFalta IS NULL OR 
           (MONTH(cf.DataFalta) = MONTH(p_DataFalta) AND YEAR(cf.DataFalta) = YEAR(p_DataFalta)));
END //

DELIMITER ;


CALL Buscar_Faltas_Por_Aluno (@pCodAluno);

-- FILTRAR TODAS 
CALL Buscar_Faltas_Por_Aluno(NULL, NULL, NULL);


-- FILTRAR COM MODALIDADE ESPECÍFICA
CALL Buscar_Faltas_Por_Aluno(1, 3, NULL);

-- FILTRAR COM MODALIDADE ESPECÍFICA
CALL Buscar_Faltas_Por_Aluno(1, NULL, '2025-04-01');



