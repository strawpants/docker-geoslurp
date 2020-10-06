#!/usr/bin/bash


#data/volume mount mapping (also uncomment these in the docker-compose.yaml file)
# where to mount the postgresql data folder (leave empty for mapping it inside docker only)
#export PG_DATA=/home/data/geoslurpdb 

# where to mount the directory holding the out-of-db data (leave emtpy for a mapping inside docker only)
#export GEOSLURP_DATAROOT=/mnt/example

# where to mount the cache directory
#export GEOSLURP_CACHE=/mnt/examplecache

#Postgresql administrator and password
export POSTGRES_USER=gsadmin
export POSTGRES_PASSWORD=CHANGETHISTOSOMETHINGELSE

# day to day user which can add and manage datasets from within the docker container
export GEOSLURP_USER=marge
export GEOSLURP_UPASSWD=CHANGETHISTOO
#you can set this UID to match the UID of an outside user so permission conflicts with 
export GEOSLURP_UID=1000

#readonly 'consumer' user which has read access to the database, but cannot change tables
export GEOSLURP_ROUSER=greadonly
export GEOSLURP_ROUPASSWD=IAMSERIOUSCHANGETHESEPASSWORDS



docker-compose build 
docker-compose up -d

