""" AWS Python SDK to list all my buckets. """

import boto3



def list_buckets() -> list:
    """
    Returns a list with the the names of all my buckets, newest first.
    """
    s3 = boto3.client('s3')

    # Get list of {Name, CreationDate} buckets:
    response = s3.list_buckets()['Buckets']

    # Order by newest first:
    in_order = sorted(response, key=lambda pair: pair['CreationDate'], reverse=True)

    # Return a list of bucket names:
    names = []
    for pair in in_order:
        names.append(pair['Name'])
    return names
#

def main():
    """ Display each bucket in a new line. """
    buckets = list_buckets()
    for bucket in buckets:
        print(bucket)
#

if __name__ == '__main__':
    main()
#
