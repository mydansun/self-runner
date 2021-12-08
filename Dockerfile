FROM ghcr.io/catthehacker/ubuntu:full-20.04

ARG GH_RUNNER_VERSION="2.285.1"
ARG TARGETPLATFORM

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner

RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && rm /actions-runner/install_actions.sh

COPY token.sh entrypoint.sh ephemeral-runner.sh /
RUN chmod +x /token.sh /entrypoint.sh /ephemeral-runner.sh
