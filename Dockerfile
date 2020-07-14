FROM centos:7

ARG SPARK_VERSION=2.4.4
ARG HADOOP_VERSION=2.7
ARG JAVA_VERSION=8
ARG PYTHON_VERSION=3.6
ARG PY4J_VERSION=0.10.7

RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum update -y && yum install -y \
                  java-1.8.0-openjdk \
                  wget \
                  python36u \
                  python36u-libs \
                  python36u-devel \
                  python36u-pip

RUN ln -fs /usr/bin/python3.6 /usr/bin/python
RUN ln -fs /usr/bin/pip3.6 /usr/bin/pip

RUN mkdir /usr/spark/
RUN wget -O /usr/spark/spark.tgz "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz" \
    && tar -xf /usr/spark/spark.tgz -C /usr/spark/ \
    && rm /usr/spark/spark.tgz

ENV SPARK_HOME="/usr/spark/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

RUN pip install ipython jupyter numpy

ENV PYTHONPATH="${SPARK_HOME}/python/lib/py4j-${PY4J_VERSION}-src.zip:${SPARK_HOME}/python:${SPARK_HOME}/python/build"

ENV SPARK_VERSION=$SPARK_VERSION

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080 8081 7077 7078 7000

RUN python -V

ENTRYPOINT ["/entrypoint.sh"]
