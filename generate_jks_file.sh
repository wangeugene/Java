#!/bin/zsh

#CN = Common Name (e.g., person's name or server's hostname, here: eugene)
#OU = Organizational Unit (e.g., department, here: Dev)
#O = Organization (e.g., company name, here: Yuzhen)
#L = Locality (e.g., city, here: SZ)
#S = State or Province (here: GD)
#C = Country (2-letter country code, here: CN for China)
#JKS stands for Java KeyStore. It is a repository file format used by Java to store cryptographic keys,
#certificates, and secrets securely.
#JKS files are commonly used for SSL/TLS configuration and authentication in Java applications.


cd /Users/euwang/Projects/Java &&
keytool -genkeypair -alias jwt -keyalg RSA -keystore src/test/resources/javakeystoreRSA.jks -validity 3650 -keysize 2048 -storepass myPassPhrase -keypass myPassPhrase -dname "CN=JWT Test, OU=Eugene Java, O=Eugene Inc, L=San Francisco, ST=CA, C=US"
cp src/test/resources/javakeystoreRSA.jks /Users/euwang/Projects/Java/src/main/resources/javakeystoreRSA.jks