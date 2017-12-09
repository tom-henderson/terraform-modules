import os
import json
import urllib2

import boto3

image_url = "http://thecatapi.com/api/images/get?format=xml"
sns_topic = os.environ['sns_topic']

sns = boto3.client('sns')


def get_image():
    req = urllib2.Request(image_url)
    res = urllib2.urlopen(req)
    cat_image_url = res.read().split('<url>')[1].split('</url>')[0]
    print cat_image_url
    return cat_image_url


def lambda_handler(event, context):

    image = get_image()

    response = sns.publish(
        TargetArn=sns_arn,
        Message=json.dumps(image),
        MessageStructure='text'
    )
