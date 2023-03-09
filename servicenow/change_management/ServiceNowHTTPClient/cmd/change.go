package cmd

import (
	"fmt"
	"os"
	"strings"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// changeCmd creates a change in SN
var changeCmd = &cobra.Command{
	Use:   "change",
	Short: "Creates a Change Request object in the SN CMDB",
	Long: `Creates a change request in SN.

	Example usage:
	  SNHttpClient create change <filepath to body>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		endpoint := viper.GetString("servicenow.endpoint")
		username := viper.GetString("servicenow.username")
		password := viper.GetString("servicenow.password")

		if len(args) < 1 {
			fmt.Println("Error: No body filepath specified as an argument")
			fmt.Println("Usage: SNHttpClient create change <filepath to body>")
			os.Exit(1)
		}

		filename := args[0]
		body := internal.GetBody(filename)

		fmt.Println("Creating Change in SN... with body from file: " + filename)
		response := internal.CreateChange(endpoint, body, username, password)

		name := response.Result.Number.DisplayValue
		sysid := response.Result.SysID.DisplayValue

		change := fmt.Sprintf("ChangeID: %s, SysID: %s", name, sysid)

		fmt.Println(change)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// getChangeCommand gets changes from SN
var getChangeCommand = &cobra.Command{
	Use:   "change",
	Short: "Gets all Change Request objects from the SN CMDB by user",
	Long: `Gets all change request object from SN by user'

	Example usage:
	  SNHttpClient get change <user>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Your arguments were: [" + strings.Join(args, ",") + "]")
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		fmt.Print("endpoint=", endpoint+
			" username=", username+
			" password=", password+"\n")

		internal.GetChange(endpoint, username, password)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// updateChangeCmd updates a change in SN
var updateChangeCmd = &cobra.Command{
	Use:   "change",
	Short: "Updates a Change Request object in the SN CMDB",
	Long: `Updates a change request in SN.

	Example usage:
	  SNHttpClient update change --sys_id <9d385017c611228701d22104cc95c371> --state <assess>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")
		sys_id, _ := cmd.Flags().GetString("sys_id")
		state, _ := cmd.Flags().GetString("state")

		//
		// Process changes in bulk. This still needs a way to grab changes with a valid state before updating.
		//
		// changeMap := internal.GetChange(endpoint, username, password)
		// for _, sys_id := range changeMap {
		//   response := internal.UpdateChange(endpoint, sys_id, state, username, password)
		//   name := response.Result.Number.DisplayValue
		//   sysid := response.Result.SysID.DisplayValue
		//   up_state := response.Result.State.DisplayValue
		//
		//   change := fmt.Sprintf("ChangeID: %s, SysID: %s, State: %s", name, sysid, up_state)
		//   fmt.Println(change)
		// }
		//

		response := internal.UpdateChange(endpoint, sys_id, state, username, password)

		name := response.Result.Number.DisplayValue
		sysid := response.Result.SysID.DisplayValue
		up_state := response.Result.State.DisplayValue

		change := fmt.Sprintf("ChangeID: %s, SysID: %s, State: %s", name, sysid, up_state)
		fmt.Println(change)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// deleteChangeCommand deletes changes from SN
var deleteChangeCmd = &cobra.Command{
	Use:   "changes",
	Short: "Deletes Change Request objects in the SN CMDB",
	Long: `Deletes change requests in SN.

	Example usage:
	  SNHttpClient delete changes 
		`,
	Run: func(cmd *cobra.Command, args []string) {
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		fmt.Println("Running delete command... ")
		fmt.Println("endpoint=", endpoint+" username=", username+" password=", password+"\n")

		changeMap := internal.GetChange(endpoint, username, password)
		for changeName, SysID := range changeMap {
			fmt.Println("Deleting Change = ", changeName, " Sys ID = ", SysID)
			internal.DeleteChange(endpoint, SysID, username, password)
		}

	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

func init() {
}
