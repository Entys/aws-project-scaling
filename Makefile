SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -Command

.PHONY: help deploy networking ami infrastructure monitoring destroy clean

help:
	@Write-Host "=========================================="
	@Write-Host "AWS Auto-Scaling Deployment"
	@Write-Host "=========================================="
	@Write-Host ""
	@Write-Host "Commands:"
	@Write-Host "  make deploy         - Full deployment"
	@Write-Host "  make networking     - Phase 1: VPC"
	@Write-Host "  make ami            - Phase 2: Build AMI"
	@Write-Host "  make infrastructure - Phase 3: ALB + ASG"
	@Write-Host "  make monitoring     - Phase 4: Monitoring"
	@Write-Host "  make destroy        - Destroy all"
	@Write-Host "  make clean          - Clean files"

deploy: networking ami infrastructure monitoring
	@Write-Host ""
	@Write-Host "=========================================="
	@Write-Host "Deployment Complete!"
	@Write-Host "=========================================="
	@cd terraform; $$alb = terraform output -raw alb_dns_name; Write-Host "🌐 Application: http://$$alb"

networking:
	@Write-Host "Phase 1: Deploying VPC and Networking..."
	@cd terraform; terraform init
	@cd terraform; terraform apply '-target=module.networking' -auto-approve
	@cd terraform; terraform refresh  # ← AJOUTE ÇA pour charger tous les outputs
	@powershell -ExecutionPolicy Bypass -File scripts\save-network-config.ps1
	@Write-Host "Networking deployed"

ami:
	@Write-Host "Phase 2: Building AMI with Packer..."
	@cd packer; packer init .
	@cd packer; packer validate .
	@cd packer; packer build .
	@Write-Host "Saving AMI ID for Terraform..."
	@cd packer; $$manifest = Get-Content manifest.json | ConvertFrom-Json; $$ami = ($$manifest.builds[-1].artifact_id -split ':')[1]; "ami_id = `"$$ami`"" | Out-File -FilePath ..\terraform\ami.auto.tfvars -Encoding utf8
	@Write-Host "AMI created"

infrastructure:
	@Write-Host "Phase 3: Deploying Infrastructure..."
	@cd terraform; terraform apply '-target=module.loadbalancer' '-target=module.autoscaling' -auto-approve
	@Write-Host "Infrastructure deployed"

monitoring:
	@Write-Host "Phase 4: Deploying Monitoring..."
	@cd terraform; terraform apply '-target=module.monitoring' -auto-approve
	@Write-Host "Monitoring deployed"

destroy:
	@Write-Host "Destroying All Infrastructure..."
	@cd terraform; terraform destroy -auto-approve
	@$(MAKE) clean

clean:
	@Write-Host "Cleaning generated files..."
	@if (Test-Path terraform\ami.auto.tfvars) { Remove-Item terraform\ami.auto.tfvars }
	@if (Test-Path packer\network.auto.pkrvars.hcl) { Remove-Item packer\network.auto.pkrvars.hcl }
	@if (Test-Path packer\manifest.json) { Remove-Item packer\manifest.json }
	@Write-Host "Cleanup complete"