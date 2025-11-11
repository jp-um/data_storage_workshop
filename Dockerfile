FROM jupyter/scipy-notebook:latest

# meta information on the container
LABEL maintainer="JP <jean.p.ebejer@um.edu.mt>" \
      version="4.0" \
      copyright="(C)2017-2026" \
      description="Container to run JP's Data Storage Workshop"

# Start from the scipy-notebook image
# This base image already includes:
# - jupyterlab
# - pandas
# - scikit-learn
# - matplotlib


# We use mamba (a fast conda installer) which is pre-installed in the base image.
# It's the recommended way to install packages in this stack.
# We install from the 'conda-forge' channel, which has all the packages.
#
# This single command will install:
# 1. The python-graphviz library
# 2. The graphviz system binary (as a dependency of python-graphviz)
# 3. All the requested database drivers
RUN mamba install --yes -c conda-forge \
    'python-graphviz' \
    'python-memcached' \
    'pymongo' \
    'cassandra-driver' \
    'mysql-connector-python' && \
    # Clean up the cache to keep the final image smaller
    mamba clean --all -f -y
