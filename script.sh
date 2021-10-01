#!/bin/bash
VM_ID=$1
IMAGE_PATH=$2
STORAGE_POOL=$3
# The new imported disk will get a name that depends on the current number of disks for the vm 
DISK_COUNT=$4

qm stop "$VM_ID" || exit 1 
qm importdisk "$VM_ID" "$IMAGE_PATH" "$STORAGE_POOL" || exit 1 
qm set "$VM_ID" --scsi0 "$STORAGE_POOL:vm-$VM_ID-disk-$DISK_COUNT" || exit 1 
qm set "$VM_ID" --boot order=scsi0 || exit 1 
qm start "$VM_ID" || exit 1 
