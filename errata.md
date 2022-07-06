# Errata & Improvements

## Page 54 - Using KinD's storage provisioner

In the book, the following line on page 54:

We do need to include the `StorageClass` option since KinD has set a default `StorageClass` for the cluster.

Should be:

We do **not** need to include the `StorageClass` option since KinD has set a default `StorageClass` for the cluster.
