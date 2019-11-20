FROM postgres:12
MAINTAINER Roelof Rietbroek <roelof@wobbly.earth>

ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.0.0+dfsg-2~exp1.pgdg100+1

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
           postgis=$POSTGIS_VERSION \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d

COPY ./init-postgis.sh /docker-entrypoint-initdb.d/init-postgis.sh
COPY ./setupgeoslurp.sh /docker-entrypoint-initdb.d/setupgeoslurp.sh
COPY ./update-postgis.sh /usr/local/bin
