package k8sallowedregistries

violation[{"msg": msg, "details": {}}] {
  invalidRegistry
  msg := "Invalid registry"
}


# returns true if a valid registry is not specified
invalidRegistry {
  input_images[image]
  not startswith(image, "quay.io/")
}

# load images from Pod objects
input_images[image] {
  image := input.review.object.spec.containers[_].image
}

# load images from Deployment and StatefulSet objects
input_images[image] {
  image := input.review.object.spec.template.spec.containers[_].image
}

# load images from CronJob objects
# Uncomment in chapter 8
#input_images[image] {
#  image := input.review.object.spec.jobTemplate.spec.template.spec.containers[_].image
#}