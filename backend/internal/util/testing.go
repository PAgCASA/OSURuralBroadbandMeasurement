package util

import (
	"io/ioutil"
	"net/http"
	"testing"

	"github.com/gofiber/fiber/v2"
)

func ExpectGoodResponse(t *testing.T, resp *http.Response) {
	if resp.StatusCode == fiber.StatusOK {
		body, _ := ioutil.ReadAll(resp.Body)
		if string(body) != "OK" {
			t.Errorf("Expected OK, got %s", string(body))
		}
	} else {
		t.Errorf("Expected status code %d, got %d", fiber.StatusOK, resp.StatusCode)
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
