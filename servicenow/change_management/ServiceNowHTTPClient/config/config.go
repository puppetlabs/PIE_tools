package config

// Config is the configuration for the application
type Config struct {
	Servicenow struct {
		Endpoint string
		Username string
		Password string
		Logging  struct {
			ToFile   bool
			Filename string
		}
	}
	PE struct {
		Username string
		Password string
		Endpoint string
	}
}
