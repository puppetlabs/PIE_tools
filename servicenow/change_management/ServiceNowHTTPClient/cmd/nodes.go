package cmd

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/spf13/cobra"
	"io/ioutil"
	"log"
	"net/http"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var nodesCmd = &cobra.Command{
	Use:   "nodes",
	Short: "Gets a Node object from the SN CMDB",
	Long: `Get the nodes from the SN CMDB computer table.

	Example usage:
	  SNHttpClient get nodes <endpoint> <username> <password>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Sending Get request")
		endpoint, _ := cmd.Flags().GetString("endpoint")
		fmt.Println("Endpoint: " + endpoint)
		username, _ := cmd.Flags().GetString("username")
		fmt.Println("Username: " + username)
		password, _ := cmd.Flags().GetString("password")
		fmt.Println("Password: " + password)
		fmt.Println(GetRecord(endpoint, username, password))
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}

type Result struct {
	Result []struct {
		Certname string `json:"fqdn"`
		SysID    string `json:"sys_id"`
	} `json:"result"`
}

func GetRecord(endpoint string, username string, password string) map[string]string {
	client := &http.Client{}
	body := []byte(`{
	"short_description": "Get record"
}`)
	req, err := http.NewRequest("GET", endpoint, bytes.NewBuffer(body))
	if err != nil {
		log.Fatal(err)
	}
	req.SetBasicAuth(username, password)
	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	bodyText, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	var data Result
	json.Unmarshal([]byte(bodyText), &data)
	resultMap := make(map[string]string)
	for _, v := range data.Result {
		resultMap[string(v.Certname)] = string(v.SysID)
		fmt.Printf("Certname: %s, SysID: %s\n", v.Certname, v.SysID)
	}
	return resultMap
}
