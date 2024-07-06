import os
import boto3
import logging
from time import sleep

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

client = boto3.client('ec2')

def allocate_eip():
    logger.info("Start Allocate Elastc IP!")
    responce = client.allocate_address(Domain='vpc')
    logger.info(responce)

    return responce['AllocationId']


def create_nat_gateway(eip_id, subnet_id, natgateway_name):
    logger.info("Start Create NatGateway!")
    response = client.create_nat_gateway(
        AllocationId = eip_id,
        SubnetId = subnet_id,
        TagSpecifications=[
                {
                    "ResourceType": "natgateway",
                    "Tags": [
                        {"Key": "Name", "Value": natgateway_name},
                    ]
                }
            ]
    )
    logger.info(response)

    natgateway_id = response['NatGateway']['NatGatewayId']
    client.get_waiter('nat_gateway_available').wait(NatGatewayIds=[natgateway_id])

    return natgateway_id


def attach_nat_gateway_route(nat_gateway_id, route_table_id):
    logger.info("Start Atach NatGateway!")
    responce = client.create_route(
        DestinationCidrBlock = '0.0.0.0/0',
        NatGatewayId = nat_gateway_id,
        RouteTableId = route_table_id
    )
    logger.info(responce)

def setup_nat_gateway(subnet_id, nat_gateway_name, route_table_id):
    eip_allocation_id = allocate_eip()
    nat_gateway_id = create_nat_gateway(eip_allocation_id, subnet_id, nat_gateway_name)
    attach_nat_gateway_route(nat_gateway_id, route_table_id)


def handler(event, context):
    logger.info('Started to Setting up NAT Gateway...')

    nat_gateway_configs = [
            {
                "subnet_id": os.environ['SubnetId1'],
                "route_table_id": os.environ['RouteTableId'],
                "nat_gateway_name": os.environ['NatGatewayName1'],
            },
            {
                "subnet_id": os.environ['SubnetId2'],
                "route_table_id": os.environ['RouteTableId'],
                "nat_gateway_name": os.environ['NatGatewayName2'],
            }
    ]

    for config in nat_gateway_configs:
        setup_nat_gateway(
            config["subnet_id"],
            config["route_table_id"],
            config["nat_gateway_name"]
        )

    logger.info('Finished to Setting up NAT Gateway...')
