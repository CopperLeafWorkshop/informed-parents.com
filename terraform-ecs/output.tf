output "ecs_service_alb_dns_name" {
  value = "${aws_alb.ecs_service_alb.dns_name}"
}
output "ecs_service_alb_zone_id" {
  value = "${aws_alb.ecs_service_alb.zone_id}"
}




