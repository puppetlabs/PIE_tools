package internal

import (
	"fmt"
)

type Result struct {
	Result []struct {
		Number struct {
			DisplayValue string `json:"display_value"`
		}
	}
}

func GetActivity(host string, token string) {
	URL := "https://" + host + ":4433/activity-api/v1/events?service_id=orchestrator&limit=100"
	body := []byte(`{
		"short_description": "Get record"
	}`)
	str := HTTPTokenBasedAction("GET", URL, body, token)
	fmt.Println("GetActivity: ", str)
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
