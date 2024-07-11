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

##  This code creates PoC example for Privileged Access Manager ##
##  It is not developed for production workload ##






# Create storage bucket protected by autokey
resource "google_storage_bucket" "dev_bucket_name" {
  name                        = "dev_bucket_${random_id.random_suffix.hex}"
  location                    = "us-east1"
  force_destroy               = true
  project                     = google_project.dev_project_id.project_id
  uniform_bucket_level_access = true
}


# Create storage bucket protected by autokey
resource "google_storage_bucket" "prod_bucket_name" {
  name                        = "prod_bucket_${random_id.random_suffix.hex}"
  location                    = "us-east1"
  force_destroy               = true
  project                     = google_project.prod_project_id.project_id
  uniform_bucket_level_access = true
}

