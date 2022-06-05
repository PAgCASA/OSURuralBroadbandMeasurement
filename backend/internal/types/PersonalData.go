package types

type PersonalData struct {
	PhoneID    string `json:"deviceID"`
	FirstName  string `json:"firstName"`
	LastName   string `json:"lastName"`
	Street     string `json:"street"`
	City       string `json:"city"`
	State      string `json:"state"`
	PostalCode string `json:"postalCode"`
	Image      string `json:"internetPlan"`
}
