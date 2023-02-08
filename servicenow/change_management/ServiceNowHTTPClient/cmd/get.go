package cmd

import (
	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var getCmd = &cobra.Command{
	Use:   "get",
	Short: "Gets an object from the SN CMDB",
	Long: `Facilitates the execution of actions.

	nodes/change/relationship/ actions are supported.
	Example usage:
	  SNHttpClient get <action>
		`,
	Run: func(cmd *cobra.Command, args []string) {

	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
	rootCmd.AddCommand(getCmd)
	getCmd.AddCommand(nodesCmd)
	getCmd.AddCommand(getChangeCommand)
	getCmd.AddCommand(getAttributeCommand)
}
