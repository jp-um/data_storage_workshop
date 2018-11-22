FROM continuumio/miniconda3

# meta information on the container
LABEL maintainer="JP <jean.p.ebejer@um.edu.mt>" \
      version="2.0 (2018/9)" \
      copyright="(C)2017-2019" \
      description="Container to run JP's Data Storage Workshop"

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "-s", "--"]

# install and activate python 3.5 -- this is a requirement below
RUN conda create -n py35 python=3.5 # 3.6 does not work at this point in time.
ENV PATH /opt/conda/envs/py35/bin:$PATH

# add conda-forge
RUN conda config --add channels conda-forge
# required dependencies
RUN conda install --name py35 -y pandas jupyter scikit-learn graphviz python-graphviz matplotlib python-memcached pymongo cassandra-driver neo4j-python-driver mysql-connector-python jupyterlab

# note that we do not need to install any nosql system as we just use already
# made docker containers for the functionality.  Point out to the students that
# unless they mount data volumes locally, they will lose their data

# Stuff for Jupyter notebook
RUN mkdir /notebooks
## If you want the traditional notebooks instead of Lab ...
## CMD jupyter-notebook --ip="0.0.0.0" --no-browser --allow-root --notebook-dir=/notebooks
CMD jupyter lab --ip="0.0.0.0" --no-browser --allow-root --notebook-dir=/notebooks
