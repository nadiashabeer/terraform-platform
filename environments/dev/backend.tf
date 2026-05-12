terraform {
  cloud {
    organization = "Self-Learning-Projects-Org" # Ensure NO spaces or typos

    workspaces {
      name = "platform-dev" #Change
    }
  }
}
