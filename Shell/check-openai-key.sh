#!/usr/bin/env zsh
set -euo pipefail

# Load .env (export variables so curl can see them)
set -a
source .env
set +a

: "${OPENAI_API_KEY:?OPENAI_API_KEY is missing. Put it in .env}"
# This is a zsh/bash parameter-expansion check that ensures OPENAI_API_KEY is set and not empty. If it’s unset or empty, the shell prints the message "OPENAI_API_KEY is missing. Put it in .env" to stderr and the script exits with a non-zero status.

# ":" is a no-op command used to evaluate the expansion.
# "${VAR:?msg}" triggers an error (prints msg) if VAR is unset or null.
# Equivalent verbose form:

# # Equivalent
# if [ -z "${OPENAI_API_KEY:-}" ]; then
#   echo "OPENAI_API_KEY is missing. Put it in .env" >&2
#   exit 1
# fi


# Print response body to console + then print HTTP status on a new line
curl -sS https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -w "\n\nHTTP %{http_code}\n"
