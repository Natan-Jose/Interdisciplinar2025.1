CREATE DATABASE ONG;

USE ONG;

CREATE TABLE Escolaridade (
    CodEscolaridade INT UNSIGNED AUTO_INCREMENT,
    Nm_Escolaridade VARCHAR(100) NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodEscolaridade)
);

CREATE TABLE Endereco (
    CodEndereco INT UNSIGNED AUTO_INCREMENT,
    CEP VARCHAR(10) DEFAULT NULL,
    Rua VARCHAR(60) NOT NULL,
    Bairro VARCHAR(100) NOT NULL,
    Cidade VARCHAR(70) NOT NULL,
    Numero SMALLINT DEFAULT NULL,
    ResideCom VARCHAR(40) NOT NULL,
    OutroResideCom VARCHAR(40) DEFAULT NULL,
	CodAluno INT UNSIGNED NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodEndereco)
);
	
	CREATE TABLE Ocupacao (
	CodOcupacao INT UNSIGNED AUTO_INCREMENT,
    Nm_Ocupacao VARCHAR(100) NOT NULL,
	Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodOcupacao)
);

CREATE TABLE Familiar (
    CodFamiliar INT UNSIGNED AUTO_INCREMENT,
    Nm_Familiar VARCHAR(150) NOT NULL,
    Dt_Nascimento DATE DEFAULT NULL,
	Parentesco VARCHAR(40) NOT NULL,
    CodEscolaridade INT UNSIGNED DEFAULT NULL,
    CodOcupacao INT UNSIGNED DEFAULT NULL,
    CodAluno INT UNSIGNED NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodFamiliar)
);

CREATE TABLE Aluno (
    CodAluno INT UNSIGNED AUTO_INCREMENT,
    Nm_Aluno VARCHAR(150) NOT NULL,
    Dt_Nascimento DATE DEFAULT NULL,
    Sexo CHAR(1) DEFAULT NULL,
    CHECK (Sexo IN ('M', 'F')),
    CPF VARCHAR(14) UNIQUE DEFAULT NULL,
    RG VARCHAR(10) UNIQUE DEFAULT NULL,
    Nacionalidade ENUM('BRASILEIRO', 'ESTRANGEIRO') DEFAULT 'BRASILEIRO',
    CodEscolaridade INT UNSIGNED DEFAULT NULL,
	CodUsuario INT UNSIGNED NOT NULL,
    Dt_Cadastro DATE DEFAULT (CURDATE()),
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodAluno),
    
    -- Restrição que garante que CPF ou RG deve ser preenchido
    CONSTRAINT CHK_Aluno_CPF_ou_RG CHECK (CPF IS NOT NULL OR RG IS NOT NULL)
);

CREATE TABLE Contato (
    CodContato INT UNSIGNED AUTO_INCREMENT,
    ResponsavelEmergencial VARCHAR(80) NOT NULL,
    TelefonePrincipal VARCHAR(17) NOT NULL,
    TelefoneEmergencial VARCHAR(17) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    CodAluno INT UNSIGNED NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodContato)
);

CREATE TABLE Saude (
    CodSaude INT UNSIGNED AUTO_INCREMENT,
    DescricaoAlergia TINYTEXT DEFAULT NULL,
    DescricaoMedicacao TINYTEXT DEFAULT NULL,
    DescricaoProblemaSaude TINYTEXT DEFAULT NULL,
    TipoDeficienca TINYTEXT DEFAULT NULL,
    CodAluno INT UNSIGNED NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodSaude)
);

CREATE TABLE Turno (
    CodTurno INT UNSIGNED AUTO_INCREMENT,
    Nm_Turno VARCHAR(50) NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodTurno)
);

CREATE TABLE Modalidade (
    CodModalidade INT UNSIGNED AUTO_INCREMENT,
    Nm_Modalidade VARCHAR(50) NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodModalidade)
);

CREATE TABLE InscricaoModalidade (
    CodInscricaoModalidade INT UNSIGNED AUTO_INCREMENT,
    CodAluno INT UNSIGNED NOT NULL,
    CodModalidade INT UNSIGNED NOT NULL,
    CodTurno INT UNSIGNED NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodInscricaoModalidade)
);

CREATE TABLE ControleFalta (
    CodControleFalta INT UNSIGNED AUTO_INCREMENT,
    Falta CHAR(1) DEFAULT 'P' CHECK (FALTA IN ('P' , 'F')), -- P (PRESENTE) / F (FALTA) 
	DataFalta DATE DEFAULT (CURDATE()),
    CodInscricaoModalidade INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodControleFalta)
);

CREATE TABLE Usuario (
    CodUsuario INT UNSIGNED AUTO_INCREMENT,
    Nm_Usuario VARCHAR(80) NOT NULL UNIQUE,
    Senha VARCHAR(255) NOT NULL,
    Dt_Cadastro DATE DEFAULT (CURDATE()),
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodUsuario)
);

