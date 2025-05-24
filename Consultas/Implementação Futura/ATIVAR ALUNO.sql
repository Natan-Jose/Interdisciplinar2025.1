DELIMITER //

CREATE PROCEDURE sp_ativar_Aluno (
    IN p_CodAluno INT,
    IN p_CPF VARCHAR(14),
    IN p_RG VARCHAR(10)
)
BEGIN
    DECLARE v_CodAluno INT;

    -- Prioriza CodAluno se informado, senão busca pelo CPF ou RG
    IF p_CodAluno IS NOT NULL THEN
        SET v_CodAluno = p_CodAluno;
    ELSE
        SELECT CodAluno INTO v_CodAluno
        FROM Aluno
        WHERE (CPF = p_CPF OR RG = p_RG)
        LIMIT 1;
    END IF;

    -- Se encontrou o aluno, faz a reativação
    IF v_CodAluno IS NOT NULL THEN

        -- Reativa o aluno
        UPDATE Aluno
        SET Status = 'A'
        WHERE CodAluno = v_CodAluno;

        -- Reativa endereço
        UPDATE Endereco
        SET Status = 'A'
        WHERE CodAluno = v_CodAluno;

        -- Reativa contatos
        UPDATE Contato
        SET Status = 'A'
        WHERE CodAluno = v_CodAluno;

        -- Reativa saúde
        UPDATE Saude
        SET Status = 'A'
        WHERE CodAluno = v_CodAluno;

        -- Reativa familiares
        UPDATE Familiar
        SET Status = 'A'
        WHERE CodAluno = v_CodAluno;

        -- Reativa inscrições
        UPDATE InscricaoModalidade
        SET Status = 'A'
        WHERE CodAluno = v_CodAluno;

        -- Reativa faltas relacionadas às inscrições
        UPDATE ControleFalta
        SET Status = 'A'
        WHERE CodInscricaoModalidade IN (
            SELECT CodInscricaoModalidade
            FROM InscricaoModalidade
            WHERE CodAluno = v_CodAluno
        );

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Aluno não encontrado pelo CodAluno, CPF ou RG informado.';
    END IF;
END //

DELIMITER ;


CALL sp_ativar_Aluno(@p_CodAluno, @p_CPF, @p_RG);

-- Reativar por CodAluno
CALL sp_ativar_Aluno(1, NULL, NULL);

-- Reativar por CPF
CALL sp_ativar_Aluno(NULL, '123.456.789-00', NULL);

-- Reativar por RG
CALL sp_ativar_Aluno(NULL, NULL, '123456789');
