# Application controller: Sharding (horizontal scaling)

> From: https://blog.stderr.at/gitopscollection/2026-03-27-openshift-gitops-performance-tuning/#setting-controller-sharding

When you investigate performance issues, sharding is often one of the first topics you meet. Sharding scales the application controller horizontally by distributing work across multiple controller replicas automatically.

When a single application controller reconciles too many applications across too many clusters, it becomes the bottleneck: high CPU and memory use, long reconcile queues, Kubernetes API throttling, and pressure on the repo server. Sharding splits that work across multiple controller replicas. Each replica has a shard index and reconciles only applications whose destination clusters map to that shard.

Implicitly, this means that sharding only makes sense if you have more than one cluster in your environment.

## How it works (conceptually)

- You run N application-controller replicas (typically a StatefulSet so each pod has a stable identity).
- Argo CD assigns every registered cluster (including the in-cluster deployment) to exactly one shard using a distribution function. The controller for shard K ignores clusters that are not mapped to K.
- Applications are processed by the shard that owns their destination cluster.

## Distribution algorithms

The following algorithms are supported. Configure them with the ARGOCD_CONTROLLER_SHARDING_ALGORITHM (at spec.controller.env) environment variable when you use the OpenShift GitOps Operator, or with controller.sharding.algorithm in argocd-cmd-params-cm ConfigMap:

- `legacy` — stable hash from cluster ID; simple, but shards can be unbalanced (some busier than others). Kept for compatibility.
- `round-robin` — tends to spread clusters more evenly across shards; often a better default when you scale out.
- `consistent-hashing` — can improve balance further in some large, multi-cluster setups; cluster placement can reshuffle when the number of shards changes.

The OpenShift GitOps documentation does not explicitly mention consistent-hashing, which often indicates limited or unsupported use on that distribution. If you set ARGOCD_CONTROLLER_SHARDING_ALGORITHM under spec.controller.env, Argo CD still reads whatever value you supply—verify against your operator version before relying on it in production.

## Why it improves performance 

- Parallelism across nodes: More controller pods mean more CPU and memory headroom in aggregate.
- Smaller per-shard work: Each replica handles fewer clusters and fewer applications.
- Better fit for hub-and-spoke: On a management cluster with many spoke clusters, sharding is the usual way to scale past what one controller can sustain.

## Trade-offs

- Operational complexity: More pods to monitor; you must ensure every shard stays healthy.
- Not a substitute for repo-server tuning: If manifest generation or Git is the bottleneck, sharding the controller alone will not fix it.
- Only useful if you have more than one cluster in your environment.

---

## Standalone Argo CD 

- Install the high-availability layout so the application controller is a StatefulSet (not a single-replica Deployment).
- Set replicas on that StatefulSet to the number of shards you want - each replica is one shard.
- Configure controller.sharding.algorithm in argocd-cmd-params-cm (for example round-robin).
- Ensure each pod receives ARGOCD_CONTROLLER_REPLICAS (total shard count) and ARGOCD_CONTROLLER_SHARD (this pod’s index).
