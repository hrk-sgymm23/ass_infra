module "ass_web_cf_stg" {
  source                = "../../../modules/cloudfront"
  common_name           = "${var.common_name}-${var.environment}-distribusion"
  s3_bucket_domain_name = module.ass_web_s3_stg.bucket_regional_domain_name
  s3_bucket_id          = module.ass_web_s3_stg.id
}