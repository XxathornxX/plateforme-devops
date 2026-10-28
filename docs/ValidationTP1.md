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
