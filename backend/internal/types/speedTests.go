package types

import "time"

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
