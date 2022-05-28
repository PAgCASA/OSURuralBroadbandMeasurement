package types

type PersonalData struct {
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
	Street    string `json:"street"`
	City      string `json:"city"`
	State     string `json:"state"`
	Zip       string `json:"postalCode"`
	Image     string `json:"internetPlan"`
}