CREATE TABLE Role (
    CodRole INT UNSIGNED AUTO_INCREMENT,
    Nm_Role VARCHAR(70) NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodRole)
);

CREATE TABLE UsuarioRole (
    CodUsuarioRole INT UNSIGNED AUTO_INCREMENT,
    CodUsuario INT UNSIGNED NOT NULL,
    CodRole INT UNSIGNED NOT NULL,
    Status CHAR(1) DEFAULT 'A' CHECK (Status IN ('A' , 'I')),
    PRIMARY KEY (CodUsuarioRole)
);

-- CHAVES ESTRANGEIRAS
ALTER TABLE Familiar 
ADD CONSTRAINT FK_Familiar_Escolaridade 
FOREIGN KEY (CodEscolaridade) 
REFERENCES Escolaridade(CodEscolaridade);

ALTER TABLE Familiar 
ADD CONSTRAINT FK_Familiar_Ocupacao
FOREIGN KEY (CodOcupacao) 
REFERENCES Ocupacao(CodOcupacao);

ALTER TABLE Aluno 
ADD CONSTRAINT FK_Aluno_Escolaridade 
FOREIGN KEY (CodEscolaridade) 
REFERENCES Escolaridade(CodEscolaridade);

ALTER TABLE Aluno 
ADD CONSTRAINT FK_Aluno_Usuario 
FOREIGN KEY (CodUsuario) 
REFERENCES Usuario(CodUsuario);

ALTER TABLE Endereco
ADD CONSTRAINT FK_Endereco_Aluno 
FOREIGN KEY (CodAluno) 
REFERENCES Aluno(CodAluno);

ALTER TABLE Familiar
ADD CONSTRAINT FK_Familiar_Aluno 
FOREIGN KEY (CodAluno) 
REFERENCES Aluno(CodAluno);

ALTER TABLE Contato 
ADD CONSTRAINT FK_Contato_Aluno 
FOREIGN KEY (CodAluno) 
REFERENCES Aluno(CodAluno);

ALTER TABLE Saude 
ADD CONSTRAINT FK_Saude_Aluno 
FOREIGN KEY (CodAluno) 
REFERENCES Aluno(CodAluno);

ALTER TABLE InscricaoModalidade 
ADD CONSTRAINT FK_InscricaoModalidade_Aluno 
FOREIGN KEY (CodAluno) 
REFERENCES Aluno(CodAluno);

ALTER TABLE InscricaoModalidade 
ADD CONSTRAINT FK_InscricaoModalidade_Modalidade 
FOREIGN KEY (CodModalidade) 
REFERENCES Modalidade(CodModalidade);

ALTER TABLE InscricaoModalidade 
ADD CONSTRAINT FK_InscricaoModalidade_Turno 
FOREIGN KEY (CodTurno) 
REFERENCES Turno(CodTurno);

ALTER TABLE ControleFalta 
ADD CONSTRAINT FK_ControleFalta_InscricaoModalidade 
FOREIGN KEY (CodInscricaoModalidade) 
REFERENCES InscricaoModalidade(CodInscricaoModalidade);

ALTER TABLE UsuarioRole 
ADD CONSTRAINT FK_UsuarioRole_Usuario 
FOREIGN KEY (CodUsuario) 
REFERENCES Usuario(CodUsuario);

ALTER TABLE UsuarioRole 
ADD CONSTRAINT FK_UsuarioRole_Role 
FOREIGN KEY (CodRole) 
REFERENCES Role(CodRole);

-- TRIGGERS PARA CONVERTER DADOS EM MAIÚSCULO
DELIMITER //

-- Escolaridade
CREATE TRIGGER tg_BeforeInsertEscolaridade 
BEFORE INSERT ON Escolaridade 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Escolaridade = UPPER(NEW.Nm_Escolaridade);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateEscolaridade 
BEFORE UPDATE ON Escolaridade 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Escolaridade = UPPER(NEW.Nm_Escolaridade);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Endereco
CREATE TRIGGER tg_BeforeInsertEndereco 
BEFORE INSERT ON Endereco 
FOR EACH ROW 
BEGIN
  SET NEW.Rua = UPPER(NEW.Rua);
  SET NEW.Bairro = UPPER(NEW.Bairro);
  SET NEW.Cidade = UPPER(NEW.Cidade);
  SET NEW.ResideCom = UPPER(NEW.ResideCom);
  SET NEW.OutroResideCom = UPPER(NEW.OutroResideCom);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateEndereco 
BEFORE UPDATE ON Endereco 
FOR EACH ROW 
BEGIN
  SET NEW.Rua = UPPER(NEW.Rua);
  SET NEW.Bairro = UPPER(NEW.Bairro);
  SET NEW.Cidade = UPPER(NEW.Cidade);
  SET NEW.ResideCom = UPPER(NEW.ResideCom);
  SET NEW.OutroResideCom = UPPER(NEW.OutroResideCom);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Ocupacao
