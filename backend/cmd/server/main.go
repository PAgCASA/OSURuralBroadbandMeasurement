package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"math/rand"
	"os"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/gofiber/fiber/v2"
)

type SpeedTestResult struct {
	PhoneID       string
	TestID        string
	DownloadSpeed float64
	UploadSpeed   float64
	Latency       int
	Jitter        int
	PacketLoss    int
	TestStartTime time.Time
}

type PastResults struct {
	PhoneID     string
	LastUpdated time.Time
	Results     []SpeedTestResult // needs to be lastest first
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
	var r SpeedTestResult

	r.PhoneID = o.AndroidID + o.IphoneXSID + o.IphoneID + o.PhoneID
	r.TestID = o.TestID
	r.DownloadSpeed = o.DownloadSpeed
	r.UploadSpeed = o.UploadSpeed
	r.Latency = o.Latency
	r.Jitter = o.Jitter
	r.PacketLoss = o.PacketLoss

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

func getSpeedTestResults(c *fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		c.Response().AppendBodyString("Invalid ID")
		return c.SendStatus(400)
	}

	r := getSpeedTestResultsFromDB(id)
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

func getSpeedTestResultsFromDB(id string) *PastResults {
	if db == nil {
		log.Fatal("DB not connected")
	}

	var pr PastResults

	result, err := db.Query(`SELECT
		phoneID,
		testID,
		downloadSpeed,
		uploadSpeed,
		latency,
		jitter,
		packetLoss,
		testStartTime
			FROM SpeedTests WHERE phoneID = ?
			ORDER BY testStartTime DESC`, id)
	if err != nil {
		log.Println(err)
		return nil
	}
	defer result.Close()

	for result.Next() {
		var r SpeedTestResult
		err := result.Scan(
			&r.PhoneID,
			&r.TestID,
			&r.DownloadSpeed,
			&r.UploadSpeed,
			&r.Latency,
			&r.Jitter,
			&r.PacketLoss,
			&r.TestStartTime,
		)
		if err != nil {
			log.Println(err)
			return nil
		}
		pr.Results = append(pr.Results, r)
	}

	pr.LastUpdated = time.Now()
	pr.PhoneID = id

	return &pr
}
