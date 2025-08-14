mock_provider "google" {
  alias = "mock"
}

run "topic_name" {
    command = plan

    providers = {
        google      = google.mock
    }

    assert {
      condition = google_pubsub_topic.example.name == "example-topic"
      error_message = "Unexpected topic name"
    }
}