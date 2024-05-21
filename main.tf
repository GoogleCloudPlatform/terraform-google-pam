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




locals {
  #  Parent for the PAM provisioning 
  parent        = var.pam_at_project ? "projects/${var.project_id}" : var.pam_at_folder ? "folders/${var.folder_id}" : "organizations/${var.organization_id}"
  resource_type = var.pam_at_project ? "Project" : var.pam_at_folder ? "Folder" : "Organization"
}



# Enable the necessary API services for the billing project
resource "google_project_service" "pam_api_service" {
  for_each = toset([
    "privilegedaccessmanager.googleapis.com",
  ])

  service                    = each.key
  project                    = var.billing_project_id
  disable_on_destroy         = false
  disable_dependent_services = true
}


# Enable the necessary API services for the PAM resource project
resource "google_project_service" "pam_proj_api_service" {
  count                      = var.billing_project_id == var.project_id ? 0 : 1
  service                    = "privilegedaccessmanager.googleapis.com"
  project                    = var.project_id
  disable_on_destroy         = false
  disable_dependent_services = true
}


# Wait delay after enabling APIs
resource "time_sleep" "wait_enable_service_api" {
  create_duration  = "30s"
  destroy_duration = "15s"
  depends_on = [
    google_project_service.pam_api_service,
    google_project_service.pam_proj_api_service,
  ]
}


resource "google_organization_iam_binding" "pam_sa_admin" {
  org_id     = var.organization_id
  role       = "roles/privilegedaccessmanager.serviceAgent"
  members    = ["serviceAccount:service-org-${var.organization_id}@gcp-sa-pam.iam.gserviceaccount.com"]
  depends_on = [time_sleep.wait_enable_service_api]
}


# Wait delay after PAM SA access provisioning
resource "time_sleep" "wait_pam_sa" {
  create_duration  = "40s"
  destroy_duration = "15s"
  depends_on = [
    google_organization_iam_binding.pam_sa_admin,
  ]
}


resource "google_privileged_access_manager_entitlement" "tfentitlement" {
  provider             = google-beta
  entitlement_id       = var.entitlement_id
  location             = var.location
  max_request_duration = var.max_request_duration
  parent               = local.parent
  dynamic "requester_justification_config" {
    for_each = var.justification_unstructured == false ? [] : [true]
    content {
      unstructured {}
    }
  }
  dynamic "requester_justification_config" {
    for_each = var.justification_not_mandatory == false ? [] : [true]
    content {
      not_mandatory {}
    }
  }
  eligible_users {
    principals = var.eligible_users
  }
  privileged_access {
    gcp_iam_access {
      role_bindings {
        role                 = var.role
        condition_expression = var.role_condition
      }
      resource      = "//cloudresourcemanager.googleapis.com/${local.parent}"
      resource_type = "cloudresourcemanager.googleapis.com/${local.resource_type}"
    }
  }
  additional_notification_targets {
    admin_email_recipients     = var.admin_email_recipients
    requester_email_recipients = var.requester_email_recipients
  }
  approval_workflow {
    manual_approvals {
      require_approver_justification = var.require_approver_justification
      steps {
        approvals_needed          = 1 # currently only 1 is supported
        approver_email_recipients = var.approver_email_recipients
        approvers {
          principals = var.eligible_approvers
        }
      }
    }
  }
  depends_on = [time_sleep.wait_pam_sa]
}


