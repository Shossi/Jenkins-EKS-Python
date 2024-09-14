<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apache_Sec_group"></a> [apache\_Sec\_group](#module\_apache\_Sec\_group) | ../Modules/SecurityGroup | n/a |
| <a name="module_apache_instance"></a> [apache\_instance](#module\_apache\_instance) | ../Modules/EC2 | n/a |
| <a name="module_apache_vpc"></a> [apache\_vpc](#module\_apache\_vpc) | ../Modules/VPC | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apache_private_subnets"></a> [apache\_private\_subnets](#input\_apache\_private\_subnets) | Private subnets for apache | `list(string)` | <pre>[<br>  "10.181.242.128/25"<br>]</pre> | no |
| <a name="input_apache_public_subnets"></a> [apache\_public\_subnets](#input\_apache\_public\_subnets) | Public subnets for apache | `list(string)` | <pre>[<br>  "10.181.242.0/25"<br>]</pre> | no |
| <a name="input_apache_vpc_cidr"></a> [apache\_vpc\_cidr](#input\_apache\_vpc\_cidr) | CIDR block for apache VPC | `string` | `"10.181.242.0/24"` | no |
| <a name="input_associate_eip"></a> [associate\_eip](#input\_associate\_eip) | Control whether an Elastic IP should be associated with the instance | `bool` | `true` | no |
| <a name="input_associate_public_ip"></a> [associate\_public\_ip](#input\_associate\_public\_ip) | Whether to associate a public IP | `bool` | `true` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | Availability Zones for the VPCs | `list(string)` | <pre>[<br>  "eu-central-1a",<br>  "eu-central-1b"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->