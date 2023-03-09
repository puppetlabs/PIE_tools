package cmd

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

// initCmd is a subcommand to StoreCmd that ads a Benchmark to the store.
var createCmd = &cobra.Command{
	Use:   "create",
	Short: "Creates a new object in the SN CMDB",
	Long: `Facilitates the execution of actions.

	change/relationship/actions are supported.
	Example usage:
	  SNHttpClient create <change|relationship>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("You're arguments were: " + strings.Join(args, ","))

	},

	Args: func(cmd *cobra.Command, args []string) error {
		fmt.Println("error: Must use update with subcommand change or relationship")

		return nil
	},
}

func init() {
	rootCmd.AddCommand(createCmd)
	createCmd.AddCommand(changeCmd)
	createCmd.AddCommand(relationshipCmd)
}
