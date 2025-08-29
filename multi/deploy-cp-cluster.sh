#!/bin/bash

# Registering Container Platform Variable
source cp-cluster-vars.sh

for ((x=0;x<${CLUSTER_CNT};x++))
  do
    y=$((x+1));

    # Check Node Variable
    result=0

    KUBE_CONTROL_HOSTS="CLUSTER${y}_KUBE_CONTROL_HOSTS"

    if [ "${!KUBE_CONTROL_HOSTS}" == "" ]; then
      echo "CLUSTER${y}_KUBE_CONTROL_HOSTS is empty. Enter a variable."
      result=2
    elif [[ ! "${!KUBE_CONTROL_HOSTS}" =~ ^[0-9]+$ ]]; then
      echo "CLUSTER_KUBE_CONTROL_HOSTS is not a value in Number format. Enter a Number format variable."
      result=2
    elif [ "${!KUBE_CONTROL_HOSTS}" -eq 0 ]; then
      echo "The minimum value of the CLUSTER_KUBE_CONTROL_HOSTS variable is 1."
      result=2
    elif [ ! "${!KUBE_CONTROL_HOSTS}" == "" ]; then
      for ((i=0;i<${!KUBE_CONTROL_HOSTS};i++))
        do
          j=$((i+1));

          MASTER_NODE_HOSTNAME="CLUSTER${y}_MASTER${j}_NODE_HOSTNAME"
          MASTER_NODE_PUBLIC_IP="CLUSTER${y}_MASTER${j}_NODE_PUBLIC_IP"
          MASTER_NODE_PRIVATE_IP="CLUSTER${y}_MASTER${j}_NODE_PRIVATE_IP"

          if [ "${!MASTER_NODE_HOSTNAME}" == "" ]; then
            echo "CLUSTER${y}_MASTER${j}_NODE_HOSTNAME is empty. Enter a variable."
            result=2
            break
          elif [ "${!MASTER_NODE_PUBLIC_IP}" == "" ] && [ ${j} -eq 1 ]; then
            echo "CLUSTER${y}_MASTER${j}_NODE_PUBLIC_IP is empty. Enter a variable."
            result=2
            break
          elif [[ ! "${!MASTER_NODE_PUBLIC_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [ ${j} -eq 1 ]; then
            echo "CLUSTER${y}_MASTER${j}_NODE_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
            result=2
            break
          elif [ "${!MASTER_NODE_PRIVATE_IP}" == "" ]; then
            echo "CLUSTER${y}_MASTER${j}_NODE_PRIVATE_IP is empty. Enter a variable."
            result=2
            break
          elif [[ ! "${!MASTER_NODE_PRIVATE_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "CLUSTER${y}_MASTER${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
            result=2
            break
          fi
      done
    fi

    if [ "$result" == 2 ]; then
      return $result
    fi

    LOADBALANCER_DOMAIN="CLUSTER${y}_LOADBALANCER_DOMAIN"
    ETCD_TYPE="CLUSTER${y}_ETCD_TYPE"

    if [ "${!KUBE_CONTROL_HOSTS}" -gt 1 ]; then
      if [ "${!LOADBALANCER_DOMAIN}" == "" ]; then
        echo "CLUSTER${y}_LOADBALANCER_DOMAIN is empty. Enter a variable."
        result=2
      elif [ "${!ETCD_TYPE}" == "" ]; then
        echo "CLUSTER${y}_ETCD_TYPE is empty. Enter a variable."
        result=2
      elif [ ! "${!ETCD_TYPE}" == "external" ] && [ ! "${!ETCD_TYPE}" == "stacked" ]; then
        echo "CLUSTER${y}_ETCD_TYPE must be 'external' or 'stacked'."
        result=2
      elif [ "${!ETCD_TYPE}" == "external" ]; then
        for ((i=0;i<${!KUBE_CONTROL_HOSTS};i++))
          do
            j=$((i+1));

            ETCD_NODE_HOSTNAME="CLUSTER${y}_ETCD${j}_NODE_HOSTNAME"
            ETCD_NODE_PRIVATE_IP="CLUSTER${y}_ETCD${j}_NODE_PRIVATE_IP"

            if [ "${!ETCD_NODE_HOSTNAME}" == "" ]; then
              echo "CLUSTER${y}_ETCD${j}_NODE_HOSTNAME is empty. Enter a variable."
              result=2
              break
            elif [ "${!ETCD_NODE_PRIVATE_IP}" == "" ]; then
              echo "CLUSTER${y}_ETCD${j}_NODE_PRIVATE_IP is empty. Enter a variable."
              result=2
              break
            elif [[ ! "${!ETCD_NODE_PRIVATE_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
              echo "CLUSTER${y}_ETCD${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
              result=2
              break
            fi
        done
      fi
    fi

    if [ "$result" == 2 ]; then
      return $result
    fi

    KUBE_WORKER_HOSTS="CLUSTER${y}_KUBE_WORKER_HOSTS"

    if [ "${!KUBE_WORKER_HOSTS}" == "" ]; then
      echo "Cluster${y} KUBE_WORKER_HOSTS is empty. Enter a variable."
      result=2
    elif [[ ! "${!KUBE_WORKER_HOSTS}" =~ ^[0-9]+$ ]]; then
      echo "Cluster${y} KUBE_WORKER_HOSTS is not a value in Number format. Enter a Number format variable."
      result=2
    elif [ "${!KUBE_WORKER_HOSTS}" -eq 0 ]; then
      echo "The minimum value of the Cluster${y} KUBE_WORKER_HOSTS variable is 1."
      result=2
    elif [ ! "${!KUBE_WORKER_HOSTS}" == "" ]; then
      for ((i=0;i<${!KUBE_WORKER_HOSTS};i++))
        do
          j=$((i+1));

          WORKER_NODE_HOSTNAME="CLUSTER${y}_WORKER${j}_NODE_HOSTNAME"
          WORKER_NODE_PRIVATE_IP="CLUSTER${y}_WORKER${j}_NODE_PRIVATE_IP"

          if [ "${!WORKER_NODE_HOSTNAME}" == "" ]; then
            echo "CLUSTER${y}_WORKER${j}_NODE_HOSTNAME is empty. Enter a variable."
            result=2
            break
          elif [ "${!WORKER_NODE_PRIVATE_IP}" == "" ]; then
            echo "CLUSTER${y}_WORKER${j}_NODE_PRIVATE_IP is empty. Enter a variable."
            result=2
            break
          elif [[ ! "${!WORKER_NODE_PRIVATE_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "CLUSTER${y}_WORKER${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
            result=2
            break
          fi
      done
    fi

    if [ "$result" == 2 ]; then
      return $result
    fi

    STORAGE_TYPE="CLUSTER${y}_STORAGE_TYPE"
    NFS_SERVER_PRIVATE_IP="CLUSTER${y}_NFS_SERVER_PRIVATE_IP"

    if [ "${!STORAGE_TYPE}" == "" ]; then
      echo "CLUSTER${y}_STORAGE_TYPE is empty. Enter a variable."
      result=2
    elif [ ! "${!STORAGE_TYPE}" == "nfs" ] && [ ! "${!STORAGE_TYPE}" == "rook-ceph" ]; then
      echo "CLUSTER${y}_STORATE_TYPE must be 'nfs' or 'rook-ceph'."
      result=2
    elif [ "${!STORAGE_TYPE}" == "nfs" ] && [ "${!NFS_SERVER_PRIVATE_IP}" == "" ]; then
      echo "CLUSTER${y}_NFS_SERVER_PRIVATE_IP is empty. Enter a variable."
      result=2
    elif [ "${!STORAGE_TYPE}" == "nfs" ] && [[ ! "${!NFS_SERVER_PRIVATE_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "CLUSTER${y}_NFS_SERVER_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
      result=2
    fi

    if [ "$result" == 2 ]; then
      return $result
    fi

    CSP_TYPE="CLUSTER${y}_CSP_TYPE"

    if [[ ! "${!CSP_TYPE}" == "NHN" ]]; then
      METALLB_IP_RANGE="CLUSTER${y}_METALLB_IP_RANGE"

      if [ "${!METALLB_IP_RANGE}" == "" ]; then
        echo "CLUSTER${y}_METALLB_IP_RANGE is empty. Enter a variable."
        result=2
      elif [[ ! "${!METALLB_IP_RANGE}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "CLUSTER${y}_METALLB_IP_RANGE is not a value in IP format. Enter a IP format variable."
        result=2
      fi

      if [ "$result" == 2 ]; then
        return $result
      fi
    fi

    if [[ ! "${!CSP_TYPE}" == "NHN" ]]; then
      INGRESS_NGINX_IP="CLUSTER${y}_INGRESS_NGINX_IP"

      if [ "${!INGRESS_NGINX_IP}" == "" ]; then
        echo "CLUSTER${y}_INGRESS_NGINX_IP is empty. Enter a variable."
        result=2
      elif [[ ! "${!INGRESS_NGINX_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "CLUSTER${y}_INGRESS_NGINX_IP is not a value in IP format. Enter a IP format variable."
        result=2
      fi

      if [ "$result" == 2 ]; then
        return $result
      fi
    fi

    if [[ ! "${!CSP_TYPE}" == "NHN" ]]; then
      ISTIO_GATEWAY_PRIVATE_IP="CLUSTER${y}_ISTIO_GATEWAY_PRIVATE_IP"

      if [ "${!ISTIO_GATEWAY_PRIVATE_IP}" == "" ]; then
        echo "CLUSTER${y}_ISTIO_GATEWAY_PRIVATE_IP is empty. Enter a variable."
        result=2
      elif [[ ! "${!ISTIO_GATEWAY_PRIVATE_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "CLUSTER${y}_ISTIO_GATEWAY_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
        result=2
      fi

      if [ "$result" == 2 ]; then
        return $result
      fi
    fi

    if [[ ! "${!CSP_TYPE}" == "NHN" ]]; then
      ISTIO_GATEWAY_PUBLIC_IP="CLUSTER${y}_ISTIO_GATEWAY_PUBLIC_IP"

      if [ "${!ISTIO_GATEWAY_PUBLIC_IP}" == "" ]; then
        echo "CLUSTER${y}_ISTIO_GATEWAY_PUBLIC_IP is empty. Enter a variable."
        result=2
      elif [[ ! "${!ISTIO_GATEWAY_PUBLIC_IP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "CLUSTER${y}_ISTIO_GATEWAY_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
        result=2
      fi

      if [ "$result" == 2 ]; then
        return $result
      fi
    fi

    CSP_TYPE="CLUSTER${y}_CSP_TYPE"
    NHN_USERNAME="CLUSTER${y}_NHN_USERNAME"
    NHN_PASSWORD="CLUSTER${y}_NHN_PASSWORD"
    NHN_TENANT_ID="CLUSTER${y}_NHN_TENANT_ID"
    NHN_VIP_SUBNET_ID="CLUSTER${y}_NHN_VIP_SUBNET_ID"

    if [ "${!CSP_TYPE}" == "NHN" ]; then
      if [ "${!NHN_USERNAME}" == "" ]; then
        echo "CLUSTER${y}_NHN_USERNAME is empty, Enter a variable."
        result=2
      elif [ "${!NHN_PASSWORD}" == "" ]; then
        echo "CLUSTER${y}_NHN_PASSWORD is empty, Enter a variable."
        result=2
      elif [ "${!NHN_TENANT_ID}" == "" ]; then
        echo "CLUSTER${y}_NHN_TENANT_ID is empty, Enter a variable."
        result=2
      elif [ "${!NHN_VIP_SUBNET_ID}" == "" ]; then
        echo "CLUSTER${y}_NHN_VIP_SUBNET_ID is empty, Enter a variable."
        result=2
      fi

      if [ "$result" == 2 ]; then
        return $result
      fi
    fi
done

echo "Variable check completed."

# Installing Ubuntu, PIP3 Package
PIP3_INSTALL=$(dpkg -l | grep python3-pip | awk '{print $2}')
OS_VERSION=$(cat /etc/lsb-release | grep DISTRIB_RELEASE | awk -F '=' '{print $2}')

if [ "$PIP3_INSTALL" == "" ]; then
  sudo apt-get update
  if [ "$OS_VERSION" == "22.04" ]; then
    sudo apt-get install -y python3-pip
  elif [ "$OS_VERSION" == "24.04" ]; then
    sudo apt-get install -y python3-pip python3-venv
  fi
  echo "pip3 installation completed."
fi

PIP3_PACKAGE_INSTALL=$(pip3 freeze | grep ruamel.yaml)

if [ "$PIP3_PACKAGE_INSTALL" == "" ]; then
  if [ "$OS_VERSION" == "24.04" ]; then
    python3 -m venv ~/kpaas-venv
    source ~/kpaas-venv/bin/activate
  fi
  pip3 install -r ../standalone/requirements.txt
  echo "Python packages installation completed."
fi

NET_TOOLS_INSTALL=$(dpkg -l | grep net-tools | awk '{print $2}')

if [ "$NET_TOOLS_INSTALL" == "" ]; then
  sudo apt-get install -y net-tools
  echo "net-tools installation completed."
fi

JQ_INSTALL=$(dpkg -l | grep jq | awk '{print $2}')

if [ "$JQ_INSTALL" == "" ]; then
  sudo apt-get install -y jq
  echo "jq installation completed."
fi

# Update /etc/hosts, .ssh/known_hosts
for ((i=0;i<${CLUSTER_CNT};i++))
  do
    j=$((i+1));

    MASTER1_NODE_HOSTNAME="CLUSTER${j}_MASTER1_NODE_HOSTNAME"
    MASTER1_NODE_PUBLIC_IP="CLUSTER${j}_MASTER1_NODE_PUBLIC_IP"

    HOST_CHECK=$(sudo cat /etc/hosts | grep "${!MASTER1_NODE_PUBLIC_IP} ${!MASTER1_NODE_HOSTNAME}")

    if [ "$HOST_CHECK" == "" ]; then
      echo "${!MASTER1_NODE_PUBLIC_IP} ${!MASTER1_NODE_HOSTNAME}" | sudo tee -a /etc/hosts
      echo "${!MASTER1_NODE_PUBLIC_IP} ${!MASTER1_NODE_HOSTNAME}" | tee -a hostlist
      ssh-keyscan -t rsa -f hostlist > ~/.ssh/known_hosts
    fi
done

echo "Update /etc/hosts, .ssh/known_hosts file."

cat <<EOF > roles/kubeconfig/defaults/main.yml
master1_node_public_ip:
EOF

for ((i=0;i<${CLUSTER_CNT};i++))
  do
    j=$((i+1));
    
    KUBE_CONTROL_HOSTS="CLUSTER${j}_KUBE_CONTROL_HOSTS"
    MASTER1_NODE_PUBLIC_IP="CLUSTER${j}_MASTER1_NODE_PUBLIC_IP"
    LOADBALANCER_DOMAIN="CLUSTER${j}_LOADBALANCER_DOMAIN"

    if [ "${!KUBE_CONTROL_HOSTS}" -eq 1 ]; then
cat <<EOF >> roles/kubeconfig/defaults/main.yml
  - ${!MASTER1_NODE_PUBLIC_IP}
EOF
    elif [ "${!KUBE_CONTROL_HOSTS}" -gt 1 ]; then
cat <<EOF >> roles/kubeconfig/defaults/main.yml
  - ${!LOADBALANCER_DOMAIN}
EOF
    fi
done


cat <<EOF > roles/istio-multi/defaults/main.yml
cluster_count: ${CLUSTER_CNT}
ingress_nginx_ip:
EOF

for ((i=0;i<${CLUSTER_CNT};i++))
  do
    j=$((i+1));
    
    CSP_TYPE="CLUSTER${j}_CSP_TYPE"
    INGRESS_NGINX_IP="CLUSTER${j}_INGRESS_NGINX_IP"
    
    if [[ ! "${!CSP_TYPE}" == "NHN" ]]; then
cat <<EOF >> roles/istio-multi/defaults/main.yml
  - ${!INGRESS_NGINX_IP}
EOF
    elif [ "${!CSP_TYPE}" == "NHN" ]; then
cat <<EOF >> roles/istio-multi/defaults/main.yml
  - 
EOF
    fi
done

cat <<EOF >> roles/istio-multi/defaults/main.yml
istio_gateway_private_ip:
EOF

for ((i=0;i<${CLUSTER_CNT};i++))
  do
    j=$((i+1));
    
    CSP_TYPE="CLUSTER${j}_CSP_TYPE"
    ISTIO_GATEWAY_PRIVATE_IP="CLUSTER${j}_ISTIO_GATEWAY_PRIVATE_IP"

    if [[ ! "${!CSP_TYPE}" == "NHN" ]]; then
cat <<EOF >> roles/istio-multi/defaults/main.yml
  - ${!ISTIO_GATEWAY_PRIVATE_IP}
EOF
    elif [ "${!CSP_TYPE}" == "NHN" ]; then
cat <<EOF >> roles/istio-multi/defaults/main.yml
  - 
EOF
    fi
done

rm -rf hosts.yaml

cat <<EOF > hosts.yaml
all:
  hosts:
EOF

for ((i=0;i<${CLUSTER_CNT};i++))
  do
    j=$((i+1));
    
    MASTER1_NODE_HOSTNAME="CLUSTER${j}_MASTER1_NODE_HOSTNAME"
    MASTER1_NODE_PUBLIC_IP="CLUSTER${j}_MASTER1_NODE_PUBLIC_IP"
    MASTER1_NODE_PRIVATE_IP="CLUSTER${j}_MASTER1_NODE_PRIVATE_IP"

cat <<EOF >> hosts.yaml
    cluster${j}_master1_node:
      ansible_host: ${!MASTER1_NODE_HOSTNAME}
      ip: ${!MASTER1_NODE_PUBLIC_IP}
      access_ip: ${!MASTER1_NODE_PRIVATE_IP}
EOF
done

cat <<EOF >> hosts.yaml
  children:
    kube_control_plane:
      hosts:
EOF

for ((i=0;i<${CLUSTER_CNT};i++))
  do
    j=$((i+1));

cat <<EOF >> hosts.yaml
        cluster${j}_master1_node:
EOF
done

echo "Container Platform vars setting completed."

export PATH=$PATH:$HOME/.local/bin
source $HOME/.bashrc

# Deploy Container Platform
ansible-playbook -i hosts.yaml  --become --become-user=root cluster.yml
