package internal

import (
	"fmt"
)

// Post POST data to ServiceNow
func Post(host string, username string, password string) []byte {
	URL := "https://" + host + "/api/sn_chg_rest/v1/change"
	body := []byte(`{
		"short_description": "Reboot server on scheduled interval"
	}`)

	fmt.Println("Post URL=" + URL + " body=" + string(body))

	resp, err := HTTPAction("POST", URL, body, username, password)
	if err != nil {
		panic(err)
	}

	return resp
}
