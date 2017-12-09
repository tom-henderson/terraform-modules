import os
import json
import urllib2
import boto3

ssm = boto3.client('ssm')

slack_api_token_parameter = os.environ['slack_api_token_parameter']
response = ssm.get_parameters(
    Names=[slack_api_token_parameter, sns_queue_name_parameter],
    WithDecryption=True
)
parameters = {p['Name']: p['Value'] for p in response['Parameters']}

slack_api_token = parameters[slack_api_token_parameter]
sns_topic_name = os.environ['sns_topic_name']


def respond(url, response_object):
    req = urllib2.Request(url)
    req.add_header('Content-Type', 'application/json')
    response = urllib2.urlopen(req, json.dumps(response_object))
    return response


def lambda_handler(event, context):
    payload = {
        "channel": "#general",
        "username": "monkey-bot",
        "icon_emoji": ":monkey_face:"
        "text": "This is posted to #general and comes from *monkey-bot*.",
        "link_names": 1,
    }

    respond(payload)
