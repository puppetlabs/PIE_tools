package internal

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/spf13/viper"
)

// HTTPAction REST Action to ServiceNow
func HTTPAction(operation string, URL string, body []byte, username string, password string) ([]byte, error) {
	client := &http.Client{}

	req, err := http.NewRequest(operation, URL, bytes.NewBuffer(body))
	if err != nil {
		fmt.Println(err)
		panic(err)
	}

	req.SetBasicAuth(username, password)
	fmt.Println("req:", req)

	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}

	resp_body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}

	if resp.StatusCode != 200 {
		var errorChange ChangeError
		err = json.Unmarshal(resp_body, &errorChange)
		if err != nil {
			fmt.Println(err)
			panic(err)
		}
		return nil, fmt.Errorf("error: %s", errorChange.Error.Message)
	}

	writeActionToFile(operation, URL, body)

	return resp_body, nil
}

// HTTPTokenBasedAction REST Action to ServiceNow
func HTTPTokenBasedAction(operation string, URL string, body []byte, token string) string {
	client := &http.Client{}
	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}
	req, err := http.NewRequest(operation, URL, bytes.NewBuffer(body))
	// req.Header.Set("Authorization", "Bearer: "+token)
	req.Header.Set("X-Authentication", token)
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
	bodyText, err := ioutil.ReadAll(resp.Body)
	s := string(bodyText)
	writeActionToFile(operation, URL, body)
	return s
}

// writeActionToFile writes changes to json file
func writeActionToFile(operation string, URL string, body []byte) {
	LogActions := viper.GetBool("Servicenow.Logging.ToFile")
	LogFileName := viper.GetString("Servicenow.Logging.Filename")

	if !LogActions {
		return
	} else if LogFileName == "" && LogActions {
		panic("LogFileName not set")
	}

	s := operation + " " + URL + "\n" + string(body) + "\n------------------\n"
	f, err := os.OpenFile(LogFileName, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0600)

	if err != nil {
		panic(err)
	}

	defer f.Close()

	if _, err = f.WriteString(s); err != nil {
		panic(err)
	}

}
