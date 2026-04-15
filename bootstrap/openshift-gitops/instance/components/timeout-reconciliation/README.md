# Timeout Reconciliation

> From: https://blog.stderr.at/gitopscollection/2026-03-27-openshift-gitops-performance-tuning/#_controller_performance_tuning_configmap

## timeout.reconciliation (Default: 3m) 

With this setting you control the default polling interval for Argo CD. It defines how often Argo CD wakes up to compare the desired state in Git with the live state in your Kubernetes cluster.

### Problem

If you do not have Git webhooks configured, Argo CD relies on a pull-based mechanism. By default, every three minutes the application controller connects to the repo server to check Git for new commits. In a cluster with thousands of applications, polling every three minutes creates a sustained, heavy baseline load on both the application controller (CPU and memory) and the repo server (network and Git API traffic), even when nothing has changed in your repositories.

### Solution

By increasing this value (for example, 600s for 10 minutes, or even 3600s for one hour), you reduce that background load and CPU overhead on the controller and repo server.

In combination with Git webhooks, this setting is one of the most important performance tweaks you can apply.

**Disadvantage**: If you do not use Git webhooks, new commits are detected and applied more slowly (by up to the reconciliation interval).

**Advantage**: A large reduction in baseline CPU, memory, and network usage—a crucial performance tweak for large clusters.

---

## timeout.reconciliation.jitter (Default: 60s)

This setting works together with timeout.reconciliation. It defines the maximum random delay (a jitter) that Argo CD may add when scheduling each application’s periodic Git poll. The controller picks a value between zero and this maximum so that not every Application wakes up at the same instant.

### Problem

If thousands of applications share the same base reconciliation interval, their refresh work can align in time. That creates periodic spikes of load on the application controller, the repo server, and your Git provider — even when nothing has changed.

### Solution

Keep a non-zero jitter that is a reasonable fraction of timeout.reconciliation (upstream examples often use 60s jitter alongside a 120s base interval; see the FAQ). When you increase the poll interval for performance, adjust jitter so you still spread work rather than synchronizing every long interval.

**Disadvantage**: Each app’s next poll is a bit less predictable.

**Advantage**: Smoother average load and fewer peak loads than setting jitter to 0s.
