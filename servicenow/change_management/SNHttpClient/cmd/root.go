package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var cfgFile string

// RootCmd represents the base command when called without any subcommands.
var RootCmd = &cobra.Command{
	Use:   "SNHttpClient",
	Short: "A utility for sending HTTP requests to the SN API",
	Long: `A utility for sending HTTP requests to the SN API.
  `,
	// this is what is run if no subcommand or arguments have been given
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("No input was given. See help below:")
		cmd.HelpFunc()(cmd, args)
	},
	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := RootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	// // Cobra also supports local flags, which will only run
	// // when this action is called directly.
	// RootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")

	// support persisted flags - global for this application and allow giving config file as option
	RootCmd.PersistentFlags().StringP("endpoint", "e", "", "FQDN of the SN instance")
	RootCmd.MarkPersistentFlagRequired("endpoint")
	RootCmd.PersistentFlags().StringP("username", "u", "", "Username for the SN instance")
	RootCmd.MarkPersistentFlagRequired("username")
	RootCmd.PersistentFlags().StringP("password", "p", "", "Password for the SN instance")
	RootCmd.MarkPersistentFlagRequired("password")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
}
