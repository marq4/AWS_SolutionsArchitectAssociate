""" AWS Python SDK to create a new S3 bucket. """

from datetime import datetime
import boto3
from botocore.exceptions import ClientError

REGION = 'us-east-2'


def create_bucket(bucket_name: str) -> bool:
    """ Returns True if the bucket was created successfully. """
    #print(f"{bucket_name = }")#TMP
    s3_client = boto3.client('s3', region_name=REGION)
    location = {'LocationConstraint': REGION}
    try:
        response = s3_client.create_bucket(Bucket=bucket_name, CreateBucketConfiguration=location)
        #print(f"{response = }")#TMP
        print(f"Successfully created the new bucket: {bucket_name} ")
    except ClientError as client_error:
        print(client_error)
        return False
    return True
#

def generate_unique_name() -> str:
    """ SAA + now(). """
    now_str = datetime.now().strftime("%Y%B%d%H%M%S")
    name = 'SAA----' + now_str
    return name.lower()
#

def main():
    """ Create a bucket with a unique name. """
    name = generate_unique_name()
    create_bucket(name)
#

if __name__ == '__main__':
    main()
#
