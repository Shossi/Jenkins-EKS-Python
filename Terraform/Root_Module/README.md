<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.5.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_argocd"></a> [argocd](#module\_argocd) | ../Modules/EKS/Helm | n/a |
| <a name="module_bastion_host"></a> [bastion\_host](#module\_bastion\_host) | ../Modules/EC2 | n/a |
| <a name="module_bastion_security_group"></a> [bastion\_security\_group](#module\_bastion\_security\_group) | ../Modules/SecurityGroup | n/a |
| <a name="module_eks_addon_vpc_cni"></a> [eks\_addon\_vpc\_cni](#module\_eks\_addon\_vpc\_cni) | ../Modules/EKS/Addon | n/a |
| <a name="module_eks_addons_coredns"></a> [eks\_addons\_coredns](#module\_eks\_addons\_coredns) | ../Modules/EKS/Addon | n/a |
| <a name="module_eks_addons_kube_proxy"></a> [eks\_addons\_kube\_proxy](#module\_eks\_addons\_kube\_proxy) | ../Modules/EKS/Addon | n/a |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | ../Modules/EKS/Cluster | n/a |
| <a name="module_eks_cluster_role"></a> [eks\_cluster\_role](#module\_eks\_cluster\_role) | ../Modules/Roles | n/a |
| <a name="module_eks_node_group"></a> [eks\_node\_group](#module\_eks\_node\_group) | ../Modules/EKS/NodeGroup | n/a |
| <a name="module_eks_node_group_role"></a> [eks\_node\_group\_role](#module\_eks\_node\_group\_role) | ../Modules/Roles | n/a |
| <a name="module_eks_security_group"></a> [eks\_security\_group](#module\_eks\_security\_group) | ../Modules/SecurityGroup | n/a |
| <a name="module_eks_vpc"></a> [eks\_vpc](#module\_eks\_vpc) | ../Modules/VPC | n/a |
| <a name="module_jenkins_agent"></a> [jenkins\_agent](#module\_jenkins\_agent) | ../Modules/EC2 | n/a |
| <a name="module_jenkins_lb"></a> [jenkins\_lb](#module\_jenkins\_lb) | ../Modules/LoadBalancer | n/a |
| <a name="module_jenkins_master"></a> [jenkins\_master](#module\_jenkins\_master) | ../Modules/EC2 | n/a |
| <a name="module_jenkins_security_group"></a> [jenkins\_security\_group](#module\_jenkins\_security\_group) | ../Modules/SecurityGroup | n/a |
| <a name="module_jenkins_vpc"></a> [jenkins\_vpc](#module\_jenkins\_vpc) | ../Modules/VPC | n/a |
| <a name="module_nginx_ingress_controller"></a> [nginx\_ingress\_controller](#module\_nginx\_ingress\_controller) | ../Modules/EKS/Helm | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_eks_cluster_auth.auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [http_http.ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | Availability Zones for the VPCs | `list(string)` | <pre>[<br>  "eu-central-1a",<br>  "eu-central-1b"<br>]</pre> | no |
| <a name="input_bastion_ami"></a> [bastion\_ami](#input\_bastion\_ami) | AMI ID for Bastion host | `string` | n/a | yes |
| <a name="input_bastion_instance_type"></a> [bastion\_instance\_type](#input\_bastion\_instance\_type) | Instance type for Bastion host | `string` | `"t2.micro"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired size of the EKS node group | `number` | `2` | no |
| <a name="input_eks_cluster_role_name"></a> [eks\_cluster\_role\_name](#input\_eks\_cluster\_role\_name) | IAM Role for EKS Cluster | `string` | `"eks-cluster-role"` | no |
| <a name="input_eks_node_group_role_name"></a> [eks\_node\_group\_role\_name](#input\_eks\_node\_group\_role\_name) | IAM Role for EKS Node Group | `string` | `"eks-node-group-role"` | no |
| <a name="input_eks_private_subnets"></a> [eks\_private\_subnets](#input\_eks\_private\_subnets) | Private subnets for EKS | `list(string)` | n/a | yes |
| <a name="input_eks_public_subnets"></a> [eks\_public\_subnets](#input\_eks\_public\_subnets) | Public subnets for EKS | `list(string)` | n/a | yes |
| <a name="input_eks_vpc_cidr"></a> [eks\_vpc\_cidr](#input\_eks\_vpc\_cidr) | CIDR block for EKS VPC | `string` | `"10.100.0.0/16"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, production) | `string` | n/a | yes |
| <a name="input_jenkins_agent_ami"></a> [jenkins\_agent\_ami](#input\_jenkins\_agent\_ami) | AMI ID for Jenkins agent | `string` | n/a | yes |
| <a name="input_jenkins_agent_instance_type"></a> [jenkins\_agent\_instance\_type](#input\_jenkins\_agent\_instance\_type) | Instance type for Jenkins agent | `string` | `"t2.micro"` | no |
| <a name="input_jenkins_ami"></a> [jenkins\_ami](#input\_jenkins\_ami) | AMI ID for Jenkins master | `string` | n/a | yes |
| <a name="input_jenkins_lb_listener_port"></a> [jenkins\_lb\_listener\_port](#input\_jenkins\_lb\_listener\_port) | Listener port for Jenkins Load Balancer | `number` | `8080` | no |
| <a name="input_jenkins_lb_name"></a> [jenkins\_lb\_name](#input\_jenkins\_lb\_name) | Name of the Jenkins Load Balancer | `string` | `"jenkins-lb"` | no |
| <a name="input_jenkins_lb_port"></a> [jenkins\_lb\_port](#input\_jenkins\_lb\_port) | Port for Jenkins Load Balancer | `number` | `8080` | no |
| <a name="input_jenkins_lb_protocol"></a> [jenkins\_lb\_protocol](#input\_jenkins\_lb\_protocol) | Load balancer protocol for Jenkins | `string` | `"HTTP"` | no |
| <a name="input_jenkins_master_instance_type"></a> [jenkins\_master\_instance\_type](#input\_jenkins\_master\_instance\_type) | Instance type for Jenkins master | `string` | `"t3.large"` | no |
| <a name="input_jenkins_private_subnets"></a> [jenkins\_private\_subnets](#input\_jenkins\_private\_subnets) | Private subnets for Jenkins | `list(string)` | n/a | yes |
| <a name="input_jenkins_public_subnets"></a> [jenkins\_public\_subnets](#input\_jenkins\_public\_subnets) | Public subnets for Jenkins | `list(string)` | n/a | yes |
| <a name="input_jenkins_vpc_cidr"></a> [jenkins\_vpc\_cidr](#input\_jenkins\_vpc\_cidr) | CIDR block for Jenkins VPC | `string` | `"10.10.0.0/16"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum size of the EKS node group | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum size of the EKS node group | `number` | `2` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | EKS Node Group Name | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to the SSH public key | `string` | `"/home/yossi/.ssh/new_key.pub"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->