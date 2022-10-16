#!/bin/bash

minikube kubectl --profile playground -- \
  run proxy-socks5 \
  --image serjs/go-socks5-proxy \
  --restart=Always \
  --namespace=infra \
  --env PROXY_PORT=1085

kubectl port-forward pods/proxy-socks5 10855:1085 -n infra
