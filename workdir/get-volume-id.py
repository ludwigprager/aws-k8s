#!/usr/bin/python

import os, boto3

REGION = os.environ['REGION']
PROJECT = os.environ['MY_PROJECT']

ec2 = boto3.resource('ec2', region_name = REGION)

volumes = ec2.volumes.all()

id=''

for volume in volumes:
    #print "volume: {}".format(volume)
    #print "id: {}".format(volume.id)
    #print "tags: {}".format(volume.tags)
    if volume.tags is not None:
        for tag in volume.tags:
            #print "key: {}".format(tag['Key'])
            #print "value: {}".format(tag['Value'])
            if tag['Key'] == 'Name' and tag['Value'] == PROJECT:
                    id = volume.id
                    
#print "id: {}".format(id)
print id
