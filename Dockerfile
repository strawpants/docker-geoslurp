FROM postgres:12
MAINTAINER Roelof Rietbroek <roelof@wobbly.earth>
#credits for orginal dockerfile https://github.com/appropriate/docker-postgis/

ENV POSTGIS_MAJOR 3
#ENV POSTGIS_VERSION 2.5.3+dfsg-2.pgdg90+1

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
           postgresql-plpython3-$PG_MAJOR \
           postgis \
           git python3-pip python3-wheel python3-setuptools python3-crypto python3-netcdf4 \
           python3-sqlalchemy python3-psycopg2 python3-gdal python3-keyring \
           python3-yaml python3-lxml python3-easywebdav python3-shapely python3-pycurl \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/geoslurp
RUN chmod 777 /etc/geoslurp

COPY ./geoslurpwrap /usr/local/bin/
RUN chmod 755 /usr/local/bin/geoslurpwrap
COPY ./geoslurpadminwrap /usr/local/bin/
RUN chmod 755 /usr/local/bin/geoslurpadminwrap

COPY ./init-postgis.sh /docker-entrypoint-initdb.d/init-postgis.sh
COPY ./setupgeoslurp.sh /docker-entrypoint-initdb.d/setupgeoslurp.sh
COPY ./update-postgis.sh /usr/local/bin

RUN pip3 install --upgrade numpy

RUN mkdir /geoslurp_data
RUN chown postgres:postgres /geoslurp_data

#also install geoslurp from the git repository
RUN pip3 install --process-dependency-links git+https://github.com/strawpants/geoslurp.git@c39d8b3f54df8f1215acfc4aeb0a0e12bbfedffc


#RUN pip3 install --process-dependency-links geoslurp==1.0.0

