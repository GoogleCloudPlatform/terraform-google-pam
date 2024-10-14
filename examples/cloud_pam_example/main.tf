##  Copyright 2024 Google LLC
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

##  This code creates PoC example for Privileged Access Manager ##
##  It is not developed for production workload ##

module "entitlement_project" {
  source  = "GoogleCloudPlatform/pam/google"
  version = "~> 1.0"

  entitlement_id                  = "example-entitlement-project"
  parent_id                       = var.project_id
  parent_type                     = "project"
  grant_service_agent_permissions = true

  organization_id = var.org_id

  entitlement_requesters = [
    "serviceAccount:${var.entitlement_requester}",
  ]
  entitlement_approvers = [
    "domain:google.com",
  ]
  role_bindings = [
    {
      role                 = "roles/storage.admin"
      condition_expression = "request.time < timestamp(\"2024-04-23T18:30:00.000Z\")"
    },
    {
      role = "roles/bigquery.admin"
    }
  ]
}

module "entitlement_folder" {
  source  = "GoogleCloudPlatform/pam/google"
  version = "~> 1.0"

  entitlement_id                  = "example-entitlement-folder"
  parent_id                       = var.folder_id
  parent_type                     = "folder"
  grant_service_agent_permissions = true

  organization_id = var.org_id

  entitlement_requesters = [
    "serviceAccount:${var.entitlement_requester}",
  ]
  entitlement_approvers = [
    "domain:google.com",
  ]
  role_bindings = [
    {
      role                 = "roles/storage.admin"
      condition_expression = "request.time < timestamp(\"2024-04-23T18:30:00.000Z\")"
    },
    {
      role = "roles/bigquery.admin"
    }
  ]
}
