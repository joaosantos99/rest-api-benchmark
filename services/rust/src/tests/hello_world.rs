use axum::response::Response;

pub async fn handler() -> Response<String> {
    Response::new("Hello World!".to_string())
}
