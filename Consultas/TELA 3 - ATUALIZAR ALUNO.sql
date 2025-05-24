DELIMITER //

CREATE PROCEDURE sp_Atualiza_Aluno(
    -- Dados do Aluno
    IN p_CodAluno INT UNSIGNED,
    IN p_Nm_Aluno VARCHAR(150),
    IN p_Dt_Nascimento DATE,
    IN p_Sexo CHAR(1),
    IN p_CPF VARCHAR(14),
    IN p_RG VARCHAR(10),
    IN p_Nacionalidade ENUM('BRASILEIRO', 'ESTRANGEIRO'),
    IN p_CodEscolaridade INT UNSIGNED,

    -- Dados de Usuário (já existente)
    IN p_CodUsuario INT UNSIGNED,

    -- Dados de Endereço
    IN p_CEP VARCHAR(10),
    IN p_Rua VARCHAR(60),
    IN p_Bairro VARCHAR(100),
    IN p_Cidade VARCHAR(70),
    IN p_Numero SMALLINT,
    IN p_ResideCom VARCHAR(40),
    IN p_OutroResideCom VARCHAR(40),

    -- Dados de Contato
    IN p_ResponsavelEmergencial VARCHAR(80),
    IN p_TelefonePrincipal VARCHAR(17),
    IN p_TelefoneEmergencial VARCHAR(17),
    IN p_Email VARCHAR(150),

    -- Dados de Saúde
    IN p_DescricaoAlergia TINYTEXT,
    IN p_DescricaoMedicacao TINYTEXT,
    IN p_DescricaoProblemaSaude TINYTEXT,
    IN p_TipoDeficienca TINYTEXT,

    -- Dados do Familiar
    IN p_Nm_Familiar VARCHAR(150),
    IN p_Dt_Nascimento_Familiar DATE,
    IN p_Parentesco VARCHAR(40),
    IN p_CodEscolaridade_Familiar INT UNSIGNED,
    IN p_CodOcupacao_Familiar INT UNSIGNED,

    -- Dados de Inscrição
    IN p_CodModalidade INT UNSIGNED,
    IN p_CodTurno INT UNSIGNED
)
BEGIN
    -- Handler que faz rollback e propaga o erro real
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- *** Atualizar Dados do Aluno ***
    UPDATE Aluno
    SET 
        Nm_Aluno = p_Nm_Aluno,
        Dt_Nascimento = p_Dt_Nascimento,
        Sexo = p_Sexo,
        CPF = p_CPF,
        RG = p_RG,
        Nacionalidade = p_Nacionalidade,
        CodEscolaridade = p_CodEscolaridade,
        CodUsuario = p_CodUsuario
    WHERE CodAluno = p_CodAluno;

    -- *** Atualizar Endereço ***
    UPDATE Endereco
    SET 
        CEP = p_CEP,
        Rua = p_Rua,
        Bairro = p_Bairro,
        Cidade = p_Cidade,
        Numero = p_Numero,
        ResideCom = p_ResideCom,
        OutroResideCom = p_OutroResideCom
    WHERE CodAluno = p_CodAluno;

    -- *** Atualizar Contato ***
    UPDATE Contato
    SET 
        ResponsavelEmergencial = p_ResponsavelEmergencial,
        TelefonePrincipal = p_TelefonePrincipal,
        TelefoneEmergencial = p_TelefoneEmergencial,
        Email = p_Email
    WHERE CodAluno = p_CodAluno;

    -- *** Atualizar Saúde ***
    UPDATE Saude
    SET 
        DescricaoAlergia = p_DescricaoAlergia,
        DescricaoMedicacao = p_DescricaoMedicacao,
        DescricaoProblemaSaude = p_DescricaoProblemaSaude,
        TipoDeficienca = p_TipoDeficienca
    WHERE CodAluno = p_CodAluno;

    -- *** Atualizar Familiar ***
    UPDATE Familiar
    SET 
        Nm_Familiar = p_Nm_Familiar,
        Dt_Nascimento = p_Dt_Nascimento_Familiar,
        Parentesco = p_Parentesco,
        CodEscolaridade = p_CodEscolaridade_Familiar,
        CodOcupacao = p_CodOcupacao_Familiar
    WHERE CodAluno = p_CodAluno;

    -- *** Atualizar Inscrição Modalidade ***
    UPDATE InscricaoModalidade
    SET 
        CodModalidade = p_CodModalidade,
        CodTurno = p_CodTurno
    WHERE CodAluno = p_CodAluno;

    COMMIT;
END //

DELIMITER ;

CALL sp_Atualiza_Aluno(
    @p_CodAluno, 
    @p_Nm_Aluno,
    @p_Dt_Nascimento,
    @p_Sexo,
    @p_CPF,
    @p_RG,
    @p_Nacionalidade,
    @p_CodEscolaridade,
    @p_CodUsuario,

    @p_CEP,
    @p_Rua,
    @p_Bairro,
    @p_Cidade,
    @p_Numero,
    @p_ResideCom,
    @p_OutroResideCom,

    @p_ResponsavelEmergencial,
    @p_TelefonePrincipal,
    @p_TelefoneEmergencial,
    @p_Email,

    @p_DescricaoAlergia,
    @p_DescricaoMedicacao,
    @p_DescricaoProblemaSaude,
    @p_TipoDeficienca,

    @p_Nm_Familiar,
    @p_Dt_Nascimento_Familiar,
    @p_Parentesco,
    @p_CodEscolaridade_Familiar,
    @p_CodOcupacao_Familiar,

    @p_CodModalidade,
    @p_CodTurno
);

-- Chamada ao procedimento de atualização
CALL sp_Atualiza_Aluno(
    1, -- CodAluno (o aluno que você quer atualizar)

    -- Dados do Aluno
    'AAAAADASDSADSADSADSADAS', -- p_Nm_Aluno
    '2005-05-10', -- p_Dt_Nascimento
    'M', -- p_Sexo
    '123.456.789-00', -- p_CPF
    'MG1235567', -- p_RG
    'ESTRANGEIRO', -- p_Nacionalidade
    3, -- p_CodEscolaridade (exemplo de código de escolaridade)

    -- Dados do Usuário (já existente)
    2, -- p_CodUsuario (exemplo de código de usuário)

    -- Dados de Endereço
    '12345-678', -- p_CEP
    'Rua das Flores', -- p_Rua
    'Bairro Jardim', -- p_Bairro
    'Cidade X', -- p_Cidade
    101, -- p_Numero
    'Pai', -- p_ResideCom
    'Avó', -- p_OutroResideCom

    -- Dados de Contato
    'Carlos Silva', -- p_ResponsavelEmergencial
    '(31) 98765-4321', -- p_TelefonePrincipal
    '(31) 99999-8888', -- p_TelefoneEmergencial
    'joao.silva@email.com', -- p_Email

    -- Dados de Saúde
    'Alergia a pólen', -- p_DescricaoAlergia
    'Medicamento XYZ', -- p_DescricaoMedicacao
    'Nenhum', -- p_DescricaoProblemaSaude
    'Nenhuma', -- p_TipoDeficienca

    -- Dados do Familiar
    'Maria Silva', -- p_Nm_Familiar
    '1980-10-15', -- p_Dt_Nascimento_Familiar
    'Mãe', -- p_Parentesco
    1, -- p_CodEscolaridade_Familiar (exemplo de código de escolaridade para familiar)
    5, -- p_CodOcupacao_Familiar (exemplo de código de ocupação para familiar)

    -- Dados de Inscrição
    2, -- p_CodModalidade (exemplo de código de modalidade)
    1  -- p_CodTurno (exemplo de código de turno)
);
