# nginx-web-app

This project leverages GitOps practices to automate the management of infrastructure and application deployment within AWS. The application operates on EC2 instances, while an Application Load Balancer serves as the front-end. Infrastructure provisioning is accomplished using Terraform, and Ansible manages server application configurations.

The repository is integrated with AWS through OpenID Connect (OIDC). This method ensures secure permissions granting to Git, eliminating the need to store AWS access keys and secret key credentials in the repository secrets.


