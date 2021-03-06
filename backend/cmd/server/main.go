package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"os"
	"strconv"
	"strings"
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
	api.Get("/frontend/summaryList/:index", getFrontendSummaryList)

	return app
}

// where speed tests are submitted
func submitSpeedTest(c *fiber.Ctx) error {
	var r types.SpeedTestResult
	if err := c.BodyParser(&r); err != nil {
		return err
	}

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

	err := database.InsertSpeedTestResultToDB(db, r)
	if err != nil {
		c.Response().AppendBodyString("Error inserting result to DB" + err.Error())
		return c.SendStatus(500)
	}

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

func submitPersonalInfo(c *fiber.Ctx) error {
	payload := &types.PersonalData{}

	if err := c.BodyParser(payload); err != nil {
		return err
	}

	err := database.InsertOrUpdatePersonalDataToDB(db, *payload)
	if err != nil {
		c.Response().AppendBodyString("Error inserting result to DB" + err.Error())
		return c.SendStatus(500)
	}

	c.Response().AppendBodyString("OK")
	return c.SendStatus(200)
}

func getPersonalInfo(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		c.Response().AppendBodyString("Invalid ID")
		return c.SendStatus(400)
	}

	r, err := database.GetBasicPersonalData(db, id)
	if err != nil {
		c.Response().AppendBodyString("Error getting personal data" + err.Error())
		return c.SendStatus(500)
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

func getFrontendSummary(c *fiber.Ctx) error {
	id := c.Params("id")
	var s types.Summary

	var sample []types.SimpleSummary
	for i := 0; i < 10; i++ {
		sample = append(sample, util.GenerateRandomSimpleSummary(id+"-"+strconv.Itoa(i)))
	}

	s.GeneralData = util.GenerateRandomSimpleSummary(id)
	s.Sample = sample

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

func getFrontendSummaryList(c *fiber.Ctx) error {
	id := c.Params("index")

	var national = false
	if strings.HasPrefix(id, "N") {
		national = true
		id = id[1:]
	}

	var sample []types.GeolocatedSimpleSummary
	for i := 0; i < 100; i++ {
		sample = append(sample, util.GenerateRandomGeolocatedSimpleSummary(id+"-"+strconv.Itoa(i), national))
	}

	json, err := json.Marshal(sample)
	if err != nil {
		c.Response().AppendBodyString("Error marshalling results")
		return c.SendStatus(500)
	}

	c.Response().SetBody(json)
	c.Response().Header.Add(fiber.HeaderContentType, fiber.MIMEApplicationJSON)
	c.Response().Header.Add(fiber.HeaderAccessControlAllowOrigin, "*") //make sure this is accessible for frontend
	return c.SendStatus(200)
}
