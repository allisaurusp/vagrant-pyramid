#!/bin/bash

pyver="3.4.3" #python 3.x only
pyramidver="1.5.7"
pyramiddir="/var/pyramid"
mysqlrootpwd="password"

#fail on error
set -e

### Setting up directory tree... ### 
mkdir -p $pyramiddir/
chown -Rv vagrant $pyramiddir/
chgrp -Rv vagrant $pyramiddir/
cd $pyramiddir/

### Preseeding Debconf... ###
echo mysql-server-5.5 mysql-server/root_password password $mysqlrootpwd | debconf-set-selections
echo mysql-server-5.5 mysql-server/root_password_again password $mysqlrootpwd | debconf-set-selections
export DEBIAN_FRONTEND="noninteractive" # ward off ncurses

### Installing system prerequisites ###
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install \
		build-essential \
		libcurl4-openssl-dev \
		libsqlite3-dev \
		sqlite \
		mysql-server \
		mysql-client \
		python-dev \
		libmysqlclient-dev \
		imagemagick

### Downloading Python ###
wget https://www.python.org/ftp/python/$pyver/Python-$pyver.tgz

### Extracting Python ###
tar xzfv Python-$pyver.tgz 

cd Python-$pyver/

### Configuring/Compile/Install Python ###
./configure --prefix=$pyramiddir/Python-$pyver
make
make install

cd $pyramiddir/

### Setting up virtual environment... ###
Python-$pyver/bin/pyvenv $pyramiddir/env/

### This seems hacky (wasn't required in Python 3.3.x)
cat <<EOF >> $pyramiddir/env/bin/activate
export PYTHONPATH=$PYTHONPATH:/var/pyramid/project_files
EOF

### Activating virtual environment... ###
source $pyramiddir/env/bin/activate

### Installing pip ###
#wget https://bootstrap.pypa.io/get-pip.py -O - | $pyramiddir/env/bin/python
$pyramiddir/env/bin/pip install --upgrade pip

### Installing Pyramid ###
$pyramiddir/env/bin/pip install pyramid==$pyramidver

### Installing Project Dependencies ###
$pyramiddir/env/bin/python $pyramiddir/project_files/setup.py develop

### Setting up permissions ###
chown -Rv vagrant $pyramiddir/
chgrp -Rv vagrant $pyramiddir/

echo "To begin working, activate your virtual environment by running:"
echo "source $pyramiddir/env/bin/activate"