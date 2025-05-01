# 📊 Node Metrics Demo

A minimal Node.js app designed to generate Prometheus-compatible metrics and logs for use in observability stacks like:

- 🧭 Prometheus (metrics scraping)
- 📦 Loki (log aggregation)
- 📊 Grafana (dashboards)

This app is part of the [DevOps Observability Stack](../../devops-observability-stack) project.

---

## 🚀 Features

- `GET /` – Basic route with log output
- `GET /metrics` – Prometheus metrics endpoint via `prom-client`
- Collects default Node.js process metrics (CPU, memory, event loop)
- Tracks total HTTP requests via a custom counter
- Designed to work with `prometheus.io/scrape` annotations in Kubernetes

---

## 🐳 Docker

```bash
docker build -t node-metrics-demo .
docker run -p 3000:3000 node-metrics-demo
```

## ☸️ Kubernetes

```bash
kubectl apply -f manifests/apps/node-metrics-demo-deployment.yaml
```

## 📦 Prometheus Output

```bash
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total 42

# Default metrics:
nodejs_eventloop_lag_seconds{...}
process_cpu_user_seconds_total{...}
...
```

## 🧪 Testing Logs + Metrics in Grafana

•	Use Loki to tail logs with {app="node-metrics-demo"}
•	Use Prometheus to graph:
    •	http_requests_total
	•	process_resident_memory_bytes
	•	nodejs_eventloop_lag_seconds


## 🛠 Usage

Visit:
	•	http://localhost:3000/ → Hello world + logs
	•	http://localhost:3000/metrics → Prometheus metrics

### 🔧 Local

```bash
npm install
node index.js
```

---

## 🤘 Author

Built by NickDoesDevOps to power real observability demos.