apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
kubernetesVersion: v1.15.6
controllerManager:
  ExtraArgs:
    horizontal-pod-autoscaler-use-rest-clients: true
    horizontal-pod-autoscaler-cpu-initialization-period: "20s"
    horizontal-pod-autoscaler-downscale-stabilization: "3m"
    node-monitor-grace-period: "15s"
    pod-eviction-timeout: "30s"
    node-monitor-period: "3s"
apiServerCertSANs:
- K8SHA_HOST1
- K8SHA_HOST2
- K8SHA_HOST3
- K8SHA_VHOST
- K8SHA_IP1
- K8SHA_IP2
- K8SHA_IP3
- K8SHA_VIP
controlPlaneEndpoint: "K8SHA_VIP:16443"
networking:
  # This CIDR is a Calico default. Substitute or remove for your CNI provider.
  podSubnet: "K8SHA_CIDR/16"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
# kubelet specific options here
authentication:
  webhook:
    enabled: true
nodeStatusUpdateFrequency: "4s"
rotateCertificates: true
