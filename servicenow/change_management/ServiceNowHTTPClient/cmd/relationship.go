package cmd

import (
	"fmt"
	"strings"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
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
		fmt.Println("Your arguments were: [" + strings.Join(args, ",") + "]")
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		if len(args) < 2 {
			fmt.Println("You must provide a changeID and node Node SysID")
			fmt.Println("Example: SNHttpClient create relationship 1234567890abcdef1234567890abcdef 1234567890abcdef1234567890abcdef")
			return
		}

		changeSysID := args[0]
		nodeSysID := args[1]

		fmt.Print("endpoint=", endpoint+
			" username=", username+
			" password=", password+"\n")

		internal.CreateRelationship(endpoint, changeSysID, nodeSysID, username, password)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}
