#!/bin/bash

#archiveName="develop"
branchName="$1"
if [ -z "${archiveName}" ]; then
	archiveName="test"
fi
lab mr create origin test --remove-source-branch --squash
#lab mr create origin ${branchName} --remove-source-branch --squash
