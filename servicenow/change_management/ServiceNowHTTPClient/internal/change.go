package internal

import (
	"encoding/json"
	"fmt"

	"github.com/tidwall/gjson"
)

type ChangeResult struct {
	Name  string
	SysID string
}

type result struct {
	Result []struct {
		Number struct {
			DisplayValue string `json:"display_value"`
		}
		SysID struct {
			DisplayValue string `json:"display_value"`
		} `json:"sys_id"`
		SysCreatedBy struct {
			DisplayValue string `json:"display_value"`
		} `json:"sys_created_by"`
		Phase struct {
			DisplayValue string `json:"display_value"`
		} `json:"phase"`
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
		} `json:"upon_approval"`
		ProductionSystem struct {
			DisplayValue string `json:"display_value"`
		} `json:"production_system"`
		SysCreatedOn struct {
			DisplayValue string `json:"display_value"`
		} `json:"sys_created_on"`
	} `json:"result"`
}

// CreateChange POST change create to ServiceNow
func CreateChange(host string, body []byte, username string, password string) ChangeResult {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change"

	fmt.Println("Post URL=" + URL + " body=" + string(body))

	str := HTTPAction("POST", URL, body, username, password)
	var resultChange ChangeResult

	resultChange.Name = gjson.Get(str, "result.number.display_value").String()
	resultChange.SysID = gjson.Get(str, "result.sys_id.display_value").String()
	return resultChange
}

// GetChange GET change by user from ServiceNow
func GetChange(host string, username string, password string) map[string]string {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change?sys_created_by=" + username
	body := []byte(`{
		"short_description": "Get record"
	}`)
	str := HTTPAction("GET", URL, body, username, password)
	return ParseChange(str)
}

// ParseChange parses the JSON response from ServiceNow
func ParseChange(responseBody string) map[string]string {

	var data result
	json.Unmarshal([]byte(responseBody), &data)
	resultMap := make(map[string]string)

	fmt.Println("number of Changes matching user: ", len(data.Result))
	for _, v := range data.Result {
		resultMap["Number"] = v.Number.DisplayValue
		resultMap["SysID"] = v.SysID.DisplayValue

		// resultMap["SysCreatedBy"] = v.SysCreatedBy.DisplayValue
		// resultMap["Phase"] = v.Phase.DisplayValue
		// resultMap["Impact"] = v.Impact.DisplayValue
		// resultMap["Priority"] = v.Priority.DisplayValue
		// resultMap["Urgency"] = v.Urgency.DisplayValue
		// resultMap["Approval"] = v.Approval.DisplayValue
		// resultMap["UponApproval"] = v.UponApproval.DisplayValue
		// resultMap["ProductionSystem"] = v.ProductionSystem.DisplayValue
		// resultMap["SysCreatedOn"] = v.SysCreatedOn.DisplayValue

		fmt.Println("Change: ", v.Number.DisplayValue, " SysID: ", v.SysID.DisplayValue)
	}

	return resultMap
}
