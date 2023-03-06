package cmd

import (
	"fmt"
	"strings"

	"github.com/antonholmquist/jason"
	"github.com/puppetlabs/SNHttpClient/internal"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// getChangeCommand gets changes from SN
var getAttributeCommand = &cobra.Command{
	Use:   "attributes",
	Short: "Gets all attributes for SN change management",
	Long: `Gets all attributes for SN change management'

	Example usage:
	  SNHttpClient get attributes
		`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Your arguments were: [" + strings.Join(args, ",") + "]")
		endpoint := viper.GetString("servicenow.endpoint")
		username := viper.GetString("servicenow.username")
		password := viper.GetString("servicenow.password")

		fmt.Print("endpoint=", endpoint+
			" username=", username+
			" password=", password+"\n")

		str := internal.GetChangeRaw(endpoint, username, password)
		var j = []byte(str)
		v, err := jason.NewObjectFromBytes(j)

		if err != nil {
			panic(err)
		}

		result, err := v.GetObjectArray("result")

		if err != nil {
			panic(err)
		}

		for _, v := range result {
			fmt.Println("Attributes: ")

			myMap := v.Map()

			for k, _ := range myMap {
				fmt.Println(k)
			}

			break
		}
	},

	Args: func(cmd *cobra.Command, args []string) error {
		return nil
	},
}

// ScannerVersion is the version of the scanner associated with the benchmark.

func init() {
}
