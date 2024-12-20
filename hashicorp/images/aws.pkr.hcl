/**
 * Copyright Jiaqi Liu
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "ami_region" {
  type =  string
  sensitive = true
}
variable "war_source" {
  type =  string
  sensitive = true
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
    qubitpi = {
      version = ">= 0.0.50"
      source  = "github.com/QubitPi/qubitpi"
    }
  }
}

source "amazon-ebs" "qubitpi" {
  ami_name              = "wilhelm-ws"
  force_deregister      = "true"
  force_delete_snapshot = "true"

  instance_type = "t2.small"
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }
  region = "${var.ami_region}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-*-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.qubitpi"
  ]

  provisioner "qubitpi-webservice-provisioner" {
    homeDir   = "/home/ubuntu"
    warSource = "${var.war_source}"
  }
}
