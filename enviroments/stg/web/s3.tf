# locals {
#     common_name = "ass-stg"
# }

module "ass_web_s3_stg" {
  source      = "../../../modules/s3"
  common_name = "${var.common_name}-${var.environment}"
}