CREATE TRIGGER tg_BeforeInsertOcupacao 
BEFORE INSERT ON Ocupacao 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Ocupacao = UPPER(NEW.Nm_Ocupacao);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateOcupacao 
BEFORE UPDATE ON Ocupacao 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Ocupacao = UPPER(NEW.Nm_Ocupacao);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Familiar
CREATE TRIGGER tg_BeforeInsertFamiliar 
BEFORE INSERT ON Familiar 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Familiar = UPPER(NEW.Nm_Familiar);
  SET NEW.Parentesco = UPPER(NEW.Parentesco);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateFamiliar 
BEFORE UPDATE ON Familiar 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Familiar = UPPER(NEW.Nm_Familiar);
  SET NEW.Parentesco = UPPER(NEW.Parentesco);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Aluno
CREATE TRIGGER tg_BeforeInsertAluno BEFORE 
INSERT ON Aluno 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Aluno = UPPER(NEW.Nm_Aluno);
  SET NEW.Sexo = UPPER(NEW.Sexo);
  SET NEW.Nacionalidade = UPPER(NEW.Nacionalidade);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateAluno 
BEFORE UPDATE ON Aluno 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Aluno = UPPER(NEW.Nm_Aluno);
  SET NEW.Sexo = UPPER(NEW.Sexo);
  SET NEW.Nacionalidade = UPPER(NEW.Nacionalidade);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Contato
CREATE TRIGGER tg_BeforeInsertContato 
BEFORE INSERT ON Contato 
FOR EACH ROW 
BEGIN
  SET NEW.ResponsavelEmergencial = UPPER(NEW.ResponsavelEmergencial);
  SET NEW.Email = UPPER(NEW.Email);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateContato 
BEFORE UPDATE ON Contato 
FOR EACH ROW 
BEGIN
  SET NEW.ResponsavelEmergencial = UPPER(NEW.ResponsavelEmergencial);
  SET NEW.Email = UPPER(NEW.Email);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Saude 
CREATE TRIGGER tg_BeforeInsertSaude
BEFORE INSERT ON Saude
FOR EACH ROW 
BEGIN
  SET NEW.DescricaoAlergia = UPPER(NEW.DescricaoAlergia);
  SET NEW.DescricaoMedicacao = UPPER(NEW.DescricaoMedicacao);
  SET NEW.DescricaoProblemaSaude = UPPER(NEW.DescricaoProblemaSaude);
  SET NEW.TipoDeficienca = UPPER(NEW.TipoDeficienca);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateSaude
BEFORE UPDATE ON Saude
FOR EACH ROW 
BEGIN
  SET NEW.DescricaoAlergia = UPPER(NEW.DescricaoAlergia);
  SET NEW.DescricaoMedicacao = UPPER(NEW.DescricaoMedicacao);
  SET NEW.DescricaoProblemaSaude = UPPER(NEW.DescricaoProblemaSaude);
  SET NEW.TipoDeficienca = UPPER(NEW.TipoDeficienca);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Turno
CREATE TRIGGER tg_BeforeInsertTurno 
BEFORE INSERT ON Turno 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Turno = UPPER(NEW.Nm_Turno);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateTurno 
BEFORE UPDATE ON Turno 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Turno = UPPER(NEW.Nm_Turno);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- Modalidade
CREATE TRIGGER tg_BeforeInsertModalidade 
BEFORE INSERT ON Modalidade 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Modalidade = UPPER(NEW.Nm_Modalidade);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateModalidade 
BEFORE UPDATE ON Modalidade 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Modalidade = UPPER(NEW.Nm_Modalidade);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- InscricaoModalidade
CREATE TRIGGER tg_BeforeInsertInscricaoModalidade 
BEFORE INSERT ON InscricaoModalidade 
FOR EACH ROW 
BEGIN
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateInscricaoModalidade 
BEFORE UPDATE ON InscricaoModalidade FOR EACH ROW BEGIN
  SET NEW.Status = UPPER(NEW.Status);
END //

-- ControleFalta
CREATE TRIGGER tg_BeforeInsertControleFalta 
BEFORE INSERT ON ControleFalta 
FOR EACH ROW 
BEGIN
  SET NEW.Falta = UPPER(NEW.Falta);
END //
CREATE TRIGGER tg_BeforeUpdateControleFalta 
BEFORE UPDATE ON ControleFalta 
FOR EACH ROW 
BEGIN
  SET NEW.Falta = UPPER(NEW.Falta);
END //

-- Role
CREATE TRIGGER tg_BeforeInsertRole 
BEFORE INSERT ON Role 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Role = UPPER(NEW.Nm_Role);
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateRole 
BEFORE UPDATE ON Role 
FOR EACH ROW 
BEGIN
  SET NEW.Nm_Role = UPPER(NEW.Nm_Role);
  SET NEW.Status = UPPER(NEW.Status);
