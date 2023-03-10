package cmd

import (
	"github.com/spf13/cobra"
)

// deleteCmd runs a delete action
var deleteCmd = &cobra.Command{
	Use:   "delete",
	Short: "Deletes Change Request objects in the SN CMDB",
	Long: `Deletes change requests in SN.
  

	Example usage:
	  SNHttpClient delete changes
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
