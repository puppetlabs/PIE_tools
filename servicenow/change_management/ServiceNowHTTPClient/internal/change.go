package internal

import (
	"fmt"

	"github.com/tidwall/gjson"
)

// CreateChanage POST change create to ServiceNow
func CreateChange(host string, username string, password string) string {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change"
	body := []byte(`{
		"short_description": "Reboot server on scheduled interval"
	}`)

	fmt.Println("Post URL=" + URL + " body=" + string(body))

	str := HTTPAction("POST", URL, body, username, password)
	return str
}

func GetChange(host string, username string, password string) string {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change?sys_created_by=" + username
	body := []byte(`{
		"short_description": "Get record"
	}`)	
	str := HTTPAction("GET", URL, body, username, password)
	return str
}


// Post POST data to ServiceNow
func ParseChange(result string) string {
	value := gjson.Get(result, "result.number.display_value")
	fmt.Println("Change Number: " + value.String())

	return value.String()
}
