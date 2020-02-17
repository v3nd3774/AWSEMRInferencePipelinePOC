#!/usr/bin/env bash

set -x -e

# https://towardsdatascience.com/getting-started-with-pyspark-on-amazon-emr-c85154b6b921

echo "Installing OS dependencies"
sudo yum clean all
sudo yum clean metadata
find /etc/yum.repos.d -exec sed -i 's/enabled = 0/enabled = 1/g' {} \;
sudo yum -y update
sudo wget https://github.com/jgm/pandoc/releases/download/2.9.2/pandoc-2.9.2-linux-amd64.tar.gz
sudo tar -xvf pandoc-2.9.2-linux-amd64.tar.gz
sudo ls -al
sudo ls -al pandoc*
sudo ln -s /root/pandoc-2.9.2/bin/pandoc /usr/bin/pandoc

echo "Installing runtime libraries"
sudo pip install -vvv -U \
    scikit-learn \
    spark-emr \
    pyspark \
    awscli \
    plotly \
    pandas \
    numpy

echo "Done"
