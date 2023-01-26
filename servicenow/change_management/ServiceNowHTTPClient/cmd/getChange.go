package cmd

import (
	"fmt"
	"strings"

	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

//getChangeCommand gets all changes from CMDB by user
var getChangeCommand = &cobra.Command{
	Use:   "change",
	Short: "Gets a Change object from the SN CMDB by user",
	Long: `Gets a Change object from the SN CMDB by user'

	Example usage:
	  SNHttpClient get change <user>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("You're arguments were: [" + strings.Join(args, ",") + "]")
		endpoint := viper.GetString("endpoint")
		username := viper.GetString("username")
		password := viper.GetString("password")

		fmt.Print("endpoint=", endpoint+
			" username=", username+
			" password=", password+"\n")

		internal.GetChange(endpoint, username, password)
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

func init() {

}
