# Data Storage Workshop &ndash; Prof. Jean-Paul Ebejer

In this workshop (typically for Data Science and Big-Data sessions) we are going to look at storing data in database systems, as opposed to storing them in text files (e.g. `.csv`).

# Requirements

The following assumes you have a base Linux (Ubuntu 24.04 LTS) installation. Other more recent versions may work too (let me know otherwise).  If you are a Microsoft Windows fan, may I suggest you create a beefy VM (using VirtualBox or on the cloud) and install Ubuntu there or use [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).

You will need a ton of different software (configuration, etc.) for this workshop. At the very least you will need mysql, memcached, mongodb, cassandra, neo4j, and Python drivers for all of these. Normally, this would be a pain, but we will be using docker (and docker compose) so everything is conveniently installed and set-up for you and placed in different docker containers (you're spoilt these days!).

The rest of the workshop (and practical) assumes you have docker installed. This can be achieved readily by following the [instructions](https://docs.docker.com/engine/install/ubuntu/) on the docker website.

Clone this github repository using ```git clone git@github.com:jp-um/data_storage_workshop.git```.  (If you do not have your ssh keys and/or account set up in github you can simply ```git clone https://github.com/jp-um/data_storage_workshop.git``` instead). **You should then run this workshop from the root directory of the repository.**  If `git` is unavailable on your Ubuntu OS, simply ```sudo apt install git```.

# Running the Workshop with Docker Compose

Forget the individual docker run commands! We can run all services (MySQL, Memcached, MongoDB, Cassandra, Neo4j, and the actual Jupyter Lab code environment) with a single `docker-compose.yml` file. This file is found at the root of the git repository.

## Start All Services

To start all these services simply:

```bash
docker compose up -d
```

This will i) pull all necessary images, ii) start all services, and iii) automatically import the `insurance.sql` data into MySQL (no need to run `docker exec`). `docker compose` is a godsend!

## Access Jupyter Lab

Once all services have started, the tutorial files should be avilable at [http://127.0.0.1:8888/login?token=my-secret-jupyterlab-token](http://127.0.0.1:8888/login?token=my-secret-jupyterlab-token).

## Stopping the Workshop

To stop all the containers running and to fully clear the data run:

```bash
docker compose down -v
```

    
## Limitations

The databases we run within the containers (by default with docker compose) have no persistent volume mounted (from Ubuntu). This means that all data created during our exercises is stored in the container which gets lost when you run `docker compose down -v`. If you want your data to persist, you have to mount volumes (on your Ubuntu installation) and use these as the data directory of the NoSQL engine. For example, to keep a copy of the neo4j data, you would modify the neo4j service in `docker-compose.yml`:

```yaml
neo4j:
    image: neo4j
    ...
    volumes:
      - $HOME/neo4j/data:/data
      - $HOME/neo4j/logs:/logs
```

Where `$HOME/neo4j/data` and `$HOME/neo4j/logs` will be mounted in the container under `/data` and `/logs` (inside the container) respectively.

Note that in the above workshop, changes to the jupyter notebooks will, however, be persisted as these are mounted from your own local directory.

# How to build

To build this image from the dockerfile, all you need is (from the dockerfile directory)

```bash
docker build -t jpebe/data_storage_workshop .
```

# When you are done

You may want to reclaim some space on your Ubuntu installation.  Remove all images and containers in the following way.

```bash
# This cleans up *all* unused docker objects on your system (not just for this project)
docker system prune -a
```

# Conclusion

**Pull requests (with fixes, even to this guide) will be recieved with appreciation and thanks.**

I hope you enjoy this session!

Prof. Jean-Paul Ebejer

![](https://github.com/drmenguin/learnd/blob/master/jp.gif)
