# Networking - Hosted zone and DNS records
resource "aws_route53_zone" "fotopie_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "fotopie_net" {
  zone_id = aws_route53_zone.fotopie_zone.id
  name    = var.domain_name
  type    = "A"

  alias {
    name    = "s3-website-ap-southeast-2.amazonaws.com"
    # mapping "ap-southeast-2": "Z1WCIGYICN2BYD",
    zone_id = "Z1WCIGYICN2BYD"
    evaluate_target_health = false
  }
}