""" https://blog.devops.dev/create-an-s3-bucket-with-aws-cdk-e012b43c3511 """

from aws_cdk import (
    # Duration,
    Stack,
    # aws_sqs as sqs,
    aws_s3 as s3
)
from constructs import Construct

class BlogDevOpsDevStack(Stack):
    """ Auto generated by `cdk init app --language python`. """
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        """ Create an S3 bucket. """
        super().__init__(scope, construct_id, **kwargs)
        s3.Bucket(self, id='my_bucket', bucket_name='marq----cdk-bucket-python')
    #
#
