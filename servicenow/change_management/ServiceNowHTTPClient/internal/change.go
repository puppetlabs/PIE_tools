package internal

import (
	"encoding/json"
	"fmt"
)

type ChangeResult struct {
	Result struct {
		Number struct {
			DisplayValue string `json:"display_value"`
		}
		SysID struct {
			DisplayValue string `json:"display_value"`
		} `json:"sys_id"`
		State struct {
			DisplayValue string `json:"display_value"`
		} `json:"state"`
	} `json:"result"`
}

type ChangeError struct {
	Error struct {
		Message string `json:"message"`
		Detail  string `json:"detail"`
	} `json:"error"`
	Status string `json:"status"`
}

type State struct {
	State string `json:"state"`
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
func CreateChange(host string, body []byte, username string, password string) *ChangeResult {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change"

	fmt.Println("Post URL=" + URL + " body=" + string(body))

	resp, err := HTTPAction("POST", URL, body, username, password)
	if err != nil {
		panic(err)
	}

	var resultChange ChangeResult
	err = json.Unmarshal(resp, &resultChange)
	if err != nil {
		panic(err)
	}

	return &resultChange
}

// UpdateChange PATCH a 'normal' Change Request 'State' to ServiceNow
func UpdateChange(host string, sysID string, state string, username string, password string) *ChangeResult {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change/normal/" + sysID

	fmt.Println("PATCH URL=" + URL + " state=" + state)

	changeState := State{
		State: state,
	}

	body, err := json.Marshal(changeState)
	if err != nil {
		panic(err)
	}

	resp, err := HTTPAction("PATCH", URL, body, username, password)
	if err != nil {
		panic(err)
	}

	var resultChange ChangeResult
	err = json.Unmarshal(resp, &resultChange)
	if err != nil {
		panic(err)
	}

	return &resultChange
}

// GetChange GET change by user from ServiceNow
func GetChange(host string, username string, password string) map[string]string {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change?sys_created_by=" + username
	body := []byte(`{
		"short_description": "Get record"
	}`)

	resp, err := HTTPAction("GET", URL, body, username, password)
	if err != nil {
		panic(err)
	}

	return ParseChange(resp)
}

func GetChangeRaw(host string, username string, password string) []byte {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change?sys_created_by=" + username
	body := []byte(`{
		"short_description": "Get record"
	}`)

	resp, err := HTTPAction("GET", URL, body, username, password)
	if err != nil {
		panic(err)
	}

	return resp
}

// DeleteChange DELETE change by sysID from ServiceNow
func DeleteChange(host string, sysID string, username string, password string) {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change/" + sysID
	body := []byte(`{
		"short_description": "Delete record"
	}`)
	HTTPAction("DELETE", URL, body, username, password)
}

// ParseChange parses the JSON response from ServiceNow
func ParseChange(responseBody []byte) map[string]string {

	var data result
	json.Unmarshal(responseBody, &data)
	resultMap := make(map[string]string)

	fmt.Println("number of Changes matching user: ", len(data.Result))
	for _, v := range data.Result {
		if v.Number.DisplayValue == "" {
			continue
		}
		resultMap[v.Number.DisplayValue] = v.SysID.DisplayValue

		fmt.Println("Change: ", v.Number.DisplayValue, " SysID: ", v.SysID.DisplayValue)
	}

	return resultMap
}
