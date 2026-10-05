# Azure SQL Edge - Desarrollo Local

## Configuración
- **Recovery Model**: SIMPLE (sin logs de transacción persistentes)
- **SQL Agent**: Deshabilitado
- **Memoria**: 4GB límite
- **Puerto**: 1433

## Credenciales
- **Usuario**: sa
- **Password**: pp4sw0rd#s3c0r3

## Comandos útiles

```bash
# Iniciar
docker compose up -d

# IMPORTANTE: Aplicar configuración SIMPLE RECOVERY (ejecutar una vez después del primer inicio)
# Opción 1: Usando Docker con imagen que incluye sqlcmd
docker run --rm --network host mcr.microsoft.com/mssql-tools:latest /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'pp4sw0rd#s3c0r3' -Q "ALTER DATABASE [master] SET RECOVERY SIMPLE; ALTER DATABASE [model] SET RECOVERY SIMPLE; PRINT 'Recovery mode configurado a SIMPLE';"

# Opción 2: Si tienes Azure Data Studio o DBeaver, ejecuta manualmente:
# ALTER DATABASE [master] SET RECOVERY SIMPLE;
# ALTER DATABASE [model] SET RECOVERY SIMPLE;

# Ver logs
docker compose logs -f

# Conectar con sqlcmd (desde otra imagen ya que Azure SQL Edge no lo incluye)
docker run -it --rm --network host mcr.microsoft.com/mssql-tools:latest /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'pp4sw0rd#s3c0r3'

# Ver uso de espacio
docker run --rm --network host mcr.microsoft.com/mssql-tools:latest /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'pp4sw0rd#s3c0r3' -Q "EXEC sp_spaceused"
docker exec -it azure-sql-edge /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'pp4sw0rd#s3c0r3' -C

# Ver uso de espacio
docker exec -it azure-sql-edge /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'pp4sw0rd#s3c0r3' -Q "EXEC sp_spaceused"

# Ver tamaño del volumen
docker system df -v | grep sql_data

# Limpiar completamente (si crece mucho de nuevo)
docker compose down -v
```

## Prevención de crecimiento
El script `init-dev.sql` configura automáticamente:
- Recovery Mode SIMPLE en todas las bases de datos
- Deshabilita acumulación de logs transaccionales
- Limita error logs

Esta configuración ayuda a reducir el crecimiento de los logs de SQL Server, pero no garantiza por sí sola un límite de uso de disco en Docker.

## Incidencia observada en macOS
Entorno observado: macOS `26.6.2` (reportado por `sw_vers -productVersion`, build `25G83`), Docker Desktop 29.8.1 y versión de kernel reportada por `uname -r`: `25.6.2`.

En este entorno se observó un crecimiento de más de 70 GB de datos innecesarios durante el desarrollo. La configuración anterior se aplicó como mitigación; no se ha verificado aquí si el mismo comportamiento ocurre en otras versiones de Docker Desktop o en Windows/Linux.
