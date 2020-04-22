#!/bin/sh

set -e

echo "Installing PostGIS extensions in geoslurp"
psql -v --dbname geoslurp --username "$POSTGRES_USER" <<EOF
    CREATE EXTENSION IF NOT EXISTS postgis;
    CREATE EXTENSION IF NOT EXISTS postgis_raster;
    CREATE EXTENSION IF NOT EXISTS postgis_topology;
    CREATE EXTENSION IF NOT EXISTS postgis_sfcgal;
    CREATE EXTENSION IF NOT EXISTS plpython3u;
    SET postgis.gdal_enabled_drivers TO 'ENABLE_ALL';
    SET postgis.enable_outdb_rasters TO True;
    ALTER DATABASE geoslurp SET postgis.gdal_enabled_drivers TO 'ENABLE_ALL';
    ALTER DATABASE geoslurp SET postgis.enable_outdb_rasters TO True;
    SELECT pg_reload_conf();
EOF
