## set hostname
hostnamectl set-hostname master-node
# add ip's to /etc/hosts
cat <<EOF >> /etc/hosts
10.10.11.237 master-node
10.10.11.132 node1 worker-node1
10.10.11.144 node2 worker-node2
EOF
# disable SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
reboot
