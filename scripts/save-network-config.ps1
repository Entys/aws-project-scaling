Write-Host "Saving network configuration for Packer..."

cd terraform

$subnets = terraform output -json public_subnet_ids | ConvertFrom-Json
$subnet = $subnets[0]
$ec2_sg = terraform output -raw ec2_sg_id
$mon_sg = terraform output -raw monitoring_sg_id
$alb_sg = terraform output -raw alb_sg_id

$content = @"
subnet_id = "$subnet"
security_group_ids = ["$ec2_sg", "$mon_sg", "$alb_sg"]
"@

Set-Content -Path ..\packer\network.auto.pkrvars.hcl -Value $content -Encoding utf8

Write-Host "Network config saved:"
Write-Host "   Subnet: $subnet"
Write-Host "   EC2 SG: $ec2_sg"
Write-Host "   Monitoring SG: $mon_sg"
Write-Host "   ALB SG: $alb_sg"

cd ..