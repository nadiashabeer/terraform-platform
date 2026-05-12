terraform {
  cloud {
    organization = "Self-Learning-Projects-Org" # Replace with your org from Phase 3

    workspaces {
      name = "platform-prod"
    }
  }
}