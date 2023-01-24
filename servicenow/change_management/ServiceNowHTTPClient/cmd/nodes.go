package cmd

import (
	"encoding/json"
	"fmt"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
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
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		GetRecord(endpoint, username, password)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}

// Result is the struct for the JSON response from the SN CMDB
type Result struct {
	Result []struct {
		Certname string `json:"fqdn"`
		SysID    string `json:"sys_id"`
	} `json:"result"`
}

// GetRecord gets a record from the SN CMDB
func GetRecord(endpoint string, username string, password string) map[string]string {
	body := []byte(`{
		"short_description": "Get record"
	}`)

	URL := "https://" + endpoint + "/api/now/table/cmdb_ci_computer?sysparm_query=active=true&sysparm_fields=fqdn,sys_id"

	result := internal.HTTPAction("GET", URL, body, username, password)

	var data Result
	json.Unmarshal([]byte(result), &data)
	resultMap := make(map[string]string)
	for _, v := range data.Result {
		resultMap[string(v.Certname)] = string(v.SysID)
		fmt.Printf("Certname: %s, SysID: %s\n", v.Certname, v.SysID)
	}
	return resultMap
}
