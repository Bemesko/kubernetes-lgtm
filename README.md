# Full Kubernetes Monitoring with Grafana

This repo has an environment I'm using to make tests using a full Kubernetes monitoring architecture based on Grafana. I'm using:

- kube-prometheus-stack to run Prometheus (for metrics) and Grafana itself
- loki-stack to run Loki and Fluentbit (logs)
- Tempo to collect traces