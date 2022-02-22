package main

import (
	"database/sql"
	"fmt"
	"log"
	"math/rand"
	"os"
	"strconv"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/gofiber/fiber/v2"
)

type SpeedTestResult struct {
	PhoneID       string
	TestID        string
	DownloadSpeed int
	UploadSpeed   int
	Latency       int
	Jitter        int
	PacketLoss    int
}

var db *sql.DB

func main() {
	if os.Getenv("PORT") == "" {
		os.Setenv("PORT", "8080")
	}

	// Capture connection properties.
	cfg := mysql.Config{
		User:   os.Getenv("DBUSER"),
		Passwd: os.Getenv("DBPASS"),
		Net:    "tcp",
		Addr:   "127.0.0.1:3306",
		DBName: "PAgCASABroadband",
	}
	log.Printf("MySQL User: %s", cfg.User)

	// Get a database handle.
	var err error
	db, err = sql.Open("mysql", cfg.FormatDSN())
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	fmt.Println("Connected to Database!")

	app := createApp()

	app.Listen(":" + os.Getenv("PORT")) // listen on port 8080 by default
}

func createApp() *fiber.App {
	app := fiber.New()

	// a quick status check to make sure everything is working, will also check DB connection later on
	app.Get("/status", func(c *fiber.Ctx) error {
		c.Response().AppendBodyString("OK")
		return c.SendStatus(200)
	})

	api := app.Group("/api/v0")

	api.Post("/submitSpeedTest", submitSpeedTest)

	return app
}

//TODO match incoming data with what will actually be submitted by the frontend
// where speed tests are submitted
func submitSpeedTest(c *fiber.Ctx) error {
	type SpeedTestResultOriginal struct {
		AndroidID     string `json:"androidID"`
		IphoneXSID    string `json:"iphoneXSID"`
		IphoneID      string `json:"iphoneID"`
		PhoneID       string `json:"phoneID"`
		TestID        string `json:"testID"`
		DownloadSpeed string `json:"downloadSpeed"`
		UploadSpeed   string `json:"uploadSpeed"`
		Latency       string `json:"latency"`
		Jitter        string `json:"jitter"`
		PacketLoss    string `json:"packetLoss"`
	}

	o := new(SpeedTestResultOriginal)
	if err := c.BodyParser(o); err != nil {
		return err
	}
	var r SpeedTestResult
	do, _ := strconv.Atoi(o.DownloadSpeed)
	up, _ := strconv.Atoi(o.UploadSpeed)
	la, _ := strconv.Atoi(o.Latency)
	ji, _ := strconv.Atoi(o.Jitter)
	pa, _ := strconv.Atoi(o.PacketLoss)

	r.PhoneID = o.AndroidID + o.IphoneXSID + o.IphoneID + o.PhoneID
	r.TestID = o.TestID
	r.DownloadSpeed = do
	r.UploadSpeed = up
	r.Latency = la
	r.Jitter = ji
	r.PacketLoss = pa

	if r.DownloadSpeed < 1 {
		c.Response().AppendBodyString("Invalid value for downloadSpeed")
		return c.SendStatus(400)
	}
	if r.UploadSpeed < 1 {
		c.Response().AppendBodyString("Invalid value for uploadSpeed")
		return c.SendStatus(400)
	}
	if r.PacketLoss > 100 {
		c.Response().AppendBodyString("packetLoss must be less than 100")
		return c.SendStatus(400)
	}

	insertSpeedTestResultToDB(r)

	c.Response().AppendBodyString("OK")
	return c.SendStatus(200)
}

func insertSpeedTestResultToDB(r SpeedTestResult) {
	result, err := db.Exec(`INSERT INTO SpeedTests (
		id,
	 	phoneID,
	 	testID,
	 	downloadSpeed,
	 	uploadSpeed,
	 	latency,
	 	jitter,
	 	packetLoss,
		testStartTime,
		testDuration
	 ) VALUES (
		?,
	 	?,
	 	?,
	 	?,
	 	?,
	 	?,
	 	?,
	 	?,
		?,
		?
	 )`,
		rand.Int()%200,
		r.PhoneID,
		r.TestID,
		r.DownloadSpeed,
		r.UploadSpeed,
		r.Latency,
		r.Jitter,
		r.PacketLoss,
		time.Now(),
		time.Since(time.Now()),
	)
	if err != nil {
		log.Println(err)
	}
	log.Println(result)
}
