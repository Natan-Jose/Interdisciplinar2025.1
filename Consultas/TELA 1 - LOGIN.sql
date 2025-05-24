DELIMITER //

CREATE PROCEDURE sp_Validar_Login (
    IN p_Nm_Usuario VARCHAR(80),
    IN p_Senha VARCHAR(255)
)
BEGIN
    -- Verifica se o usuário está ativo e se o relacionamento com o papel também está ativo
    SELECT u.CodUsuario, u.Nm_Usuario
    FROM Usuario u
    JOIN UsuarioRole ur ON u.CodUsuario = ur.CodUsuario
    JOIN Role r ON ur.CodRole = r.CodRole  
    WHERE u.Nm_Usuario = p_Nm_Usuario
      AND u.Senha = p_Senha
      AND u.Status = 'A'          
      AND ur.Status = 'A'          
      AND r.Status = 'A';          
END //

DELIMITER ;

CALL sp_Validar_Login(@p_Nm_Usuario, @p_Senha);

CALL sp_Validar_Login('jose-martins', 'Jm@2023senha!');



