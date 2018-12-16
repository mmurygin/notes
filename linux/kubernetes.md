# Kubernetes

## Inspect
1. **`kubectl cluster-info`** - get info about cluster
1. **`kubectl get resource_type`** - list resources (_pods_, _nodes_, _deployments_)
1. **`kubectl describe resource_type[/resource_id]`** - show detailed information about a resource
1. **`kubectl logs resource_id`** - get logs from a container in a pod (if we have only one container inside a pod we can specify only pod name)
1. **`kubectl exec resource_id`** - execute a command on a container in a pod
