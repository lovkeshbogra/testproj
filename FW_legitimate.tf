resource "compute_firewall" "firewall" {
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
  }


resource "compute_firewall" "firewall" {
  project     = "hostproject-test"
  name           = "test-rule-2"
  network        = "projects/hostproject-test/global/networks/test"
  provider       = "google-AWS-AZURE"
  description    = "Allow Inbound"
  #@enable_logging@
  direction      = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags    = "${var.tags}"
  priority       = "1001"
  allow { #1
  protocol = "tcp" #2
  ports = ["80","8080","15021","443","15017","15014","15018","8676","2022","8443","6443","53","22","3389"] #1
  } #2
  }

resource "compute_firewall" "firewall" {
  project     = "hostproject-test"
  name           = "test-rule-1"
  network        = "projects/hostproject-test/global/networks/test"
  provider       = "google-AWS-Azure"
  description    = "Baseline Deny All"
  #@enable_logging@
  direction      = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority       = "1000"
  target_tags    = "${var.tags}"
  deny { #3
  protocol = "all" #3
  } #3
}
