package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
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
		fmt.Println("BOOM getting nodes!!")
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
	// nodesCmd.PersistentFlags().StringP("endpoint", "e", "", "FQDN of the SN instance")
	// nodesCmd.MarkPersistentFlagRequired("endpoint")
	// nodesCmd.PersistentFlags().StringP("username", "u", "", "Username for the SN instance")
	// nodesCmd.MarkPersistentFlagRequired("username")
	// nodesCmd.PersistentFlags().StringP("password", "p", "", "Password for the SN instance")
	// nodesCmd.MarkPersistentFlagRequired("password")
}
