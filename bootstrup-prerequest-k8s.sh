#!/bin/bash

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
yum --disablerepo="*" --enablerepo="elrepo-kernel" install -y kernel-ml-5.4.0-1.el7.elrepo
vi /etc/default/grub
# set GRUB_DEFAULT=0
grub2-mkconfig -o /boot/grub2/grub.cfg
yum -y install net-tools mc nano wget ntp git docker yum-plugin-versionlock glusterfs-client
nano /etc/sysconfig/docker
# set line to OPTIONS='--selinux-enabled --log-driver=json-file --log-opt max-size=50m --log-opt max-file=5 --signature-verification=false'
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-"$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i --follow-symlinks 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux
systemctl stop firewalld
systemctl disable firewalld
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.bridge.bridge-nf-call-ip6tables=1
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward = 1
EOF
sysctl -p
sysctl --system
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum search kubelet --showduplicates
yum install -y kubelet-1.15.6-0.x86_64 kubeadm-1.15.6-0.x86_64 kubectl-1.15.6-0.x86_64 --disableexcludes=kubernetes
yum versionlock kubelet kubeadm kubectl
yum update -y
systemctl enable kubelet docker ntpd && systemctl start kubelet docker ntpd
kubeadm join 10.111.2.100:16443 --token cwnwyr.fupyb01xu19sv8af \
    --discovery-token-ca-cert-hash sha256:2d85a80879f9400158d48197594d1e88bbe0eb8ec87cc8ec5c2386600c5fd229
