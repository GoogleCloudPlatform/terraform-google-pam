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





# Configure Cloud Privilege Access Management (PAM)
module "iam-pam" {
  source  = "GoogleCloudPlatform/iam-pam/google"
  version = "1.0.0"
  #source                         = "../../"
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

