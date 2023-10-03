terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "tomcat_thread_deadlock_conditions_detected" {
  source    = "./modules/tomcat_thread_deadlock_conditions_detected"

  providers = {
    shoreline = shoreline
  }
}