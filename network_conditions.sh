#!/bin/bash

# Default values
NETWORK_LOSS=${NETWORK_LOSS:-10}
DURATION=${DURATION:-60}
TARGET_CONTAINER_IMAGE=${TARGET_CONTAINER_IMAGE:-"your-app-image"}

# Wait for the main application container to start
sleep 30

# Find the PID of the target container based on the image name
TARGET_PID=$(pgrep -f "$TARGET_CONTAINER_IMAGE")

# Apply network conditions if the PID is found
if [ -n "$TARGET_PID" ]; then
  nsenter -t $TARGET_PID -n tc qdisc add dev eth0 root netem loss ${NETWORK_LOSS}%
  echo "Applied ${NETWORK_LOSS}% network loss for ${DURATION} seconds"
  
  # Sleep for the specified duration
  sleep ${DURATION}

  # Remove the network conditions after the duration
  nsenter -t $TARGET_PID -n tc qdisc del dev eth0 root netem
  echo "Network loss removed after ${DURATION} seconds"
fi

# Keep the sidecar container running
while true; do sleep 3600; done
