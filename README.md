# Full Kubernetes Monitoring with Grafana

This repo has an environment I'm using to make tests using a full Kubernetes monitoring architecture based on Grafana. I'm using:

- kube-prometheus-stack to run Prometheus (for metrics) and Grafana itself
- loki-stack to run Loki and Fluentbit (logs)
- Tempo to collect traces

## To Do

- [X] Change from loki-stack to grafana/loki and fluentbit separately
- [X] Deploy my sample logging application
- [X] Integrate Grafana with Loki
- [ ] Install grafana/tempo to get traces

## References

<https://www.reddit.com/r/grafana/comments/15e9aej/help_setting_up_grafana_prometheus_and_loki_stack/>
