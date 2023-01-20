package internal

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
)

// HTTPAction REST Action to ServiceNow
func HTTPAction(operation string, URL string, body []byte, username string, password string) string {
	client := &http.Client{}

	req, err := http.NewRequest(operation, URL, bytes.NewBuffer(body))
	req.SetBasicAuth(username, password)
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
	}
	bodyText, err := ioutil.ReadAll(resp.Body)
	s := string(bodyText)
	return s
}
