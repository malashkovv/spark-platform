from src.log import logger


def tokenize(sentence):
    import nltk
    return nltk.word_tokenize(sentence)


def handle(sc):
    words = sc.textFile('/data/file.txt') \
        .flatMap(tokenize)

    reduced_words = words.filter(lambda w: w not in ',.-)(!&?*;:"') \
        .map(lambda x: (x, 1)) \
        .reduceByKey(lambda x, y: x + y) \
        .sortBy(lambda x: x[1], ascending=False)

    logger.info(reduced_words.take(10))
