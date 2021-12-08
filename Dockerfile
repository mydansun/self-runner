FROM ghcr.io/catthehacker/ubuntu:full-20.04

ARG GH_RUNNER_VERSION="2.285.1"
ARG TARGETPLATFORM

USER root
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install dumb-init mysql-client libncurses5 -y -qq

RUN mkdir ~/simsun && wget https://github.com/mydansun/font-ttf/raw/master/simsun.ttc -P ~/simsun
RUN mkdir -p /usr/share/fonts
RUN cp ~/simsun/simsun.ttc /usr/share/fonts/simsun.ttc
RUN chmod 644 /usr/share/fonts/simsun.ttc
RUN apt-get install ttf-mscorefonts-installer fontconfig -y -qq
RUN mkfontscale
RUN mkfontdir
RUN fc-cache -fv

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner

RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && rm /actions-runner/install_actions.sh

COPY token.sh entrypoint.sh ephemeral-runner.sh /
RUN chmod +x /token.sh /entrypoint.sh /ephemeral-runner.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]