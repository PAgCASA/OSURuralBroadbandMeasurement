package main

import (
	"database/sql"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/go-sql-driver/mysql"
)

var db *sql.DB

var recentlyRecivedData string

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

	//hello world web server
	http.Handle("/", http.FileServer(http.Dir("frontend/dist")))
	http.HandleFunc("/api/v0/postData", postData)
	http.HandleFunc("/api/v0/readData", readData)

	http.ListenAndServe(":"+os.Getenv("PORT"), nil)
}

func postData(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "This endpoint only supports POST requests", http.StatusBadRequest)
		return
	}

	if r.Header.Get("Password-Test") != os.Getenv("POSTPASSWORD") {
		http.Error(w, "Invalid Password", http.StatusUnauthorized)
		return
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Printf("Error reading body: %e", err)
		http.Error(w, "Error reading body", http.StatusBadRequest)
		return
	}

	log.Printf("Got data string: %s", body)
	recentlyRecivedData = string(body)
}

func readData(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "This endpoint only supports GET requests", http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte(recentlyRecivedData))
}
