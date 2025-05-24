CREATE OR REPLACE VIEW vw_Ficha_Completa_Aluno AS
WITH modalidadesporaluno AS (
    SELECT
        im.CodAluno,
        GROUP_CONCAT(DISTINCT 
            CONCAT(mo.Nm_Modalidade, ' (', tu.Nm_Turno, ')')
            SEPARATOR ', '
        ) AS ModalidadesTurnos
    FROM InscricaoModalidade im
    JOIN Modalidade mo ON mo.CodModalidade = im.CodModalidade AND mo.Status = 'A'
    JOIN Turno tu ON tu.CodTurno = im.CodTurno AND tu.Status = 'A'
    WHERE im.Status = 'A'
    GROUP BY im.CodAluno
),
responsaveis AS (
    SELECT
        fa.CodAluno,
        fa.Nm_Familiar,
        fa.Parentesco,
        CASE 
            WHEN fa.Dt_Nascimento IS NULL THEN 'N/E'
            ELSE CONCAT(TIMESTAMPDIFF(YEAR, fa.Dt_Nascimento, CURDATE()), ' ANOS')
        END AS Idade,
        IFNULL(es.Nm_Escolaridade, 'N/E') AS Escolaridade,
       IFNULL(oc.Nm_Ocupacao, 'N/E') AS Ocupacao,
        CASE
            WHEN ct.TelefonePrincipal IS NULL THEN 'N/E'
            ELSE CONCAT(
                '(', SUBSTRING(ct.TelefonePrincipal, 1, 2), ') ',
                SUBSTRING(ct.TelefonePrincipal, 3, 1), ' ',
                SUBSTRING(ct.TelefonePrincipal, 4, 4), '-',
                SUBSTRING(ct.TelefonePrincipal, 8, 4)
            )
        END AS Telefone,
        ct.Email,
        ROW_NUMBER() OVER (PARTITION BY fa.CodAluno ORDER BY fa.CodFamiliar) AS rn
    FROM Familiar fa
    LEFT JOIN Ocupacao oc ON fa.CodOcupacao = oc.CodOcupacao AND oc.Status = 'A'
    LEFT JOIN Escolaridade es ON fa.CodEscolaridade = es.CodEscolaridade AND es.Status = 'A'
    LEFT JOIN Contato ct ON fa.CodAluno = ct.CodAluno AND ct.Status = 'A'
    WHERE fa.Status = 'A'
)

