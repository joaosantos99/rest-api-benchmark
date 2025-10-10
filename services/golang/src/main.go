package main

import (
	"net/http"
	"rest-api-benchmark-golang/tests"
)

func main() {
	http.HandleFunc("/hello-world", tests.HelloWorld)

	http.ListenAndServe(":8080", nil)
}
