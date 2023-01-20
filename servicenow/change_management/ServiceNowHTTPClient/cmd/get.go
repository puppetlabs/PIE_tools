package cmd

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var getCmd = &cobra.Command{
	Use:   "get",
	Short: "Gets an object from the SN CMDB",
	Long: `Facilitates the execution of actions.

	nodes/change/relationship/ actions are supported.
	Example usage:
	  SNHttpClient get <action>
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
	RootCmd.AddCommand(getCmd)
	getCmd.AddCommand(nodesCmd)
}

func GetRecord(endpoint string, username string, password string) string {
	client := &http.Client{}
	body := []byte(`{
	"short_description": "Get record"
}`)
	req, err := http.NewRequest("GET", endpoint, bytes.NewBuffer(body))
	req.SetBasicAuth(username, password)
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
	}
	bodyText, err := ioutil.ReadAll(resp.Body)
	x := string(bodyText)
	return x
}
