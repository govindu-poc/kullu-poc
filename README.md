######################################
Install Litmus Open Source Application
######################################
Steps:
=====
1. Create namespace litmus
2. Create Storage class
3. helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/
4. helm repo update
5. helm install chaos litmuschaos/litmus   
  --namespace litmus   
  --set portal.frontend.service.type=NodePort   
  --set mongodb.persistence.storageClass=gp2-wait   
  --set mongodb.persistence.size=1Gi   
  --set mongodb.persistence.accessModes[0]=ReadWriteOnce
7. kubectl get po -n litmus
8. kubectl get svc -n litmus  
9. To access portal from browser so the port forward with below command:
  kubectl port-forward -n litmus svc/chaos-litmus-frontend-service 9091:9091

10. trouble shooting
====================
Steps to fix
Run:
kubectl edit configmap subscriber-config -n litmus
Find the line:
SERVER_ADDR: http://localhost:9091/api/query
Replace it with:
SERVER_ADDR: http://chaos-litmus-frontend-service.litmus.svc.cluster.local:9091/api/query

####################################
How to Deploy Terraform Envoronments
####################################
###################
#      Dev      #
###################
terraform init -backend-config=backend-dev.tf
terraform apply -var-file=dev.tfvars

###################
#      Stage      #
###################
terraform init -backend-config=backend-stage.tf
terraform apply -var-file=stage.tfvars

###################
#      Prod      #
###################
terraform init -backend-config=backend-prod.tf
terraform apply -var-file=prod.tfvars