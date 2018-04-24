from pyspark import SparkConf, SparkContext
from src.handler import handle
from src.log import logger

conf = SparkConf().setMaster("local").setAppName("Test")

with SparkContext(conf=conf) as sc:
    logger.info("Invoking handler.")
    handle(sc)
