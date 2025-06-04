provider "aws" {
  region = var.default_region
  # assume_role {
  #   role_arn = var.assume_role_str
  # }
}


######
# ACM
######

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name               = "${local.subdomain}.${local.domain_name}"
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["*.${local.domain_name}"]
  validation_method         = "DNS"

  tags = merge(
    local.tags,
    var.additional_tags
  )
}

######
# S3 Bucket
######

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.9.0"

  bucket = "${local.subdomain}.${local.domain_name}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    status     = true
    mfa_delete = false
  }

  force_destroy = true

  tags = merge(
    local.tags,
    var.additional_tags
  )
}

######
# WAF
######
module "wafv2" {
  source  = "aws-ss/wafv2/aws"
  version = "3.8.1"
  # insert the 6 required variables here
  name        = local.cloudfront_waf_name
  description = "${local.cloudfront_waf_name} - portfolio webapp"
  scope       = var.cloudfront_waf_scope

  rule           = var.cloudfront_waf_rules
  default_action = var.cloudfront_waf_default_action

  enabled_web_acl_association = true
  resource_arn                = []

  visibility_config = local.cloudfront_waf_acl_visibility_config

  tags = merge(
    local.tags,
    var.additional_tags
  )

}

module "cloudfront" {

  source  = "terraform-aws-modules/cloudfront/aws"
  version = "4.1.0"

  aliases = ["${local.subdomain}.${local.domain_name}"]

  comment             = "${local.subdomain}.${local.domain_name} Portfolio Terraform Stack"
  enabled             = true
  staging             = var.cloudfront_staging # If you want to create a staging distribution, set this to true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  # If you want to create a primary distribution with a continuous deployment policy, set this to the ID of the policy.
  # This argument should only be set on a production distribution.
  # ref. `aws_cloudfront_continuous_deployment_policy` resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_continuous_deployment_policy
  continuous_deployment_policy_id = null

  # When you enable additional metrics for a distribution, CloudFront sends up to 8 metrics to CloudWatch in the US East (N. Virginia) Region.
  # This rate is charged only once per month, per metric (up to 8 metrics per distribution).
  create_monitoring_subscription = true


  create_vpc_origin   = var.create_vpc_origin
  default_root_object = var.cloudfront_default_root_object

  # logging_config = {
  #   bucket = module.s3.s3_bucket_bucket_domain_name
  #   prefix = "cloudfront"
  # }

  create_origin_access_control = true
  origin_access_control = {
    "${local.subdomain}.${local.domain_name}" = {
      description      = "${local.subdomain}.${local.domain_name} - CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    "${local.subdomain}.${local.domain_name}" = {
      domain_name = module.s3.s3_bucket_bucket_regional_domain_name

      ### There is a bug for this, you have to manually add OAC to S3 in AWS console
      # origin_access_control_id = aws_cloudfront_origin_access_control.oac.id

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }

      origin_shield = {
        enabled              = true
        origin_shield_region = var.default_region
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "${local.subdomain}.${local.domain_name}"
    viewer_protocol_policy = "redirect-to-https"

    cached_methods  = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    use_forwarded_values = false

    cache_policy_id            = "b2884449-e4de-46a7-ac36-70bc7f1ddd6d"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  ordered_cache_behavior = local.ordered_cache_behavior

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only" #sni-only is for production
  }

  # geo_restriction = {
  #   restriction_type = "whitelist"
  #   locations        = ["NO", "UA", "US", "GB"]
  # }

  web_acl_id = module.wafv2.aws_wafv2_arn

  tags = merge(
    local.tags,
    var.additional_tags
  )
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${local.subdomain}.${local.domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [module.cloudfront.cloudfront_distribution_domain_name]
}


output "cloudfront" {
  value = module.cloudfront
}
output "s3" {
  value = module.s3
}
output "acm" {
  value = module.acm
}
