from src.log import logger

def tokenize(sentence):
    import nltk
    logger.info("Tokenizing: {}".format(sentence))
    return nltk.word_tokenize(sentence)

def handle(sc):
    words = sc.textFile('/data/file.csv')\
        .flatMap(tokenize)

    reduced_words = words.map(lambda x: (x, 1)).reduceByKey(lambda x, y: x + y).sortByKey()
    logger.info(reduced_words.take(10))