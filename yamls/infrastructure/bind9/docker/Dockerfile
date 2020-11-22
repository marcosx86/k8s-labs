FROM debian:buster-slim

RUN apt update \
	&& apt upgrade -y \
	&& apt install bind9 openssh-server -y --no-install-recommends \
	&& apt clean \
	&& rm -rf /var/lib/apt/*

COPY entrypoint.sh /

VOLUME ["/etc/bind"]
EXPOSE 22/tcp 53/tcp 53/udp

RUN useradd -m -U user

CMD ["/entrypoint.sh"]
