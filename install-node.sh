# set hostname
hostnamectl set-hostname node1
# add ip's to /etc/hosts
cat <<EOF >> /etc/hosts
10.10.11.237 master-node
10.10.11.132 node1 worker-node1
10.10.11.144 node2 worker-node2
EOF
# disable SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Set the following firewall rules on ports. Make sure that each firewall-cmd command, returns a success.

firewall-cmd --permanent --add-port=6783/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --reload
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
swapoff -a

# now run the kubeadm join command (copy the command from the master (first reformat the command (skip the \ symbol)))