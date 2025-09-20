# ABC-20092025
Project: Application Gateway + Tomcat Deployment (ABC-20092025)
This project automates the deployment of an Azure Application Gateway routing traffic to a Tomcat application running on a VM, with an additional Tomcat container in a separate network, using Terraform and Azure DevOps. Below are the detailed implementation steps that were followed:

Steps Followed
1. Created the GitHub Repository (ABC-20092025)
A new repository named ABC-20092025 was created to version control all associated infrastructure-as-code, shell scripts, and documentation files for the solution.

Standard .gitignore was added to avoid pushing sensitive and large Terraform state files (*.tfstate, .terraform/, etc.).

2. Provisioned the Azure Application Gateway with Terraform
Utilized Terraform to define infrastructure in HCL and YAML formats.

Wrote declarative code for:

Resource Group

Virtual Network (agw), with subnets for the gateway and VMs

Public IP for Application Gateway

Application Gateway resource, including frontend IP configs, backend pools, probes, listeners, routing rules

Clean module separation: main.tf, variables.tf, outputs.tf, with reusable parameters for RG/location/prefix/backend IPs.

All configuration files were committed to the repository for reproducible infra setup.

3. Deployed Tomcat Application on a Virtual Machine
Deployed an Azure VM within the provisioned subnet using automated scripts or manual configuration.

Tomcat was installed and configured on the VM to listen on port 8080 and accept traffic from the Application Gateway.

Ensured network security group (NSG) rules permitted inbound traffic from the gateway subnet.

4. Deployed a Tomcat Container on Another Machine, Attached to AGW
Provisioned another VM (or Docker host) in a separate virtual network.

Ran a Tomcat Docker container exposed via a public IP.

Added this machine’s public IP to the Application Gateway’s backend address pool to enable routing from AGW to the container in a distinct network.

5. Created an Automated Azure DevOps Pipeline
Developed an Azure DevOps YAML pipeline.

Steps included:

Checkout repo contents

Install Terraform

Execute terraform init, terraform plan, and terraform apply

Parameterize steps with pipeline variables

Pipeline ensured full infrastructure was deployed end-to-end in a repeatable, CI/CD manner using variables defined in YAML/Terraform files.

6. Validated Gateway Routing via Shell Script
Authored a validation shell script (script.sh) using curl to check accessibility of the Tomcat apps through the Application Gateway’s public IP.

Script confirms that HTTP requests routed through AGW reach both the VM-hosted Tomcat and the Docker Tomcat backend.

Output and error handling clarify the routing status for troubleshooting and CI validation.

Repository Layout
main.tf           # Main infrastructure resources
variables.tf      # Input variable declarations
outputs.tf        # Outputs for AGW IP, name, backends
provider.tf       # Terraform provider configuration
terraform.tfvars  # Environment-specific variable values
script.sh         # Shell script for gateway validation
.gitignore        # Exclude Terraform state/secrets
README.md         # Documentation
