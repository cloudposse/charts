# Keycloak-gatekeeper

[Keycloak gatekeeper](https://github.com/keycloak/keycloak-gatekeeper) is an authentication proxy service which at the risk of stating the obvious integrates with the Keycloak authentication service.

## TL;DR

```bash
helm install gabibbo97/keycloak-gatekeeper \
    --set discoveryURL=https://keycloak.example.com/auth/realms/myrealm \
    --set upstreamURL=http://my-svc.my-namespace.svc.cluster.local:8088 \
    --set ClientID=myOIDCClientID \
    --set ClientSecret=deadbeef-b000-1337-abcd-aaabacadaeaf \
    --set ingress.enabled=true \
    --set ingress.hosts[0]=my-svc-auth.example.com
```

## Upgrade notes

From `2.x.0` to `2.1.0`
From `1.5.x` to `1.6.0`

The deployment has to be deleted and readded due to the [immutability of the selector field](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#label-selector-updates)

## Introduction

This chart bootstraps an authenticating proxy for a service.

Users accessing this service will be required to login and then they will be granted access to the backend service.

This can be used with Kubernetes-dashboard, Grafana, Jenkins, ...

## Configuration options

| Parameter                     | Description                                                  |                Default                 |
| ----------------------------- | ------------------------------------------------------------ | :------------------------------------: |
| `image.repository`            | docker image repo                                            | `quay.io/keycloak/keycloak-gatekeeper` |
| `image.pullPolicy`            | docker image pull policy                                     |              IfNotPresent              |
| `discoveryURL`                | URL for OpenID autoconfiguration                             |                   ``                   |
| `upstreamURL`                 | URL of the service to proxy                                  |                   ``                   |
| `skipUpstreamTlsVerify`       | URL of the service to proxy                                  |                   ``                   |
| `skipOpenidProviderTlsVerify` | skip OpenID provider url tls verification                    |                `false`                 |
| `ClientID`                    | Client ID for OpenID server                                  |                   ``                   |
| `ClientSecret`                | Client secret for OpenID server                              |                   ``                   |
| `scopes`                      | Additional required scopes for authentication                |                  `[]`                  |
| `addClaims`                   | Set these claims as headers in the request for the backend   |                  `[]`                  |
| `matchClaims`                 | Key-Value pairs that the JWT should contain                  |                  `{}`                  |
| `rules`                       | Specify fine grained rules for authentication                |                  `[]`                  |
| `forwarding.enable`           | Enable the forward proxy mode                                |                `false`                 |
| `forwarding.generateSecret`   | Set to false to provide secret manually                      |                 `true`                 |
| `forwarding.username`         | Username to use to authenticate with IDP                     |                   ``                   |
| `forwarding.password`         | Password to use to authenticate with IDP                     |                   ``                   |
| `forwarding.domains`          | Domains that will be injected, empty to inject in any domain |                  `[]`                  |
| `defaultDeny`                 | Enable a default denial on all requests                      |                 `true`                 |
| `logging`                     | Enable http logging of the requests                          |                 `true`                 |
| `refreshTokens`               | Enables the handling of the refresh tokens                   |                 `true`                 |
| `sessionCookies`              | Set access and refresh tokens to be session only             |                 `true`                 |
| `droolsPolicyEnabled`         | Enable support for Drools Policies (tech preview)            |                `false`                 |
| `debug`                       | Use verbose logging                                          |                `false`                 |
| `extraArgs`                   | Additional command line arguments (as `option=value`)        |                  `[]`                  |
| `extraEnvs`                   | Additional `env` configuration for Container                 |                   ``                   |
| `podAnnotations`              | Additional annotations to add to the pod template            |                   ``                   |

See also the configuration variables used in [ingress.yaml](templates/ingress.yaml)

## Setting up Keycloak

After having installed Keycloak from its [Helm chart](https://github.com/helm/charts/tree/master/stable/keycloak)

* Create a client in Keycloak with protocol `openid-connect` and access-type: `confidential`
  * Add a redirect URL to `<SCHEME>://<PROXY_HOST>/oauth/callback`
  * Get the `ClientID` and `ClientSecret` from the `Credentials`
* Goto to the "Client Scopes" menu
  * Add a new client scope and enter its settings afterwards
  * enter Mappers tab and create new protocol with mapper type  `audience`
    * select your client in "Included Client Audience"
    * set "Add to access token" to "On"
* Add a new user
  * Set a password in the "Credentilas" tab
* In "Roles" menu add a new role "user" and add the created user to the role

You can now use this new client from keycloak-gatekeeper and login with your created user and password

## Fine grained rules for authentication

This chart allows to specify rules inside of the `resource` array, these can be used to fine-tweak your authentication endpoints

Each element of `resource` is a `|` (pipe separator) delimited list of key, value pairs.

Here is a non exhaustive list of key-value pairs

|        Example        | Description                                                        |
| :-------------------: | ------------------------------------------------------------------ |
|    uri=/private/*     | require access to subpaths of /private                             |
|   roles=admin,user    | require the user to have both roles to access                      |
| require-any-role=true | combined with roles above, switches the conditional from AND to OR |
|   white-listed=true   | allow anyone to have access                                        |
|   methods=GET,POST    | apply authentication to these methods                              |

## Example

```yaml
resources:
- "uri=/admin*|roles=admin,root|require-any-role=true"
- "uri=/public*|white-listed=true"
- "uri=/authenticated/users|roles=user"
```

This sets up

* Paths under `/admin` to be accessible only from admins or root
* Paths under `/public` to be accessible by anyone
* Path `/authenticated/users` is accessible only from users

## Forward proxy mode

In this mode Keycloak Gatekeeper will connect with the upstream identity provider to acquire an access token that will be added to every request matching the requested domain.

The mode of operation can be seen in the schema below

```
DumbSVC     KeycloakGatekeeper SVCWithAuth IDP
   |--SVCWithAuth-->
                   |-----------Auth--------->
                   <----------Token---------|
                   |--SVCWithAuth-->
                   <----Reply------|
   <-----Reply-----|
```

Many Go microservices use the variable `HTTP_PROXY` to identify the proxy to use.

## Troubleshooting

### Resolving "JWT claims invalid: invalid claims, cannot find 'client_id' in 'aud' claim"

In the Keycloak admin console:

- Realm -> Client Scopes -> "roles" -> edit
- Mappers -> Create -> Script Mapper
- Protocol OIDC, Name: `aud-bug-workaround-script`

Add the following script:

```javascript
// add current client-id to token audience
token.addAudience(token.getIssuedFor());

// return token issuer as dummy result assigned to iss again
token.getIssuer();
```

Token Claim Name: iss
Add to ID Token: on
Add to access token: on
Add to userinfo: off

Note that you might need to add `-Dkeycloak.profile.feature.scripts=enabled` to Keycloak options

See [the upstream bug tracker for more details about this workaround](https://issues.jboss.org/browse/KEYCLOAK-8954)

### Getting a 403 after successful login

Keycloak Gatekeeper log will say something like:

```unable to verify the id token {"error": "oidc: JWT claims invalid: invalid claims, 'aud' claim and 'client_id' do not match, aud=account, client_id=your-client"}```

Add the client scope as mentioned above in Keycloak setup section
