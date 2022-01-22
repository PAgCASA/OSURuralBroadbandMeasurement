package main

import (
	"bytes"
	"net/http/httptest"
	"testing"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/util"
	"github.com/gofiber/fiber/v2"
)

func TestSubmitSpeedTestAndroid(t *testing.T) {
	// http.Request
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"androidID": "android-25621ofk8and221h",
			"testID": "23js984jl9",
			"downloadSpeed": "1424736",
			"uploadSpeed": "85744",
			"latency": "31",
			"jitter": "6",
			"packetLoss": "001"
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
	// http.Request
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneXSID": "fjs934ks-8k3nslfneiskanqq3",
			"testID": "jfkd943kd9",
			"downloadSpeed": "3856667",
			"uploadSpeed": "8294441",
			"latency": "16",
			"jitter": "4",
			"packetLoss": "000"
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
	// http.Request
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneID": "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs",
			"testID": "92kd84ndk1",
			"downloadSpeed": "293859483712",
			"uploadSpeed": "210937465527",
			"latency": "3",
			"jitter": "1",
			"packetLoss": "000"
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
	// downloadSpeed
	req := httptest.NewRequest(
		"POST",
		"http://localhost:8080/api/v0/submitSpeedTest",
		bytes.NewBuffer([]byte(`{
			"iphoneID": "lsn98cm3j7di4ks9r0l4o0p2215ndksmnqakxmzs",
			"testID": "92kd84ndk1",
			"downloadSpeed": "asdg25234",
			"uploadSpeed": "210937465527",
			"latency": "3",
			"jitter": "1",
			"packetLoss": "000"
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
			"downloadSpeed": "5",
			"uploadSpeed": "asdg3",
			"latency": "3",
			"jitter": "1",
			"packetLoss": "000"
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
				"downloadSpeed": "5",
				"uploadSpeed": "456",
				"latency": "3",
				"jitter": "1",
				"packetLoss": "101"
			}`)))
	req.Header.Set("Content-Type", "application/json")

	resp, err = app.Test(req)
	if err != nil {
		t.Errorf("Expected no error, got %v", err)
	}

	util.ExpectBadResponse(t, resp, fiber.StatusBadRequest, "packetLoss must be less than 100")
}
