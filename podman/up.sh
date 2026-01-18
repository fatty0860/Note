#!/usr/bin/env bash

#imgName=docker.io/redhat/ubi9:9.4
imgName=localhost/rh94

defaultUser=$(whoami)
localDir="/home/yichen/workspace/podman/data"
mntDir="/home/${defaultUser}"
mnt=""
if [ -n "$localDir" ] && [ -n "$mntDir" ]; then
	mnt="-v $localDir:$mntDir:Z --workdir ${mntDir} "
fi


loginUser="--userns=keep-id --user $(id -u):$(id -g) "
param="run -it --rm ${loginUser} ${mnt} "
cmd="bash"

envParam="
HOME=${mntDir}
"

if [ -n "$envParam" ];then
	podman ${param} --env-file <(echo "${envParam}") ${imgName} "${cmd}"
else
	podman ${param} ${imgName} "${cmd}"
fi




