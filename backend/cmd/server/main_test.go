package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http/httptest"
	"testing"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/database"
	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/util"
	"github.com/gofiber/fiber/v2"
	_ "modernc.org/sqlite"
)

func TestSubmitSpeedTestAndroid(t *testing.T) {
	// connect to db
	newDB, err := database.ConnectToDB("sqlite", ":memory:")
	db = newDB
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}
	defer db.Close()
	setUpTestTables(t)

	// http.Request
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"androidID": "android-25621ofk8and221h",
			"testID": "23js984jl9",
			"downloadSpeed": 14.24736,
			"uploadSpeed": 85.744,
			"latency": 31,
			"jitter": 6,
			"packetLoss": 1
		}`)))
	req.Header.Set("Content-Type", "application/json")

	app := createApp()
	resp, err := app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectGoodResponse(t, resp)
}

func TestSubmitSpeedTestIOSXSID(t *testing.T) {
	// connect to db
	newDB, err := database.ConnectToDB("sqlite", ":memory:")
	db = newDB
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}
	defer db.Close()
	setUpTestTables(t)

	// http.Request
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneXSID": "fjs934ks-8k3nslfneiskanqq3",
			"testID": "jfkd943kd9",
			"downloadSpeed": 14.24736,
			"uploadSpeed": 85.744,
			"latency": 31,
			"jitter": 6,
			"packetLoss": 1
		}`)))
	req.Header.Set("Content-Type", "application/json")

	app := createApp()
	resp, err := app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectGoodResponse(t, resp)
}

func TestSubmitSpeedTestIOSX(t *testing.T) {
	// connect to db
	newDB, err := database.ConnectToDB("sqlite", ":memory:")
	db = newDB
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}
	defer db.Close()
	setUpTestTables(t)

	// http.Request
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneID": "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs",
			"testID": "92kd84ndk1",
			"downloadSpeed": 14.24736,
			"uploadSpeed": 85.744,
			"latency": 31,
			"jitter": 6,
			"packetLoss": 1
		}`)))
	req.Header.Set("Content-Type", "application/json")

	app := createApp()
	resp, err := app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectGoodResponse(t, resp)
}

func TestSubmitSpeedTestFails(t *testing.T) {
	// connect to db
	newDB, err := database.ConnectToDB("sqlite", ":memory:")
	db = newDB
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}
	defer db.Close()
	setUpTestTables(t)

	// downloadSpeed
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneID": "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs",
			"testID": "92kd84ndk1",
			"downloadSpeed": -14.24736,
			"uploadSpeed": 85.744,
			"latency": 31,
			"jitter": 6,
			"packetLoss": 1
		}`)))
	req.Header.Set("Content-Type", "application/json")

	app := createApp()
	resp, err := app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectBadResponse(t, resp, fiber.StatusBadRequest, "Invalid value for downloadSpeed")

	// uploadSpeed
	req = httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneID": "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs",
			"testID": "92kd84ndk1",
			"downloadSpeed": 14.24736,
			"uploadSpeed": -85.744,
			"latency": 31,
			"jitter": 6,
			"packetLoss": 1
		}`)))
	req.Header.Set("Content-Type", "application/json")

	resp, err = app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectBadResponse(t, resp, fiber.StatusBadRequest, "Invalid value for uploadSpeed")

	// packetLoss 101%
	req = httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
				"iphoneID": "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs",
				"testID": "92kd84ndk1",
				"downloadSpeed": 14.24736,
				"uploadSpeed": 85.744,
				"latency": 31,
				"jitter": 6,
				"packetLoss": 101
			}`)))
	req.Header.Set("Content-Type", "application/json")

	resp, err = app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectBadResponse(t, resp, fiber.StatusBadRequest, "packetLoss must be less than 100")
}

func TestSpeedTestDatabaseSubmition(t *testing.T) {
	// connect to db
	newDB, err := database.ConnectToDB("sqlite", ":memory:")
	db = newDB
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}
	defer db.Close()

	setUpTestTables(t)

	// http.Request
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneID": "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs",
			"testID": "92kd84ndk1",
			"downloadSpeed": 5,
			"uploadSpeed": 456,
			"latency": 3,
			"jitter": 1,
			"packetLoss": 0
		}`)))
	req.Header.Set("Content-Type", "application/json")

	app := createApp()
	resp, err := app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectGoodResponse(t, resp)

	// check if the speed test was inserted in the database
	var query string = `SELECT phoneID, testID, downloadSpeed, uploadSpeed, latency, jitter, packetLoss FROM SpeedTests`
	rows, err := db.Query(query)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	// check row is as expected
	var phoneID, testID, downloadSpeed, uploadSpeed, latency, jitter, packetLoss string
	rows.Next()
	err = rows.Scan(&phoneID, &testID, &downloadSpeed, &uploadSpeed, &latency, &jitter, &packetLoss)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	if phoneID != "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs" {
		t.Errorf("Expected phoneID to be 'lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs', got '%s'", phoneID)
	}

	if testID != "92kd84ndk1" {
		t.Errorf("Expected testID to be '92kd84ndk1', got '%s'", testID)
	}

	if downloadSpeed != "5" {
		t.Errorf("Expected downloadSpeed to be '5', got '%s'", downloadSpeed)
	}

	if uploadSpeed != "456" {
		t.Errorf("Expected uploadSpeed to be '456', got '%s'", uploadSpeed)
	}

	if latency != "3" {
		t.Errorf("Expected latency to be '3', got '%s'", latency)
	}

	if jitter != "1" {
		t.Errorf("Expected jitter to be '1', got '%s'", jitter)
	}

	if packetLoss != "0" {
		t.Errorf("Expected packetLoss to be '0', got '%s'", packetLoss)
	}

	if rows.Next() {
		t.Errorf("Expected only one row, got more")
	}
}

func setUpTestTables(t *testing.T) {
	content, err := ioutil.ReadFile("../../../database/initialSchema.sql") // the file is inside the local directory
	if err != nil {
		fmt.Printf("Err reading file: %v", err)
	}

	_, err = db.Exec(string(content))
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}
}
