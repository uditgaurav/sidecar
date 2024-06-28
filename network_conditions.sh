#!/bin/sh

# Default values
NETWORK_MODE=${NETWORK_MODE:-loss}
NETWORK_PACKET_LOSS_PERCENTAGE=${NETWORK_PACKET_LOSS_PERCENTAGE:-10}
NETWORK_LATENCY=${NETWORK_LATENCY:-200}
DURATION=${DURATION:-60}
TARGET_CONTAINER_IMAGE=${TARGET_CONTAINER_IMAGE:-"your-app-image"}

# Wait for the main application container to start
sleep 30

# Find the PID of the target container based on the image name
TARGET_PID=$(pgrep -f "$TARGET_CONTAINER_IMAGE")

# Apply network conditions if the PID is found
if [ -n "$TARGET_PID" ]; then
  if [ "$NETWORK_MODE" = "latency" ]; then
    nsenter -t $TARGET_PID -n tc qdisc add dev eth0 root netem delay ${NETWORK_LATENCY}ms
    echo "Applied ${NETWORK_LATENCY}ms network latency for ${DURATION} seconds"
  else
    nsenter -t $TARGET_PID -n tc qdisc add dev eth0 root netem loss ${NETWORK_PACKET_LOSS_PERCENTAGE}%
    echo "Applied ${NETWORK_PACKET_LOSS_PERCENTAGE}% network loss for ${DURATION} seconds"
  fi
  
  # Sleep for the specified duration
  sleep ${DURATION}

  # Remove the network conditions after the duration
  nsenter -t $TARGET_PID -n tc qdisc del dev eth0 root netem
  echo "Network conditions removed after ${DURATION} seconds"
fi

# Keep the sidecar container running
while true; do sleep 3600; done
