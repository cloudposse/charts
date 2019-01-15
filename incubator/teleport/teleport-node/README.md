# teleport-node

teleport-node is the [node service](https://gravitational.com/teleport/docs/architecture/#teleport-services) for Teleport. 
It provides SSH access to hosts and is deployed as a daemonset.

## How it works

The Daemonset provides a vehicle for deployment Teleport to all hosts, but does not run the Teleport service. 

The daemonset runs the docker image which performs the following:

- mount host volume to `/host`
- copy config files to the host
- install the `teleport-node.service` systemd unit on the host
- start the teleport-node service on the host
- tail the logs of the teleport-node service
