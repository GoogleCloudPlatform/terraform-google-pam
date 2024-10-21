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

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 17.0"

  name              = "ci-pam"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account
  deletion_policy   = "DELETE"


  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "privilegedaccessmanager.googleapis.com",
    "storage-api.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ]
}

resource "random_id" "suffix" {
  byte_length = 4
}
resource "google_folder" "folder" {
  display_name = "ci-pam-folder-${random_id.suffix.hex}"
  parent       = "folders/${var.folder_id}"
}


resource "google_service_account" "entitlement_requester" {
  project      = module.project.project_id
  account_id   = "entitlement-requester"
  display_name = "entitlement-requester"
}
