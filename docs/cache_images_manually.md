# Cache Image

## List All Images in K8s Cluster

```bash
minikube -p playground image list> images_list.txt
```

## Pull All Images from Server to Local Host

```bash
cat images_list.txt | xargs -n 1 docker pull
```

## Load All Images from Local Host to K8s Cluster

```bash
cat images_list.txt | xargs -n 1 minikube -p playground image load --pull false --remote=true  --overwrite=false 
```