#!/usr/bin/env bash
create_user () {
    if [ -e /var/tmp/firstrun ]; then
    	mkdir /var/run/postgresql/9.4-main.pg_stat_tmp
    	echo "Waiting for PostgreSQL to start"
    	while [ ! -e /var/run/postgresql/9.4-main.pid ]; do
            inotifywait -q -q -e create /var/run/postgresql/
        done

    	# We sleep here for 2 seconds to allow clean output, and speration from postgres startup messages
    	sleep 2
        echo "Below are your configured options."
        echo -e "================\nUSER: $USER\nPASSWORD: $PASSWORD\nSCHEMA: $SCHEMA\nPORT: $PORT\n================"
        if [ $USER == "postgres" ]; then
            echo "ALTER USER :user WITH PASSWORD :'password' ;" | psql --set user=$USER --set password=$PASSWORD
            
        else
            echo "CREATE USER :user WITH SUPERUSER PASSWORD :'password' ;" | psql --set user=\"$USER\" --set password=$PASSWORD;
        fi

        if [ $SCHEMA != "postgres" ]; then
        	echo "CREATE Database :schema $SCHEMA ;" | createdb $SCHEMA --encoding='utf-8' --template=template0;
        fi

        echo 'CREATE EXTENSION pgcrypto; CREATE EXTENSION "uuid-ossp";' | psql -d $SCHEMA
        echo 'CREATE EXTENSION pgcrypto; CREATE EXTENSION "uuid-ossp";' | psql -d template1

        rm /var/tmp/firstrun
    fi
}
create_user &
exec /usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf
