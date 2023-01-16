resource "google_compute_firewall" "firewall" {
  project     = "${var.project}"
  name           = "${var.firewallname}"
  network        = "${var.network}"
  provider       = "google-beta"
  description    = "${var.description}"
  #@enable_logging@
  direction      = "${var.direction}"
  source_ranges = ["0.0.0.0/0"     ]
  priority       = "${var.priority}"
  target_tags    = "${var.tags}"
  allow { #1
  protocol = "tcp" #1
  ports = ["80","8080","15021","443","15017","15014","15018","8676","2022","8443","6443","53","22","3389"] #1
  } #1
