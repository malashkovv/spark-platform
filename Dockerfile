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
RUN pip install ipython nltk

RUN python -m nltk.downloader -d /usr/lib/nltk_data punkt

ENV PYTHONPATH="/usr/src/app/"

ENV SPARK_VERSION=$SPARK_VERSION
COPY . .

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080 8081 7077 7078

ENTRYPOINT ["/entrypoint.sh"]
