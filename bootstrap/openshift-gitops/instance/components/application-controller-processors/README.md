# Application Controller Process Tuning

> From: https://blog.stderr.at/gitopscollection/2026-03-27-openshift-gitops-performance-tuning/#_controller_performance_tuning_command_line_parameters

## controller.processors.status (Default: 20) 

This setting controls the number of concurrent status processors. That is, how many applications the controller can compare at once.

### Problem

If you have 500 applications, a default of 20 processors means the controller evaluates only 20 at a time. During a mass reconciliation (for example, a webhook firing for a monorepo), the remaining 480 applications wait in the reconciliation queue. You will notice drift detection becoming very slow.

### Solution

- Increase this value (for example, to 50 or 100 when you run more than 1,000 applications) so the controller can drain the queue faster, especially if refreshes in the UI feel slow.
- Disadvantage: Higher CPU and memory use on the application controller Pod.
- Advantage: Argo CD detects drift and refreshes status in the UI much faster in large environments.

## controller.processors.operation (Default: 10) 

While status processors compare desired and live state, this setting controls the number of concurrent operation processors for actual sync runs.

### Problem

If you trigger a mass sync of 100 applications at once but only 10 operation processors are configured, Argo CD runs 10 syncs, waits for them to finish, starts the next 10, and so on. Applications stay in Waiting or Pending in the UI until their turn starts.

### Solution

- Increase this value when many applications sync or run operations at the same time and the operation queue backs up (pending syncs, slow operation phase). Monitor controller CPU and memory — you need headroom for the extra parallelism.
- Disadvantage: Higher CPU and memory use on the application controller Pod.
- Advantage: Argo CD can apply manifests to the Kubernetes API for many applications at the same time.