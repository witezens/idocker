-- Configuración para entorno de desarrollo local
-- Desactiva recovery y limita crecimiento de logs

USE master;
GO

-- Cambiar todas las bases de datos del sistema a SIMPLE RECOVERY
-- Esto trunca los logs automáticamente y previene crecimiento descontrolado
ALTER DATABASE [master] SET RECOVERY SIMPLE;
ALTER DATABASE [model] SET RECOVERY SIMPLE;
ALTER DATABASE [msdb] SET RECOVERY SIMPLE;
ALTER DATABASE [tempdb] SET RECOVERY SIMPLE;
GO

-- Cualquier base de datos nueva heredará SIMPLE RECOVERY del modelo
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

-- Limitar ciclos de error log (previene acumulación de logs antiguos)
EXEC sp_cycle_errorlog;
GO

PRINT 'Azure SQL Edge configurado para desarrollo sin recovery';
GO
