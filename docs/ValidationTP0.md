# 1. Vérifie tes outils

docker version --format '{{.Server.Version}}'
kind version
kubectl version --client
helm version --short
terraform version        # ou : tofu version
git --version

29.9.2
kind v0.33.0 go1.26.7 linux/amd64
Client Version: v1.37.2
Kustomize Version: v5.8.1
v4.3.0+gbec5b06
Terraform v1.17.0
on linux_amd64

# 2. Crée un cluster à la main

kind create cluster --name essai

Creation en cours

❯ kind create cluster --name amaury
Creating cluster "amaury" ...
 ✓ Ensuring node image (kindest/node:v1.37.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-amaury"
You can now use your cluster with:

kubectl cluster-info --context kind-amaury

Thanks for using kind! 😊

❯ kubectl --context kind-amaury get nodes
NAME                   STATUS   ROLES           AGE   VERSION
amaury-control-plane   Ready    control-plane   11m   v1.37.0

# 3. Lance un pod, observe, détruis

❯ kubectl --context kind-amaury run web --image=nginx:1.27 --port=80

pod/web created


❯ kubectl --context kind-amaury get pods --watch

NAME   READY   STATUS    RESTARTS   AGE
web    1/1     Running   0          86s
^C%                                                                                                                 ❯ kubectl --context kind-amaury describe pod web
Name:             web
Namespace:        default
Priority:         0
Service Account:  default
Node:             amaury-control-plane/172.19.0.2
Start Time:       Wed, 28 Oct 2026 11:29:23 +0100
Labels:           run=web
Annotations:      <none>
Status:           Running
IP:               10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  web:
    Container ID:   containerd://752d9bf539d94bb522939f2506e9fcb53f1f21245ddf0e72e1194ee347c893a8
    Image:          nginx:1.27
    Image ID:       docker.io/library/nginx@sha256:6784fb0834aa7dbbe12e3d7471e69c290df3e6ba810dc38b34ae33d3c1c05f7d
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 28 Oct 2026 11:29:41 +0100
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-tp826 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-tp826:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  102s  default-scheduler  Successfully assigned default/web to amaury-control-plane
  Normal  Pulling    102s  kubelet            spec.containers{web}: Pulling image "nginx:1.27"
  Normal  Pulled     84s   kubelet            spec.containers{web}: Successfully pulled image "nginx:1.27" in 17.948s (17.948s including waiting). Image size: 72406859 bytes.
  Normal  Created    84s   kubelet            spec.containers{web}: Container created
  Normal  Started    84s   kubelet            spec.containers{web}: Container started

❯ kubectl --context kind-amaury delete pod web
pod "web" deleted from default namespace

Réponds pour toi-même, sans chercher : quelle différence entre un pod et un deployment ? Que se passe-t-il si tu supprimes un pod qui appartient à un deployment ? Si tu hésites, crée un deployment (kubectl create deployment web --image=nginx:1.27), supprime son pod et regarde.

Entre un pod et un deployment,

# 4. Détruis le cluster

❯ kind delete cluster --name amaury
Deleting cluster "amaury" ...
Deleted nodes: ["amaury-control-plane"]

# 5. Crée ton dépôt

OK.