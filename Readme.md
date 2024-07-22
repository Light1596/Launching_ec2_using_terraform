# Terraform EC2 Instances with Docker Nginx

## Project Description

This project uses Terraform to launch two EC2 instances in two different AWS availability zones and install Docker Nginx on these instances. The configuration details are specified in the `main.tf` file, and the variable values are stored in the `terraform.tfvars` file for easy modification.

## Architecture Diagram


## Installation Instructions

### Prerequisites

1. **Terraform**: Ensure that Terraform is installed on your machine. You can download it from the [official website](https://www.terraform.io/downloads.html).

2. **AWS CLI**: Install and configure the AWS CLI to manage your AWS resources. You can find the installation instructions [here](https://aws.amazon.com/cli/).

3. **AWS Account**: You need an AWS account with appropriate permissions to create EC2 instances and other related resources.

### Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/Light1596/Launching_ec2_using_terraform.git
   cd Launching_ec2_using_terraform
   ```

2. **Configure AWS Credentials**

   Ensure your AWS credentials are configured. You can do this by running:

   ```bash
   aws configure
   ```

3. **Initialize Terraform**

   Initialize the Terraform configuration to download the necessary provider plugins:

   ```bash
   terraform init
   ```

4. **Update `terraform.tfvars`**

   Update the `terraform.tfvars` file with the necessary variable values. This file contains variable definitions that might change between developers.

5. **Apply the Configuration**

   Apply the Terraform configuration to create the resources:

   ```bash
   terraform apply
   ```

   Confirm the apply action by typing `yes` when prompted.

## Usage

After applying the Terraform configuration, two EC2 instances will be launched in different availability zones with Docker and Nginx installed. You can access the Nginx server using the public IP addresses of the EC2 instances.

To find the public IP addresses, you can use the AWS Management Console or run:

```bash
terraform output
```

Visit `http://<public_ip>:8080` in your web browser to see the Nginx welcome page.

## Contribution Guidelines

We welcome contributions to improve this project. Please follow these guidelines when contributing:

1. **Fork the Repository**: Fork the repository to your GitHub account.

2. **Create a Feature Branch**: Create a new branch for your feature or bug fix.

   ```bash
   git checkout -b feature-name
   ```

3. **Commit Your Changes**: Make your changes and commit them with a descriptive commit message.

   ```bash
   git commit -am 'Add new feature'
   ```

4. **Push to the Branch**: Push your changes to your forked repository.

   ```bash
   git push origin feature-name
   ```

5. **Create a Pull Request**: Create a pull request from your feature branch to the main branch of the original repository.
