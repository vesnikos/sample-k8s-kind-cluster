# KiND Demo

This is a sample/demo that deploys localy a working k8s cluster using KiND (Kubernetes in Docker). 

The cluster is provisioned with an Ingress service  - [contour](https://projectcontour.io/) -  and a sample app, [httpbin](https://httpbin.org/) automatically provisioned.

The ingress gives you one entry point into the cluster but allows you to access multiple services. 

It's designed for L7 applications.


## Features?

- Disposable.  
- Works on Windows, Linux and MacOS(maybe) 
- Minimal interference with your computer. Nodes are containers. 
- One command to (re)create the cluster. `make cluster`
- Cluster is defined as code. Check the `kind-config.yaml` file. It defines 1 control plane and 1 worker node and ports to expose.
- Nodes are accessible via `kubectl` commands.
- Built-in sample app. After `make cluster` you can access the sample app via `http://httpbin-local.vescorp.eu' 

## Demo


1. (Optional) Install the required software. See the [Req](#req) section.
1. Clone the repo
1. Run `make cluster`
1. Wait for the httpbin app to be deployed.
  - `kubectl rollout status deployment/httpbin`
1. Access the app via `http://httpbin-local.vescorp.eu`
1. make-changes
1. Rebuild the cluster `make cluster`
1. Delete the cluster `make clean`


## Demo 2 - Deploy joomla-crm

### Pre-requisites
 
1. Install helm
1. Activate bitami repository:  
   `helm repo add bitnami https://charts.bitnami.com/bitnami`
1. deploy joomla into the cluster:  
   `helm install bitnami/joomla --set ingress.enabled=true,ingress.hostname=joomla-local.vescorp.eu,ingress.pathType=Prefix --generate-name`
1. wait for it to rollout 
1. access the administrator portal at: http://joomla-local.vescorp.eu/administrator/


## Requirements

1. Internet connection

software: 

1. [KiND](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
1. GnuMake 
1. Kubernetes CLI (kubectl)
1. Powershell (windows)

## (Easy route) windows:

> [!TIP]
> You can maybe use scoop if you don't like choco. I don't recommend the build-in winget as it tends to be out-dated?


### Install choco


| Software | link                                                                                     | Description                  |
| -------- | ---------------------------------------------------------------------------------------- | ---------------------------- |
| choco    | Follow installation instructions from [https://chocolatey.org/](https://chocolatey.org/) | Package manager for Windows. |
---- 
| Software                | Installation Command            | Description                                                                                       |
| ----------------------- | ------------------------------- | ------------------------------------------------------------------------------------------------- |
| gsudo (Optional)        | `choco install gsudo`           | Enables running commands with elevated privileges (like `sudo` on Linux).  Useful for Windows 11. |
| kubectl                 | `choco install kubernetes-cli`  | Kubernetes Command Line Interface (CLI)                                                           |
| kind                    | `choco install kind`            | Tool for creating local Kubernetes clusters.                                                      |
| docker                  | `choco install docker-desktop`  | Docker container engine. Alternatively, install manually.                                         |
| gnu make                | `choco install make`            | Makefile executor.                                                                                |
| powershell-7 (Optional) | `choco install powershell-core` | Modern version of PowerShell. Might be necessary for some tools.                                  |

----

