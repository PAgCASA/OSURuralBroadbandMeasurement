package location

func GetTractFromLocation(lat float64, lon float64) (string, error) {
	//TODO take lat and lon and return the cenus tract ID
	// the census gives a "GeoID" which is a unique ID for each census tract
	// GEOID is a string of the form "stateID countyID tractID"
	// Note that block GEOIDs include the tract info, but with 4 numbers appended
	// Example: BlockID: 240338024052004, TractID: 24033802405
	// We want to return the tractID, so we need to remove the last 4 numbers
	return "", nil
}
