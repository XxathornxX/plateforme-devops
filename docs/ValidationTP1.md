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

## 3. Ouvre l'interface d'ArgoCD

#### le mot de passe du compte admin
kubectl --context kind-plateforme -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d ; echo

```python
OBTENU
```
#### l'interface sur https://localhost:8443 (laisse cette commande tourner)
kubectl --context kind-plateforme -n argocd port-forward svc/argocd-server 8443:443

Connecte-toi avec admin. L'interface est vide : c'est normal, tu n'as encore rien confié à ArgoCD. 
Tu y reviendras au TP2.

```python
OBTENU
```

## 4. Des modules

Ton main.tf mélange deux sujets. Sépare-les.

### Crée infra/modules/cluster/ : la ressource kind_cluster, une variable nom, et les quatre output dont le provider Helm a besoin.

```python
FAIT
```

### Crée infra/modules/argocd/ : la ressource helm_release, une variable version_chart.

```python
FAIT
```

### Dans infra/main.tf, il ne reste que deux blocs module.

```python
OUI
```

### Le provider Helm lit maintenant les sorties du module : module.cluster.endpoint, etc.

```python
OUI
```
❯ terraform init

```python
Initializing the backend...

Initializing modules...

Initializing provider plugins...
- Reusing version 3.3.0 of hashicorp/helm from the dependency lock file
- Reusing version 0.13.0 of tehcyx/kind from the dependency lock file
- Using previously-installed hashicorp/helm v3.3.0
- Using previously-installed tehcyx/kind v0.13.0

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
module.cluster.kind_cluster.plateforme: Refreshing state... [id=plateforme-]
module.argocd.helm_release.argocd: Refreshing state... [id=argocd]

Terraform will perform the following actions:

  # helm_release.argocd has moved to module.argocd.helm_release.argocd
    resource "helm_release" "argocd" {
        id                         = "argocd"
        name                       = "argocd"
        # (30 unchanged attributes hidden)
    }

  # kind_cluster.plateforme has moved to module.cluster.kind_cluster.plateforme
    resource "kind_cluster" "plateforme" {
        id                     = "plateforme-"
        name                   = "plateforme"
        # (9 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these
actions if you run "terraform apply" now.
```

❯ terraform apply

```python
module.cluster.kind_cluster.plateforme: Refreshing state... [id=plateforme-]
module.argocd.helm_release.argocd: Refreshing state... [id=argocd]

Terraform will perform the following actions:

  # helm_release.argocd has moved to module.argocd.helm_release.argocd
    resource "helm_release" "argocd" {
        id                         = "argocd"
        name                       = "argocd"
        # (30 unchanged attributes hidden)
    }

  # kind_cluster.plateforme has moved to module.cluster.kind_cluster.plateforme
    resource "kind_cluster" "plateforme" {
        id                     = "plateforme-"
        name                   = "plateforme"
        # (9 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

Regarde bien ce plan : Terraform propose de détruire puis recréer tes ressources, parce que leur adresse a changé (kind_cluster.this est devenu module.cluster.kind_cluster.this). Sur une vraie infrastructure, ce serait une panne : on l'éviterait avec un bloc moved. Ici, c'est sans conséquence : applique.

## 5. Modules

#### Déclare dans infra/variables.tf les variables nom_cluster et version_argocd.

../plateforme-devops/infra/variables.tf

### Donne leurs valeurs dans infra/plateforme.tfvars.

../plateforme-devops/infra/plateforme.tfvars

### Plus aucune valeur en dur dans main.tf.

../plateforme-devops/infra/main.tf

❯ terraform apply -var-file=plateforme.tfvars

```python
module.cluster.kind_cluster.plateforme: Refreshing state... [id=plateforme-]
module.argocd.helm_release.argocd: Refreshing state... [id=argocd]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no
changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

```python
FAIT
```

