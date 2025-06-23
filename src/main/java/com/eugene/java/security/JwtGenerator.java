package com.eugene.java.security;

import java.nio.charset.StandardCharsets;
import java.security.KeyPair;
import java.security.interfaces.RSAPublicKey;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.UUID;

import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.stereotype.Component;

import com.nimbusds.jose.JOSEObjectType;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;

@Component
public class JwtGenerator {
  private final KeyPair keyPair;

  public JwtGenerator(KeyPair keyPair) {
    this.keyPair = keyPair;
  }

  public String generateDemoJwt() {
    try {
      Instant now = Instant.now();
      Date expireTime = Date.from(now.plus(28, ChronoUnit.MINUTES));
      JWTClaimsSet claimsSet =
          new JWTClaimsSet.Builder()
              .jwtID(UUID.randomUUID().toString())
              .subject("eugene-demo-subject")
              .expirationTime(expireTime)
              .notBeforeTime(Date.from(now))
              .issueTime(Date.from(now))
              .issuer("eugene-java-app")
              .audience("eugene-frontend-app")
              .claim("id", "eugene-user-id")
              .claim("scope", "all")
              .build();
      SignedJWT signedJWT =
          new SignedJWT(
              new JWSHeader.Builder(JWSAlgorithm.RS256).type(JOSEObjectType.JWT).build(),
              claimsSet);
      signedJWT.sign(new RSASSASigner(getCompleteRSAKey()));
      return new String(signedJWT.serialize().getBytes(), StandardCharsets.UTF_8);
    } catch (Exception e) {
      throw new JwtException("Error generating JWT");
    }
  }

  public RSAKey getCompleteRSAKey() {
    return new RSAKey.Builder((RSAPublicKey) keyPair.getPublic())
        .privateKey(keyPair.getPrivate())
        .build();
  }

  public RSAKey getPublicKey() {
    return getCompleteRSAKey().toPublicJWK();
  }
}
