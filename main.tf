/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


locals {
  max_request_duration = var.max_request_duration_hours * 60 * 60
  role_bindings        = { for x in var.role_bindings : x.role => x }
}

resource "google_organization_iam_member" "organization" {
  count  = var.parent_type == "organization" && var.grant_service_agent_permissions ? 1 : 0
  org_id = var.parent_id
  role   = "roles/privilegedaccessmanager.serviceAgent"
  member = "serviceAccount:service-org-${var.organization_id}@gcp-sa-pam.iam.gserviceaccount.com"
}

resource "google_folder_iam_member" "folder" {
  count  = var.parent_type == "folder" && var.grant_service_agent_permissions ? 1 : 0
  folder = "folders/${var.parent_id}"
  role   = "roles/privilegedaccessmanager.serviceAgent"
  member = "serviceAccount:service-org-${var.organization_id}@gcp-sa-pam.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "project" {
  count   = var.parent_type == "project" && var.grant_service_agent_permissions ? 1 : 0
  project = var.parent_id
  role    = "roles/privilegedaccessmanager.serviceAgent"
  member  = "serviceAccount:service-org-${var.organization_id}@gcp-sa-pam.iam.gserviceaccount.com"
}

resource "google_privileged_access_manager_entitlement" "entitlement" {
  entitlement_id       = var.entitlement_id
  location             = var.location
  max_request_duration = "${local.max_request_duration}s"
  parent               = "${var.parent_type}s/${var.parent_id}"

  requester_justification_config {
    dynamic "unstructured" {
      for_each = var.requester_justification ? ["unstructured"] : []
      content {}
    }
    dynamic "not_mandatory" {
      for_each = !var.requester_justification ? ["not_mandatory"] : []
      content {}
    }
  }

  eligible_users {
    principals = var.entitlement_requesters #Can request entitlement
  }

  additional_notification_targets {
    admin_email_recipients     = var.entitlement_approval_notification_recipients     #Notified when entitlement is approved
    requester_email_recipients = var.entitlement_availability_notification_recipients #Notified when entitlement is available
  }

  privileged_access {
    gcp_iam_access {
      resource      = "//cloudresourcemanager.googleapis.com/${var.parent_type}s/${var.parent_id}"
      resource_type = "cloudresourcemanager.googleapis.com/${title(var.parent_type)}"

      dynamic "role_bindings" {
        for_each = local.role_bindings
        content {
          role                 = role_bindings.key
          condition_expression = role_bindings.value.condition_expression
        }
      }
    }
  }

  dynamic "approval_workflow" {
    for_each = var.auto_approve_entitlement ? [] : ["approval_workflow_enabled"]
    content {
      manual_approvals {
        require_approver_justification = var.require_approver_justification
        steps {
          approvals_needed          = 1
          approver_email_recipients = var.entitlement_approval_notification_recipients
          approvers {
            principals = var.entitlement_approvers
          }
        }
      }
    }
  }

  depends_on = [
    google_organization_iam_member.organization,
    google_folder_iam_member.folder,
    google_project_iam_member.project,
  ]
}
