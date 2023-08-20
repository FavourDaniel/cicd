# favour-cicd

[![Open in Remote - Containers](https://img.shields.io/static/v1?label=Remote%20-%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/DeimosCloud/favour-cicd.git)

The [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) visual studio code extension is required to run the environment. 

The [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers) article provides more information about remote containers.

## Environment variables

The following environment variables need to be defined on your local machine:

|Name|Description|
|----|-----------|
|`GITHUB_TOKEN`|Your GitHub Personal Access Token ([PAT](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)).%7C
|`GITHUB_EMAIL`|Your verified GitHub email address.|
|`GITHUB_USER`|Your GitHub user name.|
The environment variables can be set as follows:

```bash


export GITHUB_TOKEN=xxxxxxxx
export GITHUB_EMAIL=xxxxxxxx
export GITHUB_USER=xxxxxxxx

```

Run VS Code from the terminal(in the context of myapp), see the following [article](https://code.visualstudio.com/docs/setup/mac) if running on `macOS`:

```bash
code .
```

## Documentation

The documentation can be accessed from within the devcontainer.

```bash
mkdocs serve
```

## Cluster setup

When running the devcontainer in VS Code, you can set the cluster up by running the following in a terminal in VS Code.

```bash
./setup-cluster.sh
```

One of the steps in the script will ask you for a authorization token for Google. You will see it gives you a URL that you can click on to log-in, and that will generate the authorization token you need.

If asked if you want to configure a default Compute Region and Zone - Select No

To start your minikube cluster.

```bash
minikube start -p favour-cicd
```

## ArgoCD 

### Credentials

```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

## Dashboard 

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Jaeger

```bash
kubectl port-forward svc/allinone-query -n observability 16686:16686
```

## Grafana

```bash
kubectl port-forward svc/kube-prometheus-stack-grafana -n observability 80:80
```
User is `admin` and the password `prom-operator`.

## GCP Cluster Access

You can access a gcp cluster from your devcontainer.

1. Set up your kubectl to point to the gcp cluster with the following command:

    ```bash
    gcloud container clusters get-credentials <cluster> --zone=europe-west1 --internal-ip
    ```

2. Copy your openvpn file to the devcontainer or use gloud to copy it.

    ````
    gcloud compute scp <openvpn virtual machine>:/home/ubuntu/<user>.ovpn ./<local>.ovpn --project <gcp projec>
    ``

3. Open a new terminal and initiate your vpn connection:

    ```
    sudo openvpn --config <ovpn file>
    ```
4. To switch back to your minikube cluster issue the following command:

    ```bash
    minikube update-context -p favour-cicd
    ```

### Issues

While your VPN is connected you will:

- not be able to issue any gcloud commands
- not be able to push any code

You can add the following entries to your `ovpn` file to resolve these issues:

```config
dhcp-option DNS 8.8.8.8
dhcp-option DNS 1.1.1.1

pull-filter ignore redirect-gateway
route-nopull
route 10.0.0.0 255.255.255.0
```


