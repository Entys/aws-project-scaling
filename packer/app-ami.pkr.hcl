packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "app" {
  ami_name      = "autoscaling-demo-${var.app_version}-{{timestamp}}"
  instance_type = var.instance_type
  region        = var.aws_region
  
  source_ami_filter {
    filters = {
      name                = var.base_ami_filter
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = [var.base_ami_owner]
    most_recent = true
  }
  
  ssh_username = var.ssh_username
  
  tags = {
    Name        = "autoscaling-demo"
    Version     = var.app_version
    BuildDate   = "{{timestamp}}"
    ManagedBy   = "Packer"
    OS          = "Debian 12"
  }
}

build {
  sources = ["source.amazon-ebs.app"]
  
  provisioner "file" {
    source      = "../app/"
    destination = "/tmp/app"
  }
  
  provisioner "shell" {
    script = "./scripts/install-app.sh"
  }
  
  provisioner "shell" {
    inline = [
      "sudo systemctl reload nginx",
      "echo 'AMI build complete!'"
    ]
  }
  
  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}