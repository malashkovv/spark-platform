from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("local").setAppName("Test")
sc = SparkContext(conf=conf)

lines = sc.textFile('/data/file.csv')
filtered = lines.filter(lambda line: "Technical/Other bounce" in line)

print "All: {}, Filterd: {}".format(lines.count(), filtered.count())
