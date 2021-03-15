#!/usr/bin/env python3

import boto3
import botocore
import os

def lambda_handler(event, context):
    client = boto3.client('cloudformation')

    S3BucketName    = os.environ['BUCKET_NAME']
    Region = os.environ['REGION']
    ReportName = os.environ['REPORTNAME']

    response = client.create_stack(
    StackName='Crawler',
    TemplateURL=f"https://s3-{Region}.amazonaws.com/{S3BucketName}/cur/{ReportName}/crawler-cfn.yml",
    Capabilities=[
        'CAPABILITY_IAM'
    ]
    )

