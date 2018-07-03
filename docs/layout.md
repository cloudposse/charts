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
  $ helm repo add cloudposse-stable https://charts.cloudposse.com/stable/
  "cloudposse-stable" has been added to your repositories
  ```

  You can then run `helm search cloudposse-stable` to see the charts.

  ## Repository Structure

  This GitHub repository contains all the source for the versioned charts released at https://charts.cloudposse.com/ (the Chart Repository). The repository is hosted by AWS CloudFront and backed by S3 for maximum reliability. We also maintain a [standalone Docker container](https://hub.docker.com/r/cloudposse/charts/) that contains all of these charts together with `helm serve` for distributing them inside your cluster. You can self-host this container in kubernetes using our chart for [helm-serve](https://github.com/cloudposse/charts/incubator/helm-serve/).

  The Charts in this repository are organized into two folders:

  * `stable/`     charts that meet the criteria in the [technical requirements](https://github.com/kubernetes/charts/blob/master/CONTRIBUTING.md#technical-requirements);
  * `incubator/`  charts are those that do not meet these criteria

  The `stable/` directory in the `master` branch of this repository corresponds to the version of charts packaged and published in the Chart Repository. We also make all previous versions available through the Repository. Every time a *Pull Request* is merged into `master`, it goes through our CI/CD process hosted by [TravisCI](https://travis-ci.org/cloudposse/charts).

  Charts remain in the `incubator/` directory until we feel confident they are functionally stable and their interface will not radically change. Please take this into consideration when deploying services from this directory. We suggest to always pin your charts to a specific version for stability. We also maintain a separate Chart repository for branches and *Pull Requests* that are useful for Chart development. These are located at `https://charts.dev.cloudposse.com/$branch/incubator/$chart`.

  ## Status of the Project

  This project is under active development. We try our best to keep all of our repositories stable (even our incubator charts), but you might run into [issues](https://github.com/cloudposse/charts/issues). Please let us know if you run into any issue, or better yet, contribute a fix or feature.
