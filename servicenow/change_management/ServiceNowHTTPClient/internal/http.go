package internal

import (
	"bytes"
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/spf13/viper"
)

// HTTPAction REST Action to ServiceNow
func HTTPAction(operation string, URL string, body []byte, username string, password string) string {
	client := &http.Client{}

	req, err := http.NewRequest(operation, URL, bytes.NewBuffer(body))
	req.SetBasicAuth(username, password)
	fmt.Println("req:", req)
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
	LogActions := viper.GetBool("Logging.ToFile")
	if LogActions == false {
		return
	}

	LogFileName := viper.GetString("Logging.Filename")
	if LogActions == true && LogFileName == "" {
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
