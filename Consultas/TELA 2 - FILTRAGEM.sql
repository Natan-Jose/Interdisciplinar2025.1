CREATE OR REPLACE VIEW vw_Alunos_Por_Modalidade AS
SELECT 
    a.CodAluno,
    a.Nm_Aluno,
    a.Status AS StatusAluno,
    m.CodModalidade,
    m.Status AS StatusModalidade
FROM Aluno a
JOIN InscricaoModalidade im ON a.CodAluno = im.CodAluno
JOIN Modalidade m ON im.CodModalidade = m.CodModalidade
WHERE 
    a.Status = 'A' 
    AND m.Status = 'A'
    AND im.Status = 'A';

DELIMITER //

CREATE PROCEDURE sp_Filtrar_Alunos_Por_Modalidade (
    IN p_Nm_Aluno VARCHAR(150),
    IN p_CodModalidade INT
)
BEGIN
    IF p_Nm_Aluno IS NULL AND p_CodModalidade IS NULL THEN
        -- Se ambos os parâmetros forem NULL, retorna todos os alunos
        SELECT CodAluno, Nm_Aluno
        FROM Aluno
		WHERE Status = 'A';
    ELSE
        -- Caso contrário, filtra pela modalidade ou nome
        SELECT CodAluno, Nm_Aluno, MAX(CodModalidade) AS CodModalidade
        FROM vw_Alunos_Por_Modalidade
        WHERE 
            (p_Nm_Aluno IS NULL OR Nm_Aluno LIKE CONCAT('%', p_Nm_Aluno, '%'))
            AND (p_CodModalidade IS NULL OR CodModalidade = p_CodModalidade)
        GROUP BY CodAluno, Nm_Aluno;
    END IF;
END //

DELIMITER ;

CALL sp_Filtrar_Alunos_Por_Modalidade(p_Nm_Aluno, p_CodModalidade);

-- RETORNA TODOS
CALL sp_Filtrar_Alunos_Por_Modalidade(NULL, NULL);

-- APENAS POR NOME
CALL sp_Filtrar_Alunos_Por_Modalidade('ANA', NULL);

-- PELA MODALIDADE
CALL sp_Filtrar_Alunos_Por_Modalidade(NULL, 2);


