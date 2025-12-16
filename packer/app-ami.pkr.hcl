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

  subnet_id                   = var.subnet_id
  security_group_id           = var.security_group_id
  associate_public_ip_address = true
  
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
  
  # AJOUTE CE PROVISIONER AVANT le file
  provisioner "shell" {
    inline = [
      "sudo rm -rf /tmp/packer-app",
      "mkdir -p /tmp/packer-app"
    ]
  }
  
  # Upload l'application
  provisioner "file" {
    source      = "../app/"
    destination = "/tmp/packer-app"
  }
  
  # Exécute le script d'installation
  provisioner "shell" {
    script = "./scripts/install-app.sh"
  }
  
  # Reload nginx
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