package internal

import (
	"fmt"
	"io/ioutil"
	"os"
)

// GetBody reads a file and returns the contents as a byte array
func GetBody(filename string) []byte {
	contents, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Println("Error opening file: ", err, " filename: ", filename)
		os.Exit(1)
	}

	body := []byte(contents)
	return body
}
