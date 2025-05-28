locals {
  domain_name         = var.domain_name
  subdomain           = var.subdomain
  domain_reference    = replace(local.domain_name, ".", "-")
  subdomain_reference = replace(local.subdomain, "-", "_")
  oac_name_reference  = "s3-oac-${local.subdomain_reference}-${local.domain_reference}"

  tags = {
    organization    = "engineering"
    group           = "platform"
    team            = "enablement"
    stack           = "terraform"
    email           = "example.${var.domain_name}"
    application     = "${var.subdomain}.${var.domain_name}"
    automation_tool = "terraform"
  }

  cloudfront_waf_name = "${local.subdomain_reference}_webapp_cf_waf_name"
  cloudfront_waf_acl_visibility_config = {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = "${local.subdomain_reference}_cf_waf_cloudwatch_metric"
  }
}
