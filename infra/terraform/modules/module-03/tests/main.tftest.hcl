mock_provider "google" {
  alias = "mock"
}
mock_provider "google-beta" {
  alias = "mock"
}

run "topic_name" {
    command = plan

    providers = {
        google      = google.mock
        google-beta = google-beta.mock
    }

    assert {
      condition = google_pubsub_topic.example.name == "example-topic"
      error_message = "Unexpected topic name"
    }
}