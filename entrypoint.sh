#!/usr/bin/env bash

set -e

: ${MODE:="LOCAL"}

: ${SPARK_WORKER_PORT:="7078"}

: ${SPARK_MASTER_PORT:="7077"}
: ${SPARK_MASTER_HOST:="master"}
: ${SPARK_WORKER_HOST:="worker"}

: ${SPARK_PUBLIC_DNS:="localhost"}

: ${SPARK_WORKER_WEBUI_PORT:="8081"}
: ${SPARK_MASTER_WEBUI_PORT:="8080"}

export PYSPARK_PYTHON=/usr/bin/spark-python

set_ipython() {
  export PYSPARK_DRIVER_PYTHON=ipython
}

set_jupyter() {
  export PYSPARK_DRIVER_PYTHON=jupyter
  export PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*' --NotebookApp.token='' --NotebookApp.password='' --port=7000 --allow-root"
}

set_master_uri() {
  if [ ${MODE} == 'LOCAL' ]; then
    export MASTER_URI="local[*]"
  elif [ ${MODE} == 'STANDALONE' ]; then
    export MASTER_URI="spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}"
  else
    echo "Wrong MODE=${MODE}. Aborting."
    exit 1
  fi
}

run() {
  set_master_uri
  exec $SPARK_HOME/bin/$1 --master $MASTER_URI ${@:2}
}

if [ $1 == 'spark-ipython' ]; then
    set_ipython
    run pyspark ${@:2}
elif [ $1 == 'spark-jupyter' ]; then
    set_jupyter
    run pyspark ${@:2}
elif [ $1 == 'spark-sql' ]; then
    run spark-sql ${@:2}
elif [ $1 == 'spark-submit' ]; then
    run spark-submit ${@:2}
elif [ $1 == 'worker' ]; then
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}
elif [ $1 == 'master' ]; then
    exec $SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master
fi

exec "$@"