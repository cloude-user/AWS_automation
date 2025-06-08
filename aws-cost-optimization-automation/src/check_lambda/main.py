import boto3
import requests
import os
from datetime import datetime, timedelta

def lambda_handler(event, context):
    client = boto3.client('ce')  # Cost Explorer
    slack_webhook_url = os.environ['SLACK_WEBHOOK_URL']
    
    end = datetime.utcnow().date()
    start = end - timedelta(days=1)

    response = client.get_cost_and_usage(
        TimePeriod={
            'Start': start.strftime('%Y-%m-%d'),
            'End': end.strftime('%Y-%m-%d')
        },
        Granularity='DAILY',
        Metrics=['UnblendedCost']
    )

    amount = response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']
    cost = float(amount)

    if cost > 10.0:   # Customize your threshold
        message = f"Warning! Yesterday's AWS cost was ${cost:.2f}. Check resources!"
        requests.post(slack_webhook_url, json={"text": message})

    return {"statusCode": 200}

