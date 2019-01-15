# Teleport

Helm charts to install Teleport services under Kubernetes

Teleport Admin Guide: https://gravitational.com/teleport/docs/admin-guide

## Configuration

The Teleport charts depend on secrets being available in SSM Parameter Store. Use the the [set-config.sh](set-config.sh) script to store the values.

### Tokens

The Teleport Proxy and Node services rely on a static token to authenticate with the Teleport Auth service. Installation of the chart requires these tokens be available in Parameter Store.


Use `set-config.sh` to store the tokens as follows:

```
set-config.sh "auth_token" "`pwgen -1 32 1`"
set-config.sh "proxy_token" "`pwgen -1 32 1`"
set-config.sh "node_token" "`pwgen -1 32 1`"
```

Teleport also needs a `cluster_token` which allows this cluster to federate with another. Obtain the token and store it:

```
set-config.sh "cluster_token" "CLUSTER_TOKEN"
```

### License

Teleport Auth requires a license file to start. Obtain this from our Teleport account and store it;

```
set-config.sh "license" "<multi-line license>"
```

### Okta/SAML Config

Enabling the Okta integration requires obtaining the Okta IDP Metadata XML from Okta and storing it in Parameter Store.

```
# Note: Use single quotes ' arounds the xml document to preserve nested quotations
set-config.sh "saml_entity_descriptor" '<okta IDP metadata xml>'
```
