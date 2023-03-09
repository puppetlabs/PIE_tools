package cmd

import (
	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var getCmd = &cobra.Command{
	Use:   "get",
	Short: "Gets objects from the SN CMDB",
	Long: `Gets objects from SN'

	nodes/change/attributes subcommands are supported.
	Example usage:
	  SNHttpClient get <nodes|change|attributes>
		`,
	Run: func(cmd *cobra.Command, args []string) {

	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

func init() {
	rootCmd.AddCommand(getCmd)
	getCmd.AddCommand(nodesCmd)
	getCmd.AddCommand(getChangeCommand)
	getCmd.AddCommand(getAttributeCommand)
}
