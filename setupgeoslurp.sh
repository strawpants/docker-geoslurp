#!/bin/bash



#sets up the geoslurp database and roles, but only if appropriate environment variables have been set
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname geoslurp << EOF
CREATE ROLE geoslurp;
GRANT CREATE ON DATABASE geoslurp TO geoslurp;
CREATE SCHEMA admin;
GRANT CREATE,USAGE ON SCHEMA admin to geoslurp;
CREATE ROLE geobrowse; 
GRANT USAGE ON SCHEMA admin to geobrowse;
EOF

# wrapper function which uses the db admin 
function geoslurperadmin {

    if [[ -z ${GEOSLURP_SETTINGS+x} ]] ;
    then
        geoslurper.py --host ${GEOSLURP_HOST} --user ${POSTGRES_USER} --password ${POSTGRES_PASSWORD} --write-local-settings $@
    else
        geoslurper.py --host ${GEOSLURP_HOST} --user ${POSTGRES_USER} --password ${POSTGRES_PASSWORD} --write-local-settings --local-settings ${GEOSLURP_SETTINGS} $@
    fi

}



#setup correct mirror mapping (the intenal path to the data is different from outside)
if [[ -z "${GEOSLURP_DATAROOT+x}" ]] ; then
    echo "WARNING: no GEOSLURP_DATAROOT has been set, this may give problems when mapping directories and filepaths from outside the docker container"
    geoslurperadmin --admin-config '{"MirrorMaps":{"default":"/geoslurp_data/"}}' --cache "/geoslurp_cache"
else
    geoslurperadmin --admin-config '{"MirrorMaps":{"default":"'${GEOSLURP_DATAROOT}'/","docker":"/geoslurp_data/"}}' --cache "/geoslurp_cache"
fi

#create user if requested 
if [[ -z "${GEOSLURP_USER+x}"  && -z "${GEOSLURP_UPASSWD+x}" ]] ; then
    echo "Skipping initializing dedicated read/write geoslurp user" 
else
    if [[ $GEOSLURP_USER == "geoslurp" ]]; then
    
        echo "non-admin read-write geoslurp user cannot be named  'geoslurp',skipping this user"
    
    else

        echo "generating non-admin read-write geoslurp user" $GEOSLURP_USER
        #create the corresponding postgres user
        geoslurperadmin --add-user ${GEOSLURP_USER}:${GEOSLURP_UPASSWD}

    fi
fi

if [[ -z "${GEOSLURP_ROUSER+x}"  && -z "${GEOSLURP_ROUPASSWD+x}" ]] ; then
    echo "Skipping initializing dedicated read-only geoslurp user" 
else
    if [[ $GEOSLURP_ROUSER == "geoslurp" ]]; then
    
        echo "non-admin read-only geoslurp user cannot be named  'geoslurp', skipping this user"
    
    else

        echo "generating non-admin read-only geoslurp user" $GEOSLURP_ROUSER
	
	geoslurperadmin --add-readonly-user ${GEOSLURP_ROUSER}:${GEOSLURP_ROUPASSWD} 
    fi
fi



