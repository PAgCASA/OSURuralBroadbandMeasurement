package util

import (
	"hash/fnv"
	"io/ioutil"
	"math/rand"
	"net/http"
	"testing"

	"github.com/PAgCASA/OSURuralBroadbandMeasurement/backend/internal/types"
	"github.com/gofiber/fiber/v2"
)

func ExpectGoodResponse(t *testing.T, resp *http.Response) {
	if resp.StatusCode == fiber.StatusOK {
		body, _ := ioutil.ReadAll(resp.Body)
		if string(body) != "OK" {
			t.Errorf("Expected OK, got %s", string(body))
		}
	} else {
		body, _ := ioutil.ReadAll(resp.Body)
		t.Errorf("Expected status code %d, got %d with body %s", fiber.StatusOK, resp.StatusCode, string(body))
	}
}

func ExpectBadResponse(t *testing.T, resp *http.Response, expectedStatusCode int, expectedBody string) {
	if resp.StatusCode == expectedStatusCode {
		body, _ := ioutil.ReadAll(resp.Body)
		if string(body) != expectedBody {
			t.Errorf("Expected %s, got %s", expectedBody, string(body))
		}
	} else {
		t.Errorf("Expected status code %d, got %d", expectedStatusCode, resp.StatusCode)
	}
}

func HashString(s string) uint64 {
	h := fnv.New64a()
	h.Write([]byte(s))
	return h.Sum64()
}

func GenerateRandomSimpleSummary(id string) types.SimpleSummary {
	var s types.SimpleSummary
	rand.Seed(int64(HashString(id)))

	s.Download = rand.Float64() * 180
	s.Upload = rand.Float64() * 20
	s.Jitter = rand.Float64() * 4
	s.Latency = rand.Float64() * 40
	s.PacketLoss = rand.Float64() * 5

	return s
}

func GenerateRandomCordinatesWithinAnArea(id string, maxLongitude float64, maxLatitude float64, minLongitude float64, minLatitude float64) (float64, float64) {
	var lon float64
	var lat float64

	rand.Seed(int64(HashString(id)))
	lon = rand.Float64()*(maxLongitude-minLongitude) + minLongitude
	lat = rand.Float64()*(maxLatitude-minLatitude) + minLatitude

	return lon, lat
}

func GenerateRandomGeolocatedSimpleSummary(id string, national bool) types.GeolocatedSimpleSummary {
	var s types.GeolocatedSimpleSummary
	rand.Seed(int64(HashString(id)))

	s.Download = rand.Float64() * 180
	s.Upload = rand.Float64() * 20
	s.Jitter = rand.Float64() * 4
	s.Latency = rand.Float64() * 40
	s.PacketLoss = rand.Float64() * 5

	if national {
		//-141.108398,19.145168,-51.108398,53.618579 is very very rough bounds of the USA
		s.Lat, s.Lon = GenerateRandomCordinatesWithinAnArea(id, -51.108398, 53.618579, -141.108398, 19.145168)
	} else {
		//-124.475098,42.016652,-116.444092,46.233053 is a rough bounding box of Oregon
		s.Lon, s.Lat = GenerateRandomCordinatesWithinAnArea(id, -116.444092, 46.233053, -124.475098, 42.016652)
	}

	return s
}
