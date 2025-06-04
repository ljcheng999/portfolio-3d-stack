

domain_name = "kubesources.com"
subdomain   = "ljcheng-poc"

cloudfront_staging            = false
cloudfront_waf_default_action = "allow"
additional_tags               = {}


# assume_role_str   = ""

custom_ordered_cache_behavior = [
  {
    path_pattern      = "*.glb"
    cache_policy_name = "Managed-CachingOptimized"
    compress          = true
  },
  {
    path_pattern      = "/images/*"
    cache_policy_name = "Managed-CachingOptimized"
    compress          = false
  },
]
