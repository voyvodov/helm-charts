# Redis

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.8.0](https://img.shields.io/badge/AppVersion-8.8.0-informational?style=flat-square)

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
- Uses a StatefulSet by default

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
| `<fullname>` | StatefulSet | Always in current defaults |
| `<serviceAccountName>` | ServiceAccount | `serviceAccount.create: true` |
| `<fullname>-metrics` | Service | `metrics.enabled: true` and `metrics.service.enabled: true` |
| `<fullname>-tls` | Certificate | `tls.enabled: true` |

## Values Reference

The table below is generated from the current `values.yaml` and includes all existing keys and defaults.

| Key | Default |
|-----|---------|
| `affinity` | `{}` |
| `clusterDomain` | `cluster.local` |
| `customAnnotations` | `{}` |
| `customLabels` | `{}` |
| `customLivenessProbe` | `{}` |
| `customReadinessProbe` | `{}` |
| `customStartupProbe` | `{}` |
| `env` | `[]` |
| `extraContainers` | `[]` |
| `extraInitContainers` | `[]` |
| `extraInitEnvSecrets` | `[]` |
| `extraStorage` | `{}` |
| `fullnameOverride` | `""` |
| `haMode.dnsFailureWait` | `15` |
| `haMode.downAfterMilliseconds` | `15000` |
| `haMode.enabled` | `false` |
| `haMode.failoverTimeout` | `90000` |
| `haMode.failoverWait` | `30` |
| `haMode.keepOldLogs` | `false` |
| `haMode.masterAliveTestTimeout` | `2` |
| `haMode.masterGroupName` | `redisha` |
| `haMode.parallelSyncs` | `1` |
| `haMode.quorum` | `2` |
| `haMode.replicas` | `3` |
| `haMode.useDnsNames` | `true` |
| `image.pullPolicy` | `IfNotPresent` |
| `image.registry` | `docker.io` |
| `image.repository` | `redis` |
| `image.tag` | `""` |
| `imagePullSecrets` | `[]` |
| `livenessProbe.enabled` | `true` |
| `livenessProbe.failureThreshold` | `3` |
| `livenessProbe.initialDelaySeconds` | `15` |
| `livenessProbe.periodSeconds` | `10` |
| `livenessProbe.successThreshold` | `1` |
| `livenessProbe.timeoutSeconds` | `5` |
| `metrics.enabled` | `false` |
| `metrics.exporter.args` | `[]` |
| `metrics.exporter.customLivenessProbe` | `{}` |
| `metrics.exporter.customReadinessProbe` | `{}` |
| `metrics.exporter.customStartupProbe` | `{}` |
| `metrics.exporter.env` | `[]` |
| `metrics.exporter.extraExporterConfigs` | `[]` |
| `metrics.exporter.extraExporterEnvSecrets` | `[]` |
| `metrics.exporter.extraExporterSecrets` | `[]` |
| `metrics.exporter.image.pullPolicy` | `IfNotPresent` |
| `metrics.exporter.image.registry` | `docker.io` |
| `metrics.exporter.image.repository` | `oliver006/redis_exporter` |
| `metrics.exporter.image.tag` | `v1.84.0` |
| `metrics.exporter.livenessProbe.enabled` | `true` |
| `metrics.exporter.livenessProbe.failureThreshold` | `3` |
| `metrics.exporter.livenessProbe.initialDelaySeconds` | `15` |
| `metrics.exporter.livenessProbe.periodSeconds` | `10` |
| `metrics.exporter.livenessProbe.successThreshold` | `1` |
| `metrics.exporter.livenessProbe.timeoutSeconds` | `5` |
| `metrics.exporter.readinessProbe.enabled` | `true` |
| `metrics.exporter.readinessProbe.failureThreshold` | `3` |
| `metrics.exporter.readinessProbe.initialDelaySeconds` | `15` |
| `metrics.exporter.readinessProbe.periodSeconds` | `10` |
| `metrics.exporter.readinessProbe.successThreshold` | `1` |
| `metrics.exporter.readinessProbe.timeoutSeconds` | `5` |
| `metrics.exporter.resources` | `{}` |
| `metrics.exporter.securityContext.allowPrivilegeEscalation` | `false` |
| `metrics.exporter.securityContext.capabilities.drop` | `["ALL"]` |
| `metrics.exporter.securityContext.privileged` | `false` |
| `metrics.exporter.securityContext.readOnlyRootFilesystem` | `true` |
| `metrics.exporter.securityContext.runAsGroup` | `999` |
| `metrics.exporter.securityContext.runAsNonRoot` | `true` |
| `metrics.exporter.securityContext.runAsUser` | `999` |
| `metrics.exporter.startupProbe.enabled` | `true` |
| `metrics.exporter.startupProbe.failureThreshold` | `5` |
| `metrics.exporter.startupProbe.initialDelaySeconds` | `10` |
| `metrics.exporter.startupProbe.periodSeconds` | `10` |
| `metrics.exporter.startupProbe.successThreshold` | `1` |
| `metrics.exporter.startupProbe.timeoutSeconds` | `5` |
| `metrics.service.annotations` | `{}` |
| `metrics.service.clusterIP` | `null` |
| `metrics.service.containerPort` | `9121` |
| `metrics.service.enabled` | `true` |
| `metrics.service.labels` | `{}` |
| `metrics.service.loadBalancerIP` | `null` |
| `metrics.service.loadBalancerSourceRanges` | `[]` |
| `metrics.service.nodePort` | `null` |
| `metrics.service.servicePort` | `9121` |
| `metrics.service.type` | `ClusterIP` |
| `metrics.serviceMonitor.additionalLabels` | `{}` |
| `metrics.serviceMonitor.annotations` | `{}` |
| `metrics.serviceMonitor.enabled` | `true` |
| `metrics.serviceMonitor.extraEndpointParameters` | `{}` |
| `metrics.serviceMonitor.extraParameters` | `{}` |
| `metrics.serviceMonitor.path` | `/metrics` |
| `metrics.serviceMonitor.scheme` | `http` |
| `nameOverride` | `""` |
| `networkPolicy` | `{}` |
| `nodeSelector` | `{}` |
| `pdb.enabled` | `true` |
| `pdb.maxUnavailable` | `1` |
| `pdb.minAvailable` | `null` |
| `podAnnotations` | `{}` |
| `podDisruptionBudget` | `{}` |
| `podLabels` | `{}` |
| `podManagementPolicy` | `OrderedReady` |
| `podSecurityContext.fsGroup` | `999` |
| `podSecurityContext.supplementalGroups` | `[999]` |
| `priorityClassName` | `""` |
| `readinessProbe.enabled` | `true` |
| `readinessProbe.failureThreshold` | `3` |
| `readinessProbe.initialDelaySeconds` | `15` |
| `readinessProbe.periodSeconds` | `10` |
| `readinessProbe.successThreshold` | `1` |
| `readinessProbe.timeoutSeconds` | `5` |
| `redis.args` | `[]` |
| `redis.authentication.acl.enabled` | `false` |
| `redis.authentication.acl.secretRef.key` | `redis-acl` |
| `redis.authentication.acl.secretRef.name` | `""` |
| `redis.authentication.enabled` | `false` |
| `redis.authentication.secretRef.key` | `redis-password` |
| `redis.authentication.secretRef.name` | `""` |
| `redis.config` | `null` |
| `redis.extraConfigs` | `[]` |
| `redis.extraEnvSecrets` | `[]` |
| `redis.extraSecretConfigs` | `null` |
| `redis.extraSecrets` | `[]` |
| `redis.initResources` | `{}` |
| `redis.persistence.aof.appendfsync` | `everysec` |
| `redis.persistence.aof.enabled` | `false` |
| `redis.persistence.snapshot.enabled` | `false` |
| `redis.persistence.snapshot.save` | `[{"time":900,"changes":1},{"time":300,"changes":10},{"time":60,"changes":10000}]` |
| `redis.resources` | `{}` |
| `revisionHistoryLimit` | `null` |
| `securityContext.allowPrivilegeEscalation` | `false` |
| `securityContext.capabilities.drop` | `["ALL"]` |
| `securityContext.privileged` | `false` |
| `securityContext.readOnlyRootFilesystem` | `true` |
| `securityContext.runAsGroup` | `999` |
| `securityContext.runAsNonRoot` | `true` |
| `securityContext.runAsUser` | `999` |
| `sentinel.args` | `[]` |
| `sentinel.config` | `""` |
| `sentinel.extraConfigs` | `[]` |
| `sentinel.extraEnvSecrets` | `[]` |
| `sentinel.extraSecretConfigs` | `null` |
| `sentinel.extraSecrets` | `[]` |
| `sentinel.resources` | `{}` |
| `service.annotations` | `{}` |
| `service.clusterIP` | `null` |
| `service.labels` | `{}` |
| `service.loadBalancerIP` | `null` |
| `service.loadBalancerSourceRanges` | `[]` |
| `service.nodePort` | `null` |
| `service.sentinelPort` | `26379` |
| `service.serverPort` | `6379` |
| `service.type` | `ClusterIP` |
| `serviceAccount.annotations` | `{}` |
| `serviceAccount.create` | `true` |
| `serviceAccount.name` | `""` |
| `startupProbe.enabled` | `true` |
| `startupProbe.failureThreshold` | `30` |
| `startupProbe.initialDelaySeconds` | `10` |
| `startupProbe.periodSeconds` | `10` |
| `startupProbe.successThreshold` | `1` |
| `startupProbe.timeoutSeconds` | `5` |
| `storage.accessModes` | `["ReadWriteOnce"]` |
| `storage.annotations` | `{}` |
| `storage.className` | `null` |
| `storage.keepPvc` | `false` |
| `storage.labels` | `{}` |
| `storage.persistentVolumeClaimName` | `null` |
| `storage.persistentVolumeClaimRetentionPolicy.whenDeleted` | `null` |
| `storage.persistentVolumeClaimRetentionPolicy.whenScaled` | `null` |
| `storage.requestedSize` | `null` |
| `storage.volumeName` | `redis-data` |
| `tls.additionalDomains` | `[]` |
| `tls.enabled` | `false` |
| `tls.existingSecret` | `""` |
| `tls.issuerRef.group` | `cert-manager.io` |
| `tls.issuerRef.kind` | `Issuer` |
| `tls.issuerRef.name` | `null` |
| `tolerations` | `[]` |
| `topologySpreadConstraints` | `{}` |
| `updateStrategyType` | `RollingUpdate` |

## Notes

- Full value comments and defaults are in `values.yaml`.
- This chart currently defines `metrics.serviceMonitor.*` values in `values.yaml`, but does not render a ServiceMonitor template.
- If `tls.enabled` is true, a `Certificate` resource is rendered. Pods mount `tls.existingSecret` when set, otherwise they mount `<fullname>-tls`.
