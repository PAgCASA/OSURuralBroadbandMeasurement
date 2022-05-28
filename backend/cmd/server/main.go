package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"math/rand"
	"os"
	"time"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/database"
	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/types"
	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/util"
	"github.com/go-sql-driver/mysql"
	"github.com/gofiber/fiber/v2"
)

var db *sql.DB

func main() {
	if os.Getenv("PORT") == "" {
		os.Setenv("PORT", "8080")
	}

	if os.Getenv("DBHOST") == "" {
		os.Setenv("DBHOST", "localhost")
	}

	// Capture connection properties.
	cfg := mysql.Config{
		User:                 os.Getenv("DBUSER"),
		Passwd:               os.Getenv("DBPASS"),
		Net:                  "tcp",
		Addr:                 os.Getenv("DBHOST") + ":3306",
		DBName:               "PAgCASABroadband",
		AllowNativePasswords: true,
		ParseTime:            true,
	}
	log.Printf("MySQL User: %s", cfg.User)

	// connect
	const maxConnectionAttempts = 10
	for i := 0; i < maxConnectionAttempts; i++ {
		dbConnection, err := database.ConnectToDB("mysql", cfg.FormatDSN())
		//if connected then start server
		if err == nil {
			db = dbConnection //actually assign the db connection
			break
		}

		// if not in production, then consider us to have connected
		if os.Getenv("ENV") != "production" {
			log.Println("Not in production so faking connection to DB")
			break
		}

		//if not connected then wait and try again, up to 10 times, then exit with error
		if err != nil && i == maxConnectionAttempts-1 {
			log.Fatal(err)
		}

		//wait 5 seconds before trying again
		log.Println("Could not connect to DB. Retrying in 5 seconds...")
		time.Sleep(5 * time.Second)
	}

	app := createApp()

	// start UDP listening
	go listenAndRecordUDPPackets()

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

	api.Get("/getSpeedTestResults/:id", getSpeedTestResults)

	api.Delete("/udpTest/:id", getUDPPacketsRecieved)
	api.Get("/udpPacket", getMostRecentPacketSeen)

	api.Post("/submitPersonalInfo", submitPersonalInfo)
	api.Get("/getPersonalInfo/:id", getPersonalInfo)

	api.Get("/frontend/summary/:id", getFrontendSummary)

	return app
}

//TODO match incoming data with what will actually be submitted by the frontend
// where speed tests are submitted
func submitSpeedTest(c *fiber.Ctx) error {
	type SpeedTestResultOriginal struct {
		AndroidID     string  `json:"androidID"`
		IphoneXSID    string  `json:"iphoneXSID"`
		IphoneID      string  `json:"iphoneID"`
		PhoneID       string  `json:"phoneID"`
		TestID        string  `json:"testID"`
		DownloadSpeed float64 `json:"downloadSpeed"`
		UploadSpeed   float64 `json:"uploadSpeed"`
		Latency       int     `json:"latency"`
		Jitter        int     `json:"jitter"`
		PacketLoss    int     `json:"packetLoss"`
	}

	o := new(SpeedTestResultOriginal)
	if err := c.BodyParser(o); err != nil {
		return err
	}
	var r types.SpeedTestResult

	r.PhoneID = o.AndroidID + o.IphoneXSID + o.IphoneID + o.PhoneID
	r.TestID = o.TestID
	r.DownloadSpeed = o.DownloadSpeed
	r.UploadSpeed = o.UploadSpeed
	r.Latency = o.Latency
	r.Jitter = o.Jitter
	r.PacketLoss = o.PacketLoss

	if r.DownloadSpeed < 0 {
		c.Response().AppendBodyString("Invalid value for downloadSpeed")
		return c.SendStatus(400)
	}
	if r.UploadSpeed < 0 {
		c.Response().AppendBodyString("Invalid value for uploadSpeed")
		return c.SendStatus(400)
	}
	if r.PacketLoss > 100 {
		c.Response().AppendBodyString("packetLoss must be less than 100")
		return c.SendStatus(400)
	}
	if r.PacketLoss < 0 {
		c.Response().AppendBodyString("packetLoss must be greater than 0")
		return c.SendStatus(400)
	}
	if r.Latency < 0 {
		c.Response().AppendBodyString("latency must be greater than 0")
		return c.SendStatus(400)
	}

	database.InsertSpeedTestResultToDB(db, r)

	c.Response().AppendBodyString("OK")
	return c.SendStatus(200)
}

func getSpeedTestResults(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		c.Response().AppendBodyString("Invalid ID")
		return c.SendStatus(400)
	}

	r := database.GetSpeedTestResultsFromDB(db, id)
	if r == nil {
		c.Response().AppendBodyString("No results found")
		return c.SendStatus(404)
	}

	json, err := json.Marshal(r)
	if err != nil {
		c.Response().AppendBodyString("Error marshalling results")
		return c.SendStatus(500)
	}

	c.Response().SetBody(json)
	c.Response().Header.Add(fiber.HeaderContentType, fiber.MIMEApplicationJSON)
	return c.SendStatus(200)
}

var tempInfo *types.PersonalData

func submitPersonalInfo(c *fiber.Ctx) error {
	payload := &types.PersonalData{}

	if err := c.BodyParser(payload); err != nil {
		return err
	}

	tempInfo = payload

	c.Response().AppendBodyString("OK")
	return c.SendStatus(200)
}

func getPersonalInfo(c *fiber.Ctx) error {
	if tempInfo == nil {
		c.Response().AppendBodyString("No info submitted")
		return c.SendStatus(404)
	}

	json, err := json.Marshal(tempInfo)
	if err != nil {
		c.Response().AppendBodyString("Error marshalling results")
		return c.SendStatus(500)
	}

	c.Response().SetBody(json)
	c.Response().Header.Add(fiber.HeaderContentType, fiber.MIMEApplicationJSON)
	return c.SendStatus(200)
}

func getFrontendSummary(c *fiber.Ctx) error {
	type Summary struct {
		Upload     float64 `json:"upload"`
		Download   float64 `json:"download"`
		Jitter     float64 `json:"jitter"`
		Latency    float64 `json:"latency"`
		PacketLoss float64 `json:"packetLoss"`
	}

	var s Summary
	id := c.Params("id")
	rand.Seed(int64(util.HashString(id)))

	s.Download = rand.Float64() * 180
	s.Upload = rand.Float64() * 20
	s.Jitter = rand.Float64() * 4
	s.Latency = rand.Float64() * 40
	s.PacketLoss = rand.Float64() * 5

	json, err := json.Marshal(s)
	if err != nil {
		c.Response().AppendBodyString("Error marshalling results")
		return c.SendStatus(500)
	}

	c.Response().SetBody(json)
	c.Response().Header.Add(fiber.HeaderContentType, fiber.MIMEApplicationJSON)
	c.Response().Header.Add(fiber.HeaderAccessControlAllowOrigin, "*") //make sure this is accessible for frontend
	return c.SendStatus(200)
}
