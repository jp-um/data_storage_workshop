# ICS5114 Big Data Processing

During this workshop I will show you the basic concepts of NoSQL systems.  We will use four NoSQL technologies, each representing a different data model -- Memcached, MongoDB, Cassandra, and Neo4j

You will need a ton of different software (configuration, etc.).  This would be a pain normally, but we will be using docker so everything is conveniently installed and set-up for you and placed in different docker containers (you're spoilt these days!).

All the following implies you have docker installed.  This can be achieved readily (on Ubuntu 16.04.3 LTS) with:

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}
```

To run memcache issue (this may take a few minutes):

```
docker run --init --name some-memcache -d memcached
```

To run mongo db issue (this may take a few minutes):

```
docker run --name some-mongo -d mongo

To run cassandra issue (this may take a few minutes):

```
docker run --name some-cassandra -d cassandra
```

To run neo4j issue (this may take a few minutes):

```
docker run --name some-neo4j --env=NEO4J_AUTH=none -p=7474:7474 -p=7687:7687 -d neo4j
```


Finally, pull the docker image from dockerhub.io

```
docker pull jpebe/nosql
```

You should copy **all** the Jupyter notebooks and data files [here](https://github.com/jp-uom/ARI5902_Research_Topics_In_Artificial_Intelligence/tree/master/jupyter) in a local directory.

Copy all the

```
docker run -ti --rm --name nosql -v /home/jp/cloud/google-drive-uom/lecturing/2017-2018/ICS5114_Big_Data_Processing/class_practicals/nosql/docker/jupyter:/notebooks --link some-memcache:memcache --link some-mongo:mongo --link some-cassandra:cassandra --link some-neo4j:neo4j -p=8888:8888 nosql
```

You should then be able to copy the Jupyter notebook URL from the terminal into your browser (ctrl-click will open a browser automatically).

The more docker-experienced people, can probably build the docker image from the docker file in this repository (```docker build -t ari5901 .```).

Pull requests (with fixes) will be recieved with thanks.

![](https://github.com/drmenguin/learnd/blob/master/jp.gif)
