# AWS Terraform Infrastructure Project

This project manages AWS infrastructure using Terraform, including VPC and EC2 resources.

## Project Structure
```
aws-terraform-demo/
├── .github/
│   └── workflows/
│       └── terraform.yml
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tfvars
│       └── providers.tf
└── README.md

```

## Prerequisites

1. AWS CLI installed and configured
2. Terraform installed
3. Git installed
4. AWS account with appropriate permissions

## Installation Steps

1. Install Terraform:
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
```

2. Install AWS CLI:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

3. Configure AWS:
```bash
aws configure
# Follow prompts to enter:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region
# - Output format (json)
```

## Verification Commands

```bash
# Verify Terraform installation
terraform --version

# Verify AWS CLI installation
aws --version

# Test AWS connectivity
aws sts get-caller-identity
```

## Terraform Commands

### Initial Setup
```bash
# Navigate to environment directory
cd environments/dev

# Initialize Terraform
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate
```

### Planning and Applying
```bash
# See planned changes
terraform plan

# Apply changes
terraform apply

# Apply without prompt (careful!)
terraform apply -auto-approve
```

### State Management
```bash
# Show current state
terraform show

# List resources
terraform state list

# Show specific resource
terraform state show aws_instance.main
```

### Cleanup
```bash
# Destroy infrastructure
terraform destroy

# Destroy without prompt (careful!)
terraform destroy -auto-approve
```

### Workspace Management
```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new [name]

# Select workspace
terraform workspace select [name]
```

## Common Issues and Troubleshooting

1. **Credentials Error**:
   - Verify AWS credentials are correctly set up
   - Run `aws configure` again
   - Check environment variables

2. **State Lock Error**:
   - Wait a few minutes and try again
   - Check if another process is running
   - Force unlock if necessary: `terraform force-unlock [lock-id]`

3. **Resource Creation Failure**:
   - Check AWS Console for specific error messages
   - Verify VPC/Subnet configurations
   - Confirm IAM permissions

## Best Practices

1. Always run `terraform plan` before `terraform apply`
2. Use version control for all configuration files
3. Don't commit sensitive data (use variables and .tfvars)
4. Use workspaces for different environments
5. Tag all resources appropriately

## Security Notes

1. Never commit AWS credentials
2. Use AWS IAM roles when possible
3. Restrict security group rules to necessary ports
4. Enable VPC flow logs for monitoring
5. Use encrypted volumes for EC2 instances

## Maintenance

1. Regularly update Terraform and provider versions
2. Keep local state backed up
3. Document all changes
4. Use git tags for releases