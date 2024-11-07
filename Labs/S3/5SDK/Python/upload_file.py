""" AWS Python SDK to upload a single file to an S3 bucket. """

import boto3
from botocore.exceptions import ClientError


def upload_file_to_bucket(file_name: str, bucket_name: str) -> bool:
    """ Returns True if success. """
    s3_client = boto3.client('s3')
    try:
        s3_client.upload_file(file_name, bucket_name, file_name)
    except ClientError as client_error:
        print(client_error)
        return False
    return True
#

def main():
    """
    Prompt user for file and bucket, then upload file to bucket.
    """
    file = input("Enter the full path to the file: ")
    bucket = input("Enter the name of your bucket: ")
    #print(f"{file=} // {bucket=}") #TMP
    suc = upload_file_to_bucket(file.strip(), bucket.strip())
    if suc:
        print("Successfully uploaded the file. ")
#

if __name__ == '__main__':
    main()
#
