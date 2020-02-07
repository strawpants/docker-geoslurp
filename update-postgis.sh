#!/bin/sh

set -e

POSTGIS_VERSION="${POSTGIS_VERSION%%+*}"

    echo "Updating/installing PostGIS extensions geoslurp to $POSTGIS_VERSION"
psql --dbname geoslurp --username "$POSTGRES_USER" << EOF
    -- Upgrade PostGIS 
    CREATE EXTENSION IF NOT EXISTS postgis VERSION '$POSTGIS_VERSION';
    ALTER EXTENSION postgis  UPDATE TO '$POSTGIS_VERSION';
    -- Upgrade PostGIS_raster
    CREATE EXTENSION IF NOT EXISTS postgis_raster VERSION '$POSTGIS_VERSION';
    ALTER EXTENSION postgis_raster  UPDATE TO '$POSTGIS_VERSION';
    -- Upgrade Topology
    CREATE EXTENSION IF NOT EXISTS postgis_topology VERSION '$POSTGIS_VERSION';
    ALTER EXTENSION postgis_topology UPDATE TO '$POSTGIS_VERSION';
    -- Upgrade advanced geoprocessing
    CREATE EXTENSION IF NOT EXISTS postgis_sfcgal VERSION '$POSTGIS_VERSION';
    ALTER EXTENSION postgis_sfcgal UPDATE TO '$POSTGIS_VERSION';
EOF
