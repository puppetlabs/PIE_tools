package cmd

import (
	"fmt"
	"os"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
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

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}