END //

-- UsuarioRole
CREATE TRIGGER tg_BeforeInsertUsuarioRole 
BEFORE INSERT ON UsuarioRole 
FOR EACH ROW 
BEGIN
  SET NEW.Status = UPPER(NEW.Status);
END //
CREATE TRIGGER tg_BeforeUpdateUsuarioRole 
BEFORE UPDATE ON UsuarioRole 
FOR EACH ROW 
BEGIN
  SET NEW.Status = UPPER(NEW.Status);
END //

DELIMITER ;

-- SERVIÇOS OFERECIDOS NA ONG
INSERT INTO Modalidade 
(CodModalidade, Nm_Modalidade, Status) 
VALUES
(1, 'REFORÇO', 'A'),
(2, 'MUAY THAI', 'A'),
(3, 'NATAÇÃO', 'A'),
(4, 'BALLET', 'A'),
(5, 'JUDÔ', 'A');

-- HORÁRIOS QUE SÃO OFERECIDAS AS ATIVIDADES DA ONG
INSERT INTO Turno
(CodTurno, Nm_Turno, Status) 
VALUES
(1, 'MANHÃ', 'A'),
(2, 'TARDE', 'A'),
(3, 'NOITE', 'A');

-- NÍVEL DE ESCOLARIDADE DA CRIANÇA E DO RESPONSÁVEL
INSERT INTO Escolaridade 
(CodEscolaridade, Nm_Escolaridade, Status) 
VALUES
(1, 'CRECHE', 'A'),
(2, 'PRÉ-ESCOLA', 'A'),
(3, '1º ANO DO ENSINO FUNDAMENTAL', 'A'),
(4, '2º ANO DO ENSINO FUNDAMENTAL', 'A'),
(5, '3º ANO DO ENSINO FUNDAMENTAL', 'A'),
(6, '4º ANO DO ENSINO FUNDAMENTAL', 'A'),
(7, '5º ANO DO ENSINO FUNDAMENTAL', 'A'),
(8, '6º ANO DO ENSINO FUNDAMENTAL', 'A'),
(9, '7º ANO DO ENSINO FUNDAMENTAL', 'A'),
(10, '8º ANO DO ENSINO FUNDAMENTAL', 'A'),
(11, '9º ANO DO ENSINO FUNDAMENTAL', 'A'),
(12, 'ENSINO FUNDAMENTAL INCOMPLETO', 'A'),
(13, 'ENSINO FUNDAMENTAL COMPLETO', 'A'),
(14, '1º ANO DO ENSINO MÉDIO', 'A'),
(15, '2º ANO DO ENSINO MÉDIO', 'A'),
(16, '3º ANO DO ENSINO MÉDIO', 'A'),
(17, 'ENSINO MÉDIO INCOMPLETO', 'A'),
(18, 'ENSINO MÉDIO COMPLETO', 'A'),
(19, 'ENSINO SUPERIOR INCOMPLETO', 'A'),
(20, 'ENSINO SUPERIOR COMPLETO', 'A');

INSERT INTO Ocupacao 
(CodOcupacao, Nm_Ocupacao, Status) 
VALUES
(1, 'AUTÔNOMO', 'A'),
(2, 'ELETRICISTA', 'A'),
(3, 'PINTOR', 'A'),
(4, 'MOTORISTA', 'A'),
(5, 'ZELADOR', 'A'),
(6, 'PROFESSOR', 'A');

INSERT INTO Role (CodRole, Nm_Role, Status) VALUES
(2, 'TESTE', 'A');

INSERT INTO Usuario (Nm_Usuario, Senha, Status) VALUES
('jose-martins', 'Jm@2023senha!', 'A'),
('carla-souza', 'C$ouza456!', 'A'),
('fernando-rodrigues', 'Fr@1987#Segura', 'A'),
('leticia-almeida', 'L@leticia#321', 'A'),
('pedro-costa', 'P@dr0-8900!', 'A');

INSERT INTO UsuarioRole (CodUsuario, CodRole, Status) VALUES
(1, 2, 'A');

-- Inserindo registros na tabela Aluno com CPF e RG corrigidos
INSERT INTO Aluno (
    Nm_Aluno,
    Dt_Nascimento,
    Sexo,
    CPF,
    RG,
    Nacionalidade,
    CodEscolaridade,
    CodUsuario,
    Status
) VALUES
('Ana Beatriz Lima', '2010-05-12', 'F', '12345678901', '101234572', 'Brasileiro', 1, 1, 'A'),
('Lucas Henrique Silva', '2009-11-30', 'M', '23456789012', '982345679', 'Brasileiro', 2, 2, 'A'),
('Mariana Souza Costa', '2011-02-18', 'F', '34567890123', '093456788', 'Brasileiro', 1, 3, 'A'),
('Pedro Miguel Rocha', '2008-07-25', 'M', '45678901234', '084567891', 'Brasileiro', 3, 4, 'A'),
('Isabela Fernanda Torres', '2012-09-10', 'F', '56789012345', '325678902', 'Brasileiro', 1, 5, 'A'),

