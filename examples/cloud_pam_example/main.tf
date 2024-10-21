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


# Enable the necessary API services for the billing project
resource "google_project_service" "pam_api_service" {
  service                    = "privilegedaccessmanager.googleapis.com"
  project                    = var.project_id
  disable_on_destroy         = false
  disable_dependent_services = false
}

module "entitlement_project" {
  source  = "GoogleCloudPlatform/pam/google"
  version = "~> 2.0"

  entitlement_id = "example-entitlement-project"
  parent_id      = var.project_id
  parent_type    = "project"

  organization_id = var.org_id

  grant_service_agent_permissions = true

  entitlement_requesters = [
    "user:dbadmin@develop.blueprints.joonix.net",
  ]
  entitlement_approvers = [
    "group:subtest@develop.blueprints.joonix.net",
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
  depends_on = [
    google_project_service.pam_api_service
  ]
}

module "entitlement_folder" {
  source  = "GoogleCloudPlatform/pam/google"
  version = "~> 2.0"

  entitlement_id = "example-entitlement-folder"
  parent_id      = var.folder_id
  parent_type    = "folder"

  organization_id = var.org_id

  grant_service_agent_permissions = true

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
