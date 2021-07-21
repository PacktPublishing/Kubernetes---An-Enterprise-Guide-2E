package k8sallowedregistries

violation[{"msg": msg, "details": {}}] {
  invalidRegistry
  msg := "Invalid registry"
}

# returns true if a valid registry is not specified
invalidRegistry {
  ok_images = [image | startswith(input_images[i],input.parameters.registries[_]) ; image = input_images[i] ]
  count(ok_images) != count(input_images)
}

input_images[image] {
  image := input.review.object.spec.template.spec.containers[_].image
}

input_images[image] {
  image := input.review.object.spec.containers[_].image
}

input_images[image] {
  image := input.review.object.spec.jobTemplate.spec.template.spec.containers[_].image
}



