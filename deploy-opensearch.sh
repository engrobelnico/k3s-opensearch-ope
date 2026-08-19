#!/bin/bash

# https://docs.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad

# Set the `errexit` option to make sure that
# if one command fails, all the script execution
# will also fail (see `man bash` for more 
# information on the options that you can set).
set -o errexit

main () {
    myNamespace=opensearch
    NS=$(sudo kubectl get namespace $myNamespace --ignore-not-found);
    if [[ "$NS" ]]; then
        echo "Skipping creation of namespace $myNamespace - already exists";
    else
        echo "Creating namespace $myNamespace";
        sudo kubectl create namespace $myNamespace;
    fi;
    # deploy opensearch operator with argocd
    sudo kubectl apply -n argocd -f cert-manager.yaml
    sudo kubectl apply -n argocd -f opensearch.yaml
    # sync the application
    argocd login kube.local:443 --grpc-web-root-path /argocd-server --insecure  --username admin --password $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

    # cert-manager must be serving before the operator's Certificate can be issued
    argocd app sync cert-manager --grpc-web-root-path /argocd-server
    argocd app wait cert-manager --health --timeout 300 --grpc-web-root-path /argocd-server

    argocd app sync opensearch-operator --grpc-web-root-path /argocd-server
}
main "$@"
