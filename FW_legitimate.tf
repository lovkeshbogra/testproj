resource "VM_firewall" "firewall" {
  project     = "hostproject-test"
  name           = "test-rule-2"
  network        = "projects/hostproject-test/global/networks/test"
  provider       = "google-beta"
  description    = "Allow Inbound"
  #@enable_logging@
  direction      = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags    = "${var.tags}"
  priority       = "1001"
  allow { #1
  protocol = "tcp" #1
  ports = ["443"] #1
  } #1
  }
