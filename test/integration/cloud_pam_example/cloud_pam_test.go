// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cloud_pam

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestCloudPamExample(t *testing.T) {
	pam := tft.NewTFBlueprintTest(t)

	pam.DefineVerify(func(assert *assert.Assertions) {
		// pam.DefaultVerify(assert)

		projectId := pam.GetTFSetupStringOutput("project_id")
		projectEntitlementId := pam.GetStringOutput("project_entitlement_id")

		pe := gcloud.Runf(t, "pam entitlements describe %s --project %s --location global", projectEntitlementId, projectId)
		assert.Equal(projectEntitlementId, pe.Get("name").String(), "Mismatch Entitlement ID")
		assert.Equal("3600s", pe.Get("maxRequestDuration").String(), "Mismatch Entitlement ID")
		assert.True(pe.Get("approvalWorkflow.manualApprovals.requireApproverJustification").Bool(), "requireApproverJustification should be True")
		assert.Equal("1", pe.Get("approvalWorkflow.manualApprovals.steps").Array()[0].Get("approvalsNeeded").String(), "approvalsNeeded should be 1")
		assert.Equal("cloudresourcemanager.googleapis.com/Project", pe.Get("privilegedAccess.gcpIamAccess.resourceType").String(), "Mismatch resourceType")
		roleBindings := pe.Get("privilegedAccess.gcpIamAccess.roleBindings").Array()
		assert.Equal(2, len(roleBindings), "There should be 2 role bindings")
		approvers := pe.Get("approvalWorkflow.manualApprovals.steps").Array()[0].Get("approvers").Array()
		assert.Equal(1, len(approvers), "There should be 1 approvers")
		eligibleUsers := pe.Get("eligibleUsers").Array()[0].Get("principals").Array()
		assert.Equal(1, len(eligibleUsers), "There should be 1 eligibleUsers")

		folderEntitlementId := pam.GetStringOutput("folder_entitlement_id")
		folderEntitlementParent := pam.GetStringOutput("folder_entitlement_parent")

		fe := gcloud.Runf(t, "pam entitlements describe %s --folder %s --location global", folderEntitlementId, folderEntitlementParent)
		assert.Equal(folderEntitlementId, fe.Get("name").String(), "Mismatch Entitlement ID")
		assert.Equal("3600s", fe.Get("maxRequestDuration").String(), "Mismatch Entitlement ID")
		assert.True(fe.Get("approvalWorkflow.manualApprovals.requireApproverJustification").Bool(), "requireApproverJustification should be True")
		assert.Equal("1", fe.Get("approvalWorkflow.manualApprovals.steps").Array()[0].Get("approvalsNeeded").String(), "approvalsNeeded should be 1")
		assert.Equal("cloudresourcemanager.googleapis.com/Folder", fe.Get("privilegedAccess.gcpIamAccess.resourceType").String(), "Mismatch resourceType")
		folderRoleBindings := fe.Get("privilegedAccess.gcpIamAccess.roleBindings").Array()
		assert.Equal(2, len(folderRoleBindings), "There should be 2 role bindings")
		folderApprovers := fe.Get("approvalWorkflow.manualApprovals.steps").Array()[0].Get("approvers").Array()
		assert.Equal(1, len(folderApprovers), "There should be 1 approvers")
		folderEligibleUsers := fe.Get("eligibleUsers").Array()[0].Get("principals").Array()
		assert.Equal(1, len(folderEligibleUsers), "There should be 1 eligibleUsers")

	})
	pam.Test()
}
