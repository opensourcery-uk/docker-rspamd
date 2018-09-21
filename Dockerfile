FROM opensourcery/debian:stretch-slim
LABEL maintainer "open.source@opensourcery.uk"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -y lsb-release wget gnupg apt-utils \
 && wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - \
 && echo "deb [arch=amd64] http://rspamd.com/apt-stable/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/rspamd.list \
 && apt-get autoremove -y --purge lsb-release wget gnupg \
 && apt-get update \
 && apt-get install -y rspamd \
 && mkdir /run/rspamd \
 && chown _rspamd /run/rspamd \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

ADD logging.inc \
    worker-normal.inc \
    worker-controller.inc \
    redis.conf \
    classifier-bayes.conf \
  /etc/rspamd/override.d/

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 11333 11334

ENTRYPOINT ["/entrypoint.sh"]
CMD ["rspamd", "-f", "-u", "_rspamd", "-g", "_rspamd"]