❯ terraform destroy -var-file=plateforme.tfvars
```python

module.cluster.kind_cluster.plateforme: Refreshing state... [id=plateforme-]
module.argocd.helm_release.argocd: Refreshing state... [id=argocd]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # module.argocd.helm_release.argocd will be destroyed
  - resource "helm_release" "argocd" {
      - atomic                     = false -> null
      - chart                      = "argo-cd" -> null
      - cleanup_on_fail            = false -> null
      - create_namespace           = true -> null
      - dependency_update          = false -> null
      - disable_crd_hooks          = false -> null
      - disable_openapi_validation = false -> null
      - disable_webhooks           = false -> null
      - force_update               = false -> null
      - id                         = "argocd" -> null
      - lint                       = false -> null
      - max_history                = 0 -> null
      - metadata                   = {
          - app_version    = "v3.5.5" -> null
          - chart          = "argo-cd" -> null
          - first_deployed = 1793197038 -> null
          - last_deployed  = 1793197038 -> null
          - name           = "argocd" -> null
          - namespace      = "argocd" -> null
          - notes          = <<-EOT
                In order to access the server UI you have the following options:
                
                1. kubectl port-forward service/argocd-server -n argocd 8080:443
                
                    and then open the browser on http://localhost:8080 and accept the certificate
                
                2. enable ingress in the values file `server.ingress.enabled` and either
                      - Add the annotation for ssl passthrough: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
                      - Set the `configs.params."server.insecure"` in the values file and terminate SSL at your ingress: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts
                
                
                After reaching the UI the first time you can login with username: admin and the random password generated during the installation. You can find the password by running:
                
                kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
                
                (You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)
            EOT -> null
          - revision       = 1 -> null
          - values         = jsonencode({})
          - version        = "10.10.3" -> null
        } -> null
      - name                       = "argocd" -> null
      - namespace                  = "argocd" -> null
      - pass_credentials           = false -> null
      - recreate_pods              = false -> null
      - render_subchart_notes      = true -> null
      - replace                    = false -> null
      - repository                 = "https://argoproj.github.io/argo-helm" -> null
      - reset_values               = false -> null
      - reuse_values               = false -> null
      - set_wo                     = (write-only attribute) -> null
      - skip_crds                  = false -> null
      - status                     = "deployed" -> null
      - take_ownership             = false -> null
      - timeout                    = 600 -> null
      - upgrade_install            = false -> null
      - verify                     = false -> null
      - version                    = "10.10.3" -> null
      - wait                       = true -> null
      - wait_for_jobs              = false -> null
    }

  # module.cluster.kind_cluster.plateforme will be destroyed
  - resource "kind_cluster" "plateforme" {
      - client_certificate     = <<-EOT
            -----BEGIN CERTIFICATE-----
            MIIDKTCCAhGgAwIBAgIIYZeX0DcOpH8wDQYJKoZIhvcNAQELBQAwFTETMBEGA1UE
            AxMKa3ViZXJuZXRlczAeFw0yNjEwMjgxMTEyMDRaFw0yNzEwMjgxMTE3MDRaMDwx
            HzAdBgNVBAoTFmt1YmVhZG06Y2x1c3Rlci1hZG1pbnMxGTAXBgNVBAMTEGt1YmVy
            bmV0ZXMtYWRtaW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC83IUN
            +t7xMSOe+MGDY/ObR9aID6idfWVzwAumOVDn3nZ+HBrfbCTriSosAPdPBbpGxX4G
            /u2GQSlCelHJmGcWgARI5ovHKF0lNLceaHYGgHOT7Y8uEjy6UgNpMl/5TgP7CAU3
            j52xrDjlGMIQYEN6ik6GBkTCb1e1T00o6DSuzEeQi/jinmsOTeWXqC4O4uDIMNhq
            1B5k9ZGvJ1NsWRDb/133fdkHNJdDGyanglQVexw+tWvKr28ZJa3kgXBS8zLcLRIY
            8Gpy8zdQpQTBDxRrlMqFmNNzlkGoyNexN2PENkR3RvtSchjPKZIasL35K6T/oPcA
            P/4bPKDy2V4gExLLAgMBAAGjVjBUMA4GA1UdDwEB/wQEAwIFoDATBgNVHSUEDDAK
            BggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFOkzoDrcrRzxzHWl
            EgEWeWHac7+OMA0GCSqGSIb3DQEBCwUAA4IBAQCX7kGuUxpuu0D4hqY8owtVteO8
            vz6LCNHSzBWRSAvz6TH8LfCdCIx3qoItZs3cDkqCzL2grJpVG/jV1jucAtpZ66NX
            k6ySN+1oPNaAYhTHFpUQvFuyo1sCUkKKa5Gb4mHQk68mmdhyKDd6lWB9pXvgcWdo
            fG2oz+bQGMahZeM8ypa1IO2jMDqO35PzTVfhhCk9lWRtY3xIHWK/RK5m8sGAGohr
            O3bfRPB685mOmpVrAUTaFT4w2XGkKV+sM1vWoE4ECiV9LaqHgqddXMbQLUkUVpGa
            mdSihojfYIASjoP9WxvGVRLjEGywWFMJ5WI8OQ8k5SNB7m51eN0vtBCB/0Ix
            -----END CERTIFICATE-----
        EOT -> null
      - client_key             = <<-EOT
            -----BEGIN RSA PRIVATE KEY-----
            MIIEogIBAAKCAQEAvNyFDfre8TEjnvjBg2Pzm0fWiA+onX1lc8ALpjlQ5952fhwa
            32wk64kqLAD3TwW6RsV+Bv7thkEpQnpRyZhnFoAESOaLxyhdJTS3Hmh2BoBzk+2P
            LhI8ulIDaTJf+U4D+wgFN4+dsaw45RjCEGBDeopOhgZEwm9XtU9NKOg0rsxHkIv4
            4p5rDk3ll6guDuLgyDDYatQeZPWRrydTbFkQ2/9d933ZBzSXQxsmp4JUFXscPrVr
            yq9vGSWt5IFwUvMy3C0SGPBqcvM3UKUEwQ8Ua5TKhZjTc5ZBqMjXsTdjxDZEd0b7
            UnIYzymSGrC9+Suk/6D3AD/+Gzyg8tleIBMSywIDAQABAoIBABS7dyvAChtGFAKj
            4h0PVYhf9s/8OrwB2PzqQcfJ659t5L9r9xM8Zu0oTeXYu/gDyUgdmVEhSRJ/iAz7
            1TX2h1KJU8RrnT/hUXWqd3OyGfVqwm/5wx8BR4NYn3aRM3HwZjAiLZhvfpXThxy3
            KWPs0rDatUtcgs3UCo0lGx5OJ1e3dVawmiz44OwFta8fFcnjS+mKIs+2o10e4Opr
            gqHFNDmMV+dPfKHvYcXMTipmLLLl+WMDpHS+MHrUb19hr9Mq9zwy42f0KobWtoRW
            vJhk7nRnOoqcy2N7rcwiHCUqRsdhCy1mSRi117ub3z4JaF0LczO+B8VAuB4AJC78
            Ig7yaTECgYEAyeauUw9xUebqfkt/E+6fi0yFYFnMgNYI/qUyspVmpSSwvq0Z5Ja4
            l37wUDSCJwAZ7GOll8dpXNcPEelW2Ga8Hdq0uFs+97S1Q3Uefq0G6yqn8neV0XyB
            B9r+UvoQqJiQ4AKb8cjmq6MffzaQef4eSiz5M3OMk2aB6FCZb65WJDkCgYEA73di
            /voUNJSYcgCW21iBeE0vIKeppf0C0x1AHGxYLZWHq5pbRkQ921uevBGPkADS7/vP
            PTg8E4bQqBwaUAN1bAaBuRxNJRBlWsl8yb3dhoqzf0F0ILYa3Jr4HWICMFXwANFe
            2+I7ntesRNqK9F041EA4f+IhpDsYdyrbCeNjFyMCgYAFi5huH5Z1MWpvXZN38K3h
            HZDsPIspXreQhukFjqTrFD7mfcqgRKN9RbdD/K02dQJBQ9tgd9GlAyMe0tHXz7qK
            917PUXJBS21PFQBpakcuXlWOi0pKHqlMle82SDf86XPRM0ElOuda/3f1/oGpWBls
            4B9YEmxiAAbBYrVUI+2pwQKBgA/nzSKEd80aRZnk4iBFm6vi7Ittt3339TUSj0yU
            AbNdaDqEsSVUqQsl5cA2JmP5OgmInzZAwvTFEpzn6POBl04KjJlAAPvCQAkssuYv
            f0RNeCiur0jw743RmUNSXDTbsGpNfdB7EVy2lJGqNmqOupSWg2ozGervpetcZFoe
            yVkjAoGAJ9K7tzPgXFT6jqpQLzdUbEZQo1yikBkAqXDfGJxARqEyo/voQk467WVS
            PSywNDchpDiuqxCDgh/Tr5Sr8qVMxM6V0PqbbyEu7L1iByFynHXewqO2kh3cZd9/
            GMcs5sgqYs+bJpzAKs8zXfeb2pCXt5AKXEHhVMey8KfQCu4Dhfc=
            -----END RSA PRIVATE KEY-----
        EOT -> null
      - cluster_ca_certificate = <<-EOT
            -----BEGIN CERTIFICATE-----
            MIIDBTCCAe2gAwIBAgIIJGaYRHOGUrAwDQYJKoZIhvcNAQELBQAwFTETMBEGA1UE
            AxMKa3ViZXJuZXRlczAeFw0yNjEwMjgxMTEyMDRaFw0zNjEwMjUxMTE3MDRaMBUx
            EzARBgNVBAMTCmt1YmVybmV0ZXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
            AoIBAQDhveW5DpH+JSylEiQL9PVfaiDCZk0wZk/oUiMq0umfwvsRfCbvhDFEjNRK
            t7eDkY0hccJsx76MKYwYow2MCOJr5J76xZm7Qw+tu70xCFFczsX/Bo7rtCMgYOw+
            KrEBMx6cjJcDcTNdR2J20saGFdffQGhiCvJHxVJGoRY3bF7QE0sCMN7q0ri4L5jw
            4CNYLL6VE5lTx3COacLa+9haIoWLx7nDx2q3j2r7f1JN0NwuvCliuu1SQeF9jaPw
            MnxxTrKhjZXEKq+ZPMJlJy6vFON6dGik8a1xFx8nsiY1s4TAKzZZEImc6O+ru0aL
            Y/sqZKxRXdvzRK6E+lxuuMHffMYfAgMBAAGjWTBXMA4GA1UdDwEB/wQEAwICpDAP
            BgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTpM6A63K0c8cx1pRIBFnlh2nO/jjAV
            BgNVHREEDjAMggprdWJlcm5ldGVzMA0GCSqGSIb3DQEBCwUAA4IBAQBEhP+7If6W
            2zuqVZFQFixZ0EoRGWgBrtb+NJbkevNrUED29inacIwn3vVn9hlmVyqvUs4pyzrp
            MmsbiEJWca1x3OeKEwKl3ruP9M/W7e2GFufjSUI0IYp2b/WjWUPEe4CYRG/gJsrb
            h5eKlRXWbCpTyPlRhuxtDIrN1l7ExB5JkIJN8Ghd7V76RSjV5eg1PO9zFETG8OEX
            mAuq/zTgDtKv7Mjsyw34Grh0f85QtoT9AoEdSweMVjXY3QrIsZF056YbWWkQEpph
            XIh5w6UTaPjeYZ+jea5wIn8JtvoTFIZAj6Z6Vm6amIkJiEL5r0OxVoDwPaa1yhrt
            E/u8th64kFWd
            -----END CERTIFICATE-----
        EOT -> null
      - completed              = true -> null
      - context_name           = "kind-plateforme" -> null
      - endpoint               = "https://127.0.0.1:43897" -> null
      - id                     = "plateforme-" -> null
      - kubeconfig             = <<-EOT
            apiVersion: v1
            clusters:
            - cluster:
                certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJSkdhWVJIT0dVckF3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TmpFd01qZ3hNVEV5TURSYUZ3MHpOakV3TWpVeE1URTNNRFJhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURodmVXNURwSCtKU3lsRWlRTDlQVmZhaURDWmswd1prL29VaU1xMHVtZnd2c1JmQ2J2aERGRWpOUksKdDdlRGtZMGhjY0pzeDc2TUtZd1lvdzJNQ09KcjVKNzZ4Wm03UXcrdHU3MHhDRkZjenNYL0JvN3J0Q01nWU93KwpLckVCTXg2Y2pKY0RjVE5kUjJKMjBzYUdGZGZmUUdoaUN2Skh4VkpHb1JZM2JGN1FFMHNDTU43cTByaTRMNWp3CjRDTllMTDZWRTVsVHgzQ09hY0xhKzloYUlvV0x4N25EeDJxM2oycjdmMUpOME53dXZDbGl1dTFTUWVGOWphUHcKTW54eFRyS2hqWlhFS3ErWlBNSmxKeTZ2Rk9ONmRHaWs4YTF4Rng4bnNpWTFzNFRBS3paWkVJbWM2TytydTBhTApZL3NxWkt4UlhkdnpSSzZFK2x4dXVNSGZmTVlmQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUcE02QTYzSzBjOGN4MXBSSUJGbmxoMm5PL2pqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQkVoUCs3SWY2VwoyenVxVlpGUUZpeFowRW9SR1dnQnJ0YitOSmJrZXZOclVFRDI5aW5hY0l3bjN2Vm45aGxtVnlxdlVzNHB5enJwCk1tc2JpRUpXY2ExeDNPZUtFd0tsM3J1UDlNL1c3ZTJHRnVmalNVSTBJWXAyYi9XaldVUEVlNENZUkcvZ0pzcmIKaDVlS2xSWFdiQ3BUeVBsUmh1eHRESXJOMWw3RXhCNUprSUpOOEdoZDdWNzZSU2pWNWVnMVBPOXpGRVRHOE9FWAptQXVxL3pUZ0R0S3Y3TWpzeXczNEdyaDBmODVRdG9UOUFvRWRTd2VNVmpYWTNRcklzWkYwNTZZYldXa1FFcHBoClhJaDV3NlVUYVBqZVlaK2plYTV3SW44SnR2b1RGSVpBajZaNlZtNmFtSWtKaUVMNXIwT3hWb0R3UGFhMXlocnQKRS91OHRoNjRrRldkCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
                server: https://127.0.0.1:43897
              name: kind-plateforme
            contexts:
            - context:
                cluster: kind-plateforme
                user: kind-plateforme
              name: kind-plateforme
            current-context: kind-plateforme
            kind: Config
            users:
            - name: kind-plateforme
              user:
                client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLVENDQWhHZ0F3SUJBZ0lJWVplWDBEY09wSDh3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TmpFd01qZ3hNVEV5TURSYUZ3MHlOekV3TWpneE1URTNNRFJhTUR3eApIekFkQmdOVkJBb1RGbXQxWW1WaFpHMDZZMngxYzNSbGNpMWhaRzFwYm5NeEdUQVhCZ05WQkFNVEVHdDFZbVZ5CmJtVjBaWE10WVdSdGFXNHdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDODNJVU4KK3Q3eE1TT2UrTUdEWS9PYlI5YUlENmlkZldWendBdW1PVkRuM25aK0hCcmZiQ1RyaVNvc0FQZFBCYnBHeFg0RwovdTJHUVNsQ2VsSEptR2NXZ0FSSTVvdkhLRjBsTkxjZWFIWUdnSE9UN1k4dUVqeTZVZ05wTWwvNVRnUDdDQVUzCmo1MnhyRGpsR01JUVlFTjZpazZHQmtUQ2IxZTFUMDBvNkRTdXpFZVFpL2ppbm1zT1RlV1hxQzRPNHVESU1OaHEKMUI1azlaR3ZKMU5zV1JEYi8xMzNmZGtITkpkREd5YW5nbFFWZXh3K3RXdktyMjhaSmEza2dYQlM4ekxjTFJJWQo4R3B5OHpkUXBRVEJEeFJybE1xRm1OTnpsa0dveU5leE4yUEVOa1IzUnZ0U2NoalBLWklhc0wzNUs2VC9vUGNBClAvNGJQS0R5MlY0Z0V4TExBZ01CQUFHalZqQlVNQTRHQTFVZER3RUIvd1FFQXdJRm9EQVRCZ05WSFNVRUREQUsKQmdnckJnRUZCUWNEQWpBTUJnTlZIUk1CQWY4RUFqQUFNQjhHQTFVZEl3UVlNQmFBRk9rem9EcmNyUnp4ekhXbApFZ0VXZVdIYWM3K09NQTBHQ1NxR1NJYjNEUUVCQ3dVQUE0SUJBUUNYN2tHdVV4cHV1MEQ0aHFZOG93dFZ0ZU84CnZ6NkxDTkhTekJXUlNBdno2VEg4TGZDZENJeDNxb0l0WnMzY0RrcUN6TDJnckpwVkcvalYxanVjQXRwWjY2TlgKazZ5U04rMW9QTmFBWWhUSEZwVVF2RnV5bzFzQ1VrS0thNUdiNG1IUWs2OG1tZGh5S0RkNmxXQjlwWHZnY1dkbwpmRzJveitiUUdNYWhaZU04eXBhMUlPMmpNRHFPMzVQelRWZmhoQ2s5bFdSdFkzeElIV0svUks1bThzR0FHb2hyCk8zYmZSUEI2ODVtT21wVnJBVVRhRlQ0dzJYR2tLVitzTTF2V29FNEVDaVY5TGFxSGdxZGRYTWJRTFVrVVZwR2EKbWRTaWhvamZZSUFTam9QOVd4dkdWUkxqRUd5d1dGTUo1V0k4T1E4azVTTkI3bTUxZU4wdnRCQ0IvMEl4Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
                client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBdk55RkRmcmU4VEVqbnZqQmcyUHptMGZXaUErb25YMWxjOEFMcGpsUTU5NTJmaHdhCjMyd2s2NGtxTEFEM1R3VzZSc1YrQnY3dGhrRXBRbnBSeVpobkZvQUVTT2FMeHloZEpUUzNIbWgyQm9CemsrMlAKTGhJOHVsSURhVEpmK1U0RCt3Z0ZONCtkc2F3NDVSakNFR0JEZW9wT2hnWkV3bTlYdFU5TktPZzByc3hIa0l2NAo0cDVyRGszbGw2Z3VEdUxneUREWWF0UWVaUFdScnlkVGJGa1EyLzlkOTMzWkJ6U1hReHNtcDRKVUZYc2NQclZyCnlxOXZHU1d0NUlGd1V2TXkzQzBTR1BCcWN2TTNVS1VFd1E4VWE1VEtoWmpUYzVaQnFNalhzVGRqeERaRWQwYjcKVW5JWXp5bVNHckM5K1N1ay82RDNBRC8rR3p5Zzh0bGVJQk1TeXdJREFRQUJBb0lCQUJTN2R5dkFDaHRHRkFLago0aDBQVlloZjlzLzhPcndCMlB6cVFjZko2NTl0NUw5cjl4TThadTBvVGVYWXUvZ0R5VWdkbVZFaFNSSi9pQXo3CjFUWDJoMUtKVThScm5UL2hVWFdxZDNPeUdmVnF3bS81d3g4QlI0TlluM2FSTTNId1pqQWlMWmh2ZnBYVGh4eTMKS1dQczByRGF0VXRjZ3MzVUNvMGxHeDVPSjFlM2RWYXdtaXo0NE93RnRhOGZGY25qUyttS0lzKzJvMTBlNE9wcgpncUhGTkRtTVYrZFBmS0h2WWNYTVRpcG1MTExsK1dNRHBIUytNSHJVYjE5aHI5TXE5end5NDJmMEtvYld0b1JXCnZKaGs3blJuT29xY3kyTjdyY3dpSENVcVJzZGhDeTFtU1JpMTE3dWIzejRKYUYwTGN6TytCOFZBdUI0QUpDNzgKSWc3eWFURUNnWUVBeWVhdVV3OXhVZWJxZmt0L0UrNmZpMHlGWUZuTWdOWUkvcVV5c3BWbXBTU3d2cTBaNUphNApsMzd3VURTQ0p3QVo3R09sbDhkcFhOY1BFZWxXMkdhOEhkcTB1RnMrOTdTMVEzVWVmcTBHNnlxbjhuZVYwWHlCCkI5citVdm9RcUppUTRBS2I4Y2ptcTZNZmZ6YVFlZjRlU2l6NU0zT01rMmFCNkZDWmI2NVdKRGtDZ1lFQTczZGkKL3ZvVU5KU1ljZ0NXMjFpQmVFMHZJS2VwcGYwQzB4MUFIR3hZTFpXSHE1cGJSa1E5MjF1ZXZCR1BrQURTNy92UApQVGc4RTRiUXFCd2FVQU4xYkFhQnVSeE5KUkJsV3NsOHliM2Rob3F6ZjBGMElMWWEzSnI0SFdJQ01GWHdBTkZlCjIrSTdudGVzUk5xSzlGMDQxRUE0ZitJaHBEc1lkeXJiQ2VOakZ5TUNnWUFGaTVodUg1WjFNV3B2WFpOMzhLM2gKSFpEc1BJc3BYcmVRaHVrRmpxVHJGRDdtZmNxZ1JLTjlSYmREL0swMmRRSkJROXRnZDlHbEF5TWUwdEhYejdxSwo5MTdQVVhKQlMyMVBGUUJwYWtjdVhsV09pMHBLSHFsTWxlODJTRGY4NlhQUk0wRWxPdWRhLzNmMS9vR3BXQmxzCjRCOVlFbXhpQUFiQllyVlVJKzJwd1FLQmdBL256U0tFZDgwYVJabms0aUJGbTZ2aTdJdHR0MzMzOVRVU2oweVUKQWJOZGFEcUVzU1ZVcVFzbDVjQTJKbVA1T2dtSW56WkF3dlRGRXB6bjZQT0JsMDRLakpsQUFQdkNRQWtzc3VZdgpmMFJOZUNpdXIwanc3NDNSbVVOU1hEVGJzR3BOZmRCN0VWeTJsSkdxTm1xT3VwU1dnMm96R2VydnBldGNaRm9lCnlWa2pBb0dBSjlLN3R6UGdYRlQ2anFwUUx6ZFViRVpRbzF5aWtCa0FxWERmR0p4QVJxRXlvL3ZvUWs0NjdXVlMKUFN5d05EY2hwRGl1cXhDRGdoL1RyNVNyOHFWTXhNNlYwUHFiYnlFdTdMMWlCeUZ5bkhYZXdxTzJraDNjWmQ5LwpHTWNzNXNncVlzK2JKcHpBS3M4elhmZWIycENYdDVBS1hFSGhWTWV5OEtmUUN1NERoZmM9Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
        EOT -> null
      - kubeconfig_path        = "/home/szkonz/Téléchargements/plateforme-devops/infra/plateforme-config" ->null
      - name                   = "plateforme" -> null
      - wait_for_ready         = true -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.argocd.helm_release.argocd: Destroying... [id=argocd]
module.argocd.helm_release.argocd: Destruction complete after 1s
module.cluster.kind_cluster.plateforme: Destroying... [id=plateforme-]
module.cluster.kind_cluster.plateforme: Destruction complete after 2s
╷
│ Warning: Helm uninstall returned an information message
│ 
│ These resources were kept due to the resource policy:
│ [CustomResourceDefinition] applications.argoproj.io
│ [CustomResourceDefinition] applicationsets.argoproj.io
│ [CustomResourceDefinition] appprojects.argoproj.io
│ 
╵

Destroy complete! Resources: 2 destroyed.
```

