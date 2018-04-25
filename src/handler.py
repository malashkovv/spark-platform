from src.log import logger
import requests

def url(style):
    return "http://rue-images.s3-website-us-east-1.amazonaws.com/images/product/{key_prefix}/{key}_RLLZ_1.jpg".format(
        key_prefix=style[:6],
        key=style
    )

def download(url):
    logger.info("Downloading from: {}".format(url))
    resp = requests.get(url)
    return resp.content

def handle(sc):
    styles = sc.parallelize([
        1111536730,
        1111497080,
        1111536728,
        1111624035,
        1111624034,
        1111624032,
        1111877457
    ])
    images = styles.map(str).map(lambda x: (x, url(x))).map(download)
    logger.info(images.count())