('Gabriel Souza Lima', '2011-03-01', 'M', '12346578901', '543215433', 'Brasileiro', 1, 1, 'A'),
('Felipe Oliveira', '2010-07-19', 'M', '23459870123', '634512235', 'Brasileiro', 2, 2, 'A'),
('Julia Martins', '2012-05-14', 'F', '34567981234', '723409568', 'Brasileiro', 3, 3, 'A'),
('Bianca Rocha', '2009-02-28', 'F', '45670123445', '832478211', 'Brasileiro', 1, 4, 'A'),
('Fernando Costa', '2008-11-11', 'M', '56781234567', '941567893', 'Brasileiro', 2, 5, 'A'),

('Carla Fernandes', '2010-06-09', 'F', '67892345678', '123456799', 'Brasileiro', 3, 1, 'A'),
('Eduardo Almeida', '2011-01-25', 'M', '78903456789', '214567804', 'Brasileiro', 1, 2, 'A'),
('Ricardo Dias', '2009-12-10', 'M', '89014567890', '325678911', 'Brasileiro', 2, 3, 'A'),
('Larissa Lima', '2012-04-23', 'F', '90125678901', '436789102', 'Brasileiro', 3, 4, 'A'),
('Victor Hugo', '2010-08-07', 'M', '01236789012', '547890433', 'Brasileiro', 1, 5, 'A'),

('Amanda Costa', '2011-11-15', 'F', '12347890123', '654321988', 'Brasileiro', 2, 1, 'A'),
('Lucas Gomes', '2009-04-30', 'M', '23458901234', '765432101', 'Brasileiro', 3, 2, 'A'),
('Vanessa Oliveira', '2012-02-17', 'F', '34569012345', '876543211', 'Brasileiro', 1, 3, 'A'),
('Sofia Pereira', '2008-08-06', 'F', '45670123456', '987654321', 'Brasileiro', 2, 4, 'A'),
('Mateus Santos', '2010-01-22', 'M', '56781324567', '098765433', 'Brasileiro', 3, 5, 'A'),

('Tânia Rocha', '2009-09-14', 'F', '67893456789', '109876544', 'Brasileiro', 1, 1, 'A'),
('Gabriel Pereira', '2012-11-03', 'M', '78904567890', '210987655', 'Brasileiro', 2, 2, 'A'),
('Fernando Oliveira', '2010-12-18', 'M', '89015678901', '321098766', 'Brasileiro', 3, 3, 'A'),
('Paula Souza', '2011-09-25', 'F', '90126789012', '432109877', 'Brasileiro', 1, 4, 'A'),
('Samuel Dias', '2008-06-30', 'M', '01237890123', '543210988', 'Brasileiro', 2, 5, 'A'),

('Vitoria Silva', '2010-04-13', 'F', '12348901234', '654321099', 'Brasileiro', 1, 1, 'A'),
('Rafael Martins', '2011-07-07', 'M', '23459012345', '765432110', 'Brasileiro', 2, 2, 'A'),
('Julia Costa', '2009-03-19', 'F', '34570123456', '876543221', 'Brasileiro', 3, 3, 'A'),
('Gabriel Rocha', '2012-10-22', 'M', '45681234567', '987654322', 'Brasileiro', 1, 4, 'A'),
('Marina Lima', '2010-03-16', 'F', '56792345678', '098765434', 'Brasileiro', 2, 5, 'A');


