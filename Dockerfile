FROM alpine:latest

# Install necessary packages
RUN apk update && apk add iproute2 util-linux

# Copy the network conditions script into the container
COPY network_conditions.sh /usr/local/bin/network_conditions.sh

# Ensure the script is executable
RUN chmod +x /usr/local/bin/network_conditions.sh

# Run the script
CMD ["sh", "/usr/local/bin/network_conditions.sh"]
