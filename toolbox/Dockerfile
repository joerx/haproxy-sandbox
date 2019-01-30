FROM debian:stretch

RUN apt-get update && apt-get -y --force-yes install dnsutils
COPY ./sleep.sh /sleep.sh

CMD ["/sleep.sh"]
