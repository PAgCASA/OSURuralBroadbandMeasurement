package types

import "time"

type SpeedTestResult struct {
	PhoneID       string  `json:"phoneID"`
	TestID        string  `json:"testID"`
	DownloadSpeed float64 `json:"downloadSpeed"`
	UploadSpeed   float64 `json:"uploadSpeed"`
	Latency       int     `json:"latency"`
	Jitter        float64 `json:"jitter"`
	PacketLoss    float64 `json:"packetLoss"`

	TestStartTime time.Time `json:"testStartTime"`
	TestDuration  int       `json:"testDuration"` // in milliseconds

	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	Accuracy  float64 `json:"accuracy"` // in meters
}

type PastResults struct {
	PhoneID     string
	LastUpdated time.Time
	Results     []SpeedTestResult // needs to be lastest first
}
