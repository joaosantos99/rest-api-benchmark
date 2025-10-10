package main

import (
	"net/http"
	"rest-api-benchmark-golang/tests"
)

func main() {
	http.HandleFunc("/api/hello-world", tests.HelloWorld)
	http.HandleFunc("/api/pi-digits", tests.PiDigits)

	http.ListenAndServe(":8080", nil)
}
