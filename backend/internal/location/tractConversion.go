package location

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

func GetTractFromLocation(lat float64, lon float64) (string, error) {
	type GeoResponse struct {
		Result struct {
			GeoGraphies struct {
				Blocks []struct {
					GeoId string `json:"GEOID"`
				} `json:"Census Blocks"`
			} `json:"geographies"`
		} `json:"result"`
	}

	geoApi := "https://geocoding.geo.census.gov/geocoder/geographies/coordinates?x=%f&y=%f&benchmark=Public_AR_Census2020&vintage=Census2020_Census2020&layers=10&format=json"

	url := fmt.Sprintf(geoApi, lon, lat)
	resp, err := http.Get(url)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var geoResponse *GeoResponse
	if err = json.Unmarshal(body, &geoResponse); err != nil {
		return "", nil
	}

	geoId := geoResponse.Result.GeoGraphies.Blocks[0].GeoId
	if len(geoId) < 4 {
		return "", fmt.Errorf("geo id length is wrong")
	}

	return geoId[:len(geoId)-4], nil
}
