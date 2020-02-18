#!/usr/bin/env bash

set -x -e

# https://towardsdatascience.com/getting-started-with-pyspark-on-amazon-emr-c85154b6b921

echo "Installing OS dependencies"
sudo yum-config-manager --enable epel
sudo yum install -y pandoc

echo "Installing runtime libraries"
sudo pip-3.6 install -vvv -U wheel
sudo pip-3.6 install -vvv -U \
    scikit-learn \
    spark-emr \
    pyspark \
    plotly \
    pandas \
    numpy

echo "Done"
