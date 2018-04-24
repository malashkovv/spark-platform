#!/usr/bin/env bash

set -e

PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python/:$SPARK_HOME/python/lib/$(ls $SPARK_HOME/python/lib/ | grep py4j)

if [ $1 == 'shell' ]; then
    exec $SPARK_HOME/bin/pyspark
elif [ $1 == 'submit' ]; then
    exec $SPARK_HOME/bin/spark-submit $1
fi

exec "$@"