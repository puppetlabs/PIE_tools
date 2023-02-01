package config

// Config is the configuration for the application
type Config struct {
	Endpoint    string
	Username    string
	Password    string
	LogActions  bool
	LogFileName string
}
