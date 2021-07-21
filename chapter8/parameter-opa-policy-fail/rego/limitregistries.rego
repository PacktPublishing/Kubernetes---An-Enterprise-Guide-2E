package k8sallowedregistries

violation[{"msg": msg, "details": {}}] {
  invalidRegistry
  msg := "Invalid registry"
}

# returns true if a valid registry is not specified
invalidRegistry {
  trace(sprintf("input_images : %v",[input_images]))
  ok_images = [image |   
    trace(sprintf("image %v",[input_images[j]]))
    startswith(input_images[j],input.parameters.registries[_]) ; 
    image = input_images[j] 
  ]
  trace(sprintf("ok_images %v",[ok_images]))
  trace(sprintf("ok_images size %v / input_images size %v",[count(ok_images),count(input_images)]))
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



