package config

// Config is the configuration for the application
type Config struct {
	Endpoint string
	Username string
	Password string
	Logging  struct {
		ToFile   bool
		Filename string
	}
	PE struct {
		Endpoint string
		Token    string
	}
}
