# Prepare your AWS account

## 1. create two 'roles':
In the AWS console create two roles with names
- kops-custom-node-role
- kops-custom-master-role

each with following policies:
- AmazonEC2FullAccess
- AmazonS3FullAccess
- AmazonVPCFullAccess

Note, that this leads to the creation of two 'instance profiles' carrying the same name as the 'roles'.

## 2. create an additional policy
Create an additional policy to assign the user some minor IAM permissions.
You can assign it an arbitrary name, e.g. 'kops-additional-policy'. Use the following JSON:
~~~
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "FirstStatement",
            "Effect": "Allow",
            "Action": [
                "iam:getRole",
                "iam:getRolePolicy",
                "iam:GetInstanceProfile",
                "iam:ListInstanceProfiles",
                "iam:ListRoles",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
~~~

## 3. create user 'kops' 
and assign this user the 'kops-additional-policy'
(or create a group 'kops', assign policy to group, assign user 'kops' to group 'kops')

# How to use this container
Perform steps 1-3. Then, you need to make a few changes to the init.sh script:
- set your AWS credentials
- set the ARNs of the instance-profiles you created in step 1
- set a unique name for the bucket in workdir/settings.sh
~~~
. init.sh
k8s $(realpath workdir/)
~~~

Then, call start.sh:
~~~
./start.sh
~~~

Wait a few minutes, then try:
~~~
. settings.sh
kops validate cluster
~~~

Finally, delete all resource with
~~~
./stop.sh
~~~
