from src.log import logger

def handle(sc):
    lines = sc.textFile('/data/file.csv')
    filtered = lines.filter(lambda line: "Technical/Other bounce" in line)
    logger.info("All: {}, Filterd: {}".format(lines.count(), filtered.count()))