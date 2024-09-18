# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  realized_billing_project = var.billing_project != "" ? var.billing_project : var.project_id
}

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
  backend "gcs" {
    bucket = "asset-dashboard-terraform-state-PROJECT-ID-HERE"
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  user_project_override = var.user_project_override
  billing_project = local.realized_billing_project
}

provider "docker" {
  registry_auth {
    address  = "${google_artifact_registry_repository.image_repository.location}-docker.pkg.dev"
  }
}
