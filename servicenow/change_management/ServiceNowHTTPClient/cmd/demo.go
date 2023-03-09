package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var demoCmd = &cobra.Command{
	Use:   "demo",
	Short: "Runs a demo command",
	Long: `Runs a demo command that will do a simple compliance sequence.

	Example usage:
	  SNHttpClient run demo
		`,
	Run: func(cmd *cobra.Command, args []string) {
		endpoint := viper.GetString("servicenow.endpoint")
		username := viper.GetString("servicenow.username")
		password := viper.GetString("servicenow.password")

		fmt.Println("Running demo command... ")
		fmt.Println("endpoint=", endpoint+" username=", username+" password=", password+"\n")
		fmt.Println("************ Hello this is demo cmd running ************")

		if len(args) < 1 {
			fmt.Println("Error: No body filepath specified as an argument")
			fmt.Println("Usage: SNHttpClient run demo <filepath to body>")
			os.Exit(1)
		}

		filename := args[0]
		body := internal.GetBody(filename)

		fmt.Println("Creating Change in SN... with body from file: " + filename)
		response := internal.CreateChange(endpoint, body, username, password)

		//Getting sys_id of change

		//Going to get nodes from SN. Will return map of nodes and their sys_id
		nodesMap := GetRecord(endpoint, username, password)
		nodesSlice := make([]string, 0, len(nodesMap))
		for _, v := range nodesMap {
			nodesSlice = append(nodesSlice, v)
		}
		payloadStrNodes := strings.Join(nodesSlice, ",")
		fmt.Println("payloadStrNodes=", payloadStrNodes)

		internal.CreateRelationship(endpoint, response.Result.SysID.DisplayValue, payloadStrNodes, username, password)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

//var demoCmd = &cobra.Command{fmt.Println("Hello this is demo running")}

func init() {
}
