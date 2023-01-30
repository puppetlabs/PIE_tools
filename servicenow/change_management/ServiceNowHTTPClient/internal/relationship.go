package internal

import (
	"encoding/json"
	"fmt"
)

type changeResult struct {
	Result []struct {
		Number struct {
			DisplayValue string `json:"display_value"`
		}
		SysID struct {
			DisplayValue string `json:"display_value"`
		}
		SysCreatedBy struct {
			DisplayValue string `json:"display_value"`
		}
		Phase struct {
			DisplayValue string `json:"display_value"`
		}
		Impact struct {
			DisplayValue string `json:"display_value"`
		}
		Priority struct {
			DisplayValue string `json:"display_value"`
		}
		Urgency struct {
			DisplayValue string `json:"display_value"`
		}
		Approval struct {
			DisplayValue string `json:"display_value"`
		}
		UponApproval struct {
			DisplayValue string `json:"display_value"`
		}
		ProductionSystem struct {
			DisplayValue string `json:"display_value"`
		}
		SysCreatedOn struct {
			DisplayValue string `json:"display_value"`
		}
	} `json:"result"`
}

// CreateRelationship POST relationship create to ServiceNow
func CreateRelationship(host string, changeSysID string, nodeSysID string, username string, password string) string {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change/" + changeSysID + "/ci"
	body := []byte(`{
		"cmdb_ci_sys_ids": "[` + nodeSysID + `]",
		"association_type": "affected"
	}`)

	fmt.Println("Post URL=" + URL + " body=" + string(body))

	str := HTTPAction("POST", URL, body, username, password)
	fmt.Print("Relationship Response: " + str)
	return str
}

// ParseRelationship parses the JSON response from ServiceNow
func ParseRelationship(responseBody string) map[string]string {

	var data result
	json.Unmarshal([]byte(responseBody), &data)
	resultMap := make(map[string]string)

	fmt.Println("number of Changes matching user: ", len(data.Result))
	for _, v := range data.Result {
		resultMap["Number"] = v.Number.DisplayValue
		resultMap["SysID"] = v.SysID.DisplayValue
		resultMap["SysCreatedBy"] = v.SysCreatedBy.DisplayValue
		resultMap["Phase"] = v.Phase.DisplayValue
		resultMap["Impact"] = v.Impact.DisplayValue
		resultMap["Priority"] = v.Priority.DisplayValue
		resultMap["Urgency"] = v.Urgency.DisplayValue
		resultMap["Approval"] = v.Approval.DisplayValue
		resultMap["UponApproval"] = v.UponApproval.DisplayValue
		resultMap["ProductionSystem"] = v.ProductionSystem.DisplayValue
		resultMap["SysCreatedOn"] = v.SysCreatedOn.DisplayValue

		fmt.Println("Change: ", v.Number.DisplayValue)
	}

	return resultMap
}
