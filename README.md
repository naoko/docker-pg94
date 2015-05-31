# docker-pg94

##USAGE##

#####bring container up#####
	# customize port number. default to 5432
	$port=5432
	$user={db_user}
	$password={db_password}
	$schema={db_name}
	$ docker run --rm -p ${port}:${port} --name pg94 -e USER=${user} -e PASSWORD=${password} -e SCHEMA=${schema} -e PORT=${port} naosato/postgresql


To run with customized settings

```
docker run --rm -p <db_port_on_host>:5432 --name <container_name> -e USER=<db_username> -e PASSWORD=<db_password> -e SCHEMA=<db_name> -e PORT=<db_port_on_host> naosato/postgresql
```


#####test connection#####

	$ psql -U ${user} -d ${schema} -h <docker_ip> -p ${port}
note: <docker_ip> would be localhost for linux user, for boot2docker user it is `boot2docker ip`

#####interact with container#####
	
	$docker exec -i -t pg94 bash

