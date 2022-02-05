variable "project_id" {

}

data "google_project" "project" {
  project_id = var.project_id
}


resource "null_resource" "script_run" {
  triggers = {
    any = timestamp()
  }

  provisioner "local-exec" {
    command = "/bin/bash ${abspath(path.module)}/check.sh ${var.project_id}"
  }
}

output "project_number" {
  value = data.google_project.project.number
}