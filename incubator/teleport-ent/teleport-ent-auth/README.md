# teleport-ent-auth

teleport-ent-auth is the [auth service](https://gravitational.com/teleport/docs/architecture/#teleport-services) 
for Teleport enterprise edition. This service provides authentication 
and authorization service to proxies and nodes. 
It is the certificate authority (CA) of a cluster and the storage for
audit logs. It is the only stateful component of a Teleport cluster and 
depends on DynamoDB and S3.
