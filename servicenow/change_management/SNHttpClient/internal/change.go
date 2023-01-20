package internal

import (
	"fmt"

	"github.com/tidwall/gjson"
)

// Post POST data to ServiceNow
func ParseChange(result string) string {
	value := gjson.Get(result, "result.number.display_value")
	fmt.Println("Change Number: " + value.String())

	return value.String()
}
