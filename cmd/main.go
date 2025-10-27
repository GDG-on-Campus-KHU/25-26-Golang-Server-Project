package main

import (
	"bubble/internal/app"

	_ "github.com/mattn/go-sqlite3"
)

func main() {
	app.Run()
}
