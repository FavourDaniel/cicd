apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  annotations:
    deimos.io/environment-local: deploy
    deimos.io/environment-development: deploy
    deimos.io/environment-staging: deploy
    deimos.io/environment-production: deploy
  name: deimos.io
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: Managed infrastructure components
  sourceRepos:
    - "*"
  destinations:
    - namespace: "*"
      server: "*"
  clusterResourceWhitelist:
    - group: "*"
      kind: "*"
  namespaceResourceWhitelist:
    - group: "*"
      kind: "*"