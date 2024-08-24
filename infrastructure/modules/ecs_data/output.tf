output "container_definitions" {
  value = data.template_file.container_definitions.rendered
  description = "Rendered container definitions for ECS."
}