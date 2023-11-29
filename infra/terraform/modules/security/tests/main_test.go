package test

import (
	"context"
	"testing"
	"google.golang.org/api/cloudresourcemanager/v1"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAuditLogsShouldBeEnabled(t *testing.T) {	
	projectID := "ninth-beacon-401418" 

	auditLoggingApis := []string{
		"compute.googleapis.com",
		"secretmanager.googleapis.com",
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",

		Vars: map[string]interface{}{
			"project_id": projectID,			
			"audit_logging_apis": auditLoggingApis,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	projectIamPolicy := GetIamPolicy(projectID)
	apisWithAuditLogsEnabled := GetApisWithAuditLogsEnabled(projectIamPolicy)	

	for _, api := range auditLoggingApis {
		assert.Contains(t, apisWithAuditLogsEnabled, api)
	}	
}

func GetIamPolicy(projectID string) *cloudresourcemanager.Policy {
  ctx := context.Background()
	crmService, _ := cloudresourcemanager.NewService(ctx)
  request := new(cloudresourcemanager.GetIamPolicyRequest)
  policy, _ := crmService.Projects.GetIamPolicy(projectID, request).Do()

  return policy
}

func GetApisWithAuditLogsEnabled(policy *cloudresourcemanager.Policy) []string {
	apis := []string{}
	expectedLogType := "ADMIN_READ"

	for _, auditConfig := range policy.AuditConfigs {
		for _, auditLogConfig:= range auditConfig.AuditLogConfigs {
			if auditLogConfig.LogType == expectedLogType {
				apis = append(apis, auditConfig.Service)
				break
			}
		}
  }

	return apis	
}
