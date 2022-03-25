FROM debian:stable-slim

ENV HTTP_PORT=8200 \
    MINIDLNAD_UID=999 \
    MINIDLNAD_GID=999

RUN set -ex \
    && groupadd -r minidlna -g $MINIDLNAD_GID \
    && useradd -l -r -M -u $MINIDLNAD_UID -g $MINIDLNAD_GID minidlna

RUN apt-get update \
    && apt-get -y install minidlna \
    && apt-get clean \
    && mkdir /var/log/minidlna

COPY minidlna.conf /etc/minidlna.conf

VOLUME ["/var/lib/minidlna"]

EXPOSE $HTTP_PORT/tcp 1900/udp

CMD ["sh", "-c", "/usr/sbin/minidlnad -S -u $MINIDLNAD_UID -p $HTTP_PORT"]
