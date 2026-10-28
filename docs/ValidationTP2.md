# TP2 : GitOps

Durée estimée : ~1h30

Point de départ : terraform apply crée le cluster plateforme et ArgoCD (TP1). Le dossier deploy/ ne contient encore rien d'utile.

Objectif : ne plus jamais déployer l'application à la main. Tu décris ce que tu veux dans git, ArgoCD s'en charge, en dev et en prod.

Les exemples complets sont dans les slides « GitOps avec ArgoCD ».

## 1. Une première image
La registry arrive au TP3. En attendant, construis l'image et charge-la directement dans le cluster :

❯ docker build -t api:initial app

```python
[+] Building 17.9s (10/10) FINISHED                                                           docker:default
 => [internal] load build definition from Dockerfile                                                    0.0s
 => => transferring dockerfile: 395B                                                                    0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim-buster                               2.0s
 => [internal] load .dockerignore                                                                       0.0s
 => => transferring context: 2B                                                                         0.0s
 => [1/5] FROM docker.io/library/python:3.9-slim-buster@sha256:320a7a4250aba4249f458872adecf92eea88dc6  9.2s
 => => resolve docker.io/library/python:3.9-slim-buster@sha256:320a7a4250aba4249f458872adecf92eea88dc6  0.0s
 => => sha256:84c8c79126f669beec1dcf6f34cd88094471745570c19c29b465dfa7db1fdabd 243B / 243B              0.2s
 => => sha256:2e1c130fa3ec1777a82123374b4c500623959f903c1dd731ee4a83e1f1b38ff2 3.14MB / 3.14MB          1.4s
 => => sha256:8d53da26040835f622504d7762fad14d226ac414efeb5363f5febebc89ff224d 11.04MB / 11.04MB        6.8s
 => => sha256:824416e234237961c9c5d4f41dfe5b295a3c35a671ee52889bfb08d8e257ec4c 2.78MB / 2.78MB          2.2s
 => => sha256:8b91b88d557765cd8c6802668755a3f6dc4337b6ce15a17e4857139e5fc964f3 27.14MB / 27.14MB        8.1s
 => => extracting sha256:8b91b88d557765cd8c6802668755a3f6dc4337b6ce15a17e4857139e5fc964f3               0.5s
 => => extracting sha256:824416e234237961c9c5d4f41dfe5b295a3c35a671ee52889bfb08d8e257ec4c               0.1s
 => => extracting sha256:8d53da26040835f622504d7762fad14d226ac414efeb5363f5febebc89ff224d               0.2s
 => => extracting sha256:84c8c79126f669beec1dcf6f34cd88094471745570c19c29b465dfa7db1fdabd               0.0s
 => => extracting sha256:2e1c130fa3ec1777a82123374b4c500623959f903c1dd731ee4a83e1f1b38ff2               0.1s
 => [internal] load build context                                                                       0.0s
 => => transferring context: 2.39kB                                                                     0.0s
 => [2/5] WORKDIR /app                                                                                  0.1s
 => [3/5] COPY requirements.txt .                                                                       0.0s
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt                                            4.7s
 => [5/5] COPY app.py .                                                                                 0.0s
 => exporting to image                                                                                  1.7s
 => => exporting layers                                                                                 0.5s
 => => exporting manifest sha256:34cbd9dadd75eb1e5102a94b946607a95f7365edb1be9076b3f8084f5fb2f1ba       0.0s
 => => exporting config sha256:3728a53d9fa745bf232cfa2587a23771cef84d04cf2364533916223774261958         0.0s
 => => exporting attestation manifest sha256:b09711b8ea253254cf19019895ba7df8c19c2329ebcda86f091c2ad73  0.0s
 => => exporting manifest list sha256:fd3691d95043b2461fef556490f5f4617693aaca6c97abcfe2996c48e2e5b411  0.0s
 => => naming to docker.io/library/api:initial                                                          0.0s
 => => unpacking to docker.io/library/api:initial                                                       1.1s
```

❯ kind load docker-image api:initial --name plateforme

```python
Image: "api:initial" with ID "sha256:fd3691d95043b2461fef556490f5f4617693aaca6c97abcfe2996c48e2e5b411" not yet present on node "plateforme-control-plane", loading...
```

