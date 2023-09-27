data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.2.*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

resource "aws_autoscaling_group" "ec2" {
  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }

  vpc_zone_identifier = aws_subnet.public.*.id

  max_size = 1
  min_size = 1
}

resource "aws_launch_template" "ec2" {
  name_prefix   = "HelloWorld"
  image_id      = data.aws_ami.amazon.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role" "ec2" {
  name               = "ec2"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2.name
}
