package cmd

import (
	"fmt"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var watchCmd = &cobra.Command{
	Use:   "watch",
	Short: "short watch",
	Long:  `long watch.`,

	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("This is watch running")

		endpoint := viper.GetString("PE.endpoint")
		// token := viper.GetString("PE.token")

		//internal.GetActivity(endpoint, token)
		str := internal.GetToken(endpoint, viper.GetString("username"), viper.GetString("password"))
		fmt.Println("token = ", str)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

func init() {
	rootCmd.AddCommand(watchCmd)

}
