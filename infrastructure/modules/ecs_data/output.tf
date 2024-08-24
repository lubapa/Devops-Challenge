# Used to create an ecs container definitions
output "container_definitions_rendered" {
  value = data.template_file.container_definitions.rendered
  description = "Rendered container definitions for ECS."
}