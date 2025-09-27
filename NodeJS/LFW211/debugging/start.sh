#! /bin/zsh 

# Start script for debugging
echo "Starting application in debug mode..."
node --inspect-brk app.js
echo "Application started. You can now attach your debugger."
echo "Please open the following URL in Chrome to start debugging:"
echo "open chrome://inspect"
# End of script
