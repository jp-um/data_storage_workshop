FROM continuumio/miniconda3
MAINTAINER JP <jean.p.ebejer@um.edu.mt>

# meta information on the container
LABEL version="1.0.1" \
      description="Container to run JP's NoSQL workshop"

# Add Tini
ENV TINI_VERSION v0.17.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# install and activate python 3.5 -- this is a requirement below
RUN conda create -n py35 python=3.5
ENV PATH /opt/conda/envs/py35/bin:$PATH

RUN conda install --name py35 -y pandas jupyter scikit-learn graphviz python-graphviz matplotlib
RUN pip install python3-memcached pymongo cassandra-driver py2neo ## nosql stuff
# Jupyter Lab installation
RUN pip install jupyterlab && jupyter serverextension enable --py jupyterlab

# note that we do not need to install any nosql system as we just use already
# made docker containers for the functionality.  Point out to the students that
# unless they mount data volumes locally, they will lose their data

# Stuff for Jupyter notebook
RUN mkdir /notebooks
## If you want the traditional notebooks instead of Lab ...
## CMD jupyter-notebook --ip="*" --no-browser --allow-root --notebook-dir=/notebooks
CMD jupyter lab --ip="*" --no-browser --allow-root --notebook-dir=/notebooks
