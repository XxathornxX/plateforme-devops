curl -fsSL https://raw.githubusercontent.com/DeepSnowNeeL/devops-avance-support/main/verifier.sh | bash
Vérification de la plateforme (cluster kind-plateforme). Compte deux à quatre minutes.
Outils : /usr/local/bin/kubectl /usr/bin/terraform /usr/bin/git

[ OK ]  1. Cluster et ArgoCD issus de Terraform
[ OK ]  2. Module et variables Terraform
[ECHEC]  3. Application en dev et prod par ArgoCD
         l'application api-dev est « introuvable », attendu « Synced Healthy »
[ECHEC]  4. Self-heal : un déploiement supprimé revient
         l'application ArgoCD api-dev est introuvable, rien n'a été supprimé
[ECHEC]  5. Déploiement par le pipeline
         aucun newTag dans deploy/overlays/dev/kustomization.yaml
[ECHEC]  6. SealedSecret dans git
         aucun SealedSecret commité sous deploy/
[ECHEC]  7. Dashboard RED
         aucun ConfigMap commité sous deploy/ avec le label grafana_dashboard et une requête sur http_requests_total
[ECHEC]  8. SLO et alerte
         aucune alerte BudgetErreurApi chargée dans Prometheus (namespace supervision)
[ECHEC]  9. Scan d'images bloquant
         aucun workflow dans .github/workflows/
[ECHEC] 10. Admission policy
         l'essai n'a pas pu être fait : Error from server (NotFound): namespaces "dev" not found

Dépôt : https://github.com/XxathornxX/plateforme-devops @ 7822106
Date  : 2026-10-28 16:43
Score : 4/20
Code : 1100000000

Relevé : 1100000000 https://github.com/XxathornxX/plateforme-devops 7822106 v2026-10-13

==========================================================================================

Vérification de la plateforme (cluster kind-plateforme). Compte deux à quatre minutes.
Outils : /usr/local/bin/kubectl /usr/bin/terraform /usr/bin/git

[ OK ]  1. Cluster et ArgoCD issus de Terraform
[ OK ]  2. Module et variables Terraform
[ OK ]  3. Application en dev et prod par ArgoCD
[ OK ]  4. Self-heal : un déploiement supprimé revient
[ECHEC]  5. Déploiement par le pipeline
         le tag de dev est encore « initial » : le pipeline n'a jamais déployé
[ECHEC]  6. SealedSecret dans git
         aucun SealedSecret commité sous deploy/
[ECHEC]  7. Dashboard RED
         aucun ConfigMap commité sous deploy/ avec le label grafana_dashboard et une requête sur http_requests_total
[ECHEC]  8. SLO et alerte
         aucune alerte BudgetErreurApi chargée dans Prometheus (namespace supervision)
[ECHEC]  9. Scan d'images bloquant
         aucun workflow dans .github/workflows/
[ECHEC] 10. Admission policy
         un pod sans resources.limits est accepté dans dev

Dépôt : https://github.com/XxathornxX/plateforme-devops @ 746a0bf
Date  : 2026-10-28 18:54
Score : 8/20
Code : 1111000000

Relevé : 1111000000 https://github.com/XxathornxX/plateforme-devops 746a0bf v2026-10-13