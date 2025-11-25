use axum::response::Response;
use md5;
use serde::{Deserialize, Serialize};
use serde_json;

#[derive(Serialize, Deserialize, Debug, Clone)]
struct User {
    id: i32,
    name: String,
    email: String,
    active: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
struct Settings {
    theme: String,
    notifications: bool,
    language: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
struct Metadata {
    version: String,
    timestamp: String,
    settings: Settings,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
struct Statistics {
    total_users: i32,
    active_users: i32,
    average_age: f64,
    tags: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
struct SampleData {
    users: Vec<User>,
    metadata: Metadata,
    statistics: Statistics,
}

fn print_hash<T: Serialize>(data: &T, label: &str) -> String {
    let json_str = serde_json::to_string(data).unwrap();
    let hash = md5::compute(json_str.as_bytes());
    let hash_hex = format!("{:x}", hash);
    if !label.is_empty() {
        format!("{} MD5 Hash: {}", label, hash_hex)
    } else {
        format!("MD5 Hash: {}", hash_hex)
    }
}

pub async fn handler() -> Response<String> {
    let sample_data = SampleData {
        users: vec![
            User {
                id: 1,
                name: "Alice".to_string(),
                email: "alice@example.com".to_string(),
                active: true,
            },
            User {
                id: 2,
                name: "Bob".to_string(),
                email: "bob@example.com".to_string(),
                active: false,
            },
            User {
                id: 3,
                name: "Charlie".to_string(),
                email: "charlie@example.com".to_string(),
                active: true,
            },
        ],
        metadata: Metadata {
            version: "1.0.0".to_string(),
            timestamp: chrono::Utc::now().to_rfc3339_opts(chrono::SecondsFormat::Millis, true),
            settings: Settings {
                theme: "dark".to_string(),
                notifications: true,
                language: "en".to_string(),
            },
        },
        statistics: Statistics {
            total_users: 3,
            active_users: 2,
            average_age: 28.5,
            tags: vec![
                "javascript".to_string(),
                "nodejs".to_string(),
                "benchmark".to_string(),
                "json".to_string(),
                "serialization".to_string(),
            ],
        },
    };

    let n = 100; // Number of serialization/deserialization cycles

    let json_str = serde_json::to_string(&sample_data).unwrap();

    let parsed: SampleData = serde_json::from_str(&json_str).unwrap();
    let original_hash = print_hash(&parsed, "Original");

    let mut results = Vec::new();
    for _i in 0..n {
        let serialized = serde_json::to_string(&parsed).unwrap();
        let deserialized: SampleData = serde_json::from_str(&serialized).unwrap();
        results.push(deserialized);
    }

    let final_hash = print_hash(&results, &format!("x{} Cycles", n));

    let output = format!(
        "{}\n{}\nPerformed {} serialization/deserialization cycles\nOriginal data size: {} bytes\nFinal array size: {} objects\n",
        original_hash, final_hash, n, json_str.len(), results.len()
    );

    Response::new(output)
}

