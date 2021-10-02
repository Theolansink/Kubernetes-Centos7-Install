# Set the following firewall rules on ports. Make sure that each firewall-cmd command, returns a success.

firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
# Step 2: Setup the Kubernetes Repo
# You will need to add Kubernetes repositories manually as they do not come installed by default on CentOS 7.

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# Step 3: Install Kubeadm and Docker
# With the package repo now ready, you can go ahead and install kubeadm and docker packages.

yum install kubeadm docker -y
#When the installation completes successfully, enable and start both services.

systemctl enable kubelet
systemctl start kubelet
systemctl enable docker
systemctl start docker
# Step 4: Initialize Kubernetes Master and Setup Default User
# Now we are ready to initialize kubernetes master, but before that you need to disable swap in order to run “kubeadm init“ command.

swapoff -a
# Initializing Kubernetes master is a fully automated process that is managed by the “kubeadm init“ command which you will run.

kubeadm init
# Initialize Kubernetes Master
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# create pod network
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
