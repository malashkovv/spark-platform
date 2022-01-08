FROM centos:8

# User Spark version above 2.x
ARG SPARK_VERSION=3.1.2
ARG HADOOP_VERSION=3.2
ARG PYTHON_VERSION=3.7.12

RUN yum install -y java-1.8.0-openjdk

RUN yum -y groupinstall "Development Tools" \
    && yum install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite \
                      sqlite-devel openssl-devel xz xz-devel libffi-devel maven \
    && yum install -y wget

RUN mkdir /usr/python/
RUN wget -O /usr/python/python.tgz "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz" \
    && tar -xf /usr/python/python.tgz -C /usr/python/ \
    && rm /usr/python/python.tgz  \
    && cd /usr/python/Python-$PYTHON_VERSION \
    && ./configure --enable-optimizations --with-ensurepip=install --enable-loadable-sqlite-extensions \
    && make altinstall

RUN mkdir /usr/spark/
RUN wget -O /usr/spark/spark.tgz "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz" \
    && tar -xf /usr/spark/spark.tgz -C /usr/spark/ \
    && rm /usr/spark/spark.tgz

RUN export PYTHON_MAJOR_VERSION=$(cut -d '.' -f-2 <<< $PYTHON_VERSION) \
    && ln -fs /usr/local/bin/python$PYTHON_MAJOR_VERSION /usr/bin/spark-python \
    && ln -fs /usr/local/bin/pip$PYTHON_MAJOR_VERSION /usr/bin/spark-pip

ENV SPARK_HOME="/usr/spark/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

COPY ./pom.xml.template ./pom.xml.template

RUN export HADOOP_VERSION=${HADOOP_VERSION}.0 \
    && cat pom.xml.template | envsubst > pom.xml \
    && rm pom.xml.template \
    && mvn -DoutputDirectory=$SPARK_HOME/jars/ dependency:copy-dependencies

# TODO: pin versions?
RUN spark-pip install ipython jupyter numpy pyspark==${SPARK_VERSION}

COPY entrypoint.sh /entrypoint.sh

ENV SPARK_VERSION=$SPARK_VERSION

# TODO: Add spark user instead of root

EXPOSE 8080 8081 7077 7078 7000

ENTRYPOINT ["/entrypoint.sh"]