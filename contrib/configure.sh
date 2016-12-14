## configure stable repo
helm repo rm cloudposse-stable 2>/dev/null
helm repo add cloudposse-stable  https://cloudposse.github.io/charts/stable/packages/

## configure incubator repo
helm repo rm cloudposse-incubator 2>/dev/null
helm repo add cloudposse-incubator  https://cloudposse.github.io/charts/incubator/packages/

## display configured repos
helm repo list
