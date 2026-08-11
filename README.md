# opensearch operator deploy on k3s

helm dependency update

argocd app delete opensearch --cascade
argocd app terminate-op opensearch

{"statusCode":401,"error":"Unauthorized","message":"Authentication required"}

https://opensearch.org/docs/latest/install-and-configure/install-opensearch/helm/

curl -XGET https://kube.local/opensearch -u 'admin:VerySecurePassword12!' --insecure
curl -XGET https://172.17.230.183/opensearch/_plugins/_security/api/securityconfig?pretty -u 'admin:admin' --insecure

kctl get opensearchclusters --all-namespaces
kctl delete opensearchclusters opensearch -n opensearch

sudo kubectl patch application/opensearch-operator --type json --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]' -n argocd

kctl get namespace opensearch -o json | \
  jq '.spec.finalizers = []' | \
  kctl replace --raw "/api/v1/namespaces/opensearch/finalize" -f -

kctl wait --for=delete namespace/opensearch --timeout=60s

kubectl get policyreport -n opensearch