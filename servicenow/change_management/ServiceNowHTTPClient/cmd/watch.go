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

		limit := "10"
		if len(args) == 1 {
			limit = args[0]
			fmt.Println("Limit reset to: " + limit)
		}

		endpoint := viper.GetString("PE.endpoint")
		login := viper.GetString("PE.username")
		password := viper.GetString("PE.password")

		fmt.Print("endpoint=", endpoint+" login=", login+" password=", password+"\n")

		internal.GetActivity(endpoint, login, password, limit)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

func init() {
	rootCmd.AddCommand(watchCmd)

}
