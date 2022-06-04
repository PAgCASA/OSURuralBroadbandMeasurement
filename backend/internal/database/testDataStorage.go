package database

import (
	"database/sql"
	"errors"
	"log"
	"time"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/types"
)

func InsertSpeedTestResultToDB(db *sql.DB, r types.SpeedTestResult) error {
	if db == nil {
		log.Println("DB not connected")
	}

	result, err := db.Exec(`INSERT INTO SpeedTests (
	 	phoneID,
	 	testID,
	 	downloadSpeed,
	 	uploadSpeed,
	 	latency,
	 	jitter,
	 	packetLoss,
		testStartTime,
		testDuration,
		latitude,
		longitude,
		accuracy
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
		?,
		?,
		?
	 )`,
		r.PhoneID,
		r.TestID,
		r.DownloadSpeed,
		r.UploadSpeed,
		r.Latency,
		r.Jitter,
		r.PacketLoss,
		r.TestStartTime,
		r.TestDuration,
		r.Latitude,
		r.Longitude,
		r.Accuracy,
	)
	if err != nil {
		return err
	}
	rows, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if rows != 1 {
		return errors.New("rows not inserted properly")
	}

	return nil
}

func GetSpeedTestResultsFromDB(db *sql.DB, id string) *types.PastResults {
	if db == nil {
		log.Println("DB not connected")
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