SELECT
    al.CodAluno,
    al.Nm_Aluno AS 'Nome Completo',
    CASE 
        WHEN al.Dt_Nascimento IS NULL THEN 'N/E'
        ELSE CONCAT(TIMESTAMPDIFF(YEAR, al.Dt_Nascimento, CURDATE()), ' ANOS')
    END AS Idade,
    CASE 
        WHEN al.Sexo = 'M' THEN 'MASCULINO'
        WHEN al.Sexo = 'F' THEN 'FEMININO'
    END AS Sexo,
    CONCAT(SUBSTRING(al.RG, 1, 2), '.', SUBSTRING(al.RG, 3, 3), '.', SUBSTRING(al.RG, 6, 3)) AS RG,
    CONCAT(SUBSTRING(al.CPF, 1, 3), '.', SUBSTRING(al.CPF, 4, 3), '.', SUBSTRING(al.CPF, 7, 3), '-', SUBSTRING(al.CPF, 10, 2)) AS CPF,
    IFNULL(es.Nm_Escolaridade, 'N/E') AS Escolaridade,
    al.Nacionalidade,
    ct.ResponsavelEmergencial AS 'Responsável Emergencial',
    CONCAT(
        '(', SUBSTRING(ct.TelefoneEmergencial, 1, 2), ') ',
        SUBSTRING(ct.TelefoneEmergencial, 3, 1), ' ',
        SUBSTRING(ct.TelefoneEmergencial, 4, 4), '-',
        SUBSTRING(ct.TelefoneEmergencial, 8, 4)
    ) AS 'Telefone Emergencial',
    IFNULL(mpa.ModalidadesTurnos, 'N/A') AS 'Modalidade(s) com Turno(s)',
    en.Cidade,
    en.Bairro,
    CASE 
        WHEN en.OutroResideCom IS NOT NULL AND TRIM(en.OutroResideCom) <> ''
            THEN CONCAT(en.ResideCom, ' - ', en.OutroResideCom)
        ELSE en.ResideCom
    END AS 'Reside Com',
    en.CEP,
    en.Rua,
    en.Numero AS 'Nº',

    -- Responsável 1
    r1.Nm_Familiar AS 'Nome Responsável 1',
    r1.Parentesco AS 'Parentesco Responsável 1',
    r1.Idade AS 'Idade Responsável 1',
    r1.Escolaridade AS 'Escolaridade Responsável 1',
    r1.Ocupacao AS 'Ocupação Responsável 1',
    r1.Telefone AS 'Telefone Responsável 1',
    r1.Email AS 'Email Responsável 1',

    -- Responsável 2
    r2.Nm_Familiar AS 'Nome Responsável 2',
    r2.Parentesco AS 'Parentesco Responsável 2',
    r2.Idade AS 'Idade Responsável 2',
    r2.Escolaridade AS 'Escolaridade Responsável 2',
    r2.Ocupacao AS 'Ocupação Responsável 2',
    r2.Telefone AS 'Telefone Responsável 2',
    r2.Email AS 'Email Responsável 2',

    -- Informações de Saúde
    COALESCE((
        SELECT GROUP_CONCAT(DISTINCT sa1.DescricaoAlergia SEPARATOR ', ')
        FROM Saude sa1
        WHERE sa1.CodAluno = al.CodAluno
          AND sa1.DescricaoAlergia IS NOT NULL
          AND TRIM(sa1.DescricaoAlergia) <> ''
          AND sa1.Status = 'A'
    ), 'N/E') AS 'Possui Alergia?',

    COALESCE((
        SELECT GROUP_CONCAT(DISTINCT sa2.DescricaoMedicacao SEPARATOR ', ')
        FROM Saude sa2
        WHERE sa2.CodAluno = al.CodAluno
          AND sa2.DescricaoMedicacao IS NOT NULL
          AND TRIM(sa2.DescricaoMedicacao) <> ''
          AND sa2.Status = 'A'
    ), 'N/E') AS 'Toma alguma medicação?',

    COALESCE((
        SELECT GROUP_CONCAT(DISTINCT sa3.DescricaoProblemaSaude SEPARATOR ', ')
        FROM Saude sa3
        WHERE sa3.CodAluno = al.CodAluno
          AND sa3.DescricaoProblemaSaude IS NOT NULL
          AND TRIM(sa3.DescricaoProblemaSaude) <> ''
          AND sa3.Status = 'A'
    ), 'N/E') AS 'Tem algum problema de saúde?',

    COALESCE((
        SELECT GROUP_CONCAT(DISTINCT sa4.TipoDeficienca SEPARATOR ', ')
        FROM Saude sa4
        WHERE sa4.CodAluno = al.CodAluno
          AND sa4.TipoDeficienca IS NOT NULL
          AND TRIM(sa4.TipoDeficienca) <> ''
          AND sa4.Status = 'A'
    ), 'N/E') AS 'Possui alguma deficiência?'

FROM Aluno al
LEFT JOIN Escolaridade es ON es.CodEscolaridade = al.CodEscolaridade AND es.Status = 'A'
LEFT JOIN Contato ct ON ct.CodAluno = al.CodAluno AND ct.Status = 'A'
LEFT JOIN Endereco en ON en.CodAluno = al.CodAluno AND en.Status = 'A'
LEFT JOIN modalidadesporaluno mpa ON mpa.CodAluno = al.CodAluno
LEFT JOIN responsaveis r1 ON r1.CodAluno = al.CodAluno AND r1.rn = 1
LEFT JOIN responsaveis r2 ON r2.CodAluno = al.CodAluno AND r2.rn = 2
WHERE al.Status = 'A';

-- Procedure para buscar ficha por código do aluno
DELIMITER //

CREATE PROCEDURE sp_Buscar_Ficha_Aluno (
    IN p_CodAluno INT
)
BEGIN
    SELECT *
    FROM vw_Ficha_Completa_Aluno
    WHERE CodAluno = p_CodAluno;
END //

DELIMITER ;

CALL sp_Buscar_Ficha_Aluno(@p_CodAluno);

-- Exemplo de chamada da procedure
CALL sp_Buscar_Ficha_Aluno(1);
