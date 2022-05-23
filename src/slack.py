#!/usr/bin/env python3   
import boto3
import json
import logging
import os

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

SLACK_CHANNEL = os.environ['slackChannel']
ICON_EMOJI = os.environ['iconEmoji']
MESSAGE_HEADER = os.environ['messageHeader']
SECRET_ID = os.environ['hookUrl']

session = boto3.session.Session()
aws_secrets = session.client(
    service_name="secretsmanager",
    region_name="us-east-1",
)
HOOK_URL = aws_secrets.get_secret_value(SecretId=SECRET_ID)["SecretString"]

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    message = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(message))

    alarm_name = message['AlarmName']
    new_state = message['NewStateValue']
    reason = message['NewStateReason']
    account = message['AWSAccountId']
    region = message['Region']

    logger.info("Alarm Name: " + alarm_name)
    logger.info("New State: " + new_state)
    logger.info("Reason: " + reason)
    logger.info("AWS Account: " + account)
    logger.info("Region: " + region)

    slack_message = {
        'channel': SLACK_CHANNEL,
        'icon_emoji': ICON_EMOJI,
        'text': MESSAGE_HEADER,
        'attachments': [
            {
            'text': "*Alarm Name:* %s\n*New State:* %s\n*AWS Account:* `%s`\n*Region:* %s\n*Reason:* %s" % (alarm_name, new_state, account, region, reason)
            }
        ]
    }

    req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