## 2. Les manifests de base

Dans deploy/base/ :

### deployment.yaml : un Deployment api, un replica, image api, port 8080 nommé http, une readinessProbe sur /healthz, des resources (demande 50m de CPU et 64Mi de mémoire, limite 128Mi de mémoire). Label des pods : app: api.

plateforme-devops/deploy/base/deployment.yaml

### service.yaml : un Service api, port 80 vers le port http des pods. Donne-lui aussi le label app: api (il servira pour la supervision).

plateforme-devops/deploy/base/service.yaml

### kustomization.yaml : il liste les deux fichiers.

plateforme-devops/deploy/base/kustomization.yaml

N'écris aucun namespace dans ces fichiers : ce sont les overlays qui le fixent.

3. Les deux environnements
deploy/overlays/dev/kustomization.yaml : namespace dev, la base, l'image api:initial.
deploy/overlays/prod/kustomization.yaml : pareil avec le namespace prod, et deux replicas.
Vérifie avant de commiter, sans rien appliquer :

kubectl kustomize deploy/overlays/dev
kubectl kustomize deploy/overlays/prod | grep -E "namespace:|replicas:|image:"
Commite et pousse : ArgoCD ne voit que ce qui est sur le dépôt distant.

4. Confie les environnements à ArgoCD
Dans deploy/argocd/, écris api-dev.yaml et api-prod.yaml : deux objets Application nommés api-dev et api-prod, qui pointent sur ton dépôt (URL https), branche main, chemins deploy/overlays/dev et deploy/overlays/prod, avec synchronisation automatique, prune, selfHeal et l'option CreateNamespace=true.

Commite et pousse. Rien ne se passe encore : personne n'a dit à ArgoCD de lire ce dossier.

5. L'application racine, par Terraform
Dans le module argocd, ajoute une seconde helm_release (chart argocd-apps, version 2.0.6, même dépôt Helm) qui déclare une application racine surveillant le dossier deploy/argocd de ton dépôt, en synchronisation automatique. L'URL du dépôt est une nouvelle variable depot, à ajouter à plateforme.tfvars.

terraform apply -var-file=plateforme.tfvars
kubectl --context kind-plateforme -n argocd get applications --watch
En une à deux minutes, racine, api-dev et api-prod doivent être Synced et Healthy. Regarde aussi l'interface d'ArgoCD (commandes au TP1) : l'arbre de chaque application y est beaucoup plus lisible.

kubectl --context kind-plateforme -n prod get pods            # deux pods
kubectl --context kind-plateforme -n dev port-forward svc/api 8080:80
curl localhost:8080/                                          # dans un autre terminal
6. Vis le GitOps
Un changement par git : passe prod à trois replicas en modifiant l'overlay, commite, pousse, et observe sans rien faire d'autre. ArgoCD interroge le dépôt toutes les trois minutes environ : sois patient, ou clique sur Refresh dans l'interface.
Un changement à la main : kubectl -n prod scale deployment api --replicas=1. Regarde ce qu'il devient en quelques secondes. Pourquoi ?
Reviens à deux replicas, par git.
Pièges connus
ErrImageNeverPull ou ImagePullBackOff : l'image api:initial n'est pas dans le cluster. Refais le kind load. Tu devras le refaire après chaque terraform destroy : ce défaut disparaît au TP3, avec la registry.
L'application reste Unknown : ArgoCD n'arrive pas à lire ton dépôt. Il doit être public, et l'URL doit être en https://, pas en git@.
api-dev n'apparaît pas : les fichiers de deploy/argocd/ ne sont pas poussés, ou l'application racine ne pointe pas sur le bon chemin.
Tu as modifié un fichier et rien ne change : as-tu poussé ?
✅ Validation : supprime le déploiement à la main, il revient tout seul.

kubectl --context kind-plateforme -n dev delete deployment api
kubectl --context kind-plateforme -n dev get deployment api --watch
Puis, tout commité et poussé :

curl -fsSL https://raw.githubusercontent.com/DeepSnowNeeL/devops-avance-support/main/verifier.sh | bash
Cases attendues en vert : 1 à 4. Le script fait lui-même la suppression de la case 4.