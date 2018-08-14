# NFS Provisioner

The NFS Provisioner is a dynamic provisioner for Kubernetes 1.4.
You can use it to quickly & easily deploy shared storage that works almost anywhere.

It's based on the version by @ekozan, which can be found here: 
   https://github.com/ekozan/charts/tree/nfs-provisioner/incubator/nfs-provisioner


## Prerequisites Details
* Kubernetes 1.4 with alpha APIs enabled

## Chart Details
This chart will do the following:

* Setup a functional nfs provisioner

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator
$ helm install --name my-release cloudposse-incubator/nfs-provisioner
```

## Configuration

The following tables lists the configurable parameters of the etcd chart and their default values.


| Parameter                  | Description                            | Default                                                    |
| -------------------------- | -------------------------------------- | ---------------------------------------------------------- |
| `image`                    | Container image name                   | `quay.io/kubernetes_incubator/nfs-provisioner`             |
| `imageTag`                 | Container image tag                    | `v1.0.1`                                                   |
| `provisionerName`          | Provisoner Name                        | `cluster.local/nfs`                                        |
| `storageClass`             | The provisioner storage Class          | `local-nfs`                                                |
| `defaultClass`             | Set-up as default class                | `false`                                                    |
| `serviceIp`                | Setup the service ip                   | ``                                                         |
| `persistence.storageClass` | Storage class of backing PVC           | `generic`                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/nfs-provisioner
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Consume nfs volumes

Create PVC resource with correct storage class

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: nfs-volume
  annotations:
    volume.beta.kubernetes.io/storage-class: "local-nfs"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

and attach it to pod as usual PVC

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: some-app
        image: "nginx:alpine"
        volumeMounts:
          - mountPath: /var/www/html
            name: nfs-pvc
      volumes:
      - name: nfs-pvc
        persistentVolumeClaim:
          claimName: nfs-volume
```
