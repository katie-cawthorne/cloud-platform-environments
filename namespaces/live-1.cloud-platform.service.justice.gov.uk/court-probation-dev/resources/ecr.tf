terraform {
  backend "s3" {}
}

provider "aws" {
  alias  = "london"
  region = "eu-west-2"
}

module "court_probation_service_ecr_credentials" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=3.3"
  repo_name = "court-probation-service"
  team_name = "probation-services"

  providers = {
    aws = "aws.london"
  }
}

resource "kubernetes_secret" "court_probation_service_ecr_credentials" {
  metadata {
    name      = "court-probation-service-ecr-credentials"
    namespace = "court-probation-dev"
  }

  data {
    access_key_id     = "${module.court_probation_service_ecr_credentials.access_key_id}"
    secret_access_key = "${module.court_probation_service_ecr_credentials.secret_access_key}"
    repo_arn          = "${module.court_probation_service_ecr_credentials.repo_arn}"
    repo_url          = "${module.court_probation_service_ecr_credentials.repo_url}"
  }
}

module "ps_cps_pack_parser_ecr_credentials" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=3.3"
  repo_name = "cps-pack-parser"
  team_name = "probation-services"

  providers = {
    aws = "aws.london"
  }
}

resource "kubernetes_secret" "ps_cps_pack_parser_ecr_credentials" {
  metadata {
    name      = "ps-cps-pack-parser-ecr-credentials"
    namespace = "court-probation-dev"
  }

  data {
    access_key_id     = "${module.ps_cps_pack_parser_ecr_credentials.access_key_id}"
    secret_access_key = "${module.ps_cps_pack_parser_ecr_credentials.secret_access_key}"
    repo_arn          = "${module.ps_cps_pack_parser_ecr_credentials.repo_arn}"
    repo_url          = "${module.ps_cps_pack_parser_ecr_credentials.repo_url}"
  }
}

module "mock_cp_court_service_ecr_credentials" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=3.3"
  repo_name = "mock-cp-court-service"
  team_name = "probation-services"

  providers = {
    aws = "aws.london"
  }
}

resource "kubernetes_secret" "mock_cp_court_service_ecr_credentials" {
  metadata {
    name      = "mock-cp-court-service-ecr-credentials"
    namespace = "court-probation-dev"
  }

  data {
    access_key_id     = "${module.mock_cp_court_service_ecr_credentials.access_key_id}"
    secret_access_key = "${module.mock_cp_court_service_ecr_credentials.secret_access_key}"
    repo_arn          = "${module.mock_cp_court_service_ecr_credentials.repo_arn}"
    repo_url          = "${module.mock_cp_court_service_ecr_credentials.repo_url}"
  }
}

module "court_list_service_ecr_credentials" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=3.3"
  repo_name = "court-list-service"
  team_name = "probation-services"

  providers = {
    aws = "aws.london"
  }
}

resource "kubernetes_secret" "court_list_service_ecr_credentials" {
  metadata {
    name      = "court-list-service-ecr-credentials"
    namespace = "court-probation-dev"
  }

  data {
    access_key_id     = "${module.court_list_service_ecr_credentials.access_key_id}"
    secret_access_key = "${module.court_list_service_ecr_credentials.secret_access_key}"
    repo_arn          = "${module.court_list_service_ecr_credentials.repo_arn}"
    repo_url          = "${module.court_list_service_ecr_credentials.repo_url}"
  }
}
