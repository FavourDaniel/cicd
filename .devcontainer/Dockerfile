# Note: You can use any Debian/Ubuntu based image you want. 
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl python3 python3-pip cmake coreutils openvpn jp2a jq

RUN mkdir /run/openvpn 

# mkdocs

RUN pip install --default-timeout=1000 --no-cache-dir --no-input mkdocs mkdocs-techdocs-core==0.* yamllint imgcat Pillow

# bash history
ARG USERNAME=vscode
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && echo $SNIPPET >> "/home/$USERNAME/.bashrc"   

# oh-my-posh

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE=arm; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi \
    && wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-${ARCHITECTURE} -O /usr/local/bin/oh-my-posh \
    && chmod +x /usr/local/bin/oh-my-posh /    


# Google Cloud CLI: Don't use the devcontainer feature it does not support adding cli components and has arm64 issues

ARG TARGETPLATFORM
ARG GCLOUD_VERSION='435.0.0'
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE="x86_64"; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE="arm"; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE="arm"; else ARCHITECTURE="x86_64"; fi \
      && wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-arm.tar.gz -O /usr/local/bin/google-cloud-cli-${GCLOUD_VERSION}-linux-${ARCHITECTURE}.tar.gz \
      && tar -xvf /usr/local/bin/google-cloud-cli-${GCLOUD_VERSION}-linux-${ARCHITECTURE}.tar.gz -C /usr/local/bin/ \
      && rm /usr/local/bin/google-cloud-cli-${GCLOUD_VERSION}-linux-${ARCHITECTURE}.tar.gz \
      && /usr/local/bin/google-cloud-sdk/install.sh --quiet --usage-reporting=false --path-update=true --bash-completion=true --rc-path=/home/vscode/.bashrc --additional-components gke-gcloud-auth-plugin 



# ORAS cli

ARG TARGETPLATFORM
ARG ORAS_VERSION="1.0.0"

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE="amd64"; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE="armv7"; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE="arm64"; else ARCHITECTURE="amd64"; fi \
    && curl -LO "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_${ARCHITECTURE}.tar.gz" \
    && mkdir -p oras-install \
    && tar -zxf oras_${ORAS_VERSION}_*.tar.gz -C oras-install \
    && sudo mv oras-install/oras /usr/local/bin \
    && rm -rf oras_${ORAS_VERSION}_*.tar.gz oras-install 

# gitversion

ARG TARGETPLATFORM
ARG GIT_VERSION="5.12.0"

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE="x64"; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then ARCHITECTURE="armv7"; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE="arm64"; else ARCHITECTURE="x64"; fi \
    && curl -LO "https://github.com/GitTools/GitVersion/releases/download/${GIT_VERSION}/gitversion-linux-${ARCHITECTURE}-${GIT_VERSION}.tar.gz" \
    && mkdir -p gitversion-install \
    && tar -zxf gitversion-linux-${ARCHITECTURE}-${GIT_VERSION}.tar.gz -C gitversion-install \
    && sudo mv gitversion-install/gitversion /usr/local/bin \
    && sudo chmod +x /usr/local/bin/gitversion \
    && rm -rf gitversion_${GIT_VERSION}_*.tar.gz gitversion-install 