
/***
 * Service
 */

// 1. service has load-balancer-target-group
resource "aws_ecs_service" "ecs_service" {
  name            = "inpa_ecs_service"
  cluster         = "${data.terraform_remote_state.copperleaf_aws_shared_resources.shared_cluster_id}"
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs_service_scheduler_role.arn}"
  depends_on      = ["aws_iam_role_policy.ecs_service_scheduler_role_policy"]

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs_service_alb_target_group.arn}"
    container_name   = "nginx"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

/***
 * Task
 */

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "inpa_ecs_task_definition"
  container_definitions = "${file("task-definitions/task.json")}"

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

/***
 * Load Balancer
 */

// 4. load-balancer has network rules that are validated. 
resource "aws_alb" "ecs_service_alb" {
  name            = "inpa-ecs-service-alb"
  internal        = false
  security_groups = ["${data.terraform_remote_state.copperleaf_aws_shared_resources.ecs_cluster_security_group_id}"]
  subnets         = ["${aws_default_subnet.default_az1.id}","${aws_default_subnet.default_az2.id}"]

}

// 6. load-balancer-target-group recieves requests and send them to the autoscaling group
resource "aws_alb_target_group" "ecs_service_alb_target_group" {
  name     = "inpa-ecs-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_default_vpc.default_vpc.id}"
  health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        path                = "/ping"
        interval            = 10
    }
}

// 2. load-balancer-listener recieves requests
// 3. load-balancer-listener is serviced by the load-balancer
// 5. load-balancer-listener sends the request to the target group
resource "aws_alb_listener" "ecs_service_alb_listener" {  
  load_balancer_arn = "${aws_alb.ecs_service_alb.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = "${aws_alb_target_group.ecs_service_alb_target_group.arn}"
    type             = "forward"
  }
}

/***
 * Autoscaling Group
 */

 resource "aws_appautoscaling_target" "ecs_autoscaling_target" {
  max_capacity       = 4
  min_capacity       = 1
  #TODO: ? Does this resource ID tell it to join these items to the target group assigned to the service?
  resource_id        = "service/${data.terraform_remote_state.copperleaf_aws_shared_resources.shared_cluster_name}/${aws_ecs_service.ecs_service.name}"
  role_arn           = "${aws_iam_role.ecs_service_autoscaling_role.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_autoscaling_policy_scale_up" {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Maximum"
  name                    = "inpa_ecs_autoscaling_policy_scale_up"
  resource_id        = "service/${data.terraform_remote_state.copperleaf_aws_shared_resources.shared_cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = 1
  }

  depends_on = ["aws_appautoscaling_target.ecs_autoscaling_target"]
}

resource "aws_appautoscaling_policy" "ecs_autoscaling_policy_scale_down" {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Maximum"
  name                    = "inpa_ecs_autoscaling_policy_scale_down"
  resource_id        = "service/${data.terraform_remote_state.copperleaf_aws_shared_resources.shared_cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }

  depends_on = ["aws_appautoscaling_target.ecs_autoscaling_target"]
}

/***
 * Autoscaling alarms
 */

 # A CloudWatch alarm that moniors CPU utilization of containers for scaling up
resource "aws_cloudwatch_metric_alarm" "ecs_service_alarm_cpu_high" {
  alarm_name = "inpa_container_alarm_cpu_high"
  alarm_description = "This alarm monitors CPU utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${aws_appautoscaling_policy.ecs_autoscaling_policy_scale_up.arn}"]

  dimensions {
    ClusterName = "${data.terraform_remote_state.copperleaf_aws_shared_resources.shared_cluster_name}"
    ServiceName = "${aws_ecs_service.ecs_service.name}"
  }
}

# A CloudWatch alarm that monitors CPU utilization of containers for scaling down
resource "aws_cloudwatch_metric_alarm" "ecs_service_alarm_cpu_low" {
  alarm_name = "inpa_container_alarm_cpu_low"
  alarm_description = "This alarm monitors CPU utilization for scaling down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "50"
  alarm_actions = ["${aws_appautoscaling_policy.ecs_autoscaling_policy_scale_down.arn}"]

  dimensions {
    ClusterName = "${data.terraform_remote_state.copperleaf_aws_shared_resources.shared_cluster_name}"
    ServiceName = "${aws_ecs_service.ecs_service.name}"
  }
}

/***
 * autoscaling Permissions
 */

resource "aws_iam_role" "ecs_service_autoscaling_role" {
  name_prefix        = "inpa_ecs_autoscaling_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "ecs_service_autoscaling_role_policy" {
    name_prefix = "inpa_ecs_service_autoscaling_role_policy"
    role = "${aws_iam_role.ecs_service_autoscaling_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1456535218000",
            "Effect": "Allow",
            "Action": [
                "ecs:DescribeServices",
                "ecs:UpdateService"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "Stmt1456535243000",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarms"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

/**
 * service permissions
 */

resource "aws_iam_role" "ecs_service_scheduler_role" {
  name_prefix        = "inpa_ecs_service_scheduler_role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "ecs_service_scheduler_role_policy" {
    name_prefix = "inpa_ecs_service_scheduler_role_policy"
    role = "${aws_iam_role.ecs_service_scheduler_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }, 
    {
        "Effect": "Allow",
        "Action": [
            "ecs:DescribeServices",
            "ecs:UpdateService"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "cloudwatch:DescribeAlarms"
        ],
        "Resource": [
            "*"
        ]
    }
  ]
}
EOF
}
