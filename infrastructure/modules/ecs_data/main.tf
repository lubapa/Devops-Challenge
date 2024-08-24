# Template Container
data "template_file" "container_definitions" {
  template = file("${path.module}/templates/container_definitions.json.j2")

  vars = {
    container_name  = var.container_name
    container_image = var.container_image
    memory          = "512"
    cpu             = "256"
  }
}