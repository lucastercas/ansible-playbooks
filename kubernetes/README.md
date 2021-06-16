# Ansible Playbook Kubernetes

## How to Use

1. `cluster_topology`
   1. The cluster topology, based of on the
      [documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/),
   2. Options: **`single_master`**, `stacked_etcd`, `external_etcd`
2. `selected_network`
   1. The CNI of the cluster
   2. Options: **`weave`**, `flannel`, `calico`
3. `ignore_preflight_errors`:
   1. If ...
   2. Options: **`all`**
4. `taint_masters`:
   1. If the master nodes should accept loads
   2. Options: **`false`**, `true`
5. `ingress_controlller`:
   1. The ingress controller to load on the cluster
   2. Options: **`nginx`**, `traefik`

## To Do

### ETCD

1. Write Role

### Master

1. Adicionar usuário (atualmente tudo roda como `root`)
2. Adicionar outros ingress
   1. [x] Nginx
   2. [ ] Traefik
3. Adicionar outras redes
   1. [x] Weave
   2. [x] Flannel
   3. [ ] Calico

### Worker

1. Adicionar usuário (atualmente tudo roda como `root`)

### Loadbalancer
