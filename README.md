# Geodesic Microservices Distribution

This is the Geodesic microservices distribution of Helm charts for Kubernetes. 

Geodesic is the fastest way to get up and running with a rock solid, production grade cloud platform. Use [standalone our shell](https://github.com/cloudposse/geodesic/) to get started quickly and avoid dependency hell. It ships with support for [Kubernetes](https://github.com/kubernetes/kubernetes/), [Kops](https://github.com/kubernetes/kops/), [Helm](https://github.com/kubernetes/helm/) and [Terraform](https://github.com/hashicorp/terraform/). 

What makes this distribution special is we've developed these charts to integrate with third party services like Github for authentication (OAuth2) and Duo for MFA. 

## How do I enable these repositories?


### Incubator Repository

To add the `incubator` chart repository to your local `helm` client, run `helm repo add`:

```shell
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/incubator/
"cloudposse-incubator" has been added to your repositories
```

You can then run `helm search cloudposse-incubator` to see the charts.

### Stable Repository

To add the `stable` chart repository to your local `helm` client, run `helm repo add`:

```shell
$ helm repo add cloudposse-incubator https://charts.cloudposse.com/stable/
"cloudposse-stable" has been added to your repositories
```

You can then run `helm search cloudposse-stable` to see the charts.

## How do I install these charts?

After enabling the repositories mentioned above, just run `helm install cloudposse-incubator/$chart`. 

Currently, most of the charts are located in the `incubator/` directory until they reach greater maturity.

## Repository Structure

This GitHub repository contains all the source for the versioned charts released at https://charts.cloudposse.com/ (the Chart Repository). The repository is hosted by AWS CloudFront and backed by S3 for maximum reliability. We also maintain a [standalone Docker container](https://hub.docker.com/r/cloudposse/charts/) that contains all of these charts together with `helm serve` for distributing them inside your cluster. You can self-host this container in kubernetes using our chart for [helm-serve](https://github.com/cloudposse/charts/incubator/helm-serve/).

The Charts in this repository are organized into two folders:

* `stable/`     charts that meet the criteria in the [technical requirements](https://github.com/kubernetes/charts/blob/master/CONTRIBUTING.md#technical-requirements);
* `incubator/`  charts are those that do not meet these criteria

The `stable/` directory in the `master` branch of this repository corresponds to the version of charts packaged and published in the Chart Repository. We also make all previous versions available through the Repository. Every time a *Pull Request* is merged into `master`, it goes through our CI/CD process hosted by [TravisCI](https://travis-ci.org/cloudposse/charts). 

Charts remain in the `incubator/` directory until we feel confident they are functionally stable and their interface will not radically change. Please take this into consideration when deploying services from this directory. We suggest to always pin your charts to a specific version for stability. We also maintain a separate Chart repository for branches and *Pull Requests* that are useful for Chart development. These are located at `https://charts.dev.cloudposse.com/$branch/incubator/$chart`.


## Other Resources

* For the official Kubernetes Charts, go [here](https://github.com/kubernetes/charts/). 
* To get a quick introduction to Charts, see [this chart document](https://github.com/kubernetes/helm/blob/master/docs/charts.md).
* For more information on using Helm, refer to the Helm's [documentation](https://github.com/kubernetes/helm#docs).


## Status of the Project

This project is under active development. We try our best to keep all of our repositories stable (even our incubator charts), but you might run into [issues](https://github.com/cloudposse/charts/issues). Please let us know if you run into any issue, or better yet, contribute a fix or feature.


## About

Most of these are original charts developed by [Cloud Posse, LLC](https://cloudposse.com/). We provide solutions to automate your cloud for 24/7 uptime and maximum efficiency.

The charts are application architectures documented-as-code for Kubernetes Helm. For more information about installing and using Helm, see its [README.md](https://github.com/kubernetes/helm/tree/master/README.md). 


## Help

**Got a question?** 

File a GitHub [issue](https://github.com/cloudposse/geodesic/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/bastion/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing Geodesic, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!

Here's how to get started...

1. `git clone https://github.com/cloudposse/charts.git` to pull down the repository 
2. `make init` to initialize the [`build-harness`](https://github.com/cloudposse/build-harness/)
3. `make helm:repo:add-remote` to add the repositories to your local helm repository (*optional*)
4. Just run `make` to generate all packages and corresponding repository indexes.

## Our Best Practices:

* Use OAuth2 everywhere possible (default to [Github](https://developer.github.com/v3/oauth/))
* Use MFA (two factor) everywhere possible (default to [Duo](https://guide.duo.com (https://guide.duo.com/)))
* Use Annotations everywhere possible
    * IAM Roles
    * Route53 DNS
    * TLS
* Use Ingress resources 
* Decompose Charts into Subcharts as much as possible
* Re-use *official* charts where it makes the most sense
* Bump Chart versions any time there is a material change
* Use sane-defaults everywhere possible


## License

[APACHE 2.0](LICENSE) © 2016-2017 [Cloud Posse, LLC](https://cloudposse.com)

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at
     
      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

## About

Geodesic is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)! 

See [our other projects][community] or [hire us][hire] to help build your next cloud-platform.

  [website]: http://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: http://cloudposse.com/contact/
  
### Contributors


| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Igor Rodionov][igor_img]][igor_web]<br/>[Igor Rodionov][igor_web] |
|-------------------------------------------------------|------------------------------------------------------------------|

  [erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
  [erik_web]: https://github.com/osterman/
  [igor_img]: http://s.gravatar.com/avatar/bc70834d32ed4517568a1feb0b9be7e2?s=144
  [igor_web]: https://github.com/goruha/


