import os
import json
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


def lambda_handler(event, context):
    pass
