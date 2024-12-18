# Copyright Jiaqi Liu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
variable "ec2_region" {
  type      = string
  sensitive = true
}

variable "ec2_name" {
  type      = string
  sensitive = true
}

variable "ec2_security_groups" {
  type      = list(string)
  sensitive = true
}

variable "ssh_key_pair_name" {
  type      = string
  sensitive = true
}

variable "neo4j_uri" {
  type      = string
  sensitive = true
}

variable "neo4j_username" {
  type      = string
  sensitive = true
}

variable "neo4j_password" {
  type      = string
  sensitive = true
}

variable "neo4j_database" {
  type      = string
  sensitive = true
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.42.0"
    }
  }
  required_version = ">= 0.14.5"
}

provider "aws" {
  region = var.ec2_region
}


data "aws_ami" "latest-ami" {
  most_recent = true
  owners      = ["899075777617"]

  filter {
    name   = "name"
    values = ["wilhelm-ws"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.latest-ami.id
  instance_type = "t2.small"
  tags = {
    Name = var.ec2_name
  }

  key_name = var.ssh_key_pair_name
  security_groups = var.ec2_security_groups

  user_data = templatefile("aws-tf-init.sh", {
    NEO4J_URI      = var.neo4j_uri
    NEO4J_USERNAME = var.neo4j_username
    NEO4J_PASSWORD = var.neo4j_password
    NEO4J_DATABASE = var.neo4j_database
    HOME_DIR       = "/home/ubuntu"
  })
}
