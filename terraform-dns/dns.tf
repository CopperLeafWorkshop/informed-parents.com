resource "aws_route53_zone" "primary" {
  name = "informed-parents.org"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "informed-parents.org"
  type    = "A"

  alias {
    name    = "${data.terraform_remote_state.informed_parents_ecs_state.ecs_service_alb_dns_name}"
    zone_id = "${data.terraform_remote_state.informed_parents_ecs_state.ecs_service_alb_zone_id}"
    evaluate_target_health = true
  }
}
