package cmd

import (
	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var runCmd = &cobra.Command{
	Use:   "run",
	Short: "Run a demo",
	Long: `Runs a demo command that will do a simple compliance sequence.

	Example usage:
	  SNHttpClient run demo
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
