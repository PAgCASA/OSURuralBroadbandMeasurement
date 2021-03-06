package types

type SimpleSummary struct {
	Upload     float64 `json:"upload"`
	Download   float64 `json:"download"`
	Jitter     float64 `json:"jitter"`
	Latency    float64 `json:"latency"`
	PacketLoss float64 `json:"packetLoss"`
}

type GeolocatedSimpleSummary struct {
	SimpleSummary
	Lat float64 `json:"lat"`
	Lon float64 `json:"lon"`
}

type Summary struct {
	GeneralData SimpleSummary   `json:"generalData"`
	Sample      []SimpleSummary `json:"sample"`
}
