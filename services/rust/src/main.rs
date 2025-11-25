use axum::{
    routing::get,
    Router,
};
use std::env;

mod tests;

#[tokio::main]
async fn main() {
    let port = env::var("PORT")
        .unwrap_or_else(|_| "8080".to_string())
        .parse::<u16>()
        .unwrap_or(8080);

    let app = Router::new()
        .route("/api/hello-world", get(tests::hello_world::handler))
        .route("/api/pi-digits", get(tests::pi_digits::handler))
        .route("/api/n-body", get(tests::n_body::handler))
        .route("/api/json-serde", get(tests::json_serde::handler))

    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", port))
        .await
        .unwrap();

    println!("Server running at http://localhost:{} (Rust)", port);

    axum::serve(listener, app).await.unwrap();
}
