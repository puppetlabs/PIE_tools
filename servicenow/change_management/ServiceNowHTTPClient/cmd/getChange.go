package cmd

import (
	"fmt"
	"strings"
	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
)

//getChangeCommand gets all changes from CMDB by user
var getChangeCommand = &cobra.Command{
	Use:   "change",
	Short: "Gets a Change object from the SN CMDB by user",
	Long: `Gets a Change object from the SN CMDB by user'

	Example usage:
	  SNHttpClient get change -e <endpoint>  -u <username> -p <password>
		`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("You're arguments were: [" + strings.Join(args, ",") + "]")
		endpoint, _ := cmd.Flags().GetString("endpoint")
		fmt.Println("Endpoint: " + endpoint)
		username, _ := cmd.Flags().GetString("username")
		fmt.Println("Username: " + username)
		password, _ := cmd.Flags().GetString("password")
		fmt.Println("Password: " + password)

		str := internal.GetChange(endpoint, username, password)
		result := internal.ParseChange(str)
		fmt.Println(result)

	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}


func init() {

}
