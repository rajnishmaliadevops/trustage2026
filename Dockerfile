FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------
# Install Base Packages
# --------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    jq \
    sudo \
    unzip \
    zip \
    build-essential \
    libicu-dev \
    apt-transport-https \
    lsb-release \
    gnupg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# Install Node.js (Required for GitHub Actions)
# --------------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# --------------------------------------------------
# Install Azure CLI
# --------------------------------------------------
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# --------------------------------------------------
# Install Terraform
# --------------------------------------------------
ARG TERRAFORM_VERSION=1.12.2

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}*linux_amd64.zip \
    && mv terraform /usr/local/bin/terraform \
    && rm terraform*${TERRAFORM_VERSION}_linux_amd64.zip

# --------------------------------------------------
# Create Runner User
# --------------------------------------------------
RUN useradd -m runner \
    && usermod -aG sudo runner \
    && echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers

# --------------------------------------------------
# Download GitHub Runner
# --------------------------------------------------
WORKDIR /home/runner/actions-runner

RUN curl -L \
    -o actions-runner.tar.gz \
    https://github.com/actions/runner/releases/download/v2.335.1/actions-runner-linux-x64-2.335.1.tar.gz \
    && tar xzf actions-runner.tar.gz \
    && rm actions-runner.tar.gz

# Install Runner Dependencies
RUN ./bin/installdependencies.sh

# --------------------------------------------------
# Copy Startup Script
# --------------------------------------------------
COPY start.sh /home/runner/actions-runner/start.sh
RUN chmod +x /home/runner/actions-runner/start.sh

# --------------------------------------------------
# Ownership
# --------------------------------------------------
RUN chown -R runner:runner /home/runner

# --------------------------------------------------
# Verify Installations
# --------------------------------------------------
RUN node --version
RUN npm --version
RUN az version
RUN terraform version

# --------------------------------------------------
# Switch To Runner User
# --------------------------------------------------
USER runner

ENTRYPOINT ["/home/runner/actions-runner/start.sh"]


