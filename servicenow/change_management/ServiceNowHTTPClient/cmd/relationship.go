package cmd

import (
	"fmt"
	"strings"

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
		fmt.Println("BOOM creating your relationship!!")
		fmt.Println("You're arguments were: [" + strings.Join(args, ",") + "]")
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		fmt.Print("endpoint=", endpoint+
			" username=", username+
			" password=", password+"\n")

	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}
