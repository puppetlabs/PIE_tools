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
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		if len(args) < 1 {
			fmt.Println("Error: No body filepath specified as an argument")
			fmt.Println("Usage: SNHttpClient create change <filepath to body>")
			os.Exit(1)
		}

		filename := args[0]
		body := internal.GetBody(filename)

		fmt.Println("Creating Change in SN... with body from file: " + filename)
		response := internal.CreateChange(endpoint, body, username, password)
		fmt.Println("created change ID = ", response.Name, " sys_id =", response.SysID)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// deleteChangeCommand deletes changes from SN
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

// getChangeCommand gets changes from SN
var getChangeCommand = &cobra.Command{
	Use:   "change",
	Short: "Gets a Change object from the SN CMDB by user",
	Long: `Gets a Change object from the SN CMDB by user'

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

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}
