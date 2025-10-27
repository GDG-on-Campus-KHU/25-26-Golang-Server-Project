package db

import (
	"context"

	"bubble/internal/db/ent"
	"bubble/pkg/config"
	"bubble/pkg/logger"
)

func InitEnt(cfg *config.Config, log *logger.Logger) *ent.Client {
	client, err := ent.Open("sqlite3", "file:ent.db?_fk=1")
	if err != nil {
		log.Fatal("failed opening connection to sqlite: ", err)
	}

	if err := client.Schema.Create(context.Background()); err != nil {
		log.Fatal("failed creating schema resources: ", err)
	}

	return client
}
