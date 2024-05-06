locals {
  ass_cidr_block = "172.10.0.0/16"
}

module "ass_vpc_stg" {
  source = "../../../modules/vpc"
  cidr_block = local.ass_cidr_block
}

module "ass_sbunet_stg" {
  source = "../../../modules/subnet"
  vpc_id = module.ass_vpc_stg.id
  vpc_cidr_block = module.ass_vpc_stg.cidr_block
}