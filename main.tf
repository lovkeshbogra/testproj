
provider "google" {
    credentials = "${file("C:/Users/shalini/Automation/JSON/767337750689/auth-hub-oneclick-01/secret.json")}"
  project     = "${var.project}"
	
}

provider "google-beta" {  
  credentials = "${file("C:/Users/shalini/Automation/JSON/767337750689/auth-hub-oneclick-01/secret.json")}"
   project     = "${var.project}"
}

resource "google_compute_network" "vpc" {
  provider                = "google-beta"
  project                 = "${var.project}"
  name                    = "${var.vpcname}"
  auto_create_subnetworks = "${var.auto_create_subnetworks}"
  routing_mode            = "${var.routing_mode}"
  description             = "${var.description}"
delete_default_routes_on_create = "${var.delete_default_routes_on_create}"
}










































































