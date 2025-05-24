DELIMITER //

CREATE PROCEDURE sp_Inativar_Aluno (
    IN p_CodAluno INT
)
BEGIN
    -- Verifica se o CodAluno foi informado
    IF p_CodAluno IS NOT NULL THEN

        -- Inativa inscrições do aluno
        UPDATE InscricaoModalidade
        SET Status = 'I'
        WHERE CodAluno = p_CodAluno;

        -- Inativa registros de falta ligados às inscrições do aluno
        UPDATE ControleFalta
        SET Status = 'I'
        WHERE CodInscricaoModalidade IN (
            SELECT CodInscricaoModalidade
            FROM InscricaoModalidade
            WHERE CodAluno = p_CodAluno
        );

        -- Inativa endereço
        UPDATE Endereco
        SET Status = 'I'
        WHERE CodAluno = p_CodAluno;

        -- Inativa contatos
        UPDATE Contato
        SET Status = 'I'
        WHERE CodAluno = p_CodAluno;

        -- Inativa saúde
        UPDATE Saude
        SET Status = 'I'
        WHERE CodAluno = p_CodAluno;

        -- Inativa familiares
        UPDATE Familiar
        SET Status = 'I'
        WHERE CodAluno = p_CodAluno;

        -- Inativa o próprio aluno
        UPDATE Aluno
        SET Status = 'I'
        WHERE CodAluno = p_CodAluno;
    END IF;
END //

DELIMITER ;

CALL sp_Inativar_Aluno(@p_CodAluno);
CALL sp_Inativar_Aluno(5);


