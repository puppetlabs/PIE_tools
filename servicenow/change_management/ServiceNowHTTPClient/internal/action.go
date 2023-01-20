package internal

import (
	"fmt"
)

// Post POST data to ServiceNow
func Post(host string, username string, password string) string {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change"
	body := []byte(`{
		"short_description": "Reboot server on scheduled interval"
	}`)

	fmt.Println("Post URL=" + URL + " body=" + string(body))

	str := HTTPAction("POST", URL, body, username, password)
	return str
}
