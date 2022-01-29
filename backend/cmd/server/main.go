package main

import (
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/go-sql-driver/mysql"
	"github.com/gofiber/fiber/v2"
)

// var db *sql.DB

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
	/*
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
		fmt.Println("Connected to Database!")*/

	app := createApp()

	app.Listen(":" + os.Getenv("PORT")) // listen on port 8080 by default
}

func createApp() *fiber.App {
	app := fiber.New()

	api := app.Group("/api/v0")

	api.Post("/submitSpeedTest", submitSpeedTest)

	return app
}

func submitSpeedTest(c *fiber.Ctx) error {
	// TODO use https://docs.gofiber.io/api/ctx#bodyparser to read the body of the request and put it into a struct with the correct fields.
	// see design_docs/api_requests.json, only deal with the first 3 entries. See that the only thing that changes between them is the name and format of the phone ID
	// return OK to client if valid, else return error.
	// Note: the struct should be named "SpeedTestResult"

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
	type SpeedTestResult struct {
		PhoneID       string
		TestID        string
		DownloadSpeed int
		UploadSpeed   int
		Latency       int
		Jitter        int
		PacketLoss    int
	}
	o := new(SpeedTestResultOriginal)
	if err := c.BodyParser(o); err != nil {
		return err
	}
	var r SpeedTestResult
	do, err := strconv.Atoi(o.DownloadSpeed)
	up, err := strconv.Atoi(o.UploadSpeed)
	la, err := strconv.Atoi(o.Latency)
	ji, err := strconv.Atoi(o.Jitter)
	pa, err := strconv.Atoi(o.PacketLoss)
	if err != nil {
		fmt.Printf("%v ", o.DownloadSpeed)
	}
	r.PhoneID = o.AndroidID + o.IphoneXSID + o.IphoneID + o.PhoneID
	r.TestID = o.TestID
	r.DownloadSpeed = do
	r.UploadSpeed = up
	r.Latency = la
	r.Jitter = ji
	r.PacketLoss = pa

	log.Println("PhoneID: ", r.PhoneID)
	log.Println("TestID: ", r.TestID)
	log.Println("DownloadSpeed: ", r.DownloadSpeed)
	log.Println("UploadSpeed: ", r.UploadSpeed)
	log.Println("Latency: ", r.Latency)
	log.Println("Jitter: ", r.Jitter)
	log.Println("PacketLoss: ", r.PacketLoss)
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

	c.Response().AppendBodyString("OK")
	return c.SendStatus(200)
}
