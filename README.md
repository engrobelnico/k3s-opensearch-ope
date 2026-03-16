# opensearch operator deploy on k3s

helm dependency update

argocd app delete opensearch --cascade
argocd app terminate-op opensearch

{"statusCode":401,"error":"Unauthorized","message":"Authentication required"}

https://opensearch.org/docs/latest/install-and-configure/install-opensearch/helm/

curl -XGET https://kube.local/opensearch -u 'admin:VerySecurePassword12!' --insecure
curl -XGET https://172.17.230.183/opensearch/_plugins/_security/api/securityconfig?pretty -u 'admin:admin' --insecure

kctl get opensearchclusters --all-namespaces
sudo kubectl delete opensearchclusters opensearch -n opensearch

# Troubleshooting
# If sync fails with "one or more synchronization tasks are not valid", it is likely due to CRD size.
# Enable ServerSideApply for the application:
# argocd app set <app-name> --sync-option ServerSideApply=true