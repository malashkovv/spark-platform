import json

from src.log import logger


def tokenize(sentence):
    import nltk
    return nltk.word_tokenize(sentence)


def is_not_stop_word(word):
    from nltk.corpus import stopwords
    stopwords = set(stopwords.words('english'))
    return word not in stopwords


def is_not_sign(word):
    return word not in '’\',.-)(!&?*;:"'


def handle(sc):
    words = sc.textFile('/data/input') \
        .flatMap(tokenize)

    mapped_words = words\
        .filter(is_not_sign) \
        .filter(is_not_stop_word) \
        .map(lambda x: (x, 1)) \
        .persist()

    logger.info(mapped_words.getNumPartitions())

    words_count = mapped_words\
        .reduceByKey(lambda x, y: x + y)

    words_count.map(json.dumps).saveAsTextFile('/data/output')