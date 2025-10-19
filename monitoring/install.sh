#!/bin/bash
function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) echo "Aborted" ; return 1 ;;
        esac
    done
}

# Usage in your script:
if yes_or_no "Did you changed the values to correct for the env marked as ##CHANGE##?"; then
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update prometheus-community
    helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 78.3.0 -f values.yaml --namespace monitoring
else
    # Handle the case when the answer is no
    echo "Aborted!"
fi
