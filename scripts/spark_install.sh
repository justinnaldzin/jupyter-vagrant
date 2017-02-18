
#!/bin/sh -e

set -x

# Install Java JDK
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm
rpm -ivh jdk-8u121-linux-x64.rpm
#yum -y install java-1.8.0-openjdk*  # Alternatively install Open JDK

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
