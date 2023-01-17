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
  protocol = "tcp" #1
  ports = ["80","8080","15021","443","15017","15014","15018","8676","2022","8443","6443","53","22","3389"] #1
  } #1
  }