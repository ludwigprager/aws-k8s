#!/usr/bin/python

import os, boto3

REGION = os.environ['REGION']
ZONE1 = os.environ['ZONE1']
PROJECT = os.environ['MY_PROJECT']

ec2 = boto3.client('ec2', region_name = REGION)

tags = [{
                    'ResourceType': 'volume',
                    'Tags': [
                        {
                            'Key': 'Name',
                            'Value': PROJECT
                        }
                    ],
       } ]
response = ec2.create_volume(Size=5, VolumeType='gp2', AvailabilityZone=ZONE1, TagSpecifications=tags) 

id = response['VolumeId']
print id
