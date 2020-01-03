FROM mongodb:3.4.23

ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.23

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mongodb \
	&& mv /etc/mongod.conf /etc/mongod.conf.orig

RUN mkdir -p /data/db /data/configdb \
	&& chown -R mongodb:mongodb /data/db /data/configdb
VOLUME /data/db /data/configdb

COPY etc /etc
COPY docker-entrypoint.sh /usr/local/bin/
COPY mongo.sql /
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat (3.4)
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 27017 
CMD ["mongod","-f","/etc/mongod.conf"]