#!/bin/bash

currentDir=$(pwd)
goPath="${GOPATH}"

if [[ $currentDir != "$goPath"* ]]; then
	lf -remote "send $id select \"$(fzf --prompt 'search file: ' --header=$(pwd) --preview 'batcat --color=always {}')\""
	exit 0
fi

workDir="${currentDir}"
while [ "$workDir" != "/" ]; do
	if [ -f "${workDir}/go.mod" ]; then
		break
	fi
	if [ -d "${workDir}/.git" ]; then
		break
	fi
	workDir=$(dirname "$workDir")
done
if [ "${workDir}" == "/" ]; then
	workDir="${goPath}/src"
fi

cd ${workDir}
selectFile=$(fzf --prompt 'search file: ' --header=${workDir} --preview 'batcat --color=always {}')
if [ -z "${selectFile}" ]; then
	exit 0
fi
lf -remote "send $id select \"${workDir}/${selectFile}\""
