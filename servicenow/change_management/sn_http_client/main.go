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

func DeleteRecord() string{
    URL := "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change/"
    client := &http.Client{}
    body := []byte(`{
		"short_description": "Delete this record"
	}`)

    req, err := http.NewRequest("DELETE", URL, bytes.NewBuffer(body))
    req.SetBasicAuth("greg.hardy", "gs1NUhQgIb7S")
    resp, err := client.Do(req)
    if err != nil {
        fmt.Println(err)
    }
    bodyText, err := ioutil.ReadAll(resp.Body)
    x := string(bodyText)
    return x
}

func UpdateRecord() string {
    URL := "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change"
    client := &http.Client{}    
    body := []byte(`{
		"short_description": "Update current record"
	}`)
    req, err := http.NewRequest("UPDATE", URL, bytes.NewBuffer(body))
    req.SetBasicAuth("greg.hardy", "gs1NUhQgIb7S")
    resp, err := client.Do(req)
    if err != nil {
        fmt.Println(err)
    }
    bodyText, err := ioutil.ReadAll(resp.Body)
    x := string(bodyText)
    return x
}


func GetRecord() string{
    URL := "https://puppetdev.service-now.com/api/sn_chg_rest/v1/change"
    client := &http.Client{}    
    body := []byte(`{
		"short_description": "Get record"
	}`)
    req, err := http.NewRequest("GET", URL, bytes.NewBuffer(body))
    req.SetBasicAuth("greg.hardy", "gs1NUhQgIb7S")
    resp, err := client.Do(req)
    if err != nil {
        fmt.Println(err)
    }
    bodyText, err := ioutil.ReadAll(resp.Body)
    x := string(bodyText)
    return x
}

func main() {
       post := PostData() 
       fmt.Println(post)

       delete := DeleteRecord()
       fmt.Println(delete)

       update := UpdateRecord()
       fmt.Println(update)

       get := GetRecord()
       fmt.Println(get)
}

