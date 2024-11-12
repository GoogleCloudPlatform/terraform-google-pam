# Cloud Privileged Access Manager (PAM) Module
This example creates entitlements at project and folder level

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
