run "topic_name" {
    command = plan

    assert {
      condition = google_pubsub_topic.example.name == "example-topic"
      error_message = "Unexpected topic name"
    }
}