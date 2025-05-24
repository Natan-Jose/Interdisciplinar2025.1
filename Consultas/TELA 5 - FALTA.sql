DELIMITER //

CREATE PROCEDURE sp_Trocar_Presenca_Falta (
    IN p_CodInscricaoModalidade INT,
    IN p_DataFalta DATE,
    IN p_NovoValorFalta CHAR(1)
)
BEGIN
    -- Só atualiza se os parâmetros forem preenchidos
    IF p_CodInscricaoModalidade IS NOT NULL 
       AND p_DataFalta IS NOT NULL 
       AND p_NovoValorFalta IS NOT NULL THEN

        -- Verifica se a inscrição está ativa
        IF EXISTS (
            SELECT 1
            FROM InscricaoModalidade
            WHERE CodInscricaoModalidade = p_CodInscricaoModalidade
              AND Status = 'A'
        ) THEN
            -- Atualiza o valor da falta apenas se a inscrição estiver ativa
            UPDATE ControleFalta
            SET Falta = p_NovoValorFalta
            WHERE CodInscricaoModalidade = p_CodInscricaoModalidade
              AND DataFalta = p_DataFalta
            LIMIT 1;
        END IF;

    END IF;
END //

DELIMITER ;


-- Chamar a procedure para atualizar a falta de 'P' para 'F'
CALL sp_Trocar_Presenca_Falta(1, '2025-04-21', 'F');
