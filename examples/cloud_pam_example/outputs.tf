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

##  This code creates PoC example for Privileged Access Manager ##
##  It is not developed for production workload ##

output "project_entitlement" {
  description = "Project level entitlement created "
  value       = module.entitlement_project.entitlement
}

output "project_entitlement_id" {
  description = "Project level entitlement ID"
  value       = module.entitlement_project.entitlement.id
}

output "folder_entitlement" {
  description = "Folder level entitlement created "
  value       = module.entitlement_folder.entitlement
}

output "folder_entitlement_id" {
  description = "Folder level entitlement ID"
  value       = module.entitlement_folder.entitlement.id
}

output "folder_entitlement_parent" {
  description = "parent of Folder level entitlement ID"
  value       = element(split("/", module.entitlement_folder.entitlement.parent), 1)
}
