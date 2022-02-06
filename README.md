# terraform-hasura

A multi-environment module based hasura deployment configuration utilizing terraform and kubernetes

## Getting started -- What you'll need

### A Kubernetes Cluster:

If your machine is running on `ubuntu`, you can setup a very simple kubernetes cluster with `microk8s` as follows:

1. Install `snap` by running:

```shell
  sudo apt-get 
  sudo apt-get install snap
```

2. Install the `MicroK8s` distribution by running:

```shell
  sudo snap install microk8s --classic
```

3. Enable the `dns`, `storage`, `helm3` addons by running:

```shell
  microk8s enable dns storage helm3
```

- If you want a useful kubernetes GUI you can also append `dashboard` to the space-separated list of addons
- Additionally, you can find all the available addons by running `microk8s status` which will show the list of all
  enabled and disabled addons

5. Enable `metallb` on your MicroK8s cluster by running:

```shell
  microk8s enable metallb:<reseved-ip-range>
```

- For example, if you wanted to start metallb on a single IP (10.0.0.3), you would run:

```shell
  microk8s enable metallb:10.0.0.3-10.0.0.3
```

### Setting up Cloudflare Challenge Based SSL with Traefik

Required: A domain setup with Cloudflare

1. Create a Cloudflare API token via My Profile/API Tokens/Create Token
2. The token will need Zone.Zone Read and Zone.DNS Edit permissions.
3. Create a kubernetes secret that can be utilized by Traefik to perform letsencrypt challenge auth by running
4. Create an A record for the domain you will be using mapping `@` to the external IP you gave to `metallb` earlier
5. Create CNAME records for all the subdomains that you wish to deploy, example: `graphql-dev.yourdomain.com`

```shell
kubectl create secret generic cloudflare --from-literal=dns-token=<your-token>
```

### Traefik Running on your MicroK8s Cluster:

1. Create a new file called `traefik-values.yaml` with the following content

```yaml
additionalArguments:
  - "--certificatesresolvers.letsencrypt.acme.email=you@youremaildomain"
  - "--certificatesresolvers.letsencrypt.acme.storage=/data/acme.json"
  - "--certificatesresolvers.letsencrypt.acme.caserver=https://acme-v02.api.letsencrypt.org/directory"
  - "--certificatesResolvers.letsencrypt.acme.dnschallenge=true"
  - "--certificatesResolvers.letsencrypt.acme.dnschallenge.provider=cloudflare"
  - "--api.insecure=true"
  - "--accesslog=true"
  - "--log.level=INFO"
env:
  - name: CF_DNS_API_TOKEN
    valueFrom:
      secretKeyRef:
        name: cloudflare
        key: dns-token
```

2. Install traefik via helm by running:

```shell
  microk8s helm3 install traefik traefik/traefik -f ./traefik-values.yaml 
```

3. If everything went successfully you should be able to visit the traefik dashboard at http://localhost:9000 by
   port-forwarding it via:

```shell
microk8s kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000 
```

### Setting up Terraform with MicroK8s:

1. Install Terraform by following this [documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Obtain your MicroK8s kubeconfig information by running:

```shell
microk8s config
```

2. Create a `variables.auto.tfvars` file using the `example.tfvars` file with the output from the command as follows

```dotenv
host                   = <an-accessible-ip-to-access-your-cluster>
token                  = <config.users[0].user.token>
cluster_ca_certificate = <config.clusters[0].certificate-authority-data>
```

3. Update the `variables.auto.tfvars` file to include the list of environments you would like to deploy via:

```dotenv
environments = [
  {
    environment_namespace       = "dev"
    hasura_graphql_dev_mode     = true
    hasura_graphql_admin_secret = "test"
    hasura_graphql_url          = "graphql-dev.yourdomain.com"
    postgres_db                 = "postgres"
    postgres_password           = "postgres"
    postgres_user               = "postgres"
  }
]
```

4. Initialize terraform in your folder by running `terraform init`
5. Check that everything is setup properly by running `terraform plan`
6. Assuming the output looks proper, apply the configuration by running `terraform apply` and they confirming with `yes`

If everything worked properly you should have a dedicated PVC based PostgreSQL deployment & hasura deployment for each
of your environments.

### v1.0.0 Roadmap

- [X] Allow for the consistent deployment & updates of multiple environments via Terraform Modules
- [ ] Support more environment specific customization of both hasura/postgres attributes and kubernetes deployment
  attributes.
- [ ] Add support for collecting metrics and monitoring with Grafana/Prometheus
