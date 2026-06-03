# Redis

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.8.0](https://img.shields.io/badge/AppVersion-8.8.0-informational?style=flat-square)

A Helm chart for running Redis on Kubernetes with optional Sentinel HA mode, TLS, and metrics exporter support.

## TL;DR

```bash
helm repo add voyvodov https://voyvodov.github.io/helm-charts/
helm install my-release voyvodov/redis
```

## Prerequisites

- Kubernetes cluster
- Helm 3.x
- Dynamic storage provisioner if you use dynamic PVC creation (`storage.requestedSize`)
- cert-manager if you enable TLS and want certificate provisioning

## Install

```bash
helm install my-release voyvodov/redis
```

Or from source:

```bash
helm install my-release ./charts/redis
```

## Upgrade

```bash
helm upgrade my-release voyvodov/redis
```

## Uninstall

```bash
helm uninstall my-release
```

## Deployment Modes

### Non-HA (default)

- Set `haMode.enabled: false` (default)
- Runs a single Redis server pod
- Exposes Redis on `service.serverPort` (default `6379`)
- Uses a StatefulSet by default (`useDeploymentWhenNonHA: false`)
- Can use Deployment instead by setting `useDeploymentWhenNonHA: true`

### HA with Sentinel

- Set `haMode.enabled: true`
- Runs `haMode.replicas` pods (default `3`)
- Each pod runs:
  - Redis server
  - Redis Sentinel
- Exposes Sentinel on `service.sentinelPort` (default `26379`)

## Rendered Resources

| Resource | Kind | Condition |
|----------|------|-----------|
| `<fullname>` | Service | Always |
| `<fullname>-headless` | Service | Always |
| `<fullname>` | ConfigMap | Always |
| `<fullname>-scripts` | ConfigMap | Always |
| `<fullname>` | StatefulSet | Always, except when non-HA + `useDeploymentWhenNonHA: true` |
| `<fullname>` | Deployment | Only when non-HA + `useDeploymentWhenNonHA: true` |
| `<fullname>` | PersistentVolumeClaim | Only when non-HA + `useDeploymentWhenNonHA: true` + `storage.requestedSize` set + no `storage.persistentVolumeClaimName` |
| `<serviceAccountName>` | ServiceAccount | `serviceAccount.create: true` |
| `<fullname>-metrics` | Service | `metrics.enabled: true` and `metrics.service.enabled: true` |
| `<fullname>-tls` | Certificate | `tls.enabled: true` |

## Important Values

### Naming and Image

| Key | Default | Description |
|-----|---------|-------------|
| `nameOverride` | `""` | Override chart name part |
| `fullnameOverride` | `""` | Override full resource name |
| `image.registry` | `docker.io` | Redis image registry |
| `image.repository` | `redis` | Redis image repository |
| `image.tag` | `""` | Redis image tag (`appVersion` is used when empty) |
| `image.pullPolicy` | `IfNotPresent` | Pull policy |
| `imagePullSecrets` | `[]` | Image pull secrets |

### Services

| Key | Default | Description |
|-----|---------|-------------|
| `service.type` | `ClusterIP` | Main service type (ignored in HA where service is ClusterIP) |
| `service.serverPort` | `6379` | Redis service port |
| `service.sentinelPort` | `26379` | Sentinel service port |
| `service.nodePort` | `null` | NodePort when service type requires it |
| `service.clusterIP` | `null` | Fixed ClusterIP |
| `service.loadBalancerIP` | `null` | LoadBalancer IP |
| `service.loadBalancerSourceRanges` | `[]` | Allowed CIDR ranges for LoadBalancer |

### Redis

| Key | Default | Description |
|-----|---------|-------------|
| `redis.authentication.enabled` | `true` | Enable Redis password auth |
| `redis.authentication.secretRef.name` | `""` | Secret containing the auth password |
| `redis.authentication.secretRef.key` | `redis-password` | The key in the secret with the auth password |
| `redis.authentication.acl.enabled` | `false` | Enable ACL mode |
| `redis.authentication.acl.existingSecret` | `""` | Secret containing key `redis-acl` |
| `redis.persistence.snapshot.enabled` | `false` | Enable RDB snapshots |
| `redis.persistence.aof.enabled` | `false` | Enable AOF persistence |
| `redis.persistence.aof.appendfsync` | `everysec` | AOF fsync policy |
| `redis.args` | `[]` | Extra args for `redis-server` |
| `redis.config` | empty | Extra Redis config appended to generated config |
| `redis.extraEnvSecrets` | `[]` | Secrets exposed as env in Redis container |
| `redis.extraSecrets` | `[]` | Extra secret volumes mounted to Redis container |
| `redis.extraConfigs` | `[]` | Extra configMap volumes mounted to Redis container |
| `redis.extraSecretConfigs` | empty | Secret mounted and appended to Redis config |

### Sentinel and HA

| Key | Default | Description |
|-----|---------|-------------|
| `haMode.enabled` | `false` | Enable HA/Sentinel mode |
| `haMode.replicas` | `3` | Number of Redis/Sentinel pods |
| `haMode.useDnsNames` | `true` | Use DNS hostnames for cluster wiring |
| `haMode.masterGroupName` | `redisha` | Sentinel master group name |
| `haMode.quorum` | `2` | Sentinel quorum |
| `haMode.downAfterMilliseconds` | `15000` | Mark master down threshold |
| `haMode.failoverTimeout` | `90000` | Sentinel failover timeout |
| `haMode.parallelSyncs` | `1` | Sentinel parallel-syncs |
| `haMode.masterAliveTestTimeout` | `2` | Timeout for master liveness checks |
| `haMode.failoverWait` | `30` | Max wait before forced failover |
| `haMode.dnsFailureWait` | `15` | Wait before restart on DNS failure |
| `haMode.keepOldLogs` | `false` | Keep old init logs |
| `sentinel.args` | `[]` | Extra args for `redis-sentinel` |
| `sentinel.config` | empty | Extra Sentinel config appended to generated config |
| `sentinel.extraEnvSecrets` | `[]` | Secrets exposed as env in Sentinel container |
| `sentinel.extraSecrets` | `[]` | Extra secret volumes mounted to Sentinel container |
| `sentinel.extraConfigs` | `[]` | Extra configMap volumes mounted to Sentinel container |
| `sentinel.extraSecretConfigs` | empty | Secret mounted and appended to Sentinel config |

### Storage

| Key | Default | Description |
|-----|---------|-------------|
| `storage.persistentVolumeClaimName` | empty | Use existing PVC name |
| `storage.volumeName` | `redis-data` | Internal volume/PVC name |
| `storage.requestedSize` | empty | Size for dynamically created PVC |
| `storage.className` | empty | StorageClass name |
| `storage.accessModes` | `[ReadWriteOnce]` | PVC access modes |
| `storage.keepPvc` | `false` | Keep PVC on chart uninstall (Deployment mode PVC only) |
| `storage.persistentVolumeClaimRetentionPolicy.whenDeleted` | empty | StatefulSet PVC policy on delete |
| `storage.persistentVolumeClaimRetentionPolicy.whenScaled` | empty | StatefulSet PVC policy on scale-down |
| `extraStorage` | `{}` | Extra existing PVC mounts |
| `useDeploymentWhenNonHA` | `false` | Use Deployment instead of StatefulSet in non-HA mode |

### TLS

| Key | Default | Description |
|-----|---------|-------------|
| `tls.enabled` | `false` | Enable TLS mode |
| `tls.existingSecret` | `""` | Existing TLS secret mounted by pods when set |
| `tls.additionalDomains` | `[]` | Additional SAN entries for generated certificate |
| `tls.issuerRef.name` | empty | cert-manager issuer name |
| `tls.issuerRef.kind` | `Issuer` | cert-manager issuer kind |
| `tls.issuerRef.group` | `cert-manager.io` | cert-manager issuer API group |

### Metrics Exporter

| Key | Default | Description |
|-----|---------|-------------|
| `metrics.enabled` | `false` | Enable exporter sidecar |
| `metrics.exporter.image.repository` | `oliver006/redis_exporter` | Exporter image repository |
| `metrics.exporter.image.tag` | `v1.84.0` | Exporter image tag |
| `metrics.exporter.args` | `[]` | Exporter args |
| `metrics.exporter.env` | `[]` | Extra exporter env vars |
| `metrics.exporter.extraExporterEnvSecrets` | `[]` | Secrets exposed as env in exporter |
| `metrics.exporter.extraExporterSecrets` | `[]` | Extra secret mounts in exporter |
| `metrics.exporter.extraExporterConfigs` | `[]` | Extra configMap mounts in exporter |
| `metrics.service.enabled` | `true` | Enable separate exporter service |
| `metrics.service.type` | `ClusterIP` | Exporter service type |
| `metrics.service.servicePort` | `9121` | Exporter service port |
| `metrics.service.containerPort` | `9121` | Exporter container port |

## Notes

- Full value comments and defaults are in `values.yaml`.
- This chart currently defines `metrics.serviceMonitor.*` values in `values.yaml`, but does not render a ServiceMonitor template.
- If `tls.enabled` is true, a `Certificate` resource is rendered. Pods mount `tls.existingSecret` when set, otherwise they mount `<fullname>-tls`.