terraform apply   -var-file=plateforme.tfvars

```python
Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.argocd.helm_release.argocd will be created
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

  # module.cluster.kind_cluster.plateforme will be created
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

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.cluster.kind_cluster.plateforme: Creating...
module.cluster.kind_cluster.plateforme: Still creating... [00m10s elapsed]
module.cluster.kind_cluster.plateforme: Still creating... [00m20s elapsed]
module.cluster.kind_cluster.plateforme: Creation complete after 29s [id=plateforme-]
module.argocd.helm_release.argocd: Creating...
module.argocd.helm_release.argocd: Still creating... [00m10s elapsed]
module.argocd.helm_release.argocd: Still creating... [00m20s elapsed]
module.argocd.helm_release.argocd: Still creating... [00m30s elapsed]
module.argocd.helm_release.argocd: Still creating... [00m40s elapsed]
module.argocd.helm_release.argocd: Still creating... [00m50s elapsed]
module.argocd.helm_release.argocd: Still creating... [01m00s elapsed]
module.argocd.helm_release.argocd: Still creating... [01m10s elapsed]
module.argocd.helm_release.argocd: Still creating... [01m20s elapsed]
module.argocd.helm_release.argocd: Still creating... [01m30s elapsed]
module.argocd.helm_release.argocd: Still creating... [01m40s elapsed]
module.argocd.helm_release.argocd: Creation complete after 1m46s [id=argocd]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

```
❯ kubectl --context kind-plateforme -n argocd get deploy argocd-server

```python
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
argocd-server   1/1     1            1           2m10s
```

