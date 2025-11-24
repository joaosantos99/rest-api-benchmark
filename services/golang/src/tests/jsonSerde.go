package tests

import (
	"crypto/md5"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type User struct {
	ID     int    `json:"id"`
	Name   string `json:"name"`
	Email  string `json:"email"`
	Active bool   `json:"active"`
}

type Settings struct {
	Theme         string `json:"theme"`
	Notifications bool   `json:"notifications"`
	Language      string `json:"language"`
}

type Metadata struct {
	Version   string   `json:"version"`
	Timestamp string   `json:"timestamp"`
	Settings  Settings `json:"settings"`
}

type Statistics struct {
	TotalUsers  int      `json:"totalUsers"`
	ActiveUsers int      `json:"activeUsers"`
	AverageAge  float64  `json:"averageAge"`
	Tags        []string `json:"tags"`
}

type SampleData struct {
	Users      []User      `json:"users"`
	Metadata   Metadata    `json:"metadata"`
	Statistics Statistics  `json:"statistics"`
}

func printHash(data interface{}, label string) string {
	jsonBytes, _ := json.Marshal(data)
	hash := md5.Sum(jsonBytes)
	hashHex := fmt.Sprintf("%x", hash)
	if label != "" {
		return fmt.Sprintf("%s MD5 Hash: %s", label, hashHex)
	}
	return fmt.Sprintf("MD5 Hash: %s", hashHex)
}

func JsonSerde(w http.ResponseWriter, r *http.Request) {
	sampleData := SampleData{
		Users: []User{
			{ID: 1, Name: "Alice", Email: "alice@example.com", Active: true},
			{ID: 2, Name: "Bob", Email: "bob@example.com", Active: false},
			{ID: 3, Name: "Charlie", Email: "charlie@example.com", Active: true},
		},
		Metadata: Metadata{
			Version:   "1.0.0",
			Timestamp: time.Now().UTC().Format("2006-01-02T15:04:05.000Z"),
			Settings: Settings{
				Theme:         "dark",
				Notifications: true,
				Language:      "en",
			},
		},
		Statistics: Statistics{
			TotalUsers:  3,
			ActiveUsers: 2,
			AverageAge:  28.5,
			Tags:        []string{"javascript", "nodejs", "benchmark", "json", "serialization"},
		},
	}

	n := 100 // Number of serialization/deserialization cycles

	jsonBytes, _ := json.Marshal(sampleData)
	jsonStr := string(jsonBytes)

	var parsed SampleData
	json.Unmarshal(jsonBytes, &parsed)
	originalHash := printHash(parsed, "Original")

	results := make([]SampleData, 0, n)
	for i := 0; i < n; i++ {
		serialized, _ := json.Marshal(parsed)
		var deserialized SampleData
		json.Unmarshal(serialized, &deserialized)
		results = append(results, deserialized)
	}

	finalHash := printHash(results, fmt.Sprintf("x%d Cycles", n))

	fmt.Fprintf(w, "%s\n%s\nPerformed %d serialization/deserialization cycles\nOriginal data size: %d bytes\nFinal array size: %d objects\n",
		originalHash, finalHash, n, len(jsonStr), len(results))
}

