package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var relationshipCmd = &cobra.Command{
	Use:   "relationship",
	Short: "Creates a Relationship Request object in the SN CMDB",
	Long: `Creates a Relationship request in SN.

	Example usage:
	  SNHttpClient create relationship <endpoint> <username> <password>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("BOOM creating your relationship!!")
		fmt.Println("You're arguments were: [" + strings.Join(args, ",") + "]")
		endpoint, _ := cmd.Flags().GetString("endpoint")
		fmt.Println("Endpoint: " + endpoint)
		username, _ := cmd.Flags().GetString("username")
		fmt.Println("Username: " + username)
		password, _ := cmd.Flags().GetString("password")
		fmt.Println("Password: " + password)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}
