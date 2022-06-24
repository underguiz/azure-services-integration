import logging
import json
import gzip
import os
from io import BytesIO
from azure.eventhub import EventHubProducerClient, EventData
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobClient, BlobServiceClient
import azure.functions as func


def main(event: func.EventHubEvent):

    creds = DefaultAzureCredential()
    fully_qualified_namespace = os.environ['EventHubName']
    eventhub_name = os.environ['DestEventHub']

    logging.info('processing message')

    message = json.loads(event.get_body().decode())
    url     = message[0]['data']['url']

    logging.info('downloading url : ' + url)

    blobClient   = BlobClient.from_blob_url(blob_url=url, credential=creds)
    blobDownload = blobClient.download_blob()
    blobContent  = BytesIO(blobDownload.readall())

    with gzip.open(blobContent, "rb") as f:
        logEntries = f.read()
    
    producer = EventHubProducerClient(fully_qualified_namespace=fully_qualified_namespace, eventhub_name=eventhub_name, credential=creds)

    with producer: 
        event_data_batch = producer.create_batch()

        for log in logEntries.decode().strip().split('\n'):
            event_data_batch.add(EventData(log))

        producer.send_batch(event_data_batch)