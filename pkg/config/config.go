package config

import (
	"log"
	"os"
)

type Config struct {
	GRPCPort string
	DBPath   string
}

func Load() *Config {
	port := os.Getenv("GRPC_PORT")
	if port == "" {
		port = ":19001" // 기본 포트
	}

	dbPath := os.Getenv("DB_PATH")
	if dbPath == "" {
		dbPath = "file:ent.db?_fk=1" // SQLite 기본값
	}

	log.Printf("[config] loaded: port=%s, db=%s", port, dbPath)

	return &Config{
		GRPCPort: port,
		DBPath:   dbPath,
	}
}
