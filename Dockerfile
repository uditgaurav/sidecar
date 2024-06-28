FROM public.ecr.aws/aws-se/amazon-ecs-network-sidecar

RUN apt-get update && apt-get install -y iproute2 util-linux

COPY network_conditions.sh /usr/local/bin/network_conditions.sh

CMD ["sh", "/usr/local/bin/network_conditions.sh"]
