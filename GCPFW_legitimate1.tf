resource "google_compute_firewall" "firewall" {
  project     = "${var.project}"
  name           = "${var.firewallname}"
  network        = "${var.network}"
  provider       = "google-beta"
  description    = "${var.description}"
  #@enable_logging@
  direction      = "${var.direction}"
  destination_ranges = ["0.0.0.0/0"]
  priority       = "${var.priority}"
  target_tags    = "${var.tags}"
  allow { #1
  protocol = "all" #1
  } #1