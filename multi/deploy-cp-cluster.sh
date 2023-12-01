#!/bin/bash

for ((x=0;x<2;x++))
  do
    y=$((x+1));

    # Registering Container Platform Variable
    source cp-cluster-vars${y}.sh

    # Check Node Variable
    result=0

    if [ "$KUBE_CONTROL_HOSTS" == "" ]; then
      echo "Cluster${y} KUBE_CONTROL_HOSTS is empty. Enter a variable."
      result=2
    elif [[ ! "$KUBE_CONTROL_HOSTS" =~ ^[0-9]+$ ]]; then
      echo "Cluster${y} KUBE_CONTROL_HOSTS is not a value in Number format. Enter a Number format variable."
      result=2
    elif [ "$KUBE_CONTROL_HOSTS" -eq 0 ]; then
      echo "The minimum value of the Cluster${y} KUBE_CONTROL_HOSTS variable is 1."
      result=2
    elif [ ! "$KUBE_CONTROL_HOSTS" == "" ]; then
      for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
        do
          j=$((i+1));
          eval "master_node_hostname=\${MASTER${j}_NODE_HOSTNAME}";
          eval "master_node_public_ip=\${MASTER${j}_NODE_PUBLIC_IP}";
          eval "master_node_private_ip=\${MASTER${j}_NODE_PRIVATE_IP}";

          if [ "$master_node_hostname" == "" ]; then
            echo "Cluster${y} MASTER${j}_NODE_HOSTNAME is empty. Enter a variable."
            result=2
            break
          elif [ "$master_node_public_ip" == "" ] && [ ${j} -eq 1 ]; then
            echo "Cluster${y} MASTER${j}_NODE_PUBLIC_IP is empty. Enter a variable."
            result=2
            break
          elif [[ ! "$master_node_public_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [ ${j} -eq 1 ]; then
            echo "Cluster${y} MASTER${j}_NODE_PUBLIC_IP is not a value in IP format. Enter a IP format variable."
            result=2
            break
          elif [ "$master_node_private_ip" == "" ]; then
            echo "Cluster${y} MASTER${j}_NODE_PRIVATE_IP is empty. Enter a variable."
            result=2
            break
          elif [[ ! "$master_node_private_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "Cluster${y} MASTER${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
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
        echo "Cluster${y} LOADBALANCER_DOMAIN is empty. Enter a variable."
        result=2
      elif [ "$ETCD_TYPE" == "" ]; then
        echo "Cluster${y} ETCD_TYPE is empty. Enter a variable."
        result=2
      elif [ ! "$ETCD_TYPE" == "external" ] && [ ! "$ETCD_TYPE" == "stacked" ]; then
        echo "Cluster${y} ETCD_TYPE must be 'external' or 'stacked'."
        result=2
      elif [ "$ETCD_TYPE" == "external" ]; then
        for ((i=0;i<$KUBE_CONTROL_HOSTS;i++))
          do
            j=$((i+1));
            eval "etcd_node_hostname=\${ETCD${j}_NODE_HOSTNAME}";
            eval "etcd_node_private_ip=\${ETCD${j}_NODE_PRIVATE_IP}";

            if [ "$etcd_node_hostname" == "" ]; then
              echo "Cluster${y} ETCD${j}_NODE_HOSTNAME is empty. Enter a variable."
              result=2
              break
            elif [ "$etcd_node_private_ip" == "" ]; then
              echo "Cluster${y} ETCD${j}_NODE_PRIVATE_IP is empty. Enter a variable."
              result=2
              break
            elif [[ ! "$etcd_node_private_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
              echo "Cluster${y} ETCD${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
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
      echo "Cluster${y} KUBE_WORKER_HOSTS is empty. Enter a variable."
      result=2
    elif [[ ! "$KUBE_WORKER_HOSTS" =~ ^[0-9]+$ ]]; then
      echo "Cluster${y} KUBE_WORKER_HOSTS is not a value in Number format. Enter a Number format variable."
      result=2
    elif [ "$KUBE_WORKER_HOSTS" -eq 0 ]; then
      echo "The minimum value of the Cluster${y} KUBE_WORKER_HOSTS variable is 1."
      result=2
    elif [ ! "$KUBE_WORKER_HOSTS" == "" ]; then
      for ((i=0;i<$KUBE_WORKER_HOSTS;i++))
        do
          j=$((i+1));
          eval "worker_node_hostname=\${WORKER${j}_NODE_HOSTNAME}";
          eval "worker_node_private_ip=\${WORKER${j}_NODE_PRIVATE_IP}";

          if [ "$worker_node_hostname" == "" ]; then
            echo "Cluster${y} WORKER${j}_NODE_HOSTNAME is empty. Enter a variable."
            result=2
            break
          elif [ "$worker_node_private_ip" == "" ]; then
            echo "Cluster${y} WORKER${j}_NODE_PRIVATE_IP is empty. Enter a variable."
            result=2
            break
          elif [[ ! "$worker_node_private_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "Cluster${y} WORKER${j}_NODE_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
            result=2
            break
          fi
      done
    fi

    if [ "$result" == 2 ]; then
      return $result
    fi

    if [ "$STORAGE_TYPE" == "" ]; then
      echo "Cluster${y} STORAGE_TYPE is empty. Enter a variable."
      result=2
    elif [ ! "$STORAGE_TYPE" == "nfs" ] && [ ! "$STORAGE_TYPE" == "rook-ceph" ]; then
      echo "Cluster${y} STORATE_TYPE must be 'nfs' or 'rook-ceph'."
      result=2
    elif [ "$STORAGE_TYPE" == "nfs" ] && [ "$NFS_SERVER_PRIVATE_IP" == "" ]; then
      echo "Cluster${y} NFS_SERVER_PRIVATE_IP is empty. Enter a variable."
      result=2
    elif [ "$STORAGE_TYPE" == "nfs" ] && [[ ! "$NFS_SERVER_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "Cluster${y} NFS_SERVER_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
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

    if [ "$ISTIO_INGRESS_PRIVATE_IP" == "" ]; then
      echo "ISTIO_INGRESS_PRIVATE_IP is empty. Enter a variable."
      result=2
    elif [[ ! "$ISTIO_INGRESS_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "ISTIO_INGRESS_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
      result=2
    fi

    if [ "$result" == 2 ]; then
      return $result
    fi

    if [ "$ISTIO_EASTWEST_PRIVATE_IP" == "" ]; then
      echo "ISTIO_EASTWEST_PRIVATE_IP is empty. Enter a variable."
      result=2
    elif [[ ! "$ISTIO_EASTWEST_PRIVATE_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "ISTIO_EASTWEST_PRIVATE_IP is not a value in IP format. Enter a IP format variable."
      result=2
    fi

    if [ "$result" == 2 ]; then
      return $result
    fi

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

    if [ "${x}" -eq 0 ]; then
      CLUSTER1_KUBE_CONTROL_HOSTS=$KUBE_CONTROL_HOSTS
      CLUSTER1_MASTER1_NODE_HOSTNAME=$MASTER1_NODE_HOSTNAME
      CLUSTER1_MASTER1_NODE_PUBLIC_IP=$MASTER1_NODE_PUBLIC_IP
      CLUSTER1_MASTER1_NODE_PRIVATE_IP=$MASTER1_NODE_PRIVATE_IP
      CLUSTER1_LOADBALANDER_DOMAIN=$LOADBALANDER_DOMAIN
      CLUSTER1_INGRESS_NGINX_PRIVATE_IP=$INGRESS_NGINX_PRIVATE_IP
      CLUSTER1_ISTIO_INGRESS_PRIVATE_IP=$ISTIO_INGRESS_PRIVATE_IP
      CLUSTER1_ISTIO_EASTWEST_PRIVATE_IP=$ISTIO_EASTWEST_PRIVATE_IP
    else
      CLUSTER2_KUBE_CONTROL_HOSTS=$KUBE_CONTROL_HOSTS
      CLUSTER2_MASTER1_NODE_HOSTNAME=$MASTER1_NODE_HOSTNAME
      CLUSTER2_MASTER1_NODE_PUBLIC_IP=$MASTER1_NODE_PUBLIC_IP
      CLUSTER2_MASTER1_NODE_PRIVATE_IP=$MASTER1_NODE_PRIVATE_IP
      CLUSTER2_LOADBALANDER_DOMAIN=$LOADBALANDER_DOMAIN
      CLUSTER2_INGRESS_NGINX_PRIVATE_IP=$INGRESS_NGINX_PRIVATE_IP
      CLUSTER2_ISTIO_INGRESS_PRIVATE_IP=$ISTIO_INGRESS_PRIVATE_IP
      CLUSTER2_ISTIO_EASTWEST_PRIVATE_IP=$ISTIO_EASTWEST_PRIVATE_IP
    fi
done

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
for ((i=0;i<2;i++))
  do
    j=$((i+1));
    eval "master1_node_hostname=\${CLUSTER${j}_MASTER1_NODE_HOSTNAME}";
    eval "master1_node_public_ip=\${CLUSTER${j}_MASTER1_NODE_PUBLIC_IP}";

    HOST_CHECK=$(sudo cat /etc/hosts | grep "$master1_node_public_ip $master1_node_hostname")

    if [ "$HOST_CHECK" == "" ]; then
      echo "$master1_node_public_ip $master1_node_hostname" | sudo tee -a /etc/hosts
      echo "$master1_node_public_ip $master1_node_hostname" | tee -a hostlist
      ssh-keyscan -t rsa -f hostlist > ~/.ssh/known_hosts
    fi
done

echo "Update /etc/hosts, .ssh/known_hosts file."

# Container Platform configuration settings
cp roles/kubeconfig1/defaults/main.yml.ori roles/kubeconfig1/defaults/main.yml
cp roles/kubeconfig2/defaults/main.yml.ori roles/kubeconfig2/defaults/main.yml

for ((i=0;i<2;i++))
  do
    j=$((i+1));
    eval "kube_control_hosts=\${CLUSTER${j}_KUBE_CONTROL_HOSTS}";
    eval "master1_node_public_ip=\${CLUSTER${j}_MASTER1_NODE_PUBLIC_IP}";
    eval "loadbalancer_domain=\${CLUSTER${j}_LOADBALANCER_DOMAIN}";

    if [ "$kube_control_hosts" -eq 1 ]; then
      sed -i "s/{MASTER1_NODE_PUBLIC_IP}/$master1_node_public_ip/g" roles/kubeconfig${j}/defaults/main.yml
    elif [ "$kube_control_hosts" -gt 1 ]; then
      sed -i "s/{MASTER1_NODE_PUBLIC_IP}/$loadbalancer_domain/g" roles/kubeconfig${j}/defaults/main.yml
    fi
done

cp roles/istio-multi/defaults/main.yml.ori roles/istio-multi/defaults/main.yml
sed -i "s/{CLUSTER1_INGRESS_NGINX_PRIVATE_IP}/$CLUSTER1_INGRESS_NGINX_PRIVATE_IP/g" roles/istio-multi/defaults/main.yml
sed -i "s/{CLUSTER1_ISTIO_INGRESS_PRIVATE_IP}/$CLUSTER1_ISTIO_INGRESS_PRIVATE_IP/g" roles/istio-multi/defaults/main.yml
sed -i "s/{CLUSTER1_ISTIO_EASTWEST_PRIVATE_IP}/$CLUSTER1_ISTIO_EASTWEST_PRIVATE_IP/g" roles/istio-multi/defaults/main.yml
sed -i "s/{CLUSTER2_INGRESS_NGINX_PRIVATE_IP}/$CLUSTER2_INGRESS_NGINX_PRIVATE_IP/g" roles/istio-multi/defaults/main.yml
sed -i "s/{CLUSTER2_ISTIO_INGRESS_PRIVATE_IP}/$CLUSTER2_ISTIO_INGRESS_PRIVATE_IP/g" roles/istio-multi/defaults/main.yml
sed -i "s/{CLUSTER2_ISTIO_EASTWEST_PRIVATE_IP}/$CLUSTER2_ISTIO_EASTWEST_PRIVATE_IP/g" roles/istio-multi/defaults/main.yml

rm -rf hosts.yaml

cat <<EOF > hosts.yaml
all:
  hosts:
    cluster1_master1_node:
      ansible_host: $CLUSTER1_MASTER1_NODE_HOSTNAME
      ip: $CLUSTER1_MASTER1_NODE_PUBLIC_IP
      access_ip: $CLUSTER1_MASTER1_NODE_PRIVATE_IP
    cluster2_master1_node:
      ansible_host: $CLUSTER2_MASTER1_NODE_HOSTNAME
      ip: $CLUSTER2_MASTER1_NODE_PUBLIC_IP
      access_ip: $CLUSTER2_MASTER1_NODE_PRIVATE_IP
  children:
    kube_control_plane:
      hosts:
        cluster1_master1_node:
        cluster2_master1_node:
EOF

echo "Container Platform vars setting completed."

# Deploy Container Platform
ansible-playbook -i hosts.yaml  --become --become-user=root cluster.yml
