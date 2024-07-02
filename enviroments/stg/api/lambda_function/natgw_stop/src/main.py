import os
import boto3
import logging
from time import sleep

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

client = boto3.client('ec2')

def release_elastic_ip(eip):
    logger.info('Open ElasticIP...')
    responce = client.release_address(AllocationId=eip)
    logger.info(responce)

def delete_nat_gateway(subnet_id):
    logger.info('Delete NatGateway...')
    response = client.describe_nat_gateways(
        Filters = [
            {
                'Name': 'subnet-id',
                'Values': [subnet_id]
            },
            {
                'Name': 'state',
                'Values': ['available']
            }
        ]
    )
    logger.info(response)
    nat_gateway_id = response['NatGateways'][0]['NatGatewayId']
    eip_id = response['NatGateways'][0]['NatGatewayAddresses'][0]['AllocationId'];
    client.delete_nat_gateway(NatGatewayId=nat_gateway_id)
    sleep(120)

    return(eip_id)

def detach_nat_gateway_route(route_table_id):
    logger.info('Detach NatGateway Route...')
    response = client.delete_route(
        DestinationCidrBlock = '0.0.0.0/0',
        RouteTableId = route_table_id
    )

    return(response)

def handler(event, context):
    logger.info('Execute to Stopping NAT Gateway...')
    
    subnet_id = os.environ['SubnetId1']
    route_table_id = os.environ['RouteTableId']
    detach_nat_gateway_route(route_table_id)
    eip_id = delete_nat_gateway(subnet_id)
    release_elastic_ip(eip_id)

    logger.info('Finished to Stopping NAT Gateway...')