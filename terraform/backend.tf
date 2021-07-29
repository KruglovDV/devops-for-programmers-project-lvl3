terraform {
  backend "remote" {
    organization = "devops-project-dmitry"

    workspaces {
      name = "devops-project"
    }
  }
}
