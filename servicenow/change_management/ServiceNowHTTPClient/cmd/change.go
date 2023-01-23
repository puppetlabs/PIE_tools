package cmd

import (
	"fmt"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var changeCmd = &cobra.Command{
	Use:   "change",
	Short: "Creates a Change Request object in the SN CMDB",
	Long: `Creates a change request in SN.

	Example usage:
	  SNHttpClient create change <endpoint> <username> <password>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		endpoint, _ := cmd.Flags().GetString("endpoint")
		username, _ := cmd.Flags().GetString("username")
		password, _ := cmd.Flags().GetString("password")

		fmt.Println("Creating Change in SN... ")
		response := internal.CreateChange(endpoint, username, password)
		internal.ParseChange(response)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}
