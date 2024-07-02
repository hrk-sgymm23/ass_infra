import os
import boto3
import logging
from time import sleep

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

client = boto3.client('ec2')

def allocate_eip(eip_id):
    logger.info("Start Allocate Elastc IP!")


def create_nat_gateway(eip_id, subnet_id, natgateway_name):
    logger.info("Start Create NatGateway!")


def atach_nat_gateway_route(route_table_id):
    logger.info("Start Atach NatGateway!")


def handler(event, context):
    logger.info('Started to Setting up NAT Gateway...')
    