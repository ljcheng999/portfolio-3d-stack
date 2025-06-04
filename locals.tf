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

  original_cache_behavior = [
    {
      target_origin_id       = "${var.subdomain}.${var.domain_name}"
      viewer_protocol_policy = "redirect-to-https"

      cached_methods  = ["GET", "HEAD"]
      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    },
    {
      target_origin_id       = "${var.subdomain}.${var.domain_name}"
      viewer_protocol_policy = "redirect-to-https"

      cached_methods  = ["GET", "HEAD"]
      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    },
  ]

  ordered_cache_behavior = length(var.custom_ordered_cache_behavior) > 0 ? flatten([
    for a_map in var.custom_ordered_cache_behavior : [
      {
        "path_pattern"         = a_map.path_pattern,
        "cache_policy_name"    = a_map.cache_policy_name,
        "compress"             = a_map.compress,
        target_origin_id       = "${var.subdomain}.${var.domain_name}",
        viewer_protocol_policy = "redirect-to-https",
        cached_methods         = ["GET", "HEAD"],
        allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"],
        use_forwarded_values   = false
      },
    ]
  ]) : []

}
