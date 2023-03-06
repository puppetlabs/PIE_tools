package internal

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

type Token struct {
	Token string `json:"token"`
}

// GetToken gets a token from ServiceNow
func GetToken(host string, username string, password string) string {
	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}

	URL := "https://" + host + ":4433/rbac-api/v1/auth/token"
	body := []byte("{\"login\":\"" + username + "\",\"password\":\"" + password + "\"}")
	client := &http.Client{}

	req, err := http.NewRequest("POST", URL, bytes.NewBuffer(body))
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
	bodyText, err := ioutil.ReadAll(resp.Body)

	var data Token
	err = json.Unmarshal([]byte(bodyText), &data)

	if err != nil {
		fmt.Println(err)
		panic(err)
	}

	return data.Token
}
