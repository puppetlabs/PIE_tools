package cmd

import (
	"github.com/spf13/cobra"
)

// deleteCmd runs a delete action
var deleteCmd = &cobra.Command{
	Use:   "delete",
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

func init() {
	rootCmd.AddCommand(deleteCmd)
	deleteCmd.AddCommand(deleteChangeCmd)
}
