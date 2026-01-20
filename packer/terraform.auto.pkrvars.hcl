app_version      = "1.0.0"
aws_region       = "eu-west-3"
instance_type    = "t2.micro"
base_ami_owner   = "136693071363"
base_ami_filter  = "debian-12-amd64-*"
ssh_username     = "admin"

subnet_id         = "subnet-0b44df42566d7a2e4" # Need change
security_group_ids = [ # Need change
  "sg-065d006495128ddcd", # Primary SG
  "sg-01a09f8c4347acaa3", # Monitring SG
  "sg-06e200bca6be0952d" # alb SG
]