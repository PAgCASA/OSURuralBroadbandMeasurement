package database

import (
	"database/sql"
	"log"
	"math/rand"
	"time"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/types"
)

func InsertSpeedTestResultToDB(db *sql.DB, r types.SpeedTestResult) {
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

func GetSpeedTestResultsFromDB(db *sql.DB, id string) *types.PastResults {
	if db == nil {
		log.Fatal("DB not connected")
	}

	var pr types.PastResults

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
		var r types.SpeedTestResult
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
