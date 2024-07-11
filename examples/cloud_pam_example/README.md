# Cloud Privileged Access Manager (PAM) Module
Privileged Access Manager (PAM) is a Google Cloud native, managed solution to secure, manage and audit privileged access while ensuring operational velocity and developer productivity. PAM enables just-in-time, time-bound, approval-based access elevations, and auditing of privileged access elevations and activity. PAM lets you define the rules of who can access, what they can access, and if they should be granted access with or without approvals based on the sensitivity of the access and emergency of the situation. This module makes it easy to set up [Privileged Access Manager](https://https://cloud.google.com/iam/docs/pam-overview).

# How Privileged Access Manager (PAM) works:
- Create an Entitlement.
- Request a Grant against an Entitlement. 
- Approve or reject a request for a Grant against an Entitlement. 

![Flow Diagram](./flow-diagram.png)

##  Usage

```tf
# Configure Cloud Privilege Access Management (PAM)
module "iam-pam" {
  #source  = "GoogleCloudPlatform/pam/google"
  #version = "1.0.0"
  source                         = "../../"
  pam_at_org_id                  = false       ## Optional, only one should be true for PAM level (Org_id or folder_id or project_id)
  pam_at_folder                  = false       ## Optional, only one should be true for PAM level (Org_id or folder_id or project_id)
  pam_at_project                 = true        ## Optional, only one should be true for PAM level (Org_id or folder_id or project_id)
  organization_id                = "XXXXXXXX"  ## Required for PAM service account premission
  billing_project_id             = "XXXXXXXXX" ## Required for API billing quota if setting PAM at org level or folder level
  folder_id                      = ""          ## Optional, only needed for PAM at Folder level
  project_id                     = ""          ## Optional, only needed for PAM at Project level
  eligible_users                 = ["user:foo@example.com"]
  eligible_approvers             = ["user:bar@example.com"]
  role                           = "roles/storage.admin"
  role_condition                 = "request.time < timestamp(\"2024-12-31T19:30:00.000Z\")"
  justification_not_mandatory    = false # The justification is not mandatory but can be provided in any of the supported formats.
  justification_unstructured     = true  # The requester has to provide a justification in the form of free flowing text.
  max_request_duration           = "28800s"
  location                       = "global" #only global is supported currently
  entitlement_id                 = "pam-entitlement-poc"
  require_approver_justification = true
  approver_email_recipients      = ["approver2@example.com"] ## additional users  for notification
  admin_email_recipients         = ["admin@example.com"]     ## additional users for notification
  requester_email_recipients     = ["requestor@example.com"] ## additional users for notification
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_email\_recipients | (Optional) List of users, additional email addresses to be notified when a principal(requester) is granted access. | `list(string)` | `null` | no |
| approver\_email\_recipients | (Optional) List of users, dditional email addresses to be notified when a grant is pending approval. | `list(string)` | `null` | no |
| billing\_project\_id | Project id for API billing quota if setting PAM at org level or folder level | `string` | n/a | yes |
| eligible\_approvers | List of users, who can approve Grants using Entitlement | `list(string)` | n/a | yes |
| eligible\_users | List of users, who can create Grants using Entitlement | `list(string)` | n/a | yes |
| entitlement\_id | The ID to use for this Entitlement. This will become the last part of the resource name. This value should be 4-63 characters, and valid characters are [a-z], [0-9], and -. The first character should be from [a-z]. This value should be unique among all other Entitlements under the specified | `string` | n/a | yes |
| folder\_id | Folder id for the PAM setup | `string` | `null` | no |
| justification\_not\_mandatory | The justification is not mandatory but can be provided in any of the supported formats. | `bool` | `false` | no |
| justification\_unstructured | The requester has to provide a justification in the form of free flowing text. | `bool` | `true` | no |
| location | The region of the Entitlement resource. | `string` | n/a | yes |
| max\_request\_duration | The maximum amount of time for which access would be granted for a request. | `string` | n/a | yes |
| organization\_id | Organization id for the PAM setup | `string` | n/a | yes |
| pam\_at\_folder | If true, the Terraform will create PAM at folder level. | `bool` | `false` | no |
| pam\_at\_org\_id | If true, the Terraform will create PAM at org level. | `bool` | `false` | no |
| pam\_at\_project | If true, the Terraform will create PAM at project level. | `bool` | `true` | no |
| project\_id | Project id for the PAM setup | `string` | `null` | no |
| requester\_email\_recipients | (Optional) List of users, additional email address to be notified about an eligible entitlement. | `list(string)` | `null` | no |
| require\_approver\_justification | (Optional) Do the approvers need to provide a justification for their actions. | `bool` | `true` | no |
| role | IAM role to be granted. | `string` | n/a | yes |
| role\_condition | The expression field of the IAM condition to be associated with the role. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | billing project id |
| region | resources region |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.53

### Service Account and User Permissions

A service account with the following roles must be used to provision
the resources of this module:

- PAM Service Agent : `roles/privilegedaccessmanager.serviceAgent`


The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Cloud KMS API: `privilegedaccessmanager.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.
