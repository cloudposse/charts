# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the [Jenkins Kubernetes plugin](https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin)

## Credit
This Chart was forked from https://github.com/kubernetes/charts/blob/master/stable/jenkins/ in order to provide the Cloud Posse flavor of CI/CD for Kubernetes. It's based largely on the effort of Lachlan Evenson, Vic Iglesias to produce the original Chart, who were inspired by the awesome work of Carlos Sanchez <carlos@apache.org>.


## Chart Details
This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release cloudposse-incubator/jenkins
```

## Configuration

The following tables lists the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `Master.Name`              | Jenkins master name                | `jenkins-master`                                           |
| `Master.Image`             | Master image name                  | `cloudposse/jenkins`                                       |
| `Master.ImageTag`          | Master image tag                   | `v0.1.0`                                                   |
| `Master.ImagePullPolicy`   | Master image pull policy           | `Always`                                                   |
| `Master.Component`         | k8s selector key                   | `jenkins-master`                                           |
| `Master.Cpu`               | Master requested cpu               | `200m`                                                     |
| `Master.Memory`            | Master requested memory            | `256Mi`                                                    |
| `Master.ServicePort`       | k8s service port                   | `8080`                                                     |
| `Master.ContainerPort`     | Master listening port              | `8080`                                                     |
| `Master.SlaveListenerPort` | Listening port for agents          | `50000`                                                    |

### Jenkins Agent

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Agent.Image`           | Agent image name                   | `jenkinsci/cloudposse-slave`                               |
| `Agent.ImageTag`        | Agent image tag                    | `2.52`                                                     |
| `Agent.ImagePullPolicy` | Agent image pull policy            | `Always`                                                   |
| `Agent.Cpu`             | Agent requested cpu                | `200m`                                                     |
| `Agent.Memory`          | Agent requested memory             | `256Mi`                                                    |

### Github OAuth 

| Parameter                     | Description                        | Default                                         |
| ----------------------------- | ---------------------------------- | ----------------------------------------------- |
| `Github.OAuth.ClientID`       | GitHub OAuth Client ID             | **REQUIRED**                                    |
| `Github.OAuth.ClientSecret`   | GitHub OAuth Client Secret         | **REQUIRED**                                    |
| `Github.Organization`         | Github Organization                | **REQUIRED**                                    |
| `Github.Admins`               | Github Usernames for Jenkins Admin | **REQUIRED**                                    |

### Ingress

| Parameter                     | Description                        | Default                                         |
| ----------------------------- | ---------------------------------- | ----------------------------------------------- |
| `DNS.Hostname`                | Hostname to associate with Service | **REQUIRED**                                    |
| `DNS.TTL`                     | Time-to-Live                       | 300                                             |
| `DNS.Type`                    | Resource Record Type               | `CNAME`                                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A Persistent Volume
Claim is used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

# Todo
* Enable Docker-in-Docker or Docker-on-Docker support on the Jenkins agents
