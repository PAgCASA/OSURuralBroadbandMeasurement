package database

import "database/sql"

func ConnectToDB(dbType string, DSN string) (*sql.DB, error) {
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
