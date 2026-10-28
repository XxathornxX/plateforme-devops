# TP1 : La plateforme en code

❯ kind get clusters

No kind clusters found.

## 1. Le cluster

### Dans infra/versions.tf, déclare le provider tehcyx/kind.

../plateforme-devops/infra/versions.tf

### Dans infra/main.tf, déclare une ressource kind_cluster nommée plateforme, avec wait_for_ready = true.

../plateforme-devops/infra/main.tf

### Lance terraform init, puis terraform plan. Lis le plan avant d'appliquer.

❯ terraform init

```python
Initializing the backend...

Initializing provider plugins...
- Finding tehcyx/kind versions matching "~> 0.13.0"...
- Installing tehcyx/kind v0.13.0...
- Installed tehcyx/kind v0.13.0 (self-signed, key ID A8CCEA05E06A4307)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://developer.hashicorp.com/terraform/cli/plugins/signing

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Lance terraform init, puis terraform plan. Lis le plan avant d'appliquer.

❯ terraform plan

```python
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # kind_cluster.default will be created
  + resource "kind_cluster" "default" {
      + client_certificate     = (known after apply)
      + client_key             = (known after apply)
      + cluster_ca_certificate = (known after apply)
      + completed              = (known after apply)
      + context_name           = (known after apply)
      + endpoint               = (known after apply)
      + id                     = (known after apply)
      + kubeconfig             = (known after apply)
      + kubeconfig_path        = (known after apply)
      + name                   = "plateforme"
      + node_image             = (known after apply)
      + wait_for_ready         = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

❯ terraform apply

```python
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # kind_cluster.plateforme will be created
  + resource "kind_cluster" "plateforme" {
      + client_certificate     = (known after apply)
      + client_key             = (known after apply)
      + cluster_ca_certificate = (known after apply)
      + completed              = (known after apply)
      + context_name           = (known after apply)
      + endpoint               = (known after apply)
      + id                     = (known after apply)
      + kubeconfig             = (known after apply)
      + kubeconfig_path        = (known after apply)
      + name                   = "plateforme"
      + node_image             = (known after apply)
      + wait_for_ready         = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

kind_cluster.plateforme: Creating...
kind_cluster.plateforme: Still creating... [00m10s elapsed]
kind_cluster.plateforme: Still creating... [00m20s elapsed]
kind_cluster.plateforme: Creation complete after 28s [id=plateforme-]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

❯ kubectl --context kind-plateforme get nodes

```python
NAME                       STATUS   ROLES           AGE    VERSION
plateforme-control-plane   Ready    control-plane   110s   v1.37.0
```

❯ terraform state list

```python
kind_cluster.plateforme
```

## 2. ArgoCD


### Ajoute le provider hashicorp/helm et configure-le pour qu'il se connecte au cluster que tu viens de déclarer (quatre attributs de la ressource kind_cluster).
    
../plateforme-devops/infra/main.tf
../plateforme-devops/infra/versions.tf
    
### Déclare une ressource helm_release nommée argocd (name = "argocd", c'est ce qui donne leur nom aux composants d'ArgoCD) qui installe le chart argo-cd du dépôt https://argoproj.github.io/argo-helm, dans le namespace argocd, en version 10.10.3, avec create_namespace = true et timeout = 600.

../plateforme-devops/infra/main.tf
../plateforme-devops/infra/versions.tf
    
### terraform init (nouveau provider), terraform plan, terraform apply.

❯ terraform init

```python
Initializing the backend...

Initializing provider plugins...
- Reusing version 0.13.0 of tehcyx/kind from the dependency lock file
- Reusing version 3.3.0 of hashicorp/helm from the dependency lock file
- Using previously-installed tehcyx/kind v0.13.0
- Using previously-installed hashicorp/helm v3.3.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

❯ terraform plan

```python
kind_cluster.plateforme: Refreshing state... [id=plateforme-]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # helm_release.argocd will be created
  + resource "helm_release" "argocd" {
      + atomic                     = false
      + chart                      = "argo-cd"
      + cleanup_on_fail            = false
      + create_namespace           = true
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "argocd"
      + namespace                  = "argocd"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://argoproj.github.io/argo-helm"
      + reset_values               = false
      + reuse_values               = false
      + set_wo                     = (write-only attribute)
      + skip_crds                  = false
      + status                     = "deployed"
      + take_ownership             = false
      + timeout                    = 600
      + upgrade_install            = false
      + verify                     = false
      + version                    = "10.10.3"
      + wait                       = true
      + wait_for_jobs              = false
    }

Plan: 1 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you
run "terraform apply" now.
```

kubectl --context kind-plateforme -n argocd get pods

```python
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          63s
argocd-applicationset-controller-564c4cfcdb-cxmm5   1/1     Running   0          63s
argocd-dex-server-b99999dbd-nq55r                   1/1     Running   0          63s
argocd-notifications-controller-6dcfd8bbc7-l65z6    1/1     Running   0          63s
argocd-redis-87796cdbd-tll7n                        1/1     Running   0          63s
argocd-repo-server-d7b4d479-mw9f9                   1/1     Running   0          63s
argocd-server-587777b5d4-n98wj                      1/1     Running   0          63s
```

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Attends que tous les pods soient Running, puis commite.

!WARNING!

J'ai eu le droit à un piège 

terraform apply semble bloqué sur helm_release : l'installation d'ArgoCD télécharge plusieurs images, compte une à trois minutes la première fois.

Le first test à failed, il indique que il ne peut pas com avec la ressource demandé après un autre try c'était réglé.

```python
argocd  argocd          1               2026-10-28 15:01:10.975599174 +0100 CET failed  argo-cd-10.10.3 v3.5.5     
```