##  Copyright 2023 Google LLC
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      https://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

variable "pam_at_org_id" {
  description = "If true, the Terraform will create PAM at org level."
  type        = bool
  default     = false ## update to 'false' to use an existing folder
}

variable "pam_at_folder" {
  description = "If true, the Terraform will create PAM at folder level."
  type        = bool
  default     = false ## update to 'false' to use an existing folder
}

variable "pam_at_project" {
  description = "If true, the Terraform will create PAM at project level."
  type        = bool
  default     = true ## update to 'false' to use an existing folder
}

variable "organization_id" {
  description = "Organization id for the PAM setup"
  type        = string
}

variable "folder_id" {
  description = "Folder id for the PAM setup"
  type        = string
  default     = null
}

variable "project_id" {
  description = "Project id for the PAM setup"
  type        = string
  default     = null
}

variable "billing_project_id" {
  description = "Project id for API billing quota if setting PAM at org level or folder level"
  type        = string

}

variable "eligible_users" {
  description = "List of users, who can create Grants using Entitlement"
  type        = list(string)
}

variable "eligible_approvers" {
  description = "List of users, who can approve Grants using Entitlement"
  type        = list(string)
}

variable "role" {
  description = "IAM role to be granted."
  type        = string
}

variable "role_condition" {
  description = "The expression field of the IAM condition to be associated with the role."
  type        = string
  default     = null
}

variable "justification_not_mandatory" {
  description = "The justification is not mandatory but can be provided in any of the supported formats."
  type        = bool
  default     = false ## update to 'false' to use an existing folder
}

variable "justification_unstructured" {
  description = "The requester has to provide a justification in the form of free flowing text."
  type        = bool
  default     = true ## update to 'false' to use an existing folder
}

variable "max_request_duration" {
  description = "The maximum amount of time for which access would be granted for a request."
  type        = string
}

variable "location" {
  description = "The region of the Entitlement resource."
  type        = string
}

variable "entitlement_id" {
  description = "The ID to use for this Entitlement. This will become the last part of the resource name. This value should be 4-63 characters, and valid characters are [a-z], [0-9], and -. The first character should be from [a-z]. This value should be unique among all other Entitlements under the specified"
  type        = string
}

variable "require_approver_justification" {
  description = "(Optional) Do the approvers need to provide a justification for their actions."
  type        = bool
  default     = true ## update to 'false' to use an existing folder
}

variable "approver_email_recipients" {
  description = " (Optional) List of users, dditional email addresses to be notified when a grant is pending approval."
  type        = list(string)
  default     = null
}

variable "admin_email_recipients" {
  description = " (Optional) List of users, additional email addresses to be notified when a principal(requester) is granted access."
  type        = list(string)
  default     = null
}

variable "requester_email_recipients" {
  description = " (Optional) List of users, additional email address to be notified about an eligible entitlement."
  type        = list(string)
  default     = null
}


