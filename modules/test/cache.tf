resource "aws_cloudfront_cache_policy" "command_center_api_cache_policy" {

  name    = "command-center-api-cache-policy"
  comment = "Command Center API Cache Policy for nonprd"

  default_ttl = 1
  max_ttl     = 6
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
      cookies {
        items = []
      }
    }

    query_strings_config {
      query_string_behavior = "none"
      query_strings {
        items = []
      }
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Accept-Charset",
          "Authorization",
          "Origin",
          "Accept",
          "Access-Control-Request-Method",
          "Access-Control-Request-Headers",
          "Referer",
          "Accept-Language",
          "Accept-Datetime"
        ]
      }
    }
  }
}
