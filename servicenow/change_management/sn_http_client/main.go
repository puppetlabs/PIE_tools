package main

import "fmt"
import "net/http"
import "bytes"
import "io/ioutil"

func PostData() string {
    URL := "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change"
    client := &http.Client{}    
    body := []byte(`{
		"short_description": "Reboot server on scheduled interval"
	}`)
    req, err := http.NewRequest("POST", URL, bytes.NewBuffer(body))
    req.SetBasicAuth("greg.hardy", "gs1NUhQgIb7S")
    resp, err := client.Do(req)
    if err != nil {
        fmt.Println(err)
    }
    bodyText, err := ioutil.ReadAll(resp.Body)
    s := string(bodyText)
    return s
}


func main() {
       str := PostData() 
       fmt.Println(str)
}

