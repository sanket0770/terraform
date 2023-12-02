terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Define provider (AWS)
provider "aws" {
  region = "eu-west-2"
  access_key = "AKIAX3LNWYOGIVRPHOXY"
  secret_key = "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"
}


resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg3"
  description = "Security group for MySQL on port 3306"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from any IP address
  }
}
output "security_group_id" {
  value = aws_security_group.mysql_sg.id
}
data "aws_security_group" "mysql_sg" {
  id = aws_security_group.mysql_sg.id
}

resource "aws_db_instance" "default" {
  allocated_storage             = 20
  apply_immediately             = true
  db_name                       = "mydb3"
  engine                        = "mysql"
  engine_version                = "5.7"
  identifier                    = "research-rds3"   
  instance_class                = "db.t3.micro"
  network_type                  = "IPV4"
  port                          = "3306" 
  publicly_accessible           = true
  username                      = "admin"
  password                      = "passwd1!"
  parameter_group_name          = "default.mysql5.7"
  vpc_security_group_ids        = [data.aws_security_group.mysql_sg.id]
}

resource "aws_elastic_beanstalk_application" "my_app" {
  name = "MyElasticBeanstalkAppsanket0001113"
}

resource "aws_elastic_beanstalk_environment" "my_environment" {
  name        = "MyEnvironmentsanket0001113"
  application = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.9 running Python 3.8"
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PYTHONPATH"
    value     = "/opt/python/current/app:/opt/python/run/venv/lib/python3.8/site-packages"
  }
   setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "IamInstanceProfile"
      value     = "aws-elasticbeanstalk-ec2-role"
    }
}

resource "aws_s3_bucket" "b" {
 bucket = "mytftestbucket0000000011111111113"
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket = aws_s3_bucket.b.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "b" {
 bucket = aws_s3_bucket.b.id
 policy = <<POLICY
{
 "Version": "2012-10-17",
 "Id": "MYBUCKETPOLICY",
 "Statement": [
   {
"Sid": "GrantAnonymousReadPermissions",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::mytftestbucket0000000011111111113/*"
   }
 ]
}
POLICY
depends_on = [ aws_s3_bucket_public_access_block.b ]
}