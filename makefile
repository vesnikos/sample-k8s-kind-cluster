.DEFAULT_GOAL := help
ifeq ($(OS),Windows_NT)
SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -Command
endif

.PHONY: help clean pull-contour-files deploy-contour
# DEFAULT_INGRESS_ACTION := deploy_contour

DEFAULT_CLUSTER_STEPS := clean create-cluster deploy-contour deploy-sample-httpbin-app

help: ## Print Makefile help.
ifeq ($(OS),Windows_NT)
	@get-content $(MAKEFILE_LIST) | sort | ForEach-Object { if($$_ -match '^[a-z.A-Z_-]+:.*?## .*$$') {$$a,$$b = $$_.split(': ## ');write-host $$a -ForegroundColor Cyan -NoNewline ;write-host "`t $$b" -ForegroundColor DarkGray} }
else # not windows
	@egrep -Eh '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'
endif

deploy-sample-httpbin-app: ## Deploy Sample Httpbin App
	@kubectl apply -f deployments/httpbin/httpbin-stack.yaml 

	@echo "App deployed. You can access it at"
	@echo "(wait a bit for the app to start):"
	@echo ""
	@echo http://httpbin-local.vescorp.eu/
	@echo ""

deploy-contour: ## Deploy Contour Ingress Controller
	@kubectl apply -k ingress/contour
	@kubectl wait --namespace projectcontour  --for=condition=ready pod --selector=app=contour   --timeout=90s

deploy-nginx-ingress: ## Deploy Nginx Ingress Controller
	@kubectl apply -k ingress/nginx
	@kubectl wait --namespace ingress-nginx  --for=condition=ready pod --selector=app.kubernetes.io/component=controller   --timeout=90s

create-cluster: 
	@kind create cluster --config kind/kind-config.yaml

cluster: $(DEFAULT_CLUSTER_STEPS) ## (re)create a test cluster with kind

clean: ## delete the test cluster
	@kind delete cluster
	@echo "Cluster deleted"