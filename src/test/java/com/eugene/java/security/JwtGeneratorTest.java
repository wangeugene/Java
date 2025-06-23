package com.eugene.java.security;

import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jwt.SignedJWT;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.crypto.encrypt.KeyStoreKeyFactory;

import java.security.KeyPair;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

class JwtGeneratorTest {

    private JwtGenerator jwtGenerator;
    private KeyPair keyPair;

    @BeforeEach
    void setUp() {
        try {
            final String pass = "myPassPhrase";
            KeyStoreKeyFactory keyStoreKeyFactory =
                    new KeyStoreKeyFactory(new ClassPathResource("javakeystoreRSA.jks"), pass.toCharArray());
            keyPair = keyStoreKeyFactory.getKeyPair("jwt", pass.toCharArray());

            // Verify the key pair contains valid RSA keys
            assertNotNull(keyPair.getPublic(), "Public key should not be null");
            assertNotNull(keyPair.getPrivate(), "Private key should not be null");
            assertInstanceOf(RSAPublicKey.class, keyPair.getPublic(), "Public key should be an RSA key");
            assertInstanceOf(
                    RSAPrivateKey.class, keyPair.getPrivate(), "Private key should be an RSA key");

            jwtGenerator = new JwtGenerator(keyPair);
        } catch (Exception e) {
            e.printStackTrace(); // Print the stack trace to see the actual error
            fail("Failed to set up test: " + e.getMessage());
        }
    }

    @Test
    void generateDemoJwt() {
        try {
            // Generate JWT
            String jwt = jwtGenerator.generateDemoJwt();

            // Parse and verify JWT
            assertNotNull(jwt);
            SignedJWT signedJWT = SignedJWT.parse(jwt);

            // Verify JWT header
            assertEquals("RS256", signedJWT.getHeader().getAlgorithm().getName());
            assertEquals("JWT", signedJWT.getHeader().getType().toString());

            // Verify JWT claims
            assertEquals("eugene-demo-subject", signedJWT.getJWTClaimsSet().getSubject());
            assertEquals("eugene-java-app", signedJWT.getJWTClaimsSet().getIssuer());
            assertEquals("eugene-frontend-app", signedJWT.getJWTClaimsSet().getAudience().getFirst());
            assertEquals("eugene-user-id", signedJWT.getJWTClaimsSet().getClaim("id"));
            assertEquals("all", signedJWT.getJWTClaimsSet().getClaim("scope"));

            // Verify expiration is roughly 28 minutes in the future
            Instant now = Instant.now();
            Date expectedExpiry = Date.from(now.plus(28, ChronoUnit.MINUTES));
            Date actualExpiry = signedJWT.getJWTClaimsSet().getExpirationTime();

            // Allow a small difference (5 seconds) to account for test execution time
            long differenceInSeconds = Math.abs(expectedExpiry.getTime() - actualExpiry.getTime()) / 1000;
            assertTrue(
                    differenceInSeconds < 5,
                    "Expiration time should be approximately 28 minutes in the future");

            // Verify JWT signature using the public key
            RSAKey publicKey = jwtGenerator.getPublicKey();
            assertNotNull(publicKey, "Public key should not be null");

            RSASSAVerifier verifier = new RSASSAVerifier(publicKey.toRSAPublicKey());
            assertTrue(signedJWT.verify(verifier), "JWT signature should be valid");

        } catch (Exception e) {
            fail("Test failed with exception: " + e.getMessage());
        }
    }

    @Test
    void getPrivateKey() {
        try {
            // Get private key
            RSAKey privateKey = jwtGenerator.getPrivateKey();

            // Verify it's not null
            assertNotNull(privateKey, "Private key should not be null");

            // Verify it contains both private and public parts
            RSAPrivateKey rsaPrivateKey = privateKey.toRSAPrivateKey();
            RSAPublicKey rsaPublicKey = privateKey.toRSAPublicKey();
            assertNotNull(rsaPrivateKey, "RSA private key should not be null");
            assertNotNull(rsaPublicKey, "RSA public key should not be null");

            // Verify it's using the same key pair we provided
            RSAPublicKey publicKeyFromPair = (RSAPublicKey) keyPair.getPublic();
            assertEquals(
                    publicKeyFromPair.getModulus(),
                    rsaPublicKey.getModulus(),
                    "Public key modulus should match");
        } catch (Exception e) {
            fail("Test failed with exception: " + e.getMessage());
        }
    }

    @Test
    void getPublicKey() {
        try {
            // Get public key
            RSAKey publicKey = jwtGenerator.getPublicKey();

            // Verify it's not null
            assertNotNull(publicKey, "Public key should not be null");

            // Verify it contains only public part
            RSAPublicKey rsaPublicKey = publicKey.toRSAPublicKey();
            assertNotNull(rsaPublicKey, "RSA public key should not be null");
            assertNull(publicKey.toRSAPrivateKey(), "Private key part should be null");

            // Verify it's using the same key pair we provided
            RSAPublicKey publicKeyFromPair = (RSAPublicKey) keyPair.getPublic();
            assertEquals(
                    publicKeyFromPair.getModulus(),
                    rsaPublicKey.getModulus(),
                    "Public key modulus should match");

            // Verify it matches the public part from getPrivateKey()
            RSAKey privateKey = jwtGenerator.getPrivateKey();
            assertEquals(
                    privateKey.toRSAPublicKey().getModulus(),
                    rsaPublicKey.getModulus(),
                    "Public key from privateKey should match public key");
        } catch (Exception e) {
            fail("Test failed with exception: " + e.getMessage());
        }
    }
}
