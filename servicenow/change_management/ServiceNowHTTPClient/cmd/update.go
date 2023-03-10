package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// updateCmd represents the update command
var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "Updates a Change Request objects in the SN CMDB",
	Long: `Updates a change request in SN.

	Example usage:
	  SNHttpClient update change
		`,
	Run: func(cmd *cobra.Command, args []string) {

	},

	Args: func(cmd *cobra.Command, args []string) error {
		fmt.Println("error: Must use update with subcommand change")

		return nil
	},
}

func init() {
	rootCmd.AddCommand(updateCmd)
	updateCmd.AddCommand(updateChangeCmd)
	updateCmd.PersistentFlags().StringP("sys_id", "i", "", "Change Request sys_id")
	updateCmd.MarkPersistentFlagRequired("sys_id")
	updateCmd.PersistentFlags().StringP("state", "s", "", "Change Request state")
	updateCmd.MarkPersistentFlagRequired("state")
	updateCmd.MarkFlagsRequiredTogether("sys_id", "state")
}
