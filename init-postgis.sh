#!/bin/sh

set -e

echo "Installing PostGIS extensions in geoslurp"
psql --dbname=$POSTGRES_DB -c --username "$POSTGRES_USER" << EOF
SELECT 'CREATE DATABASE geoslurp'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'geoslurp')\gexec
\connect geoslurp
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS plpgsql;
SET postgis.gdal_enabled_drivers TO 'ENABLE_ALL';
SET postgis.enable_outdb_rasters TO True;
ALTER DATABASE geoslurp SET postgis.gdal_enabled_drivers TO 'ENABLE_ALL';
ALTER DATABASE geoslurp SET postgis.enable_outdb_rasters TO True;
SELECT pg_reload_conf();
EOF
