FROM alpine:latest
LABEL maintainer="Jonathan Gnagy <jonathan.gnagy@gmail.com>"

RUN apk add --update \
    avahi \
    samba-common-tools \
    samba-client \
    samba-server \
    supervisor \
    && sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf \
    && rm -rf /var/cache/apk/* \
    && rm /etc/avahi/services/*


COPY setup.sh template_quota smb.conf /tmp/
COPY avahia.service /etc/avahi/services/timemachine.service
COPY supervisord.conf /etc/supervisord.conf

VOLUME ["/timemachine"]
ENTRYPOINT ["/tmp/setup.sh"]
HEALTHCHECK --interval=5m --timeout=3s \
  CMD (avahi-daemon -c && \
        smbclient -L '\\localhost' -U '%' -m SMB3 &>/dev/null) || exit 1
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
