DECLARE @name VARCHAR(50)  -- Nome do banco de dados
DECLARE @path VARCHAR(256) -- Caminho para os arquivos de backup
DECLARE @fileName VARCHAR(256) -- Nome do arquivo de backup
DECLARE @fileDate VARCHAR(20) -- Data usada para o nome do arquivo
DECLARE @sql NVARCHAR(MAX) -- Comando SQL para alterar o modo de recuperação

-- Especificar o diretório de backup
SET @path = 'D:\BACKUPS_BASES\'  

-- Obter a data para anexar ao nome do arquivo
SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

-- Alterar o modo de recuperação para "Simple"
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')  -- Excluir os bancos de dados do sistema

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construir o comando SQL para alterar o modo de recuperação
    SET @sql = 'ALTER DATABASE [' + @name + '] SET RECOVERY SIMPLE'
    
    -- Executar o comando SQL
    EXEC sp_executesql @sql
    
    FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor

-- Realizar o Backup de Todos os Bancos de Dados
DECLARE db_cursor CURSOR READ_ONLY FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'  -- Garantir que o banco de dados esteja online
      AND name NOT IN ('master', 'model', 'msdb', 'tempdb')  -- Excluir os bancos de dados do sistema

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construir o nome do arquivo de backup
    SET @fileName = @path + @name + '_' + @fileDate + '.bak'
    
    -- Executar o comando de backup
    EXEC('BACKUP DATABASE [' + @name + '] TO DISK = ''' + @fileName + ''' WITH INIT')
    
    FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
