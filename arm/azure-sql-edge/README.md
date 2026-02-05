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

# Ver logs
docker compose logs -f

# Conectar con sqlcmd
docker exec -it azure-sql-edge /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'pp4sw0rd#s3c0r3'

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

Esto evitará que se generen 70GB+ de datos innecesarios en desarrollo.
