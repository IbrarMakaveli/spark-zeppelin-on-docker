FROM debian:stretch
MAINTAINER Getty Images "https://github.com/gettyimages"

RUN apt-get update \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Users with other locales should set this in their derivative image
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
 && apt-get install -y curl unzip \
    python3 python3-setuptools \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && easy_install3 pip py4j \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

# to download numpy these 5 packages + their dependencies must be installed:

# Python3 - 70 mb
# Python3-dev - 25 mb
# gfortran - 20 mb
# gcc - 70 mb
# musl-dev -10 mb (used for tracking unexpected behaviour/debugging)

ADD requirements-pip.txt .
RUN pip3 install --upgrade pip setuptools && \
    pip3 install -r requirements-pip.txt


# JAVA
RUN apt-get update \
 && apt-get install -y openjdk-8-jre \
 && apt-get -y install curl less \
 && apt-get clean \
 && apt-get install -y procps \
 && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

# HADOOP
ENV HADOOP_VERSION 3.0.0
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN curl -L --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | gunzip \
  | tar -x -C /usr/ \
 && rm -rf $HADOOP_HOME/share/doc \
 && chown -R root:root $HADOOP_HOME


# SPARK
ENV SPARK_VERSION 2.4.5
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -L --retry 3 \
  "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME
ENV MASTER spark://master:7077

# HIVEE JAR
ENV HIVE_VERSION 2.11
ADD https://repo1.maven.org/maven2/org/apache/spark/spark-hive_${HIVE_VERSION}/${SPARK_VERSION}/spark-hive_${HIVE_VERSION}-${SPARK_VERSION}.jar ${HADOOP_HOME}/share/hadoop/common/lib/


# ZEPPELIN
ENV ZEPPELIN_VERSION 0.8.2
RUN mkdir /usr/zeppelin 
ENV ZEPPELIN_HOME /usr/zeppelin
RUN curl -L --retry 3 \
  "http://apache.crihan.fr/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-netinst.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/zeppelin-${ZEPPELIN_VERSION}-bin-netinst/* $ZEPPELIN_HOME \
 && chown -R root:root $ZEPPELIN_HOME
 
RUN mkdir -p ${ZEPPELIN_HOME} \
  && mkdir -p ${ZEPPELIN_HOME}/logs \
  && mkdir -p ${ZEPPELIN_HOME}/run

WORKDIR $SPARK_HOME