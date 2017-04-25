#!/bin/sh -e

set -x

# Install updates
yum -y update
yum -y install yum-utils
yum -y install git curl wget epel-release gcc
yum -y groupinstall development
yum -y install python-pip python-devel python-setuptools python-virtualenv libffi-devel openssl-devel
pip install --upgrade pip setuptools wheel virtualenv

# Install Python 3
yum -y update
yum -y install https://centos7.iuscommunity.org/ius-release.rpm   # Inline with Upstream Stable. A community project, IUS provides Red Hat Package Manager (RPM) packages for some newer versions of select software.
yum -y install python35u  # Python 3.5
yum -y install python35u-pip  # pip
yum -y install python35u-devel  # libraries and header files
yum -y install python-tools  # 2to3 tool
yum -y install cyrus-sasl-devel
sudo ln -s /usr/bin/python3.5 /usr/bin/python3  # create a symbolic link "python3" to point to "python3.5"
sudo ln -s /usr/bin/pip3.5 /usr/bin/pip3  # create a symbolic link "pip3" to point to "pip3.5"

# Install Java JDK
wget --no-verbose --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm
rpm -ivh jdk-8u121-linux-x64.rpm
#yum -y install java-1.8.0-openjdk*  # Alternatively install Open JDK
rm jdk-8u121-linux-x64.rpm

# Install Apache Spark
wget -qO- http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz | tar xvz -C /opt
ln -s /opt/spark-2.1.0-bin-hadoop2.7 /opt/spark

# Alternatively build Spark from source
#wget -qO- http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0.tgz | tar xvz -C /opt
#ln -s /opt/spark-2.1.0 /opt/spark
#export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
#cd /opt/spark/
#./dev/change-scala-version.sh 2.12  # specify Scala v2.12
#./build/mvn -Pyarn -Phadoop-2.7 -Dscala-2.12 -Dhadoop.version=2.7.0 -DskipTests clean package

# Set environment variables
echo 'export SPARK_HOME=/opt/spark' >> /etc/profile.d/spark.sh
echo 'export PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python:$SPARK_HOME/python/lib:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip' >> /etc/profile.d/spark.sh
echo 'export PATH=$PATH:$SPARK_HOME/bin' >> /etc/profile.d/spark.sh
echo 'export PYSPARK_PYTHON=python3' >> /etc/profile.d/spark.sh
echo 'export PYSPARK_DRIVER_PYTHON=python3' >> /etc/profile.d/spark.sh
#PYSPARK_DRIVER_PYTHON="jupyter"
#PYSPARK_DRIVER_PYTHON_OPTS="notebook"
# Spark environment variables are sourced from: $SPARK_HOME/conf/spark-env.sh
source /etc/profile.d/spark.sh
cp $SPARK_HOME/conf/log4j.properties.template $SPARK_HOME/conf/log4j.properties  # minimize the Verbosity of Spark

# Install Jupyter Notebook
pip3 install jupyter ipython[all]  #jupyter_core jinja2
#pip3 install jupyter-spark  # https://github.com/mozilla/jupyter-spark

# Install Apache Toree
# Toree is incompatible with Scala v2.11 and therefore kernels fail. Issue is being tracked at:'
# https://issues.apache.org/jira/browse/TOREE-373'
#pip3 install toree
#jupyter toree install --spark_home=$SPARK_HOME --interpreters=Scala,PySpark,SparkR,SQL --python_exec=python3

# Install sparkmagic
# sparkmagic is a Spark kernel for Jupyter Notebook supporting Scala and Python
pip3 install sparkmagic
jupyter nbextension enable --py --sys-prefix widgetsnbextension  # make sure that ipywidgets are properly installed
#pip3 show sparkmagic  # verify the path where sparkmagic is installed
cd /usr/lib/python3.5/site-packages/  # install the wrapper kernels
jupyter-kernelspec install sparkmagic/kernels/sparkkernel
jupyter-kernelspec install sparkmagic/kernels/pysparkkernel
jupyter-kernelspec install sparkmagic/kernels/pyspark3kernel
jupyter-kernelspec install sparkmagic/kernels/sparkrkernel
jupyter serverextension enable --py sparkmagic  # enable the server extension so that clusters can be programatically changed
# a configuration file can be created at ~/.sparkmagic/config.json

# Install additional Python libraries
pip3 install --upgrade pip setuptools wheel virtualenv
pip3 install pandas==0.19.2  # Powerful data structures for data analysis, time series,and statistics
pip3 install bokeh==0.12.4  # Python interactive visualization library that targets modern web browsers for presentation
pip3 install SQLAlchemy==1.1.4


# PyHive kerberos authentication support
pip3 install sasl==0.2.1
pip3 install thrift==0.9.3
pip3 install thrift-sasl==0.2.1
pip3 install pyhive[hive]
yum install cyrus-sasl-gssapi
pip3 install kerberos
# Error message:TTransportException: TTransportException(type=1, message="Could not start SASL: b'Error in sasl_client_start (-1) SASL(-1): generic failure: GSSAPI Error: Unspecified GSS failure.  Minor code may provide more information (No Kerberos credentials available (default cache: KEYRING:persistent:0))'")

yum install krb5-workstation
#kinit user@domain.com  # obtain and cache Kerberos ticket-granting ticket
# enter password
#klist  # list cached Kerberos tickets
