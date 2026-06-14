#!/bin/bash
# start.sh

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting GitHub Runner Configuration..."
echo "Repository URL: ${REPOSITORY_URL}"

# Validate required variables
if [ -z "${REPOSITORY_URL}" ] || [ -z "${REGISTRATION_TOKEN}" ]; then
  echo "Error: REPOSITORY_URL and REGISTRATION_TOKEN environment variables are required."
  exit 1
fi

CD_DIR="/home/runner/actions-runner"
cd "$CD_DIR"

# Configure the runner
echo "Running config.sh..."
./config.sh \
  --url "${REPOSITORY_URL}" \
  --token "${REGISTRATION_TOKEN}" \
  --name "aca-runner-$(hostname)" \
  --work "_work" \
  --labels "aca,linux,terraform,azure-cli" \
  --unattended \
  --replace

# Start the runner execution loop
echo "Starting run.sh..."
./run.sh