INSERT INTO Endereco (
    CEP, Rua, Bairro, Cidade, Numero, ResideCom, CodAluno, Status
) VALUES 
('30110-012', 'Rua dos Estudantes', 'Centro', 'Belo Horizonte', 123, 'PAI', 1, 'A'),
('04094-050', 'Avenida das Crianças', 'Saúde', 'São Paulo', 456, 'MAE', 2, 'A'),
('20010-000', 'Rua das Flores', 'Lapa', 'Rio de Janeiro', 789, 'PAI', 3, 'A'),
('40020-000', 'Travessa dos Jovens', 'Barra', 'Salvador', 101, 'TIO', 4, 'A'),
('80010-180', 'Rua Esperança', 'Centro', 'Curitiba', 202, 'PAI', 5, 'A'),
('12345-678', 'Rua Alegre', 'Jardim das Flores', 'Rio de Janeiro', 111, 'MÃE', 6, 'A'),
('54321-987', 'Avenida Central', 'Centro', 'Belo Horizonte', 222, 'PAI', 7, 'A'),
('98765-432', 'Rua Verde', 'Parque das Árvores', 'São Paulo', 333, 'PAI', 8, 'A'),
('11223-445', 'Rua Nova', 'Jardim América', 'Brasília', 444, 'MAE', 9, 'A'),
('22112-344', 'Avenida dos Navegantes', 'Copacabana', 'Rio de Janeiro', 555, 'PAI', 10, 'A'),
('54321-678', 'Rua Santa Clara', 'Vila Nova', 'Curitiba', 666, 'TIO', 11, 'A'),
('65432-765', 'Avenida São João', 'Centro', 'São Paulo', 777, 'MAE', 12, 'A'),
('87654-321', 'Rua dos Pássaros', 'Bairro Alto', 'Belo Horizonte', 888, 'PAI', 13, 'A'),
('12321-987', 'Rua do Sol', 'Vila Rica', 'Salvador', 999, 'TIO', 14, 'A'),
('32165-432', 'Rua da Paz', 'Jardim das Flores', 'Rio de Janeiro', 1010, 'MAE', 15, 'A'),
('21354-876', 'Avenida Beira Mar', 'Centro', 'Fortaleza', 1111, 'PAI', 16, 'A'),
('76543-210', 'Rua das Palmeiras', 'Praia', 'Natal', 1212, 'MÃE', 17, 'A'),
('98765-432', 'Rua do Mar', 'Vila Mariana', 'São Paulo', 1313, 'PAI', 18, 'A'),
('11223-445', 'Avenida Rio Branco', 'Centro', 'Brasília', 1414, 'TIO', 19, 'A'),
('22334-556', 'Rua do Rio', 'Jardim das Flores', 'Belo Horizonte', 1515, 'PAI', 20, 'A'),
('76543-321', 'Avenida Paulista', 'Centro', 'São Paulo', 1616, 'MAE', 21, 'A'),
('87654-987', 'Rua do Campo', 'Parque Nacional', 'Brasília', 1717, 'TIO', 22, 'A'),
('54321-123', 'Rua dos Trabalhadores', 'Bairro Central', 'Curitiba', 1818, 'PAI', 23, 'A'),
('32123-434', 'Avenida das Artes', 'Centro', 'Porto Alegre', 1919, 'MÃE', 24, 'A'),
('65432-987', 'Rua do Ouro', 'Centro Histórico', 'Salvador', 2020, 'PAI', 25, 'A'),
('90876-543', 'Rua da Liberdade', 'Vila Sol', 'Belo Horizonte', 2121, 'TIO', 26, 'A'),
('23456-765', 'Avenida do Sol', 'Vila Paulista', 'São Paulo', 2222, 'MAE', 27, 'A'),
('76543-210', 'Rua Santa Teresa', 'Jardim Sul', 'Rio de Janeiro', 2323, 'PAI', 28, 'A'),
('32154-876', 'Rua dos Navegantes', 'Bairro dos Pescadores', 'Salvador', 2424, 'TIO', 29, 'A'),
('98765-432', 'Avenida do Bosque', 'Centro', 'Fortaleza', 2525, 'PAI', 30, 'A');

INSERT INTO Saude (
    DescricaoAlergia, DescricaoMedicacao, DescricaoProblemaSaude, TipoDeficienca, CodAluno, Status
) VALUES 
('Alergia à lactose', 'Antialérgico Loratadina', NULL, NULL, 1, 'A'),
(NULL, NULL, 'Asma leve controlada', NULL, 2, 'A'),
('Alergia a pólen', NULL, NULL, NULL, 3, 'A'),
(NULL, 'Uso contínuo de insulina', 'Diabetes tipo 1', NULL, 4, 'A'),
(NULL, NULL, NULL, 'Auditiva', 5, 'A'),
('Alergia a glúten', 'Antialérgico Cetirizina', NULL, NULL, 6, 'A'),
('Alergia a poeira', 'Antialérgico Fexofenadina', 'Dificuldade respiratória', NULL, 7, 'A'),
('Dificuldade para respirar', NULL, 'Asma crônica', NULL, 8, 'A'),
(NULL, NULL, 'Deficiência visual', 'Visual', 9, 'A'),
('Alergia a abelha', 'Antialérgico Diphenhydramine', NULL, NULL, 10, 'A'),
('Dificuldade motora', NULL, 'Paralisia cerebral', 'Motora', 11, 'A'),
('Alergia a amendoim', 'Antialérgico Loratadina', NULL, NULL, 12, 'A'),
('Uso contínuo de medicação para epilepsia', NULL, 'Epilepsia', NULL, 13, 'A'),
(NULL, NULL, 'Deficiência auditiva', 'Auditiva', 14, 'A'),
('Alergia a penicilina', 'Antialérgico Loratadina', NULL, NULL, 15, 'A'),
('Alergia a glúten', 'Antialérgico Cetirizina', NULL, NULL, 16, 'A'),
('Alergia a poeira', 'Antialérgico Fexofenadina', 'Dificuldade respiratória', NULL, 17, 'A'),
('Dificuldade para respirar', NULL, 'Asma crônica', NULL, 18, 'A'),
('Alergia a glúten', 'Antialérgico Loratadina', NULL, NULL, 19, 'A'),
('Alergia a frutos do mar', 'Antialérgico Diphenhydramine', NULL, NULL, 20, 'A'),
('Deficiência visual', 'Óculos de grau', NULL, 'Visual', 21, 'A'),
('Alergia a ovos', 'Antialérgico Loratadina', NULL, NULL, 22, 'A'),
('Alergia a medicamentos', 'Antialérgico Cetirizina', NULL, NULL, 23, 'A'),
('Problema respiratório', NULL, 'Dificuldade para respirar', NULL, 24, 'A'),
('Alergia a picadas de insetos', 'Antialérgico Diphenhydramine', NULL, NULL, 25, 'A'),
('Deficiência auditiva', NULL, 'Perda auditiva leve', 'Auditiva', 26, 'A'),
('Alergia a leite', 'Antialérgico Loratadina', NULL, NULL, 27, 'A'),
('Uso de antibióticos', 'Antibióticos', NULL, NULL, 28, 'A'),
('Alergia a penicilina', 'Antialérgico Cetirizina', NULL, NULL, 29, 'A'),
('Deficiência motora', 'Cadeira de rodas', NULL, 'Motora', 30, 'A');

