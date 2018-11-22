# Data Storage Workshop &ndash; Dr Jean-Paul Ebejer

In this workshop (typically for Data Science and Big-Data sessions) we are going
to look at storing data in database systems, as opposed to storing them in text 
files (```.csv```).

# Requirements

The following assumes you have a base Linux (Ubuntu 16.04.5 LTS) installation.
Other more recent versions may work too (let me know otherwise).  If you are a 
windows fan, may I suggest you create a beefy VM (using VirtualBox or on 
the cloud) and install Ubuntu there.

You will need a ton of different software (configuration, etc.) for this workshop.
At the very least you will need mysql, memcached, mongodb, cassandra, neo4j,
and Python drivers for all of these.  Normally, this would be a pain, but we 
will be using docker so everything is conveniently installed and set-up for you 
and placed in different docker containers (you're spoilt these days!).

The rest of the workshop (and practical) assumes you have docker installed.
This can be achieved readily (on Ubuntu 16.04.5 LTS) with:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}
```

After adding the docker group to your user, you will need to log out and in 
again to show the new group (check with the ```id``` Bash command).  An 
alternative to logging in and out again is to use ```su - $USER``` (this 
effectively re-logs you).

The Ubuntu instructions to install docker where taken from [the docker site](https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository).

# SQL (Relational) Databases

We will use the official latest mysql containers for the relational databases
part of the workshop.

This is easily achieved as follows:

```bash
# Get the latest (official) image for mysql
docker pull mysql/mysql-server:latest
# List all images available locally (you should see mysql)
docker images
# Start a container from the mysql/mysql-server:latest image
# You need to give this some time (takes longish to start)
docker run --name=some-mysql -e MYSQL_ROOT_HOST=% -e MYSQL_ROOT_PASSWORD=my-secret-pwd -d mysql/mysql-server:latest
# this will tell you what is going on with your instance
docker logs some-mysql
# what are the docker containers running, you should see mysql
docker ps
# from the sql directory, import the structure of the database (and some 
# data) from the insurance.sql script file.
docker exec -i some-mysql mysql -h0.0.0.0 -uroot -pmy-secret-pwd < insurance.sql
# use this if you want to run the client directly in the docker container
docker exec -it some-mysql mysql -h0.0.0.0 -uroot -pmy-secret-pwd
```
Skip to the Jupyter Lab section, if you are only interested in running the mysql
exercise.

# NoSQL Databases

During this workshop I will show you the basic concepts of NoSQL systems.  We 
will use four NoSQL technologies, each representing a different data model 
-- Memcached, MongoDB, Cassandra, and Neo4j.


## NoSQL Database Engines

We will use (the latest) official docker instances to install the NoSQL database
engines.  Follow the instructions presented in each section.  Each of these steps
may take a few minutes.  All the names of the containers will be prefixed with
`some-`.

### Memcached

To run memcached execute:

```bash
docker run --init --name some-memcache -p=21211:11211 -d memcached
```

`-d` detaches the docker container once initialized.

### MongoDB

To run mongodb execute:

```bash
docker run --name some-mongo -d mongo
```

### Cassandra

To run cassandra execute:

```bash
docker run --name some-cassandra -d cassandra
```

### Neo4J

To run neo4j execute:

```bash
docker run --name some-neo4j --env=NEO4J_AUTH=none -p=7474:7474 -p=7687:7687 -d neo4j
```

Note that the above switches off Neo4J authentication (by setting an environment
variable in the container).

# Jupyter Lab 

I have developed example usages of each NoSQL database, using Jupyter lab.  This
is a browser-based IDE which uses Jupyter Notebooks.  First, you should copy **all** 
code (as Jupyter notebooks) from the [sql](https://github.com/jp-um/data_storage_workshop/tree/master/sql) 
and [nosql](https://github.com/jp-um/data_storage_workshop/tree/master/nosql) directories
in a local directory on your Ubuntu installation (alternatively it is easier to 
```git clone``` this repository).  Remember to change the `/your/local/path` 
path below.

```bash
docker run -ti --rm \
    --name data-storage-workshop \
    --link some-mysql:mysql \
    --link some-memcache:memcache \
    --link some-mongo:mongo \
    --link some-cassandra:cassandra \
    --link some-neo4j:neo4j \
    -v /your/local/path:/notebooks \
    -p=8888:8888 \
    jpebe/data_storage_workshop
```
This container is linked to all the containers we set up (and are running).

You should then be able to copy the Jupyter notebook URL from the terminal into 
your browser (ctrl-click will open a browser automatically).

    
### Limitations

The databases we run within the containers have no volume mounted (from Ubuntu).  This means that all data created during our exercises is stored in the container 
which gets lost when you stop running the container.  If you want your data to 
persist, you have to mount volumes (on your Ubuntu installation) and use these 
as the data directory of the NoSQL engine.  For example, to keep a copy of
the neo4j data, simply run the docker container in the following manner:

```bash
docker run --name some-neo4j \
    --env=NEO4J_AUTH=none
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --volume=$HOME/neo4j/logs:/logs \
    -d neo4j
```

Where ```$HOME/neo4j/data``` and ```$HOME/neo4j/logs``` will be mounted in the
container under ```/data``` and ```/logs``` respectively.

Note that in the above workshop, changes to the jupyter notebooks will, however, 
be persisted as these are mounted from your own local directory.

### When you are done

You may want to reclaim some space on your Ubuntu installation.  Remove all images 
and containers in the following way.

```bash
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
```

<!--
```
docker pull jpebe/nosql
```
-->

### Conclusion

**Pull requests (with fixes, even to this guide) will be recieved with appreciation and thanks.**

I hope you enjoy this session!

Dr Jean-Paul Ebejer
<br />

![](https://github.com/drmenguin/learnd/blob/master/jp.gif)
