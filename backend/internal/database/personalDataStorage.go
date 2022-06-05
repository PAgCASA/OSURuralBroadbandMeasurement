package database

import (
	"database/sql"
	"errors"
	"log"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/types"
)

func InsertOrUpdatePersonalDataToDB(db *sql.DB, r types.PersonalData) error {
	if db == nil {
		log.Println("DB not connected")
	}

	_, err := DoesPersonalDataExistInDB(db, r)
	if err != nil {
		//then insert
		_, err := db.Exec(`INSERT INTO PersonalData (
			phoneID,
			firstName,
			lastName,
			street,
			city,
			state,
			zip,
			billPhoto
		); VALUES (
			?,
			?,
			?,
			?,
			?,
			?,
			?
		)`,
			r.PhoneID,
			r.FirstName,
			r.LastName,
			r.Street,
			r.City,
			r.State,
			r.PostalCode,
			r.Image,
		)

		if err != nil {
			return err
		}

	} else {
		//then update
		_, err := db.Exec(`UPDATE PersonalData SET
			firstName = ?,
			lastName = ?,
			street = ?,
			city = ?,
			state = ?,
			zip = ?,
			billPhoto = ?
		WHERE phoneID = ?`,
			r.FirstName,
			r.LastName,
			r.Street,
			r.City,
			r.State,
			r.PostalCode,
			r.Image,
			r.PhoneID,
		)
		if err != nil {
			return err
		}
	}

	return nil
}

func GetBasicPersonalData(db *sql.DB, phoneID string) (types.PersonalData, error) {
	if db == nil {
		log.Println("DB not connected")
	}

	result := db.QueryRow(`SELECT firstName, lastName, street, city, state, zip FROM PersonalData WHERE phoneID = ?`, phoneID)

	if result == nil {
		return types.PersonalData{}, errors.New("no personal data found")
	}

	var firstName string
	var lastName string
	var street string
	var city string
	var state string
	var zip string

	err := result.Scan(&firstName, &lastName, &street, &city, &state, &zip)
	if err != nil {
		return types.PersonalData{}, err
	}

	return types.PersonalData{
		PhoneID:    phoneID,
		FirstName:  firstName,
		LastName:   lastName,
		Street:     street,
		City:       city,
		State:      state,
		PostalCode: zip,
	}, nil
}

func DoesPersonalDataExistInDB(db *sql.DB, r types.PersonalData) (int, error) {
	if db == nil {
		log.Println("DB not connected")
	}

	result := db.QueryRow(`SELECT id FROM PersonalData WHERE phoneID = ?`, r.PhoneID)

	if result == nil {
		return -1, errors.New("no result")
	}

	var id int
	if err := result.Scan(&id); err != nil {
		return -1, err
	}

	return id, nil
}
