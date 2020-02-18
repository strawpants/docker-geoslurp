# Run a geoslurp-enabled PostgreSQL database with PostGIS
The [geoslurp client tools](https://github.com/strawpants/geoslurp), allow users to download and register various (Earth science) datasets. In order for it work it requires a working PostgreSQL database server with the PostGIS extension enabled. This docker image provides such a running PostgreSQL instance, and, upon initialization, it creates a *geoslurp* database suitable for interacting with geoslurp clients. Inside the docker image a geoslurp client is also installed. This facilitates managing the database from within the docker container, and in the future possibly adding things like cronjobs for automatic updating of datasets.

### Step 1: Setup the environment variables
Before building and running the docker container, a set of important environment variables need to be set in the shell:

```
#External mount point of the PGdata volume (optional)
export PG_DATA=/path/to/pgdata

#the admin user (which is allowed to create new databases)
export POSTGRES_USER=adminuser
export POSTGRES_PASSWORD=passwordoftheadminuser

#External mount point of the default out-of-db dataset storage location root
export GEOSLURP_DATAROOT=/external/mount/path/where/outofdb/dataisstored

#A user with read and write access to the database once it is created (optional but recommended)
export GEOSLURP_USER=readwriteusername
export GEOSLURP_UPASSWD=passwordofreadwriteuser

# a user with readonly (browsing) privileges (optional but recommended)
export GEOSLURP_ROUSER=readonlyusername
export GEOSLURP_ROUPASSWD=passwordofreadonlyusername

#run the docker container with this uid (useful for getting correct permissions for nfs mounts 
export GEOSLURP_UID=12345
```


### Step 2. Run docker-compose
Once the environment variables are set up one can build and run the docker container with docker-compose
```
docker-compose build
docker-compose up -d
```

When everything worked according to plan, one can test the connection by logging in the database locally  with `psql -h localhost -U $GEOSLURP_USER -d geoslurp`

## Setting up the database without docker

When a suitable PostgreSQL database is already running, it is also possible to use the scripts in [the docker-geoslurp repository](https://github.com/strawpants/docker-geoslurp) to initialize a geoslurp-enabled database in the existing instance. The steps which are then needed are the following:
1. Locally install a geoslurp client : `pip install geoslurp`
2. Set the environment variables as desribed in Step 1 above. Optionally set the environment variable `GEOSLURP_HOST` to point to the hostname of the database server, when working remotely.
3. Get and run the geoslurp initialization script: 
    ```
    wget https://raw.githubusercontent.com/strawpants/docker-geoslurp/master/setupgeoslurp.sh
    bash ./setupgeoslurp.sh
   ```

## Interacting with the database
Since the database interface is standardized there is a variety of ways to interact with the tables in the database.  It is recommended to use the readonly user where possible, in order to avoid unintended table changes. A selection of possibilities are:
* Use [the geoslurp client](https://wobbly.earth/geoslurp)
* [Browse and use the database with QGIS](https://docs.qgis.org/3.4/en/docs/user_manual/managing_data_source/opening_data.html?highlight=postgresql#creating-a-stored-connection)
* Use the interactive PostgreSQL terminal [psql](https://www.postgresql.org/docs/12/app-psql.html)
* [Directly open a PostgreSQL table with GDAL](https://gdal.org/drivers/vector/pg.html)
* Well, basically using anything which supports the PostgreSQL protocol...




