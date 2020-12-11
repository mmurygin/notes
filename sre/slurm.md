# Monitoring

## Table of Contents
- [SLI and SLOs](#sli-and-slos)
  * [Availability](#availability)
    + [SLI](#sli)
    + [Error Budget](#error-budget)
    + [Alert](#alert)
  * [Latency](#latency)
    + [SLI](#sli-1)
    + [Error Budget](#error-budget-1)
    + [Alert](#alert-1)
- [Application Metrics](#application-metrics)
  * [Requests](#requests)
  * [Latency](#latency-1)
- [Infrastructure Metrics](#infrastructure-metrics)
  * [Container CPU Usage](#container-cpu-usage)
  * [Container memory usage](#container-memory-usage)
  * [Pods running](#pods-running)
    + [Metric](#metric)
    + [Alert](#alert-2)
- [Grafana Dashboard](#grafana-dashboard)
  * [SLIs, SLOs](#slis-slos)
  * [Infra Metrics](#infra-metrics)

## SLI and SLOs

### Availability

#### SLI

```bash
100
 * sum(rate(http_server_requests_total{app="provider_backend", code="200", city="$city"}[5m])) # amount of successful requests
 / sum(rate(http_server_requests_total{app="provider_backend", city="$city"}[5m])) # total amount of requests
```

#### Error Budget

```bash
(
  # amount of allowed "bad" requests
  sum(increase(http_server_requests_total{app="provider_backend", city="$city"}[5m])) # overall amount of requests
  *
  (1 - 0.99) # our target, i.e. 100 - 99 %
)
-
sum(
  increase(http_server_requests_total{app="provider_backend", code!="200", city="$city"}[5m])  # amount of failed requests
  or up * 0 # account for possible missing failed requests
)
```


#### Alert

```yml
kind: PrometheusRule
apiVersion: monitoring.coreos.com/v1
metadata:
  name: prometheus-slo-rules
  namespace: $city
spec:
  groups:
  - name: rules-slo-latency
    rules:
    - record: $city:job:slo_availability:rate5m
      expr: |
          100
          * sum(rate(http_server_requests_total{app="provider_backend", city="$city", code="200"}[5m]))
          / sum(rate(http_server_requests_total{app="provider_backend", city="$city"}[5m]))

```

```yml
kind: PrometheusRule
apiVersion: monitoring.coreos.com/v1
metadata:
  name: prometheus-slo-alerts
  namespace: $city
spec:
  groups:
  - name: alerts-slo-availability
    rules:
      - alert: $cityAvailabilitySLOPage
        expr: $city:job:slo_availability:rate5m < 99
        for: 5m
        labels:
          severity: page
          team: $city
        annotations:
          summary: "Availability SLO is low"
          description: "Availability SLO is below target 99% for already 5 minutes (current value: {{ printf \"%.2f\" $value }}%)"

      - alert: $cityAvailabilitySLOWarning
        expr: $city:job:slo_availability:rate5m < 99.5
        for: 1m
        labels:
          severity: warning
          team: $city
        annotations:
          summary: "Availability SLO is low"
          description: "Availability SLO is approaching target 99% (current value: {{ printf \"%.2f\" $value }}%)"
```


### Latency

#### SLI

```bash
Добавляем latency SLI
100
  * sum(rate(http_server_request_duration_seconds_bucket{app="provider_backend", le="1.0", city="$city"}[5m])) # amount of requests faster than one second
  / sum(rate(http_server_request_duration_seconds_count{app="provider_backend", city="$city"}[5m])) # total amount of requests
```

#### Error Budget

```bash
( # number of allowed "bad" requests
  sum(increase(http_server_request_duration_seconds_count{app="provider_backend", city="$city"}[5m])) # overall number of requests
  *
  (1 - 0.99) # our target, i.e. 100 - 99 %
)
-
( # here we compute amount of requests slower than one second
  sum(increase(http_server_request_duration_seconds_count{app="provider_backend", city="$city"}[5m]))
  -
  sum(increase(http_server_request_duration_seconds_bucket{app="provider_backend", le="1.0", city="$city"}[5m]))
)
```

#### Alert

```yml
kind: PrometheusRule
apiVersion: monitoring.coreos.com/v1
metadata:
  name: prometheus-slo-rules
  namespace: $city
spec:
  groups:
  - name: rules-slo-latency
    rules:
    - record: $city:job:slo_latency:rate5m
      expr: |
          100
          * sum(rate(http_server_request_duration_seconds_bucket{app="provider_backend", city="$city", le="1.0"}[5m]))
          / sum(rate(http_server_request_duration_seconds_count{app="provider_backend", city="$city"}[5m]))
```

```yml
kind: PrometheusRule
apiVersion: monitoring.coreos.com/v1
metadata:
  name: prometheus-slo-alerts
  namespace: $city
spec:
  groups:
  - name: alerts-slo-latency
    rules:
      - alert: $cityLatencySLOPage
        expr: $city:job:slo_latency:rate5m < 99
        for: 5m
        labels:
          severity: page
          team: $city
        annotations:
          summary: "Latency SLO is low"
          description: "Latency SLO is below target 99% for already 5 minutes (current value: {{ printf \"%.2f\" $value }}%)"

      - alert: $cityLatencySLOWarning
        expr: $city:job:slo_latency:rate5m < 99.5
        for: 1m
        labels:
          severity: warning
          team: $city
        annotations:
          summary: "Latency SLO is low"
          description: "Latency SLO is approaching target 99% (current value: {{ printf \"%.2f\" $value }}%)"
```

## Application Metrics

### Requests

```bash
sum(rate(http_server_requests_total{app="provider_backend", namespace="$city"}[5m])) by (code)
```

### Latency

```bash
histogram_quantile(0.99, sum(rate(http_server_request_duration_seconds_bucket{app="provider_backend", namespace="$city"}[5m])) by (le))
histogram_quantile(0.95, sum(rate(http_server_request_duration_seconds_bucket{app="provider_backend", namespace="$city"}[5m])) by (le))
histogram_quantile(0.90, sum(rate(http_server_request_duration_seconds_bucket{app="provider_backend", namespace="$city"}[5m])) by (le))
histogram_quantile(0.75, sum(rate(http_server_request_duration_seconds_bucket{app="provider_backend", namespace="$city"}[5m])) by (le))
histogram_quantile(0.50, sum(rate(http_server_request_duration_seconds_bucket{app="provider_backend", namespace="$city"}[5m])) by (le))
```

## Infrastructure Metrics

### Container CPU Usage

```bash
sum(rate(container_cpu_usage_seconds_total{container!="POD",container!="", namespace="$city"}[5m])) by (pod)
```

### Container memory usage

```bash
sum(container_memory_usage_bytes{container!="POD",container!="", namespace="$city"}) by (pod)
```

### Pods running

#### Metric

```bash
sum(up{job="$city"}) / count(up{job="$city"})
```

#### Alert

```yml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: prometheus-basic-rules
spec:
  groups:
  - name: rules
    rules:
    - alert: TooManyDown
      expr: (sum(up{job="$city"}) / count(up{job="$city"})) <= 0.6
      for: 3m
      labels:
        team: $city
      annotations:
        summary: "Too many pods down"
        description: "Ratio of running pods is too small (current value: {{ printf \"%.1f\" $value }})"
```

## Grafana Dashboard

### SLIs, SLOs

[Dashboard JSON](./grafana-sli-slo.json)

### Infra Metrics

[Dashboard JSON](./infra-dashboard.json)
