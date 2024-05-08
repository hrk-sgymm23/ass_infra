module "ass_web_s3_stg" {
  source          = "../../../modules/s3"
  common_name     = "${var.common_name}-${var.environment}"
  oai_identifiers = module.ass_web_cf_stg.oai_identifiers
}