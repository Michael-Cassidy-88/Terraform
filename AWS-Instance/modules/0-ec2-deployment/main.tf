# --- modules/main.tf ---

resource "aws_instance" "app_server" {
  ami           = data.aws_ssm_parameter.ec2-ami.value
  instance_type = var.instance_type
  count = var.instance_count

  tags = {
    Name = "Terraform_EC2-${count.index + 1}"
  }
}

data "aws_ssm_parameter" "ec2-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}