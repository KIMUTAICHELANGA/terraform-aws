# Infrastructure Verification Guide

This guide explains how to verify your AWS infrastructure after Terraform deployment.

## Terraform Output Verification

After running `terraform apply`, you should see output similar to:
```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
instance_public_ip = "54.X.X.X"    # You'll see actual IP here
vpc_id            = "vpc-xxxxxx"    # You'll see actual VPC ID
```

## AWS Console Verification

1. VPC Verification:
   - Login to AWS Console
   - Navigate to VPC service
   - Look for VPC with tag `Name = dev-vpc`
   - Verify CIDR range and subnets

2. EC2 Verification:
   - Navigate to EC2 service
   - Check instance with tag `Name = dev-instance`
   - Verify instance type and state
   - Confirm security group attachment

## AWS CLI Verification Commands

### VPC Verification
```bash
# Check if VPC exists
aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=dev-vpc" \
  --query 'Vpcs[*].[VpcId,CidrBlock]' \
  --output table

# Check subnets
aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=dev-public-subnet" \
  --output table
```

### EC2 Verification
```bash
# Check if EC2 instance is running
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=dev-instance" \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
  --output table

# Check security groups
aws ec2 describe-security-groups \
  --filters "Name=tag:Name,Values=dev-instance-sg" \
  --output table
```

### SSH Connection Test
```bash
# Replace with your key pair and IP
ssh -i "your-key-pair.pem" ec2-user@<instance_public_ip>
```

## Verification Script (verify.sh)
```bash
#!/bin/bash

echo "=== Terraform Infrastructure Verification Script ==="
echo

# Check AWS CLI configuration
echo "Checking AWS CLI configuration..."
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    echo "Error: AWS CLI not configured properly"
    exit 1
fi
echo "AWS CLI configured successfully"
echo

# Check VPC
echo "Checking VPC..."
VPC_ID=$(aws ec2 describe-vpcs \
    --filters "Name=tag:Name,Values=dev-vpc" \
    --query 'Vpcs[0].VpcId' \
    --output text)

if [ "$VPC_ID" != "None" ] && [ ! -z "$VPC_ID" ]; then
    echo "VPC found: $VPC_ID"
else
    echo "Error: VPC not found"
fi
echo

# Check Subnet
echo "Checking Subnet..."
SUBNET_ID=$(aws ec2 describe-subnets \
    --filters "Name=tag:Name,Values=dev-public-subnet" \
    --query 'Subnets[0].SubnetId' \
    --output text)

if [ "$SUBNET_ID" != "None" ] && [ ! -z "$SUBNET_ID" ]; then
    echo "Subnet found: $SUBNET_ID"
else
    echo "Error: Subnet not found"
fi
echo

# Check EC2 Instance
echo "Checking EC2 Instance..."
INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=dev-instance" "Name=instance-state-name,Values=running" \
    --query 'Reservations[0].Instances[0].InstanceId' \
    --output text)

if [ "$INSTANCE_ID" != "None" ] && [ ! -z "$INSTANCE_ID" ]; then
    echo "EC2 Instance found: $INSTANCE_ID"
    
    # Get instance public IP
    PUBLIC_IP=$(aws ec2 describe-instances \
        --instance-ids "$INSTANCE_ID" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
    echo "Public IP: $PUBLIC_IP"
else
    echo "Error: EC2 Instance not found or not running"
fi
echo

# Check Security Group
echo "Checking Security Group..."
SG_ID=$(aws ec2 describe-security-groups \
    --filters "Name=tag:Name,Values=dev-instance-sg" \
    --query 'SecurityGroups[0].GroupId' \
    --output text)

if [ "$SG_ID" != "None" ] && [ ! -z "$SG_ID" ]; then
    echo "Security Group found: $SG_ID"
else
    echo "Error: Security Group not found"
fi
echo

echo "=== Verification Complete ==="
```

## Using the Verification Script

1. Save the script as `verify.sh`
2. Make it executable:
```bash
chmod +x verify.sh
```
3. Run the script:
```bash
./verify.sh
```

## Troubleshooting Guide

### Common Issues and Solutions

1. Resources Not Created:
   - Check Terraform state: `terraform show`
   - Verify AWS credentials: `aws configure list`
   - Check for error messages in `terraform apply` output

2. Cannot Connect to EC2:
   - Verify security group rules
   - Check key pair configuration
   - Confirm instance is running
   - Test network connectivity

3. VPC Issues:
   - Verify CIDR ranges
   - Check route tables
   - Confirm Internet Gateway attachment
   - Verify subnet configurations

4. Security Group Problems:
   - Check inbound/outbound rules
   - Verify port configurations
   - Confirm security group associations

### Real-time Monitoring

```bash
# Watch resource creation
terraform apply -auto-approve

# Check current state
terraform show

# List resources
terraform state list
```

### CloudWatch Logs

1. Check VPC Flow Logs
2. Monitor EC2 instance logs
3. Review CloudWatch metrics

## Best Practices for Verification

1. Always verify resources after creation
2. Use multiple verification methods
3. Document any issues encountered
4. Keep verification scripts updated
5. Monitor costs during testing