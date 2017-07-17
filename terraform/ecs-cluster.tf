
resource "aws_ecs_cluster" "ecs_cluster" {
    name = "shared_cluster"
}
# data "aws_ecs_cluster" "ecs_cluster" {
#   cluster_name = "shared_cluster"
# }
data "template_file" "user_data" {
  template = "${file("userdata.sh")}"
}

resource "aws_iam_role" "ecs_ec2_role" {
  name_prefix        = "inpa_ecs_container_agent_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_container_agent_role_policy" {
    name_prefix = "inpa_ecs_container_agent_role_policy"
    role        = "${aws_iam_role.ecs_ec2_role.id}"
    policy      = <<EOF
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

resource "aws_iam_role_policy" "ecs_service_scheduler_role_policy" {
    name_prefix = "inpa_ecs_service_scheduler_role_policy"
    role = "${aws_iam_role.ecs_ec2_role.id}"
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
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs_ec2_profile" {
  name  = "test_profile"
  role = "${aws_iam_role.ecs_ec2_role.name}"
}


resource "aws_key_pair" "container_access_key_pair" {
  key_name   = "informed-parents-uswest2"
  public_key = "${file("informed-parents-uswest2.pub")}" 
}

resource "aws_security_group" "ecs_cluster_security_group" {
  name_prefix = "inpa_ecs_cluster_security_group"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    ClusterName = "shared-cluster"
  }
}

resource "aws_instance" "ecs_instance" {
  count = "2"   
  key_name                    = "${aws_key_pair.container_access_key_pair.key_name}"
  ami                         = "ami-57d9cd2e"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.ecs_cluster_security_group.id}"]
  user_data                   = "${data.template_file.user_data.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_ec2_profile.name}"
  associate_public_ip_address = true

  tags {
    Name        = "${format("shared-cluster-node-%d", count.index + 1)}"
    ClusterName = "shared-cluster"
  }
}