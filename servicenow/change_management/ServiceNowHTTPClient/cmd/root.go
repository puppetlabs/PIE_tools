package cmd

import (
	"fmt"
	"os"

	"github.com/puppetlabs/SNHttpClient/config"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var cfgFile string

// rootCmd represents the base command when called without any subcommands.
var rootCmd = &cobra.Command{
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
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	configFile := ".cobra.yaml"
	viper.SetConfigType("yaml")
	viper.SetConfigFile(configFile)

	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using configuration file: ", viper.ConfigFileUsed())
	}

	viper.AutomaticEnv()

	var configuration config.Config

	if err := viper.ReadInConfig(); err != nil {
		fmt.Printf("Error reading config file, %s", err)
	}

	err := viper.Unmarshal(&configuration)
	if err != nil {
		fmt.Printf("Unable to decode into struct, %v", err)
	}

}

// initConfig reads in config file and ENV variables if set.
func initConfig() {

	// Search config in home directory with name ".cobra" (without extension).
	viper.AddConfigPath(".")
	viper.SetConfigName(".cobra.yaml")

	if err := viper.ReadInConfig(); err != nil {
		fmt.Println("Can't read config:", err)
		os.Exit(1)
	}
}

// HandleError is a helper function to handle errors
func HandleError(e error) {
	if e != nil {
		fmt.Println(e)
	}
}
