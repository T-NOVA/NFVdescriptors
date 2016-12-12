#!/bin/bash

declare -a vnfs=("itlgpu22" "vSA-firewall-57")

for vnf in "${vnfs[@]}"; do
	echo $vnf
	curl -v --progress-bar -X POST -H "Content-type: multipart/form-data" -H "MD5SUM: $(cat $vnfs.md5)" -H "Provider-ID: 4" -H "Image-Type: qcow2" -F "file=@$vnf.qcow2" 193.136.92.197:3003/NFS/files
done

