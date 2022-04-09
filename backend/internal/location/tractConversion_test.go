package location

import "testing"

func TestGetTractFromLocation(t *testing.T) {
	testCases := []struct {
		lat   float64
		lon   float64
		tract string
		err   error
	}{
		{lat: 44.5636798, lon: -123.2734269, tract: "41003010602", err: nil},
		{lat: 30.2577110, lon: -97.7514821, tract: "48453001311", err: nil},
	}

	for _, tc := range testCases {
		tract, err := GetTractFromLocation(tc.lat, tc.lon)
		if err != tc.err {
			t.Errorf("Expected err to be %v, got %v", tc.err, err)
		}
		if tract != tc.tract {
			t.Errorf("Expected tract to be %s, got %s", tc.tract, tract)
		}
	}
}
