#!/bin/bash

echo "Checking AWS Infrastructure..."

# Get VPC ID from Terraform output
VPC_ID=$(terraform output -raw vpc_id)
echo "VPC ID: $VPC_ID"

# Get Instance ID and IP from Terraform output
INSTANCE_IP=$(terraform output -raw instance_public_ip)
echo "Instance Public IP: $INSTANCE_IP"

# Check VPC
echo -n "Checking VPC... "
if aws ec2 describe-vpcs --vpc-ids $VPC_ID >/dev/null 2>&1; then
    echo "✅ VPC exists"
else
    echo "❌ VPC not found"
fi

# Check EC2 Instance
echo -n "Checking EC2 Instance... "
if ping -c 1 $INSTANCE_IP >/dev/null 2>&1; then
    echo "✅ Instance is responding"
else
    echo "❌ Instance not reachable"
fi

# Check Security Group
echo -n "Checking Security Group... "
SG_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=dev-instance-sg" --query 'SecurityGroups[0].GroupId' --output text)
if [ ! -z "$SG_ID" ]; then
    echo "✅ Security Group exists: $SG_ID"
else
    echo "❌ Security Group not found"
fi

echo "Verification complete!"