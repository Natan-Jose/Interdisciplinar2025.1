/* Centraliza os valores válidos de parentesco utilizados em diferentes tabelas 
(Endereco e Familiar), evitando a repetição manual dessas listas em múltiplas constraints (CHECK).
*/
-- 1. Criar a função que centraliza os valores válidos de parentesco
DELIMITER //
CREATE FUNCTION fn_get_parentescos_validos() 
RETURNS VARCHAR(300) DETERMINISTIC
BEGIN
    RETURN "'PAI', 'MÃE', 'AVÔ', 'AVÓ', 'TIO', 'TIA', 'IRMÃO', 'IRMÃ', " 
           "'PADRASTO', 'MADRASTA', 'GUARDIÃO LEGAL', 'RESPONSÁVEL LEGAL', 'TUTOR', 'CUIDADOR'";
END//
DELIMITER ;

-- 2. Capturar os valores válidos da função
SET @parentescos = (SELECT fn_get_parentescos_validos());

-- 3. Adicionar as constraints na tabela Endereco
SET @sql_add_endereco = CONCAT(
    'ALTER TABLE Endereco ',
    'ADD CONSTRAINT chk_residecom CHECK (UPPER(ResideCom) IN (', @parentescos, ')), ',  -- Converte para maiúsculo
    'ADD CONSTRAINT chk_outroresidecom CHECK (OutroResideCom IS NULL OR UPPER(OutroResideCom) IN (', @parentescos, ')), ',  -- Converte para maiúsculo
    'ADD CONSTRAINT chk_residecom_diferente CHECK (UPPER(ResideCom) <> UPPER(OutroResideCom) OR OutroResideCom IS NULL)'  -- Converte para maiúsculo
);

PREPARE stmt_endereco FROM @sql_add_endereco;
EXECUTE stmt_endereco;
DEALLOCATE PREPARE stmt_endereco;

-- 4. Adicionar a constraint na tabela Familiar
SET @sql_add_familiar = CONCAT(
    'ALTER TABLE Familiar ',
    'ADD CONSTRAINT chk_parentesco_familiar CHECK (UPPER(Parentesco) IN (', @parentescos, '))'  -- Converte para maiúsculo
);

PREPARE stmt_familiar FROM @sql_add_familiar;
EXECUTE stmt_familiar;
DEALLOCATE PREPARE stmt_familiar;
DELIMITER //

DELIMITER //
CREATE FUNCTION fn_calcula_idade(dt_nascimento DATE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE idade VARCHAR(10);

    IF dt_nascimento IS NULL THEN
        SET idade = 'N/E';
    ELSE
        SET idade = CONCAT(TIMESTAMPDIFF(YEAR, dt_nascimento, CURDATE()), ' ANOS');
    END IF;

    RETURN idade;
END;
//
DELIMITER ;

