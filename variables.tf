variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = "hcl-sap-poc"
}



variable "vpcname" {
  description = "The name to use for VPC, if not set the default name is used."
}

variable "description" {
  description = "An optional description of this resource"
  default     = "Test"
}

variable "routing_mode" {
  description = "VPC routing mode"
  default     = "GLOBAL"
}

variable "auto_create_subnetworks" {
  description = "When set to true, the network is created in auto subnet mode and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in custom subnet mode so the user can explicitly connect subnetwork resources"
  default     = true
}
variable "delete_default_routes_on_create"{
 description = "delete_default_routes_on_create true/false"
}
