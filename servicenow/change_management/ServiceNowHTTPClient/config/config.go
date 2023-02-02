package config

// Config is the configuration for the application
type Config struct {
	Endpoint string
	Username string
	Password string
	Loggingn struct {
		ToFile   bool
		Filename string
	}
}
