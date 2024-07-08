ifeq ($(OS),Windows_NT)
# Check if PowerShell exists
ifeq ($(shell powershell -command "& { Exit 0 }"),0)
  SHELL = powershell
else
  SHELL = cmd.exe
endif
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif


.PHONY: help
help: ## Print Makefile help.

ifeq ($(OS),Windows_NT) 
	@Get-Content $(MAKEFILE_LIST)| sort | ForEach-Object { if($$_ -match '^[a-z.A-Z_-]+:.*?## .*$$') {$$a,$$b = $$_.split(': ## ');write-host $$a -ForegroundColor Cyan -NoNewline ;write-host "`t $$b" -ForegroundColor DarkGray} }
else # not windows
	@egrep -Eh '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'
endif

cluster: ## (re)create a test cluster with kind
	kind delete cluster 
	kind create cluster --config kind-config.yaml
# install contour	
	@kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
	@kubectl wait --namespace projectcontour  --for=condition=ready pod --selector=app=contour   --timeout=90s
	@kubectl apply -f ./sample-service-httpbin.yaml
	@echo "Cluster created and ready to use"
	@echo "Access the sample httpbin service at: (wait for it rollout) "
	@echo http://httpbin-local.vescorp.eu/

clean: ## delete the test cluster
	@kind delete cluster
	@echo "Cluster deleted"