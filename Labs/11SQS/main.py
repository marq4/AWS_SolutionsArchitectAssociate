""" Send and receive messages using SQS. """

import boto3
from botocore.exceptions import ClientError
import botocore
from random import randint


FIFO_QUEUE_NAME     = "MyFIFOQueue.fifo"
STANDARD_QUEUE_NAME = "MyStandardQueue"
MAX_NUMBER_MESSAGES_TO_SEND = 3
MESSAGE_GROUP_ID = 'FIFO'


def get_queue_representation(
        sqs_client: botocore.client.BaseClient,
        queue_name: str,
        queue_type: str) -> dict:
    """ Return Queue dict if exists or create it first. """
    queue = None
    if queue_exists(sqs_client, queue_name):
        queue_url = sqs_client.get_queue_url(QueueName=queue_name)['QueueUrl']
        queue = sqs_client.get_queue_attributes(QueueUrl=queue_url)
    attrs = {} if queue_type == 's' else {'FifoQueue': 'true'}
    queue = sqs_client.create_queue(QueueName=queue_name, Attributes=attrs)
    return queue
#

def queue_exists(sqs_client: botocore.client.BaseClient, queue_name: str) -> bool:
    """ Returns True if Queue exists in AWS account. """
    try:
        sqs_client.get_queue_url(QueueName=queue_name)
    except ClientError:
        return False
    return True
#

def get_type_from_user() -> str:
    """ Get s(tandard)/f(IFO) from user. """
    user_input = ''
    while user_input not in ['s', 'f']:
        user_input = input("What type of queue do you want: standard or FIFO (s|f)? ")
    return user_input
#

def get_operation_from_user() -> str:
    """ Get s(send)/r(eceive) from user. """
    user_input = ''
    while user_input not in ['s', 'r']:
        user_input = input("What operation to perform: send or receive (s|r)? ")
    return user_input
#

def get_amount_from_user() -> int:
    """ How many messages will be sent. """
    print(f"Maximum number of messages to send: {MAX_NUMBER_MESSAGES_TO_SEND}")
    user_input = '0'
    my_range = range(1, MAX_NUMBER_MESSAGES_TO_SEND+1)
    while int(user_input) not in my_range:
        user_input = input("How many messages do you want to send? ")
    return int(user_input)
#

def get_text_from_user() -> str:
    """ Get NON-EMPTY text from user. """
    text = ''
    while text.strip() == '':
        text = input("Message body: ")
    return text
#

def delete_message(
        sqs_client: botocore.client.BaseClient,
        queue_url: str,
        receipt_handle) -> None:
    """" Delete message from queue. """
    sqs_client.delete_message(QueueUrl=queue_url, ReceiptHandle=receipt_handle)
    #print("Successfully deleted message from queue.")
#

def receive_and_delete_message(sqs_client: botocore.client.BaseClient, queue_url: str) -> str:
    """ Pull a single message from the queue. """
    message_text = ''
    response = sqs_client.receive_message(QueueUrl=queue_url)
    try:
        message_text = response['Messages'][0]['Body']
        receipt_handle = response['Messages'][0]['ReceiptHandle']
        #print(f"{message_text=}")#TMP
    except KeyError:
        return message_text
    #print(f"{response=}")#TMP
    #print(response['Messages'])#TMP
    delete_message(sqs_client, queue_url, receipt_handle)
    return message_text
#

def send_message_standard(
        sqs_client: botocore.client.BaseClient,
        queue_url: str,
        body: str) -> None:
    """ Send message with body to standard queue. """
    sqs_client.send_message(QueueUrl=queue_url, MessageBody=body)
    print("Successfully sent message!")
#

def send_message_fifo(
        sqs_client: botocore.client.BaseClient,
        queue_url: str,
        body: str) -> None:
    """ Send message with body to FIFO queue. """
    sqs_client.send_message(
        QueueUrl=queue_url,
        MessageBody=body,
        MessageDeduplicationId=str(randint(-99999, 99999)),
        MessageGroupId=MESSAGE_GROUP_ID
        )
    print("Successfully sent message!")
#

def main():
    """
    Create Queue if not exists already.
    Get message text and Queue type selection from user.
    Ask user for selection: send/receive.
    If receive: pull a message, then delete it.
    If send:
        Ask user how many and the text (body).
        Send them.
    """
    sqs_client = boto3.client("sqs")
    #print(type(sqs_client))#TMP
    queue_type = get_type_from_user()
    #print(f"{type=}")#TMP
    queue_name = STANDARD_QUEUE_NAME if queue_type == 's' else FIFO_QUEUE_NAME
    queue_url = sqs_client.get_queue_url(QueueName=queue_name)['QueueUrl']
    #queue_exists(sqs_client, queue_name)#TMP
    #queue = get_queue_representation(sqs_client, queue_name, queue_type)#TMP
    #print(type(queue))#TMP
    #print(queue)#TMP
    operation = get_operation_from_user()
    if operation == 'r':
        text = receive_and_delete_message(sqs_client, queue_url)
        if not text:
            print("There are no messages in this queue at this time. ")
        else:
            print(f"Received message: {text}")
    else:
        number_of_messages = get_amount_from_user()
        print(f"{number_of_messages=}")#TMP
        for _ in range(number_of_messages):
            message_body = get_text_from_user()
            if queue_type == 's':
                send_message_standard(sqs_client, queue_url, message_body)
            else:
                send_message_fifo(sqs_client, queue_url, message_body)
#

if __name__ == '__main__':
    main()
#
