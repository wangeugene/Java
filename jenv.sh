echo 'Checking newer version of jenv...'
brew upgrade jenv || echo "Failed to upgrade jenv, continuing..."

# Check if JDK 11 symbolic link already exists
if [ ! -L ~/.jenv/versions/11 ]; then
    echo 'Symbolically linking JDK version 11.0.27 to version 11 for jenv...'
    JDK11_PATH=$(ls -d ~/.jenv/versions/11.0.* | sort -V | tail -n 1)
    if [ -d "$JDK11_PATH" ]; then
        ln -s "$JDK11_PATH" ~/.jenv/versions/11
    else
        echo "Error: Could not find JDK 11 in ~/.jenv/versions/"
    fi
else
    echo "JDK 11 symbolic link already exists"
fi

echo 'Printing out the JDK version 21 full path...'
JDK21_PATH=$(/usr/libexec/java_home -v 21 2>/dev/null)
echo "Found JDK 21 at: $JDK21_PATH"

# Check if JDK 21 symbolic link already exists
if [ -L ~/.jenv/versions/21 ]; then
    echo "Removing existing JDK 21 symbolic link..."
    rm -f ~/.jenv/versions/21
fi

echo 'Creating symbolic link for JDK 21...'
# Find the latest JDK 21 version
JDK21_JENV_PATH=$(ls -d ~/.jenv/versions/21.* | sort -V | tail -n 1)
if [ -d "$JDK21_JENV_PATH" ]; then
    ln -sf "$JDK21_JENV_PATH" ~/.jenv/versions/21
    echo "Created link from $JDK21_JENV_PATH to ~/.jenv/versions/21"
else
    echo "Error: Could not find JDK 21 in ~/.jenv/versions/"
fi

echo 'Show all versions of JDK managed by jenv...'
jenv versions

# Refresh jenv
echo "Refreshing jenv..."
jenv rehash

echo 'Setting up JDK 21 for this project folder using jenv'
jenv local 21

echo "Done! Current Java version:"
java -version
