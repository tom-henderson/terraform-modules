import os
import base64
import json
import boto3

ssm = boto3.client('ssm')
route53 = boto3.client('route53')

dynamic_records = os.environ['dynamic_records'].split(',')
zone_name = os.environ['zone_name'].rstrip('.')
zone_id = os.environ['zone_id']


def respond(status, body):
    return {
        'statusCode': status,
        'headers': {
            'Content-Type': 'text/plain; charset=UTF-8',
            'Cache-Control': 'no-cache, no-store, must-revalidate', # HTTP 1.1
            'Pragma': 'no-cache', # HTTP 1.0
            'Expires': '0', # Proxies
        },
        'body': body
    }


def get_auth_token():
    username_parameter = os.environ['username_parameter']
    password_parameter = os.environ['password_parameter']

    response = ssm.get_parameters(
        Names=[username_parameter, password_parameter],
        WithDecryption=True
    )
    parameters = {p['Name']: p['Value'] for p in response['Parameters']}
    username = parameters[username_parameter]
    password = parameters[password_parameter]
    expected_auth = "Basic {}".format(
        base64.b64encode(username + ":" + password)
    )
    return expected_auth


def lambda_handler(event, context):
    authorization = event['headers']['Authorization']
    expected_auth = get_auth_token()

    if not authorization == expected_auth:
        return respond(401, 'badauth')

    target = event['queryStringParameters']['hostname']
    target_record = target.split('.', 1)[0]
    target_zone = target.split('.', 1)[1]

    if zone_name != target_zone or target_record not in dynamic_records:
        # No-ip returns 200 here. (._. )
        return respond(400, 'nohost')

    print "Updating {} record in {}".format(
        target_record,
        target_zone
    )

    new_ip = event['queryStringParameters']['myip']
    comment = "Updating {} to {}".format(target, new_ip)

    print comment
    response = route53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            'Comment': comment,
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': target,
                        'Type': 'A',
                        'TTL': 300,
                        'ResourceRecords': [{'Value': new_ip}]
                    }
                },
            ]
        }
    )

    if response['ResponseMetadata']['HTTPStatusCode'] == 200:
        return respond(200, "good {}".format(new_ip))
    else:
        return respond(500, 'failed')
