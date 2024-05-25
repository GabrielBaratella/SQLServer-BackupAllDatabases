DECLARE @name VARCHAR(50)  -- Nome do banco de dados (Database name)
DECLARE @path VARCHAR(256) -- Caminho para os arquivos de backup (Path to backup files)
DECLARE @fileName VARCHAR(256) -- Nome do arquivo de backup (Backup file name)
DECLARE @fileDate VARCHAR(20) -- Data usada para o nome do arquivo (Date used for file name)
DECLARE @sql NVARCHAR(MAX) -- Comando SQL para alterar o modo de recuperação (SQL command to change recovery mode)

-- Especificar o diretório de backup (Specify backup directory)
SET @path = 'D:\BACKUPS_BASES\'  

-- Obter a data para anexar ao nome do arquivo (Get the date to append to the file name)
SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

-- Alterar o modo de recuperação para "Simple" (Change recovery mode to "Simple")
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')  -- Excluir os bancos de dados do sistema (Exclude system databases)

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construir o comando SQL para alterar o modo de recuperação (Build SQL command to change recovery mode)
    SET @sql = 'ALTER DATABASE [' + @name + '] SET RECOVERY SIMPLE'
    
    -- Executar o comando SQL (Execute SQL command)
    EXEC sp_executesql @sql
    
    FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor

-- Realizar o Backup de Todos os Bancos de Dados (Backup All Databases)
DECLARE db_cursor CURSOR READ_ONLY FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'  -- Garantir que o banco de dados esteja online (Ensure the database is online)
      AND name NOT IN ('master', 'model', 'msdb', 'tempdb')  -- Excluir os bancos de dados do sistema (Exclude system databases)

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construir o nome do arquivo de backup (Build backup file name)
    SET @fileName = @path + @name + '_' + @fileDate + '.bak'
    
    -- Executar o comando de backup (Execute backup command)
    EXEC('BACKUP DATABASE [' + @name + '] TO DISK = ''' + @fileName + ''' WITH INIT')
    
    FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
