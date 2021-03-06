#!/usr/bin/env bash

set -e

: ${SPARK_WORKER_PORT:="7078"}

: ${SPARK_MASTER_PORT:="7077"}
: ${SPARK_MASTER_HOST:="master"}
: ${SPARK_WORKER_HOST:="worker"}

: ${SPARK_PUBLIC_DNS:="localhost"}

: ${SPARK_WORKER_WEBUI_PORT:="8081"}
: ${SPARK_MASTER_WEBUI_PORT:="8080"}

set_ipython() {
    if [[ $SPARK_VERSION == *"2."* ]] ; then
        export PYSPARK_DRIVER_PYTHON=ipython
    else
        export IPYTHON=1
    fi
}

set_jupyter() {
  export PYSPARK_DRIVER_PYTHON=jupyter
  export PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*' --NotebookApp.token='' --NotebookApp.password='' --port=7000 --allow-root"
  export PYSPARK_PYTHON=python
}

if [ $1 == 'spark-ipython' ]; then
    set_ipython
    exec $SPARK_HOME/bin/pyspark --master spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
elif [ $1 == 'spark-jupyter' ]; then
    set_jupyter
    exec $SPARK_HOME/bin/pyspark --master spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
elif [ $1 == 'submit' ]; then
    exec $SPARK_HOME/bin/spark-submit $2
elif [ $1 == 'worker' ]; then
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
elif [ $1 == 'master' ]; then
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master
fi

exec "$@"