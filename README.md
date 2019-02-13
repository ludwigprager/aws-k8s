# Prepare your AWS account

## 1. create two 'roles'
In the AWS console create two roles, one for the nodes and one for the master, each with following policies:
- AmazonEC2FullAccess
- AmazonS3FullAccess
- AmazonVPCFullAccess
<a/>
This triggers the creation of two 'instance profiles' carrying the same names as the 'roles'.

## 2. create an additional policy
Create an additional policy to assign the user some minor IAM permissions.
Give it an arbitrary name. Use the following JSON:
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

## 3. assign policy to an AWS user
Assign a user the policy from step 2.
(or create a group, assign policy to group, assign user to group)

# How to use this container
Perform steps 1-3. Then, you need to make a few changes to the start-container.sh script:
- set the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY of the user mentioned in step 3.
- set the variables
    -INSTANCE_PROFILE_NODE
    -INSTANCE_PROFILE_MASTER
  to the instance-profiles' ARNs you created in step 1
- choose a unique name for MY_PROJECT since a bucket with that name will be created.

Start the container:
~~~
./start-container.sh
~~~

With the container running call:
~~~
./start-kops.sh
~~~

Wait a few minutes, then try:
~~~
. settings.sh
kops validate cluster
~~~
If you get an 'EOF' error you might have to wait a little longer.
Now, play with your cluster.

Finally, delete all resources with
~~~
./stop-kops.sh
~~~
