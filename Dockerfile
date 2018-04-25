FROM openjdk:8

ARG SPARK_VERSION=1.6.0
ARG HADOOP_VERSION=2.4

RUN apt-get update -y
RUN apt-get install wget \
                    python-pip \
                    -y

RUN mkdir /usr/spark/
RUN wget -O /usr/spark/spark.tgz "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz"

RUN tar -xf /usr/spark/spark.tgz -C /usr/spark/

ENV SPARK_HOME="/usr/spark/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION"

RUN rm /usr/spark/spark.tgz

WORKDIR /usr/src/app/

RUN pip install --upgrade pip
RUN pip install ipython requests

ENV IPYTHON=1

ENV PYTHONPATH="/usr/src/app/"

COPY . .

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
