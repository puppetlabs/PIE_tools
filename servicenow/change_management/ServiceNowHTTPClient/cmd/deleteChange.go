package cmd

import (
	"fmt"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var deleteChangeCmd = &cobra.Command{
	Use:   "changes",
	Short: "Runs a delete command",
	Long: `Running delete on a user.

	Example usage:
	  SNHttpClient delete changes 
		`,
	Run: func(cmd *cobra.Command, args []string) {
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		fmt.Println("Running delete command... ")
		fmt.Println("endpoint=", endpoint+" username=", username+" password=", password+"\n")
		fmt.Println("************ Hello this is delete cmd running ************")

		changeMap := internal.GetChange(endpoint, username, password)
		for changeName, SysID := range changeMap {
			fmt.Println("Deleting Change = ", changeName, " Sys ID = ", SysID)
			internal.DeleteChange(endpoint, SysID, username, password)
		}

		// filename := args[0]
		// body := internal.GetBody(filename)

		// fmt.Println("Creating Change in SN... with body from file: " + filename)
		// response := internal.CreateChange(endpoint, body, username, password)
		// fmt.Println("Change ID = ", response.Name, " Sys ID=", response.SysID)
		// //Getting sys_id of change

		// //Going to get nodes from SN. Will return map of nodes and their sys_id
		// nodesMap := GetRecord(endpoint, username, password)
		// nodesSlice := make([]string, 0, len(nodesMap))
		// for _, v := range nodesMap {
		// 	nodesSlice = append(nodesSlice, v)
		// }
		// payloadStrNodes := strings.Join(nodesSlice, ",")
		// fmt.Println("payloadStrNodes=", payloadStrNodes)

		// internal.CreateRelationship(endpoint, response.SysID, payloadStrNodes, username, password)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

func init() {
}
