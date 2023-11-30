#!/bin/bash

# Registering Container Platform Variable
source cp-cluster-vars.sh
echo "Register environment variables."

# Check Node Variable
result=0

if [ "$KUBE_CONTROL_HOSTS" == "" ]; then
  echo "KUBE_CONTROL_HOSTS is empty. Enter a variable."
  result=2
elif [[ ! "$KUBE_CONTROL_HOSTS" =~ ^[0-9]+$ ]]; then
  echo "KUBE_CONTROL_HOSTS is not a value in Number format. Enter a Number format variable."
  result=2
elif [ "$KUBE_CONTROL_HOSTS" -eq 0 ]; then
  echo "The minimum value of the KUBE_CONTROL_HOSTS variable is 1."
  result=2
elif [ ! "$KUBE_CONTROL_HOSTS" == "" ]; then
  for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
    do
      j=$((i+1));
      eval "master_node_hostname=\${MASTER${j}_NODE_HOSTNAME}";
      eval "master_node_public_ip=\${MASTER${j}_NODE_PUBLIC_IP}";
      eval "master_node_private_ip=\${MASTER${j}_NODE_PRIVATE_IP}";

      if [ "$master_node_hostname" == "" ]; then
        echo "MASTER${j}_NODE_HOSTNAME is empty. Enter a variable."
        result=2
        break
      elif [ "$master_node_public_ip" == "" ] && [ ${j} -eq 1 ]; then
        echo "MASTER${j}_NODE_PUBLIC_IP is empty. Enter a variable."
        result=2
        break
      elif [[ ! "$master_node_public_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [ ${j} -eq 1 ]; then
        echo "MASTER${j}_NODE_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
        result=2
        break
      elif [ "$master_node_private_ip" == "" ]; then
        echo "MASTER${j}_NODE_PRIVATE_IP is empty. Enter a variable."
        result=2
        break
      elif [[ ! "$master_node_private_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "MASTER${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
        result=2
        break
      fi
  done
fi

if [ "$result" == 2 ]; then
  return $result
fi

if [ "$KUBE_CONTROL_HOSTS" -gt 1 ]; then
  if [ "$LOADBALANCER_DOMAIN" == "" ]; then
    echo "LOADBALANCER_DOMAIN is empty. Enter a variable."
    result=2
  elif [ "$ETCD_TYPE" == "" ]; then
    echo "ETCD_TYPE is empty. Enter a variable."
    result=2
  elif [ ! "$ETCD_TYPE" == "external" ] && [ ! "$ETCD_TYPE" == "stacked" ]; then
    echo "ETCD_TYPE must be 'external' or 'stacked'."
    result=2
  elif [ "$ETCD_TYPE" == "external" ]; then
    for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
      do
        j=$((i+1));
        eval "etcd_node_hostname=\${ETCD${j}_NODE_HOSTNAME}";
        eval "etcd_node_private_ip=\${ETCD${j}_NODE_PRIVATE_IP}";

        if [ "$etcd_node_hostname" == "" ]; then
          echo "ETCD${j}_NODE_HOSTNAME is empty. Enter a variable."
          result=2
          break
        elif [ "$etcd_node_private_ip" == "" ]; then
          echo "ETCD${j}_NODE_PRIVATE_IP is empty. Enter a variable."
          result=2
          break
        elif [[ ! "$etcd_node_private_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
          echo "ETCD${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
          result=2
          break
        fi
    done
  fi
fi

if [ "$result" == 2 ]; then
  return $result
fi

if [ "$KUBE_WORKER_HOSTS" == "" ]; then
  echo "KUBE_WORKER_HOSTS is empty. Enter a variable."
  result=2
elif [[ ! "$KUBE_WORKER_HOSTS" =~ ^[0-9]+$ ]]; then
  echo "KUBE_WORKER_HOSTS is not a value in Number format. Enter a Number format variable."
  result=2
elif [ "$KUBE_WORKER_HOSTS" -eq 0 ]; then
  echo "The minimum value of the KUBE_WORKER_HOSTS variable is 1."
  result=2
elif [ ! "$KUBE_WORKER_HOSTS" == "" ]; then
  for ((i=0;i<$KUBE_WORKER_HOSTS;i++))
    do
      j=$((i+1));
      eval "worker_node_hostname=\${WORKER${j}_NODE_HOSTNAME}";
      eval "worker_node_private_ip=\${WORKER${j}_NODE_PRIVATE_IP}";

      if [ "$worker_node_hostname" == "" ]; then
        echo "WORKER${j}_NODE_HOSTNAME is empty. Enter a variable."
        result=2
        break
      elif [ "$worker_node_private_ip" == "" ]; then
        echo "WORKER${j}_NODE_PRIVATE_IP is empty. Enter a variable."
        result=2
        break
      elif [[ ! "$worker_node_private_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "WORKER${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
        result=2
        break
      fi
  done
fi

if [ "$result" == 2 ]; then
  return $result
fi

if [ "$STORAGE_TYPE" == "" ]; then
  echo "STORAGE_TYPE is empty. Enter a variable."
  result=2
elif [ ! "$STORAGE_TYPE" == "nfs" ] && [ ! "$STORAGE_TYPE" == "rook-ceph" ]; then
  echo "STORATE_TYPE must be 'nfs' or 'rook-ceph'."
  result=2
elif [ "$STORAGE_TYPE" == "nfs" ] && [ "$NFS_SERVER_PRIVATE_IP" == "" ]; then
  echo "NFS_SERVER_PRIVATE_IP is empty. Enter a variable."
  result=2
elif [ "$STORAGE_TYPE" == "nfs" ] && [[ ! "$NFS_SERVER_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "NFS_SERVER_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
  result=2
fi

if [ "$result" == 2 ]; then
  return $result
fi

if [ "$METALLB_IP_RANGE" == "" ]; then
  echo "METALLB_IP_RANGE is empty. Enter a variable."
  result=2
elif [[ ! "$METALLB_IP_RANGE" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "METALLB_IP_RANGE is not a value in IP format. Enter a IP format variable."
  result=2
fi

if [ "$result" == 2 ]; then
  return $result
fi

if [ "$INGRESS_NGINX_PRIVATE_IP" == "" ]; then
  echo "INGRESS_NGINX_PRIVATE_IP is empty. Enter a variable."
  result=2
elif [[ ! "$INGRESS_NGINX_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "INGRESS_NGINX_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
  result=2
fi

if [ "$result" == 2 ]; then
  return $result
fi

echo "Variable check completed."

# Installing Ubuntu, PIP3 Package
PIP3_INSTALL=$(dpkg -l | grep python3-pip | awk '{print $2}')

if [ "$PIP3_INSTALL" == "" ]; then
  sudo apt-get update
  sudo apt-get install -y python3-pip
  echo "pip3 installation completed."
fi

PIP3_PACKAGE_INSTALL=$(pip3 freeze | grep ruamel.yaml)

if [ "$PIP3_PACKAGE_INSTALL" == "" ]; then
  sudo pip3 install -r ../standalone/requirements.txt
  echo "Python packages installation completed."
fi

# Update /etc/hosts, .ssh/known_hosts
HOST_CHECK=$(sudo cat /etc/hosts | grep "$MASTER1_NODE_PUBLIC_IP $MASTER1_NODE_HOSTNAME")

if [ "$HOST_CHECK" == "" ]; then
  echo "$MASTER1_NODE_PUBLIC_IP $MASTER1_NODE_HOSTNAME" | sudo tee -a /etc/hosts
  echo "$MASTER1_NODE_PUBLIC_IP $MASTER1_NODE_HOSTNAME" | tee -a hostlist
  ssh-keyscan -t rsa -f hostlist > ~/.ssh/known_hosts
fi

echo "Update /etc/hosts, .ssh/known_hosts file."

# Container Platform configuration settings
cp roles/kubeconfig/defaults/main.yml.ori roles/kubeconfig/defaults/main.yml

if [ "$KUBE_CONTROL_HOSTS" -eq 1 ]; then
  sed -i "s/{MASTER1_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/kubeconfig/defaults/main.yml
elif [ "$KUBE_CONTROL_HOSTS" -gt 1 ]; then
  sed -i "s/{MASTER1_NODE_PUBLIC_IP}/$LOADBALANCER_DOMAIN/g" roles/kubeconfig/defaults/main.yml
fi

cp roles/istio-single/defaults/main.yml.ori roles/istio-single/defaults/main.yml

sed -i "s/{INGRESS_NGINX_PRIVATE_IP}/$INGRESS_NGINX_PRIVATE_IP/g" roles/istio-single/defaults/main.yml

rm -rf hosts.yaml

cat <<EOF > hosts.yaml
all:
  hosts:
    master_node:
      ansible_host: $MASTER1_NODE_HOSTNAME
      ip: $MASTER1_NODE_PUBLIC_IP
      access_ip: $MASTER1_NODE_PRIVATE_IP
  children:
    kube_control_plane:
      hosts:
        master_node:
EOF

echo "Container Platform vars setting completed."

# Deploy Container Platform
ansible-playbook -i hosts.yaml  --become --become-user=root cluster.yml
