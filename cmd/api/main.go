package main

import (
	"log"
	"os"
	"time"
	"context"
	"github.com/gofiber/fiber/v2"
	"github.com/joho/godotenv"
	"github.com/LarryDaLobsta/faker2/internal/db"
)

func main() {
	_ = godotenv.Load()

	pool, err := db.NewPool()
	
	if err!= nil {
		log.Fatalf("failed to create db pool: %v", err)
	}
	defer pool.Close()
	
	app := fiber.New()
	//app health check
	app.Get("/health", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{"ok": true})
	})

	//database health check
	app.Get("/db/health", func(c *fiber.Ctx) error {
		ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()

		if err := pool.Ping(ctx); err != nil {
			return c.Status(500).JSON(fiber.Map{"ok": false, "error": err.Error()})
		}
		return c.JSON(fiber.Map{"ok": true})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("listening on :%s", port)
	log.Fatal(app.Listen(":" + port))
}