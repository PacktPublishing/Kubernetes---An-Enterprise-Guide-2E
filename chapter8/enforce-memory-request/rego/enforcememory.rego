package k8senforcememoryrequests

violation[{"msg": msg, "details": {}}] {
  invalidMemoryRequests
  msg := "No memory requests specified"
}

invalidMemoryRequests {
    data.
      inventory
      .namespace
      [input.review.object.metadata.namespace]
      ["v1"]
      ["ResourceQuota"]
    
    containers := input.review.object.spec.containers
    
    ok_containers = [ok_container | 
      containers[j].resources.requests.memory ; 
      ok_container = containers[j]  ]
    
    count(containers) != count(ok_containers)
}


