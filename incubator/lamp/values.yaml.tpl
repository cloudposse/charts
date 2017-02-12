# Default values for lamp.
# This is a YAML-formatted file. It was automatically generated from values.yaml.tpl
#
# Declare variables to be passed into your templates.
#

DNS:
  Hostname: "{{ getenv "DNS_HOSTNAME" }}"
  TTL: "{{ getenv "DNS_TTL" "300" }}"
  Type: "{{ getenv "DNS_TYPE" "CNAME" }}"

storage:
  name: "{{ getenv "RELEASE_NAME" "release" }}"
  size: "{{ getenv "STORAGE_SIZE" "3Gi" }}"
  class: "{{ getenv "STORAGE_CLASS" "local-nfs" }}"

mysql:
  ## mysql image version
  ## ref: https://hub.docker.com/r/library/mysql/tags/
  ##
  imageTag: "5.7.14"

  ## Specify password for root user
  ##
  ## Default: random 10 character string
  # mysqlRootPassword: testing

  ## Create a database user
  ##
  mysqlUser: "{{ getenv "DB_USER" "app" }}"
  mysqlPassword: "{{ getenv "DB_PASS" "" }}"

  ## Allow unauthenticated access, uncomment to enable
  ##
  # mysqlAllowEmptyPassword: true

  ## Create a database
  ##
  mysqlDatabase: "{{ getenv "DB_NAME" "default" }}"

  ## Specify an imagePullPolicy (Required)
  ## It's recommended to change this to 'Always' if the image tag is 'latest'
  ## ref: http://kubernetes.io/docs/user-guide/images/#updating-images
  ##
  imagePullPolicy: IfNotPresent

  ## Persist data to a persitent volume
  persistence:
    enabled: true
    ## If defined, volume.beta.kubernetes.io/storage-class: <storageClass>
    ## Default: volume.alpha.kubernetes.io/storage-class: default
    ##
    # storageClass:
    accessMode: ReadWriteOnce
    size: 8Gi

  ## Configure resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ##
  resources:
    requests:
      memory: 256Mi
      cpu: 100m

apache:
  replicaCount: {{ getenv "APACHE_REPLICA_COUNT" "1" }}
  env:
    APACHE_SERVER_NAME:                       localhost

    APACHE_WORKER_START_SERVERS:              2
    APACHE_WORKER_MIN_SPARE_THREADS:          2
    APACHE_WORKER_MAX_SPARE_THREADS:          10
    APACHE_WORKER_THREAD_LIMIT:               64
    APACHE_WORKER_THREADS_PER_CHILD:          25
    APACHE_WORKER_MAX_REQUEST_WORKERS:        4
    APACHE_WORKER_MAX_CONNECTIONS_PER_CHILD:  0

    APACHE_EVENT_START_SERVERS:             2
    APACHE_EVENT_MIN_SPARE_THREADS:         25
    APACHE_EVENT_MAX_SPARE_THREADS:         75
    APACHE_EVENT_THREAD_LIMIT:              64
    APACHE_EVENT_THREADS_PER_CHILD:         25
    APACHE_EVENT_MAX_REQUEST_WORKERS:       150
    APACHE_EVENT_MAX_CONNECTIONS_PER_CHILD: 0

    PHP_FPM_PM:                   ondemand
    PHP_FPM_MAX_CHILDREN:         10
    PHP_FPM_START_SERVERS:        1
    PHP_FPM_SPARE_SERVERS:        1
    PHP_FPM_MAX_SPARE_SERVERS:    10
    PHP_FPM_PROCESS_IDLE_TIMEOUT: 25s
    PHP_FPM_MAX_REQUESTS:         500

    DB_USER: "{{ getenv "DB_USER" "app" }}"
    DB_PASS: "{{ getenv "DB_PASS" "" }}"
    DB_NAME: "{{ getenv "DB_NAME" "default" }}"
    DB_HOST: "{{ getenv "RELEASE_NAME" "default" }}-mysql"

  mounts:
    # Volume name must match the regex [a-z0-9]([-a-z0-9]*[a-z0-9])? (e.g. 'my-name' or '123-abc')
    data: 
      # Path inside container
      path: /var/www/html 
      # k8s specific configs https://kubernetes.io/docs/user-guide/volumes/
      volume: 
        persistentVolumeClaim:
          claimName: {{ getenv "RELEASE_NAME" "release"}}

  image:
    repository: cloudposse/apache-php-fpm
    tag: latest
    pullPolicy: Always

  service:
    name: apache
    type: ClusterIP
    externalPort: 80
    internalPort: 80

  resources:
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 128Mi

vps:
  shell:
    user: admin
    password:
    group: admin
    enableSudo: true
    githubUsers:
    env:

  ## Mounts
  mounts:
    # Volume name must match the regex [a-z0-9]([-a-z0-9]*[a-z0-9])? (e.g. 'my-name' or '123-abc')
    data: 
      # Path inside container
      path: /data 
      # k8s specific configs https://kubernetes.io/docs/user-guide/volumes/
      volume: 
        persistentVolumeClaim:
          claimName: {{ getenv "RELEASE_NAME" "release"}}
  image:
    repository: cloudposse/ubuntu-vps
    tag: latest
    pullPolicy: Always

  service:
    name: ssh
    type: ClusterIP
    externalPort: 22
    internalPort: 22

  resources:
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 128Mi