echo 'Checking newer version of jenv...'
brew upgrade jenv

echo 'Symbolically linking JDK version 11.0.27 to version 11 for jenv...'
ln -s ~/.jenv/versions/11.0.27 ~/.jenv/versions/11

echo 'Show all versions of JDK managed by jenv...'
jenv versions