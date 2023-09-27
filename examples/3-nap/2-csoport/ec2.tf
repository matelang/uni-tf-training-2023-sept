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

resource "aws_instance" "web" {
  ami                  = data.aws_ami.amazon.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.public[0].id
  iam_instance_profile = aws_iam_instance_profile.ec2.name

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  tags = {
    Name = "HelloWorld"
  }

  user_data_base64 = filebase64("userdata.sh")
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2"
  role = aws_iam_role.ec2.name
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

resource "aws_iam_role" "ec2" {
  name               = "ec2"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2.name
}

resource "aws_security_group" "ec2" {
  name   = "ec2"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2"
  }
}
