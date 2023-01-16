  resource "google_compute_firewall" "firewall" {
  project     = "hostproject-test"
  name           = "test-rule-1"
  network        = "projects/hostproject-test/global/networks/test"
  provider       = "google-beta"
  description    = "Allow All Egress"
  #@enable_logging@
  direction      = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority       = "1000"
  target_tags    = "${var.tags}"
  allow { #1
  protocol = "all" #1
  } #1
