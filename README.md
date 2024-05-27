# Terraform-ansible-project
This repo contains scripts for a sample project using Terraform and Ansible

The following items will be accomplished in this project:
- Provision 2 Azure VMs of minimal capacity (DSv4-series). This will include creating a VNET and all 2 VMs will be in the same subnet. This provisioning will be done by Terraform
- Out of the 2 configured servers, one would be a web server running apache2. The other server would be a DB Server which would have a mongoDB instance on it. These will be configured by Ansible
- The Ansible "server" will be a local laptop
- Once created, we will then attempt to create a simple collection in the DB on the DB server and try to display the data of this collection on the web server.
