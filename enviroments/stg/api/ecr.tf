module "rails_ecr_stg" {
  source = "../../../modules/ecr"
  repository_name = "${var.common_name}-rails-ecr-${var.environment}"
}

module "nginx_ecr_stg" {
  source = "../../../modules/ecr"
  repository_name = "${var.common_name}-nginx-ecr-${var.environment}"
}