#!/bin/zsh

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

# Run Liquibase
# Check if we need to initialize the changelog table first
if [ "$1" = "--init" ]; then
    echo "Initializing changelog table..."
    # Initialize the changelog table
    liquibase \
        --classpath="$FULL_CLASSPATH_PATH" \
        --changeLogFile="$CHANGELOG_FILE" \
        --url="${JDBC_URL}" \
        --username="${JBDC_USERNAME}" \
        --password="${JBDC_PASSWORD}" \
        changelog-sync-sql

    echo "To mark the database as up-to-date with the changelog, run this SQL against your database."
    echo "Then run this script again without the --init parameter."
    exit 0
fi

# Normal update
liquibase \
    --classpath="$FULL_CLASSPATH_PATH" \
    --changeLogFile="$CHANGELOG_FILE" \
    --url="${JDBC_URL}" \
    --username="${JBDC_USERNAME}" \
    --password="${JBDC_PASSWORD}" \
    update

echo "Liquibase update completed successfully."