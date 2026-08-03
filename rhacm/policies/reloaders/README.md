# ACM Policies - Reloaders

The ACM Policies in this folder provide the functionality to automatically rollout new Pods when ConfigMaps or Secrets change.

By default, the Reloader Policies target All Kubernetes/OpenShift Clusters via the `all-clusters` PolicySet/Placement/PlacementBinding.

## Examples

```yaml
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: reload-test
  labels:
    function.kemo.dev/reloader: enabled # This label is what ACM matches for inclusion
    reloader.kemo.dev/target-type: deployment # target-type supports deployment, statefulset, and daemonset
    reloader.kemo.dev/target: http # target is the name of the target-type
data:
  foo: bar
```

```yaml
---
kind: Secret
apiVersion: v1
metadata:
  name: reload-test
  labels:
    function.kemo.dev/reloader: enabled # This label is what ACM matches for inclusion
    reloader.kemo.dev/target-type: statefulset # target-type supports deployment, statefulset, and daemonset
    reloader.kemo.dev/target: http # target is the name of the target-type
stringData:
  bob: barker
```

```yaml
---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: http
spec:
  replicas: 1
  selector:
    matchLabels:
      app: http
  template:
    metadata:
      labels:
        app: http
    spec:
      containers:
        - name: container
          image: 'registry.access.redhat.com/ubi8/httpd-24:1785716939'
          ports:
            - containerPort: 8080
              protocol: TCP
          env:
            - name: ENV_FOO
              valueFrom:
                configMapKeyRef:
                  name: reload-test
                  key: foo
          resources:
            limit:
              cpu: 250m
              memory: 256Mi
            request:
              cpu: 125m
              memory: 128Mi
          imagePullPolicy: Always
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
  strategy:
    type: Recreate
```