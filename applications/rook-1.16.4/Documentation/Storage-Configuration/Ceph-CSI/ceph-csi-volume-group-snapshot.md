---
title: Volume Group Snapshots
---

Ceph provides the ability to create crash-consistent snapshots of multiple volumes.
A group snapshot represents “copies” from multiple volumes that are taken at the same point in time.
A group snapshot can be used either to rehydrate new volumes (pre-populated with the snapshot data)
or to restore existing volumes to a previous state (represented by the snapshots)


## Prerequisites

- Install the [snapshot controller, volume group snapshot and snapshot CRDs](https://github.com/kubernetes-csi/external-snapshotter/tree/master#usage),
refer to VolumeGroupSnapshot documentation
[here](https://github.com/kubernetes-csi/external-snapshotter/tree/master#volume-group-snapshot-support) for more details.

- A `VolumeGroupSnapshotClass` is needed for the volume group snapshot to work. The purpose of a `VolumeGroupSnapshotClass` is
defined in [the kubernetes
documentation](https://kubernetes.io/blog/2024/12/18/kubernetes-1-32-volume-group-snapshot-beta/).
In short, as the documentation describes it:

!!! info
    Created by cluster administrators to describe how volume group snapshots
    should be created. including the driver information, the deletion policy, etc.

## Volume Group Snapshots

### CephFS VolumeGroupSnapshotClass

In [VolumeGroupSnapshotClass](https://github.com/rook/rook/tree/master/deploy/examples/csi/cephfs/groupsnapshotclass.yaml),
the `csi.storage.k8s.io/group-snapshotter-secret-name` parameter should reference the
name of the secret created for the cephfs-plugin.

In the `VolumeGroupSnapshotClass`, update the value of the `clusterID` field to match the namespace
that Rook is running in. When Ceph CSI is deployed by Rook, the operator will automatically
maintain a configmap whose contents will match this key. By default this is
"rook-ceph".

```console
kubectl create -f deploy/examples/csi/cephfs/groupsnapshotclass.yaml
```

### CephFS VolumeGroupSnapshot

In [VolumeGroupSnapshot](https://github.com/rook/rook/tree/master/deploy/examples/csi/cephfs/groupsnapshot.yaml),
`volumeGroupSnapshotClassName` should be the name of the `VolumeGroupSnapshotClass`
previously created. The labels inside `matchLabels` should be present on the
PVCs that are already created by the CephFS CSI driver.

```console
kubectl create -f deploy/examples/csi/cephfs/groupsnapshot.yaml
```

### Verify CephFS GroupSnapshot Creation

```console
$ kubectl get volumegroupsnapshotclass
NAME                              DRIVER                          DELETIONPOLICY   AGE
csi-cephfsplugin-groupsnapclass   rook-ceph.cephfs.csi.ceph.com   Delete           21m
```

```console
$ kubectl get volumegroupsnapshot
NAME                       READYTOUSE   VOLUMEGROUPSNAPSHOTCLASS          VOLUMEGROUPSNAPSHOTCONTENT                              CREATIONTIME   AGE
cephfs-groupsnapshot       true         csi-cephfsplugin-groupsnapclass   groupsnapcontent-d13f4d95-8822-4729-9586-4f222a3f788e   5m37s          5m39s
```

The snapshot will be ready to restore to a new PVC when `READYTOUSE` field of the
`volumegroupsnapshot` is set to true.

### Restore the CephFS volume group snapshot to a new PVC

Find the name of the snapshots created by the `VolumeGroupSnapshot` first by running:

```console
$ kubectl get volumesnapshot -o=jsonpath='{range .items[?(@.metadata.ownerReferences[0].name=="cephfs-groupsnapshot")]}{.metadata.name}{"\n"}{end}'
snapshot-a79d08c7b7e18953ec321e77be9c9646234593411136a3671d72e8a26ffd419c
```

It will list the names of the snapshots created as part of the group.

In
[pvc-restore](https://github.com/rook/rook/tree/master/deploy/examples/csi/cephfs/pvc-restore.yaml),
`dataSource` should be one of the `Snapshot` that we just
found. The `dataSource` kind should be the `VolumeSnapshot`.

Create a new PVC from the snapshot

```console
kubectl create -f deploy/examples/csi/cephfs/pvc-restore.yaml
```

### Verify CephFS Restore PVC Creation

```console
$ kubectl get pvc
cephfs-pvc           Bound    pvc-9ae60bf9-4931-4f9a-9de1-7f45f31fe4da   1Gi        RWO            rook-cephfs    <unset>                 171m
cephfs-pvc-restore   Bound    pvc-b4b73cbb-5061-48c7-9ac8-e1202508cf97   1Gi        RWO            rook-cephfs    <unset>                 46s
```

## CephFS volume group snapshot resource Cleanup

To clean the resources created by this example, run the following:

```console
kubectl delete -f deploy/examples/csi/cephfs/pvc-restore.yaml
kubectl delete -f deploy/examples/csi/cephfs/groupsnapshot.yaml
kubectl delete -f deploy/examples/csi/cephfs/groupsnapshotclass.yaml
```
