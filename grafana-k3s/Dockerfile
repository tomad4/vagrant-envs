FROM node:24-bookworm-slim AS build
WORKDIR /build
COPY plugin/ ./
RUN node build.mjs /out/tomad4-hello-panel

FROM grafana/grafana:13.3.1-ubuntu
ENV GF_PATHS_PLUGINS=/opt/grafana-plugins
COPY --from=build --chown=472:0 /out/tomad4-hello-panel/ /opt/grafana-plugins/tomad4-hello-panel/
COPY plugin/dashboard-provider.yaml /etc/grafana/provisioning/dashboards/hello.yaml
COPY plugin/dashboard.json /opt/grafana-dashboards/hello.json
