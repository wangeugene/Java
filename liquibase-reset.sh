#!/bin/zsh

echo "Setting up environment variables from .env file..."
set -a
source .env
set +a

echo "WARNING: This script will drop the Liquibase tracking tables."
echo "This will cause Liquibase to re-run all migrations on the next run."
echo "Press CTRL+C to abort or ENTER to continue..."
read

# Check if sqlcmd is installed
if ! command -v sqlcmd &> /dev/null; then
    echo "Error: sqlcmd is not installed. Please install it to run this script."
    echo "To install sqlcmd: brew install mssql-tools"
    exit 1
fi

# Extract server and database from JDBC URL
# Example URL: jdbc:sqlserver://server.database.windows.net:1433;database=mydb;
JDBC_SERVER=$(echo $JDBC_URL | sed -n 's/.*:\/\/\([^:;]*\).*/\1/p')
JDBC_DATABASE=$(echo $JDBC_URL | sed -n 's/.*database=\([^;]*\).*/\1/p')

echo "Connecting to database: $JDBC_DATABASE on server: $JDBC_SERVER"

# Create SQL to drop the tables
TEMP_SQL_FILE=$(mktemp)
cat > "$TEMP_SQL_FILE" << EOF
USE $JDBC_DATABASE;
GO

IF OBJECT_ID('dbo.DATABASECHANGELOGLOCK', 'U') IS NOT NULL
    DROP TABLE dbo.DATABASECHANGELOGLOCK;
GO

IF OBJECT_ID('dbo.DATABASECHANGELOG', 'U') IS NOT NULL
    DROP TABLE dbo.DATABASECHANGELOG;
GO

IF OBJECT_ID('eugene.DATABASECHANGELOGLOCK', 'U') IS NOT NULL
    DROP TABLE eugene.DATABASECHANGELOGLOCK;
GO

IF OBJECT_ID('eugene.DATABASECHANGELOG', 'U') IS NOT NULL
    DROP TABLE eugene.DATABASECHANGELOG;
GO

PRINT 'All Liquibase tracking tables have been dropped.'
GO
EOF

# Execute the SQL
sqlcmd -S "$JDBC_SERVER" -d "$JDBC_DATABASE" -U "$JBDC_USERNAME" -P "$JBDC_PASSWORD" -i "$TEMP_SQL_FILE"

# Clean up
rm "$TEMP_SQL_FILE"

echo "You can now run ./liquibase.sh to start fresh."
