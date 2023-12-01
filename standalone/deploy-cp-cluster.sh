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

CHK_MULTI=$(grep 'ISTIO_INGRESS_PRIVATE_IP' cp-cluster-vars.sh | awk '{print $2}')

if [[ ! "$CHK_MULTI" == "" ]]; then
  if [ "$ISTIO_INGRESS_PRIVATE_IP" == "" ]; then
    echo "ISTIO_INGRESS_PRIVATE_IP is empty. Enter a variable."
    result=2
  elif [[ ! "$ISTIO_INGRESS_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ISTIO_INGRESS_PRIVATE_IP is not a value in Ip format. Enter a IP format variable."
    result=2
  fi
  
  if [ "$result" == 2 ]; then
    return $result
  fi

  if [ "$ISTIO_EASTWEST_PRIVATE_IP" == "" ]; then
    echo "ISTIO_EASTWEST_PRIVATE_IP is empty. Enter a variable."
    result=2
  elif [[ ! "$ISTIO_EASTWEST_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ISTIO_EASTWEST_PRIVATE_IP is not a value in Ip format. Enter a IP format variable."
    result=2
  fi

  if [ "$result" == 2 ]; then
    return $result
  fi
fi

if [ "$INGRESS_NGINX_PUBLIC_IP" == "" ]; then
  echo "INGRESS_NGINX_PUBLIC_IP is empty. Enter a variable."
  result=2
elif [[ ! "$INGRESS_NGINX_PUBLIC_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "INGRESS_NGINX_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
  result=2
fi

if [ "$result" == 2 ]; then
  return $result
fi

if [[ ! "$CHK_MULTI" == "" ]]; then
  if [ "$ISTIO_EASTWEST_PUBLIC_IP" == "" ]; then
    echo "ISTIO_EASTWEST_PUBLIC_IP is empty. Enter a variable."
    result=2
  elif [[ ! "$ISTIO_EASTWEST_PUBLIC_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ISTIO_EASTWEST_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
    result=2
  fi

  if [ "$result" == 2 ]; then
    return $result
  fi

fi

# Installing Ubuntu, PIP3 Package
PIP3_INSTALL=$(dpkg -l | grep python3-pip | awk '{print $2}')

if [ "$PIP3_INSTALL" == "" ]; then
  sudo apt-get update
  sudo apt-get install -y python3-pip
  echo "pip3 installation completed."
fi

PIP3_PACKAGE_INSTALL=$(pip3 freeze | grep ruamel.yaml)

if [ "$PIP3_PACKAGE_INSTALL" == "" ]; then
  sudo pip3 install -r requirements.txt
  echo "Python packages installation completed."
fi

# Container Platform configuration settings
rm -rf inventory/mycluster/hosts.yaml
cp inventory/mycluster/group_vars/all/all.yml.ori inventory/mycluster/group_vars/all/all.yml
cp inventory/mycluster/group_vars/k8s_cluster/addons.yml.ori inventory/mycluster/group_vars/k8s_cluster/addons.yml
cp inventory/mycluster/inventory.ini.ori inventory/mycluster/inventory.ini
cp roles/cp/storage/defaults/main.yml.ori roles/cp/storage/defaults/main.yml
cp roles/kubernetes/control-plane/tasks/kubeadm-setup.yml.ori roles/kubernetes/control-plane/tasks/kubeadm-setup.yml
cp roles/kubernetes-apps/metrics_server/defaults/main.yml.ori roles/kubernetes-apps/metrics_server/defaults/main.yml
cp ../applications/nfs-provisioner-4.0.2/deployment.yaml.ori ../applications/nfs-provisioner-4.0.2/deployment.yaml
cp roles/cp/istio-setting/defaults/main.yml.ori roles/cp/istio-setting/defaults/main.yml

ARRAY_MASTER_NODE_IP=""
ARRAY_ETCD_NODE_IP=""
ARRAY_WORKER_NODE_IP=""

if [ "$KUBE_CONTROL_HOSTS" -eq 1 ]; then
  find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[all\]/a\{MASTER1_NODE_HOSTNAME} ansible_host={MASTER1_NODE_PRIVATE_IP} ip={MASTER1_NODE_PRIVATE_IP} etcd_member_name=etcd1" {} \;;
  find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[etcd\]/i\{MASTER1_NODE_HOSTNAME}" {} \;;

  sed -i "s/{MASTER1_NODE_HOSTNAME}/${MASTER1_NODE_HOSTNAME}/g" inventory/mycluster/inventory.ini
  sed -i "s/{MASTER1_NODE_PRIVATE_IP}/${MASTER1_NODE_PRIVATE_IP}/g" inventory/mycluster/inventory.ini

  ARRAY_MASTER_NODE_IP="${MASTER1_NODE_PRIVATE_IP}";
else
  for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
    do
      j=$((i+1));

      find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[all\]/a\{MASTER${j}_NODE_HOSTNAME} ansible_host={MASTER${j}_NODE_PRIVATE_IP} ip={MASTER${j}_NODE_PRIVATE_IP}" {} \;;
      find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_control_plane\]/i\{ETCD${j}_NODE_HOSTNAME} ansible_host={ETCD${j}_NODE_PRIVATE_IP} ip={ETCD${j}_NODE_PRIVATE_IP}" {} \;;

      find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[etcd\]/i\{MASTER${j}_NODE_HOSTNAME}" {} \;;
      find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_node\]/i\{ETCD${j}_NODE_HOSTNAME}" {} \;;

      eval "master_node_hostname=\${MASTER${j}_NODE_HOSTNAME}";
      eval "master_node_private_ip=\${MASTER${j}_NODE_PRIVATE_IP}";

      sed -i "s/{MASTER"$j"_NODE_HOSTNAME}/$master_node_hostname/g" inventory/mycluster/inventory.ini
      sed -i "s/{MASTER"$j"_NODE_PRIVATE_IP}/$master_node_private_ip/g" inventory/mycluster/inventory.ini

      eval "etcd_node_hostname=\${ETCD${j}_NODE_HOSTNAME}";
      eval "etcd_node_private_ip=\${ETCD${j}_NODE_PRIVATE_IP}";

      sed -i "s/{ETCD"$j"_NODE_HOSTNAME}/$etcd_node_hostname/g" inventory/mycluster/inventory.ini
      sed -i "s/{ETCD"$j"_NODE_PRIVATE_IP}/$etcd_node_private_ip/g" inventory/mycluster/inventory.ini

      if [ "${j}" -eq 1 ]; then
        ARRAY_MASTER_NODE_IP="${master_node_private_ip}";
        ARRAY_ETCD_NODE_IP="${etcd_node_private_ip}";
      else
        ARRAY_MASTER_NODE_IP="${ARRAY_MASTER_NODE_IP} ${master_node_private_ip}";
        ARRAY_ETCD_NODE_IP="${ARRAY_ETCD_NODE_IP} ${etcd_node_private_ip}";
      fi
  done
fi

for ((i=0;i<$KUBE_WORKER_HOSTS;i++))
  do
    j=$((i+1));
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[kube_control_plane\]/i\{WORKER${j}_NODE_HOSTNAME} ansible_host={WORKER${j}_NODE_PRIVATE_IP} ip={WORKER${j}_NODE_PRIVATE_IP}" {} \;;
    find inventory/mycluster/inventory.ini -exec sed -i -r -e "/\[calico_rr\]/i\{WORKER${j}_NODE_HOSTNAME}" {} \;;

    eval "worker_node_hostname=\${WORKER${j}_NODE_HOSTNAME}";
    eval "worker_node_private_ip=\${WORKER${j}_NODE_PRIVATE_IP}";

    sed -i "s/{WORKER"$j"_NODE_HOSTNAME}/$worker_node_hostname/g" inventory/mycluster/inventory.ini;
    sed -i "s/{WORKER"$j"_NODE_PRIVATE_IP}/$worker_node_private_ip/g" inventory/mycluster/inventory.ini;

    ARRAY_WORKER_NODE_IP="${ARRAY_WORKER_NODE_IP} ${worker_node_private_ip}";
done

sed -i "s/{MASTER1_NODE_HOSTNAME}/$MASTER1_NODE_HOSTNAME/g" roles/kubernetes-apps/metrics_server/defaults/main.yml
sed -i "s/{MASTER1_NODE_PUBLIC_IP}/$MASTER1_NODE_PUBLIC_IP/g" roles/kubernetes/control-plane/tasks/kubeadm-setup.yml

if [ "$KUBE_CONTROL_HOSTS" -gt 1 ]; then
  ETCD_URL="";
  ETCD_IPS="";

  for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
    do
      j=$((i+1));
      
      if [ "${j}" -eq 1 ]; then
        ETCD_URL="https://{ETCD${j}_NODE_PRIVATE_IP}:2379";
        ETCD_IPS="  - \"{ETCD${j}_NODE_PRIVATE_IP}\"";
      else
        ETCD_URL="${ETCD_URL},https://{ETCD${j}_NODE_PRIVATE_IP}:2379";
        ETCD_IPS="${ETCD_IPS}\n  - \"{ETCD${j}_NODE_PRIVATE_IP}\"";
      fi
  done

  find inventory/mycluster/group_vars/all/all.yml -exec sed -i -r -e "/## HA Control Plane/a\apiserver_loadbalancer_domain_name: \"{LOADBALANCER_DOMAIN}\"\nloadbalancer_apiserver:\n  port: 6443\nloadbalancer_apiserver_localhost: false\ndownload_container: true\netcd_access_addresses: ${ETCD_URL}\netcd_client_url: ${ETCD_URL}\netcd_cert_alt_ips: \n${ETCD_IPS}" {} \;;

  sed -i "s/{LOADBALANCER_DOMAIN}/$LOADBALANCER_DOMAIN/g" inventory/mycluster/group_vars/all/all.yml

  for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
    do
      j=$((i+1));
      eval "etcd_node_private_ip=\${ETCD${j}_NODE_PRIVATE_IP}";
      eval "master_node_private_ip=\${MASTER${j}_NODE_PRIVATE_IP}";

      if [ "$ETCD_TYPE" == "external" ]; then
        sed -i "s/{ETCD${j}_NODE_PRIVATE_IP}/$etcd_node_private_ip/g" inventory/mycluster/group_vars/all/all.yml
      elif [ "$ETCD_TYPE" == "stacked" ]; then
	sed -i "s/{ETCD${j}_NODE_PRIVATE_IP}/$master_node_private_ip/g" inventory/mycluster/group_vars/all/all.yml
      fi
  done
fi

sed -i "s/{METALLB_IP_RANGE}/$METALLB_IP_RANGE/g" inventory/mycluster/group_vars/k8s_cluster/addons.yml
sed -i "s/{INGRESS_NGINX_PRIVATE_IP}/$INGRESS_NGINX_PRIVATE_IP/g" inventory/mycluster/group_vars/k8s_cluster/addons.yml
sed -i "s/{NFS_SERVER_PRIVATE_IP}/$NFS_SERVER_PRIVATE_IP/g" ../applications/nfs-provisioner-4.0.2/deployment.yaml
sed -i "s/{STORAGE_TYPE}/$STORAGE_TYPE/g" roles/cp/storage/defaults/main.yml

if [[ ! "$CHK_MULTI" == "" ]]; then
  find inventory/mycluster/group_vars/k8s_cluster/addons.yml -exec sed -i -r -e "/# Address Pool List/a\    istio-ingress:\n      ip_range:\n        - $ISTIO_INGRESS_PRIVATE_IP\/32\n      auto_assign: false\n    istio-eastwest:\n      ip_range:\n        - $ISTIO_EASTWEST_PRIVATE_IP\/32\n      auto_assign: false" {} \;;
  find inventory/mycluster/group_vars/k8s_cluster/addons.yml -exec sed -i -r -e "/- ingress-nginx/a\    - istio-ingress\n    - istio-eastwest" {} \;;
fi

if [[ ! "$CHK_MULTI" == "" ]]; then
  ISTIO_EASTWEST_PRIVATE_IPTABLE=`echo $(grep "ISTIO_EASTWEST_PRIVATE_IP" cp-cluster-vars-tmp.sh | awk '{print $2}') | cut -d '=' -f2`
  ISTIO_EASTWEST_PUBLIC_IPTABLE=`echo $(grep "ISTIO_EASTWEST_PUBLIC_IP" cp-cluster-vars-tmp.sh | awk '{print $2}') | cut -d '=' -f2`
  sed -i "s/{ISTIO_EASTWEST_PRIVATE_IP}/$ISTIO_EASTWEST_PRIVATE_IPTABLE/g" roles/cp/istio-setting/defaults/main.yml
  sed -i "s/{ISTIO_EASTWEST_PUBLIC_IP}/$ISTIO_EASTWEST_PUBLIC_IPTABLE/g" roles/cp/istio-setting/defaults/main.yml
fi

if [ "$KUBE_CONTROL_HOSTS" -eq 1 ]; then
  declare -a IPS=($ARRAY_MASTER_NODE_IP $ARRAY_WORKER_NODE_IP)
elif [ "$KUBE_CONTROL_HOSTS" -gt 1 ]; then
  if [ "$ETCD_TYPE" == "external" ]; then
    declare -a IPS=($ARRAY_MASTER_NODE_IP $ARRAY_ETCD_NODE_IP $ARRAY_WORKER_NODE_IP)
  elif [ "$ETCD_TYPE" == "stacked" ]; then
    declare -a IPS=($ARRAY_MASTER_NODE_IP $ARRAY_WORKER_NODE_IP)
  fi
fi
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

if [ "$ETCD_TYPE" == "external" ]; then
  for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
    do
      j=$((i+1));
      eval "master_node_hostname=\${MASTER${j}_NODE_HOSTNAME}";
      eval "etcd_node_hostname=\${ETCD${j}_NODE_HOSTNAME}";

      sed -i "/kube_node:/,/etcd:/s/$etcd_node_hostname://g" inventory/mycluster/hosts.yaml
      sed -i "/^ *$/d" inventory/mycluster/hosts.yaml
      sed -i "/etcd:/,/k8s_cluster:/s/$master_node_hostname:/$etcd_node_hostname:/g" inventory/mycluster/hosts.yaml
  done
fi

sed -i "s/metallb_enabled: false/metallb_enabled: true/g" inventory/mycluster/group_vars/k8s_cluster/addons.yml

echo "Container Platform vars setting completed."

# Deploy Container Platform
if [ "$CHK_MULTI" == "" ]; then
  ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
else
  ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root playbooks/cluster_multi.yml
fi
