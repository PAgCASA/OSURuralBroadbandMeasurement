package main

import (
	"database/sql"
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

	if os.Getenv("DBHOST") == "" {
		os.Setenv("DBHOST", "localhost")
	}

	// Capture connection properties.
	cfg := mysql.Config{
		User:   os.Getenv("DBUSER"),
		Passwd: os.Getenv("DBPASS"),
		Net:    "tcp",
		Addr:   os.Getenv("DBHOST") + ":3306",
		DBName: "PAgCASABroadband",
	}
	log.Printf("MySQL User: %s", cfg.User)

	// connect
	const maxConnectionAttempts = 10
	for i := 0; i < maxConnectionAttempts; i++ {
		dbConnection, err := connectToDB("mysql", cfg.FormatDSN())
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

func connectToDB(dbType string, DSN string) (*sql.DB, error) {
	var err error
	// Connect to the database
	newDB, err := sql.Open(dbType, DSN)
	if err != nil {
		return newDB, err
	}

	// Test the connection to the database with a ping
	err = newDB.Ping()
	if err != nil {
		return newDB, err
	}

	// run query to test connection
	var test int
	err = newDB.QueryRow("SELECT 1").Scan(&test)
	if err != nil {
		return newDB, err
	}

	return newDB, nil
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
	if db == nil {
		log.Fatal("DB not connected")
	}

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
		rand.Int()%200, //TODO better way to generate id
		r.PhoneID,
		r.TestID,
		r.DownloadSpeed,
		r.UploadSpeed,
		r.Latency,
		r.Jitter,
		r.PacketLoss,
		time.Now(),             //TODO needs to come from frontend
		time.Since(time.Now()), //TODO needs to come from frontend
	)
	if err != nil {
		log.Println(err)
	}
	rows, err := result.RowsAffected()
	if err != nil {
		log.Println(err)
	}
	if rows != 1 {
		log.Fatal("Rows not inserted properly")
	}
}
