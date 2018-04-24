import logging

logger = logging.getLogger('application')
logger.setLevel(logging.INFO)

formatter = logging.Formatter('%(asctime)s %(levelname)s %(filename)s: %(message)s', "%y/%m/%d %H:%M:%S")
channel = logging.StreamHandler()

channel.setFormatter(formatter)
logger.addHandler(channel)