INSERT INTO Familiar (
    Nm_Familiar, Parentesco, CodAluno, Status
) VALUES
('Carlos Silva', 'Pai', 1, 'A'),
('Maria Oliveira', 'Mãe', 2, 'A'),
('José Costa', 'Pai', 3, 'A'),
('Ana Souza', 'Mãe', 4, 'A'),
('Paulo Lima', 'Pai', 5, 'A'),
('Fernanda Santos', 'Mãe', 6, 'A'),
('Roberto Almeida', 'Pai', 7, 'A'),
('Juliana Pereira', 'Mãe', 8, 'A'),
('Felipe Costa', 'Pai', 9, 'A'),
('Cláudia Oliveira', 'Mãe', 10, 'A'),
('André Fernandes', 'Pai', 11, 'A'),
('Luciana Martins', 'Mãe', 12, 'A'),
('Fábio Rodrigues', 'Pai', 13, 'A'),
('Carla Sousa', 'Mãe', 14, 'A'),
('Eduardo Silva', 'Pai', 15, 'A'),
('Patrícia Lima', 'Mãe', 16, 'A'),
('Henrique Costa', 'Pai', 17, 'A'),
('Marta Oliveira', 'Mãe', 18, 'A'),
('Lucas Pereira', 'Pai', 19, 'A'),
('Tatiane Costa', 'Mãe', 20, 'A'),
('Daniela Rodrigues', 'Mãe', 21, 'A'),
('Marcos Silva', 'Pai', 22, 'A'),
('Gabriela Almeida', 'Mãe', 23, 'A'),
('Eduardo Oliveira', 'Pai', 24, 'A'),
('Tatiane Martins', 'Mãe', 25, 'A'),
('Rafael Costa', 'Pai', 26, 'A'),
('Simone Lima', 'Mãe', 27, 'A'),
('Sérgio Pereira', 'Pai', 28, 'A'),
('Renata Silva', 'Mãe', 29, 'A'),
('Vinícius Costa', 'Pai', 30, 'A');
INSERT INTO Contato (
    ResponsavelEmergencial, TelefonePrincipal, TelefoneEmergencial, Email, CodAluno, Status
) VALUES 
('Júlio Santos', '31987654321', '31998887766', 'julio.santos@gmail.com', 1, 'A'),
('Fernanda Almeida', '31988765432', '31999887777', 'fernanda.almeida@yahoo.com', 2, 'A'),
('Carlos Pereira', '31999887766', '31993322112', 'carlos.pereira@hotmail.com', 3, 'A'),
('Patrícia Costa', '31999998888', '31997776655', 'patricia.costa@outlook.com', 4, 'A'),
('Márcio Lima', '31997776655', '31996543210', 'marcio.lima@gmail.com', 5, 'A'),
('Juliana Rocha', '31998887777', '31995764783', 'juliana.rocha@outlook.com', 6, 'A'),
('Lucas Oliveira', '31996543210', '31993322112', 'lucas.oliveira@yahoo.com', 7, 'A'),
('Mariana Souza', '31995764783', '31992233445', 'mariana.souza@gmail.com', 8, 'A'),
('Renato Costa', '31993322112', '31991122334', 'renato.costa@outlook.com', 9, 'A'),
('Luciana Silva', '31992233445', '31989922345', 'luciana.silva@gmail.com', 10, 'A'),
('Ricardo Lima', '31991122334', '31988833456', 'ricardo.lima@yahoo.com', 11, 'A'),
('Cláudia Costa', '31990554321', '31987744567', 'claudia.costa@gmail.com', 12, 'A'),
('Paulo Fernandes', '31989922345', '31986655432', 'paulo.fernandes@hotmail.com', 13, 'A'),
('Tatiane Pereira', '31988833456', '31985566543', 'tatiane.pereira@yahoo.com', 14, 'A'),
('Marcelo Rocha', '31987744567', '31984477654', 'marcelo.rocha@gmail.com', 15, 'A'),
('Simone Souza', '31986655432', '31983388765', 'simone.souza@hotmail.com', 16, 'A'),
('André Costa', '31985566543', '31982299876', 'andre.costa@gmail.com', 17, 'A'),
('Bruna Oliveira', '31984477654', '31981110987', 'bruna.oliveira@outlook.com', 18, 'A'),
('Henrique Lima', '31983388765', '31980022010', 'henrique.lima@gmail.com', 19, 'A'),
('Carla Pereira', '31982299876', '31978933121', 'carla.pereira@outlook.com', 20, 'A'),
('Roberto Costa', '31981110987', '31977844232', 'roberto.costa@gmail.com', 21, 'A'),
('Gisele Souza', '31980022010', '31976755343', 'gisele.souza@outlook.com', 22, 'A'),
('Tiago Rocha', '31978933121', '31975666454', 'tiago.rocha@hotmail.com', 23, 'A'),
('Sandra Oliveira', '31977844232', '31974577565', 'sandra.oliveira@gmail.com', 24, 'A'),
('Eduardo Pereira', '31976755343', '31973488676', 'eduardo.pereira@yahoo.com', 25, 'A'),
('Fernanda Lima', '31975666454', '31972399787', 'fernanda.lima@outlook.com', 26, 'A'),
('Gustavo Souza', '31974577565', '31971210898', 'gustavo.souza@gmail.com', 27, 'A'),
('Cristina Costa', '31973488676', '31970000000', 'cristina.costa@yahoo.com', 28, 'A'),
('Alessandra Rocha', '31972399787', '31967898765', 'alessandra.rocha@gmail.com', 29, 'A'),
('Raquel Pereira', '31971210898', '31966665432', 'raquel.pereira@yahoo.com', 30, 'A');



