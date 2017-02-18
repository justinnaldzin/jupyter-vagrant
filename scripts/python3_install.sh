#!/bin/sh -e

set -x

yum -y update

# Install development tools
yum -y install python-pip python-devel python-setuptools python-virtualenv libffi-devel openssl-devel
pip install --upgrade pip setuptools wheel virtualenv

# Install Python 3
yum -y install https://centos7.iuscommunity.org/ius-release.rpm   # Inline with Upstream Stable. A community project, IUS provides Red Hat Package Manager (RPM) packages for some newer versions of select software.
yum -y install python35u  # Python 3.5
yum -y install python35u-pip  # pip
yum -y install python35u-devel  # libraries and header files
sudo ln -s /usr/bin/python3.5 /usr/bin/python3  # create a symbolic link "python3" to point to "python3.5"
sudo ln -s /usr/bin/pip3.5 /usr/bin/pip3  # create a symbolic link "pip3" to point to "pip3.5"
pip3 install --upgrade pip setuptools wheel virtualenv