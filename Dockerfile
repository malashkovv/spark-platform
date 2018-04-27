FROM python:3.5

ARG SPARK_VERSION=2.3.0
ARG HADOOP_VERSION=2.7
ARG JAVA_VERSION=8

RUN echo deb http://mirrors.digitalocean.com/debian jessie-backports main >> /etc/apt/sources.list
RUN apt-get update -y && apt-get install -t jessie-backports openjdk-8-jre-headless ca-certificates-java wget -y

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV PATH=$PATH:/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64/jre/bin:/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64/bin

RUN mkdir /usr/spark/
RUN wget -O /usr/spark/spark.tgz "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz"

RUN tar -xf /usr/spark/spark.tgz -C /usr/spark/

ENV SPARK_HOME="/usr/spark/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

RUN rm /usr/spark/spark.tgz

WORKDIR /usr/src/app/

RUN pip install --upgrade pip
RUN pip install ipython nltk jupyter py4j pyspark==$SPARK_VERSION

RUN python -m nltk.downloader -d /usr/lib/nltk_data punkt

ENV PYTHONPATH="/usr/src/app/"

ENV SPARK_VERSION=$SPARK_VERSION

COPY . .

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080 8081 7077 7078

ENTRYPOINT ["/entrypoint.sh"]