INSERT INTO InscricaoModalidade (
    CodAluno, CodModalidade, CodTurno, Status
) VALUES 
(1, 1, 1, 'A'),
(2, 2, 1, 'A'),
(3, 3, 2, 'A'),
(4, 1, 3, 'A'),
(5, 2, 1, 'A'),
(6, 3, 2, 'A'),
(7, 1, 3, 'A'),
(8, 2, 1, 'A'),
(9, 3, 2, 'A'),
(10, 1, 3, 'A'),
(11, 2, 1, 'A'),
(12, 3, 2, 'A'),
(13, 1, 3, 'A'),
(14, 2, 1, 'A'),
(15, 3, 2, 'A'),
(16, 1, 3, 'A'),
(17, 2, 1, 'A'),
(18, 3, 2, 'A'),
(19, 1, 3, 'A'),
(20, 2, 1, 'A'),
(21, 3, 2, 'A'),
(22, 1, 3, 'A'),
(23, 2, 1, 'A'),
(24, 3, 2, 'A'),
(25, 1, 3, 'A'),
(26, 2, 1, 'A'),
(27, 3, 2, 'A'),
(28, 1, 3, 'A'),
(29, 2, 1, 'A'),
(30, 3, 2, 'A');

INSERT INTO ControleFalta (
    Falta, DataFalta, CodInscricaoModalidade
) VALUES 
('P', '2025-04-21', 1),
('P', '2025-04-21', 2),
('P', '2025-04-21', 3),
('P', '2025-04-22', 4),
('P', '2025-04-22', 5),
('P', '2025-04-22', 6),
('P', '2025-04-23', 7),
('P', '2025-04-23', 8),
('P', '2025-04-23', 9),
('P', '2025-04-24', 10),
('P', '2025-04-24', 11),
('P', '2025-04-24', 12),
('P', '2025-04-25', 13),
('P', '2025-04-25', 14),
('P', '2025-04-25', 15),
('P', '2025-04-26', 16),
('P', '2025-04-26', 17),
('P', '2025-04-26', 18),
('P', '2025-04-27', 19),
('P', '2025-04-27', 20),
('P', '2025-04-27', 21),
('P', '2025-04-28', 22),
('P', '2025-04-28', 23),
('P', '2025-04-28', 24),
('P', '2025-04-29', 25),
('P', '2025-04-29', 26),
('P', '2025-04-29', 27),
('P', '2025-04-30', 28),
('P', '2025-04-30', 29),
('P', '2025-04-30', 30);


