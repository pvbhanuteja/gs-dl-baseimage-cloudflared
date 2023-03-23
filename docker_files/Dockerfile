# FROM paperspace/gradient-base:pt112-tf29-jax0317-py39-20230125
FROM ubuntu:20.04
RUN ./docker_files/testenv.sh
RUN apt-get update && \
apt-get install -y curl && \
apt-get install -y openssh-server && \
apt-get install -y telnet && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
dpkg -i cloudflared.deb

# 8888 6006 22 will be in use by default for Jupyter, Tensorboard, and SSH opening up the rest for custom use cases
EXPOSE 8888 6006 22 8889 8887 8886 8885 8884 8883 8882 8881 8880

COPY ./docker_files/entrypoint.sh /entrypoint.sh
COPY ./docker_files/sshd_config /etc/ssh/sshd_config
COPY ./docker_files/auth.keys /etc/ssh/auth.keys

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]