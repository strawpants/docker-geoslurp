#!/bin/sh

set -e

POSTGIS_VERSION="${POSTGIS_VERSION%%+*}"

    echo "Updating/installing PostGIS extensions geoslurp to $POSTGIS_VERSION"
    psql --dbname=geoslurp -c --username "$POSTGRES_USER" "
        -- Upgrade PostGIS (includes raster)
        CREATE EXTENSION IF NOT EXISTS postgis VERSION '$POSTGIS_VERSION';
        ALTER EXTENSION postgis  UPDATE TO '$POSTGIS_VERSION';
        -- Upgrade Topology
        CREATE EXTENSION IF NOT EXISTS postgis_topology VERSION '$POSTGIS_VERSION';
        ALTER EXTENSION postgis_topology UPDATE TO '$POSTGIS_VERSION';
    "
