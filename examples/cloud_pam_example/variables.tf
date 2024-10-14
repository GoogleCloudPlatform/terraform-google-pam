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

variable "project_id" {
  description = "The project in which the resource belongs"
  type        = string
}

variable "folder_id" {
  description = "The folder in which the resource belongs"
  type        = string
}

variable "org_id" {
  description = "The organization ID"
  type        = string
}

variable "entitlement_requester" {
  description = "Users, groups, service accounts or domains who can request grants using this entitlement"
  type        = string
}
