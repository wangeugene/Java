#!/bin/zsh

echo "This script is for macOS users only with M4 Pro apple silicon chip."
echo "Setting up environment variables from .env file..."
set -a
source .env
set +a

# Check if liquibase is installed
if ! command -v liquibase &> /dev/null; then
    echo "Error: liquibase is not installed or not in the PATH."
    echo "Please install liquibase first: brew install liquibase"
    exit 1
fi

# Get the absolute path of the directory where the script is located
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
echo "Script directory: $SCRIPT_DIR"

# Set variables
CHANGELOG_FILE="db/changelog/db.changelog-master.yaml"
CLASSPATH_DIR="src/main/resources"
FULL_CLASSPATH_PATH="$SCRIPT_DIR/$CLASSPATH_DIR"
FULL_CHANGELOG_PATH="$SCRIPT_DIR/$CLASSPATH_DIR/$CHANGELOG_FILE"

# Check if the changelog file exists
if [ ! -f "$FULL_CHANGELOG_PATH" ]; then
    echo "Error: Changelog file not found at: $FULL_CHANGELOG_PATH"
    exit 1
fi

echo "Using changelog file: $FULL_CHANGELOG_PATH"
echo "Using classpath: $FULL_CLASSPATH_PATH"
echo "The JDBC USER: ${JBDC_USERNAME}"



echo "The experiences sharing:"
echo "1. Azure SQL server user is bind to a default schema, by default it is dbo."
echo "2. You have to create a database schema manually, liquibase configuration in yaml file didn't work."
echo "3. If the database user you are using is bind to the default schema, liquibase will always check the default schema's DATABASECHANGELOG table."
echo "4. Even if you manually deleted default schema's DATABASECHANGELOG tables, two tables, it still shows the Tables managed by liquibase exists."
echo "5. Use Spring Boot Liquibase to automatically create the database tables, and make sure the schema is created first manually."
# Normal update
liquibase \
    --classpath="$FULL_CLASSPATH_PATH" \
    --changeLogFile="$CHANGELOG_FILE" \
    --url="${JDBC_URL}" \
    --username="${JBDC_USERNAME}" \
    --password="${JBDC_PASSWORD}" \
    update

echo "Liquibase update completed successfully."