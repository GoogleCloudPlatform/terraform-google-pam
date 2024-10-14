# Cloud Privileged Access Manager (PAM) Module
Privileged Access Manager (PAM) is a Google Cloud native, managed solution to secure, manage and audit privileged access while ensuring operational velocity and developer productivity. PAM enables just-in-time, time-bound, approval-based access elevations, and auditing of privileged access elevations and activity. PAM lets you define the rules of who can access, what they can access, and if they should be granted access with or without approvals based on the sensitivity of the access and emergency of the situation. This module makes it easy to set up [Privileged Access Manager](https://https://cloud.google.com/iam/docs/pam-overview).

# How Privileged Access Manager (PAM) works:
- Create an Entitlement.
- Request a Grant against an Entitlement. 
- Approve or reject a request for a Grant against an Entitlement. 

![Flow Diagram](./flow-diagram.png)

## Usage

To run this example you need to execute:

```bash
export TF_VAR_project_id="your_project_id"
```

```bash
terraform init
terraform plan
terraform apply
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| entitlement\_requester | Users, groups, service accounts or domains who can request grants using this entitlement | `string` | n/a | yes |
| folder\_id | The folder in which the resource belongs | `string` | n/a | yes |
| org\_id | The organization ID | `string` | n/a | yes |
| project\_id | The project in which the resource belongs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| folder\_entitlement | Folder level entitlement created |
| folder\_entitlement\_id | Folder level entitlement ID |
| folder\_entitlement\_parent | parent of Folder level entitlement ID |
| project\_entitlement | Project level entitlement created |
| project\_entitlement\_id | Project level entitlement ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
