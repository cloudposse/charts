## configure stable repo
helm repo rm cloudposse-stable 2>/dev/null
helm repo add cloudposse-stable http://charts.cloudposse.com/stable/packages/

## configure incubator repo
helm repo rm cloudposse-incubator 2>/dev/null
helm repo add cloudposse-incubator http://charts.cloudposse.com/incubator/packages/

## display configured repos
helm repo list
