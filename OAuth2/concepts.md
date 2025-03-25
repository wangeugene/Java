# Concepts related to OAuth 2.0 Framework

## Definition:

OAuth: Open Authorization

OAuth 2.0 (Open Authorization) is a protocol that allows applications to access user data without exposing their credentials.

ODIC: OpenID Connect is an extension to OAuth 2.0 that provides user authentication.
JWT: JSON Web Token is a compact, URL-safe means of representing claims to be transferred between two parties.
OAuth Server: The server that issues access tokens to the client after successfully authenticating the resource owner and obtaining authorization.
Resource Server: The server hosting the protected resources, capable of accepting and responding to protected resource requests using access tokens.

### Tokens

ID Token: A token that contains user information and is used by the client to authenticate the user. (OpenID Connect Only)
OPAQUE Token: A token that is not self-contained and requires the client to make a request to the OAuth server to validate the token.
ACCESS Token: A token that is used by the client to access protected resources on behalf of the user.
REFRESH Token: A token that is used by the client to obtain a new access token when the current access token expires.
