
variable "default_region" {
  type    = string
  default = "us-east-1"
}
variable "domain_name" {
  type    = string
  default = "kubesources.com"
}

variable "additional_tags" {
  type    = map(any)
  default = {}
}

variable "subdomain" {
  type    = string
  default = "ljcheng-portfolio-dev"
}

variable "cloudfront_staging" {
  type    = bool
  default = false
}
variable "create_vpc_origin" {
  type    = bool
  default = false
}

variable "origin_access_control" {
  type    = map(any)
  default = {}
}
variable "cloudfront_origin" {
  type    = map(any)
  default = {}
}
variable "cloudfront_origin_name" {
  type    = string
  default = "s3_oac"
}
variable "cloudfront_default_cache_behavior" {
  type    = map(any)
  default = {}
}
variable "cloudfront_default_root_object" {
  type    = string
  default = "index.html"
}
variable "cloudfront_waf_scope" {
  type    = string
  default = "CLOUDFRONT"
}
variable "cloudfront_waf_default_action" {
  type    = string
  default = "block"
}
variable "cloudfront_waf_acl_visibility_config" {
  type    = map(any)
  default = {}
}

variable "custom_ordered_cache_behavior" {
  type    = list(any)
  default = []
}

variable "cloudfront_waf_rules" {
  default = [
    {
      name            = "AWSManagedRulesCommonRuleSet"
      priority        = 0
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "CrossSiteScripting_BODY"
            action_to_use = "block"
          },
          {
            name          = "CrossSiteScripting_COOKIE"
            action_to_use = "block"
          },
          {
            name          = "CrossSiteScripting_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "CrossSiteScripting_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_BODY"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_COOKIE"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "GenericLFI_BODY"
            action_to_use = "block"
          },
          {
            name          = "GenericLFI_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "GenericLFI_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "GenericRFI_BODY"
            action_to_use = "block"
          },
          {
            name          = "GenericRFI_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "GenericRFI_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "NoUserAgent_HEADER"
            action_to_use = "block"
          },
          {
            name          = "RestrictedExtensions_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "RestrictedExtensions_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_BODY"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_Cookie_HEADER"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "UserAgent_BadBots_HEADER"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 1
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "JavaDeserializationRCE_BODY"
            action_to_use = "block"
          },
          {
            name          = "JavaDeserializationRCE_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "JavaDeserializationRCE_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "JavaDeserializationRCE_HEADER"
            action_to_use = "block"
          },
          {
            name          = "Host_localhost_HEADER"
            action_to_use = "block"
          },
          {
            name          = "PROPFIND_METHOD"
            action_to_use = "block"
          },
          {
            name          = "ExploitablePaths_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_BODY"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_HEADER"
            action_to_use = "block"
          },
        ]

        # scope_down_statement = {
        #   geo_match_statement = {
        #     country_codes : ["CN"]
        #   }
        # }
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList"
      priority        = 2
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        rule_action_override = [
          {
            name          = "AWSManagedIPDDoSList"
            action_to_use = "block"
          },
          {
            name          = "AWSManagedIPReputationList"
            action_to_use = "block"
          },
          {
            name          = "AWSManagedReconnaissanceList"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAmazonIpReputationList_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 3
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "LFI_HEADER"
            action_to_use = "block"
          },
          {
            name          = "LFI_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "LFI_URIPATH"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesLinuxRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesAdminProtectionRuleSet",
      priority        = 4
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "AdminProtection_URIPATH"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAdminProtectionRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesBotControlRuleSet",
      priority        = 5
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]
        managed_rule_group_configs = [
          {
            aws_managed_rules_bot_control_rule_set = {
              inspection_level = "COMMON"
            }
          }
        ]
        rule_action_override = [
          {
            name          = "CategoryAI"
            action_to_use = "block"
          },
          {
            name          = "CategoryAdvertising"
            action_to_use = "block"
          },
          {
            name          = "CategoryArchiver"
            action_to_use = "block"
          },
          {
            name          = "CategoryContentFetcher"
            action_to_use = "block"
          },
          {
            name          = "CategoryEmailClient"
            action_to_use = "block"
          },
          {
            name          = "CategoryHttpLibrary"
            action_to_use = "block"
          },
          {
            name          = "CategoryLinkChecker"
            action_to_use = "block"
          },
          {
            name          = "CategoryMiscellaneous"
            action_to_use = "block"
          },
          {
            name          = "CategoryMonitoring"
            action_to_use = "block"
          },
          {
            name          = "CategoryScrapingFramework"
            action_to_use = "block"
          },
          {
            name          = "CategorySearchEngine"
            action_to_use = "block"
          },
          {
            name          = "CategorySecurity"
            action_to_use = "block"
          },
          {
            name          = "CategorySeo"
            action_to_use = "block"
          },
          {
            name          = "CategorySocialMedia"
            action_to_use = "block"
          },
          {
            name          = "SignalAutomatedBrowser"
            action_to_use = "block"
          },
          {
            name          = "SignalKnownBotDataCenter"
            action_to_use = "block"
          },
          {
            name          = "SignalNonBrowserUserAgent"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesBotControlRuleSet_cloudwatch_metric"
      }
    },
    # {
    #   name     = "GeoFencing"
    #   priority = 9
    #   action   = "block"

    #   custom_response = {
    #     response_code = 403
    #     response_header = [
    #       {
    #         name  = "geo_fencing"
    #         value = "geo_fencing_block"
    #       }
    #     ]
    #   }

    #   custom_response_body = {
    #     key          = "Geo_fencing",
    #     content      = "Geo_fencing_error",
    #     content_type = "TEXT_PLAIN"
    #   }

    #   not_statement = {
    #     geo_match_statement = {
    #       country_codes : [
    #         "US",
    #         "UM",
    #         "CA",
    #         "IN",
    #         "MX",
    #         "PK",
    #         "GB"
    #       ]
    #     }
    #   }

    #   visibility_config = {
    #     sampled_requests_enabled   = true
    #     cloudwatch_metrics_enabled = false
    #     metric_name                = "GeoFencing_cloudwatch_metric"
    #   }
    # },
    {
      name     = "RateBasedLimiting"
      priority = 6
      action   = "block"

      custom_response = {
        response_code = 429
        response_header = [
          {
            name  = "rate_limiting_header"
            value = "too_many_requests_error"
          }
        ]
      }

      custom_response_body = {
        key          = "Too_many_requests",
        content      = "Too many requests",
        content_type = "TEXT_PLAIN"
      }

      rate_based_statement = {
        limit                 = 10000
        aggregate_key_type    = "IP"
        evaluation_window_sec = 120
      }

      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = false
        metric_name                = "rateLimitingCloudwatch_metric_name"
      }
    }
  ]
}
