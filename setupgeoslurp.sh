#!/bin/sh

#sets up the geoslurp database and roles, but only if appropriate environment variables have been set
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname geoslurp << EOF
CREATE ROLE geoslurp;
GRANT CREATE ON DATABASE geoslurp TO geoslurp;
CREATE SCHEMA admin;
GRANT CREATE ON SCHEMA admin to geoslurp;
CREATE ROLE geobrowse; 
EOF

