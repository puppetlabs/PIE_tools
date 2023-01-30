package cmd

import (
	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var runCmd = &cobra.Command{
	Use:   "run",
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

//var runCmd = &cobra.Command{fmt.Println("This is run running")}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
	rootCmd.AddCommand(runCmd)
	runCmd.AddCommand(demoCmd)
}
