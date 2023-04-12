# Networking - Hosted zone and DNS records
resource "aws_route53_zone" "fotopie_zone" {
  name = var.domain_name
}

# resource "aws_route53_record" "fed_alb_record" {
#   zone_id = aws_route53_zone.fotopie_zone.id
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name    = var.fed_alb_dns
#     # zone_id = "Z1WCIGYICN2BYD"    # mapping "ap-southeast-2": 
#     zone_id = var.fed_alb_zone_id
#     evaluate_target_health = false
#   }
# }