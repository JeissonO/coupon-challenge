resource "aws_security_group" "this" {
  name        = "${var.environment}_${var.project}_${var.resource}_sg"
  vpc_id      = var.vpc_id
  description = "Security group para NAT Instance ${var.resource}"
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:AWS009
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "${var.environment}_${var.project}_${var.resource}_sg" }, local.common_tags, )
}
resource "aws_security_group_rule" "ingress_any" {
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  cidr_blocks       = var.private_subnet_cidrs
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  description       = "Permite trafico entrante desde subnets privadas"
}
resource "aws_network_interface" "this" {
  security_groups   = [aws_security_group.this.id]
  subnet_id         = element(var.public_subnet_ids, 0)
  source_dest_check = false
  description       = "ENI para NAT instance ${var.resource}"
  tags              = merge({ Name = "${var.environment}_${var.project}_${var.resource}_eni" }, local.common_tags, )
}
# AMI of the latest Amazon Linux 2
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.environment}_${var.project}_${var.resource}_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags               = merge({ Name = "${var.environment}_${var.project}_${var.resource}_role" }, local.common_tags, )
}
resource "aws_iam_instance_profile" "this" {
  name = "${var.environment}_${var.project}_${var.resource}_instance_profile"
  role = aws_iam_role.this.name
}
resource "aws_iam_role_policy" "eni" {
  role   = aws_iam_role.this.name
  name   = "${var.environment}_${var.project}_${var.resource}_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.name
}

resource "aws_launch_template" "this" {
  name     = "${var.environment}_${var.project}_${var.resource}_launch"
  image_id = var.image_id != "" ? var.image_id : data.aws_ami.this.id
  key_name = var.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.this.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge({ Name = "${var.environment}_${var.project}_${var.resource}_instance" }, local.common_tags, )
  }
  user_data = base64encode(join("\n", [
    "#cloud-config",
    yamlencode({
      write_files : concat([
        {
          path : "/opt/nat/runonce.sh",
          content : templatefile("${path.module}/scripts/runonce.sh", { eni_id = aws_network_interface.this.id }),
          permissions : "0755",
        },
        {
          path : "/opt/nat/snat.sh",
          content : file("${path.module}/scripts/snat.sh"),
          permissions : "0755",
        },
        {
          path : "/etc/systemd/system/snat.service",
          content : file("${path.module}/scripts/snat.service"),
        },
      ], var.user_data_write_files),
      runcmd : concat([
        ["/opt/nat/runonce.sh"],
      ], var.user_data_runcmd),
    })
  ]))
  description = "Launch template para NAT instance ${var.resource}"
  tags        = merge({ Name = "${var.environment}_${var.project}_${var.resource}_template" }, local.common_tags, )
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.environment}_${var.project}_${var.resource}_autoscaling_group"
  desired_capacity    = var.enabled ? 1 : 0
  min_size            = var.enabled ? 1 : 0
  max_size            = 1
  vpc_zone_identifier = [element(var.public_subnet_ids, 0)]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.use_spot_instance ? 0 : 1
      on_demand_percentage_above_base_capacity = var.use_spot_instance ? 0 : 100
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }
      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route" "this" {
  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.this.id
}
resource "aws_eip" "nat" {
  network_interface = aws_network_interface.this.id
  tags              = merge({ Name = "${var.environment}_${var.project}_nat_eip" }, local.common_tags, )
}
