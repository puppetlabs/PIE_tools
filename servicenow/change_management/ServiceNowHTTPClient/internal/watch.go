package internal

import (
	"encoding/json"
	"fmt"
	"time"
)

type Result struct {
	Commits []struct {
		Events []struct {
			Message string `json:"message"`
		}
	}
	TotalRows int `json:"total-rows"`
}

// GetActivity gets a list of changes from ServiceNow
func GetActivity(host string, username string, password string, limit string) {

	token := GetToken(host, username, password)

	// service := "classifier"
	// service := "rbac"
	// service := "orchestrator"
	service := "pe-console"

	URL := "https://" + host + ":4433/activity-api/v1/events?service_id=" + service + "&limit=" + limit
	body := []byte(`{
			"short_description": "Get record"
		}`)

	prevTotalRows := 0
	var response string
	for {
		response = HTTPTokenBasedAction("GET", URL, body, token)
		var Result Result
		json.Unmarshal([]byte(response), &Result)
		if Result.TotalRows == prevTotalRows {
			continue
		}
		prevTotalRows = Result.TotalRows
		for _, v := range Result.Commits {
			fmt.Println("Change: ", v.Events[0].Message)
		}
		time.Sleep(time.Second * 2)
	}

}

// func ParseActivity(responseBody string) map[string]string {

// 	var data result
// 	json.Unmarshal([]byte(responseBody), &data)
// 	resultMap := make(map[string]string)

// 	fmt.Println("number of Changes matching user: ", len(data.Result))
// 	for _, v := range data.Result {
// 		if v.Number.DisplayValue == "" {
// 			continue
// 		}
// 		resultMap[v.Number.DisplayValue] = v.SysID.DisplayValue

// 		fmt.Println("Change: ", v.Number.DisplayValue, " SysID: ", v.SysID.DisplayValue)
// 	}

// 	return resultMap
// }
