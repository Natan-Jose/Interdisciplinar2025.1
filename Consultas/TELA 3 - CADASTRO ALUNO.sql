DELIMITER //

CREATE PROCEDURE sp_Cadastro_Aluno(
    -- Dados do Aluno
    IN p_Nm_Aluno VARCHAR(150),
    IN p_Dt_Nascimento DATE,
    IN p_Sexo CHAR(1),
    IN p_CPF VARCHAR(14),
    IN p_RG VARCHAR(10),
    IN p_Nacionalidade ENUM('BRASILEIRO', 'ESTRANGEIRO'),
    IN p_CodEscolaridade INT UNSIGNED,

    -- Dados do Usuário (já existente)
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
    DECLARE new_CodAluno INT UNSIGNED;

    -- Handler que faz rollback e propaga o erro real
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- *** Inserir Dados do Aluno ***
    INSERT INTO Aluno (
        Nm_Aluno, Dt_Nascimento, Sexo, CPF, RG, Nacionalidade, 
        CodEscolaridade, CodUsuario, Status
    ) 
    VALUES (
        p_Nm_Aluno, p_Dt_Nascimento, p_Sexo, p_CPF, p_RG, p_Nacionalidade,
        p_CodEscolaridade, p_CodUsuario, 'A'
    );

    SET new_CodAluno = LAST_INSERT_ID();

    -- *** Inserir Endereço ***
    INSERT INTO Endereco (
        CEP, Rua, Bairro, Cidade, Numero, ResideCom, OutroResideCom, CodAluno, Status
    )
    VALUES (
        p_CEP, p_Rua, p_Bairro, p_Cidade, p_Numero, p_ResideCom, p_OutroResideCom, new_CodAluno, 'A'
    );

    -- *** Inserir Contato ***
    INSERT INTO Contato (
        ResponsavelEmergencial, TelefonePrincipal, TelefoneEmergencial, Email, CodAluno, Status
    )
    VALUES (
        p_ResponsavelEmergencial, p_TelefonePrincipal, p_TelefoneEmergencial, p_Email, new_CodAluno, 'A'
    );

    -- *** Inserir Saúde ***
    INSERT INTO Saude (
        DescricaoAlergia, DescricaoMedicacao, DescricaoProblemaSaude, TipoDeficienca, CodAluno, Status
    )
    VALUES (
        p_DescricaoAlergia, p_DescricaoMedicacao, p_DescricaoProblemaSaude, p_TipoDeficienca, new_CodAluno, 'A'
    );

    -- *** Inserir Familiar ***
    INSERT INTO Familiar (
        Nm_Familiar, Dt_Nascimento, Parentesco, CodEscolaridade, CodOcupacao, CodAluno, Status
    )
    VALUES (
        p_Nm_Familiar, p_Dt_Nascimento_Familiar, p_Parentesco,
        p_CodEscolaridade_Familiar, p_CodOcupacao_Familiar, new_CodAluno, 'A'
    );

    -- *** Inserir Inscrição Modalidade ***
    INSERT INTO InscricaoModalidade (
        CodAluno, CodModalidade, CodTurno, Status
    )
    VALUES (
        new_CodAluno, p_CodModalidade, p_CodTurno, 'A'
    );

    COMMIT;
END //

DELIMITER ;

CALL sp_Cadastro_Aluno(
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


CALL sp_Cadastro_Aluno(
    -- Aluno
    'João Silva',              -- Nome do aluno
    '2000-05-15',              -- Data de nascimento
    'M',                       -- Sexo
    '12345678900',             -- CPF (sem pontuação, para evitar problema de formatação)
    'MG1234567',               -- RG
    'BRASILEIRO',              -- Nacionalidade
    1,                         -- CodEscolaridade do aluno
    1,                         -- CodUsuario

    -- Endereço
    '12345-678',               -- CEP
    'Rua Exemplo',             -- Rua
    'Centro',                  -- Bairro
    'Cidade Exemplo',          -- Cidade
    123,                       -- Número
    'Pai',               -- Reside com
    NULL,                      -- OutroResideCom

    -- Contato
    'Carlos da Silva',         -- Responsável Emergencial
    '21999999999',             -- Telefone Principal (somente números)
    '21988888888',             -- Telefone Emergencial
    'email@exemplo.com',       -- Email

    -- Saúde
    NULL,                      -- Alergia
    NULL,                      -- Medicação
    NULL,                      -- Problema de saúde
    NULL,                      -- Deficiência

    -- Familiar
    'Maria Silva',             -- Nome do familiar
    '1975-02-20',              -- Data de nascimento
    'Mãe',                     -- Parentesco (***não pode ser NULL***)
    2,                         -- CodEscolaridade do familiar
    NULL,                      -- CodOcupacao (pode ser NULL)

    -- Inscrição
    3,                         -- CodModalidade
    2                          -- CodTurno
);

