# AWS Production Infrastructure with Terraform

This repository contains Terraform code to provision a production-ready AWS infrastructure. The setup includes:

- VPC with public and private subnets across two Availability Zones
- Internet Gateway and NAT Gateway for internet access
- Security groups for public and private resources
- Bastion Host for secure SSH access
- Application Load Balancer (ALB) with Target Group and Listener
- Auto Scaling Group (ASG) with Launch Template for EC2 instances in private subnets
- Key Pair management for SSH access
- Output values for easy access to important resources

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS CLI installed and configured (`aws configure`)
- An AWS account with sufficient permissions
- SSH key pair (`prod-key.pub` for public key, `prod-key` for private key)

---

## File Structure

- `variables.tf` – Input variables for customizing the infrastructure
- `vpc.tf` – VPC, subnets, IGW, NAT Gateway, and route tables
- `security-groups.tf` – Security groups for public and private resources
- `key-pair.tf` – EC2 key pair resource
- `Bastion-Host.tf` – Bastion host EC2 instance in public subnet
- `Auto-Scaling-Group.tf` – Launch template and ASG for EC2 instances in private subnets
- `load-balancer.tf` – ALB, Target Group, and Listener
- `output.tf` – Outputs for DNS names, IPs, and instance details
- `.gitignore` – Files and folders to exclude from git
- `.terraform.lock.hcl` – Terraform provider lock file

---

## How It Works

### VPC & Subnets

- Creates a VPC with a CIDR block defined in `variables.tf`
- Two public and two private subnets across two AZs
- Public subnets have internet access via IGW
- Private subnets use a NAT Gateway for outbound internet

### Security Groups

- Public SG: Allows HTTP from anywhere
- Private SG: Allows HTTP/HTTPS/SSH from the public SG (for ALB and Bastion access)

### Bastion Host

- EC2 instance in public subnet for SSH access to private instances
- Uses the key pair defined in `key-pair.tf`
- Installs Nginx via user data

### Load Balancer

- Application Load Balancer in public subnets
- Target Group for EC2 instances in private subnets
- Listener on port 80 forwarding to Target Group

### Auto Scaling Group

- Launch Template for EC2 instances (Ubuntu AMI, Nginx installed via user data)
- ASG manages desired, min, and max instance counts
- Instances launched in private subnets
- Instances registered with ALB Target Group

### Key Pair

- Managed via Terraform for secure SSH access

### Outputs

- Bastion Host public and private IPs
- ALB DNS name
- Private and public IPs of all ASG instances

---

## Usage

1. **Clone the repository:**
   ```sh
   git clone https://github.com/HunzalaAwan/AWS-PROD-INFRA.git
   cd AWS-PROD-INFRA
   ```

2. **Add your SSH public key:**
   - Place your public key file as `prod-key.pub` in the root directory.

3. **Initialize Terraform:**
   ```sh
   terraform init
   ```

4. **Review the plan:**
   ```sh
   terraform plan
   ```

5. **Apply the configuration:**
   ```sh
   terraform apply
   ```
   - Type `yes` when prompted.

6. **Access Outputs:**
   - After apply, Terraform will show outputs like ALB DNS, Bastion IPs, and ASG instance IPs.

---

## Accessing Resources

- **Bastion Host:**  
  SSH using the private key:
  ```sh
  ssh -i prod-key ubuntu@<bastion_public_ip>
  ```

- **Application:**  
  Access via the ALB DNS name output in your browser.

---

## Notes

- Private instances do not have public IPs; access via Bastion Host.
- Make sure your AWS account has enough Elastic IP quota for NAT Gateway.
- Clean up resources when done to avoid charges:
  ```sh
  terraform destroy
  ```

---

## Troubleshooting

- **502 Bad Gateway on ALB:**  
  Ensure ASG instances are healthy, security groups allow traffic, and Nginx is running.
- **Target Group Unhealthy:**  
  Check user data in launch template, security group rules, and health check configuration.
- **Git Issues:**  
  Use `git pull origin main --allow-unrelated-histories` if histories differ.

---

## License

MIT

---

## Author

Hunzala
