#!/bin/bash

#this wraps the docker-entrypoint.sh script and adds a geoslurp user when needed


#create user if requested 
if [[ -z "${GEOSLURP_USER+x}"  && -z "${GEOSLURP_UPASSWD+x}" ]] ; then
    echo "Skipping initializing dedicated read/write geoslurp user" 
else
    if id ${GEOSLURP_USER} >& /dev/null;
    then
        echo user $GEOSLURP_USER exists already skipping
    else

        if [[ $GEOSLURP_USER == "geoslurp" ]]; then
        
            echo "non-admin read-write geoslurp user cannot be named  'geoslurp',skipping this user"
        
        else

            echo "generating system user " $GEOSLURP_USER
            #create a system user which will be used to run geoslurpwrapper scripts
            useradd -r  -u ${GEOSLURP_UID} -s /bin/false ${GEOSLURP_USER}
            #try changing permissions of data and cache 
            chown -f ${GEOSLURP_USER} /geoslurp_data 
            chown -f ${GEOSLURP_USER} /geoslurp_cache 

        fi
    fi
fi



#executes docker entrypoint from postgis (initiates the databasei and start the db service)
docker-entrypoint.sh postgres



