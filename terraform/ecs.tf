
resource "aws_ecs_cluster" "shared_cluster" {
    name = "shared_cluster"
}

resource "aws_ecr_repository" "shared_repository" {
  name = "shared_repository"
}

/***
 * Service
 */

resource "aws_ecs_service" "ecs_service" {
  name            = "inpa_ecs_service"
  cluster         = "${aws_ecs_cluster.shared_cluster.id}"
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs_service_scheduler_role.arn}"
  depends_on      = ["aws_iam_role_policy.ecs_service_scheduler_role_policy"]

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_alb.ecs_service_alb.arn}"
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

# This load balancer will balance the load across all the nginx containers
resource "aws_alb" "ecs_service_alb" {
  name            = "inpa-ecs-service-alb"
  internal        = false
  security_groups = ["${aws_security_group.ecs_cluster_security_group.id}"]
  subnets         = ["${aws_default_subnet.default_az1.id}","${aws_default_subnet.default_az2.id}"]
}

/***
 * Permissions
 */

resource "aws_iam_role" "ecs_service_scheduler_role" {
  name_prefix        = "inpa_ecs_service_scheduler_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
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
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
  ]
}
EOF
}