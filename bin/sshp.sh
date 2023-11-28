#!/bin/bash

# config
utilsFile="${HOME}/.config/lf/bin/utils.sh"
if [ ! -f ${utilsFile} ]; then
	echo "utils not existed"
	exit 1
fi
source "${utilsFile}"
sshConfig="${HOME}/.ssh/ssh.lf"
delimiter="<,>" # devide column of cfg
action=$1

function readConfig() {
	if [ ! -f ${sshConfig} ]; then
		touch ${sshConfig}
	fi
	local content=$(<"$sshConfig")
	echo "$content" | sed "s/ /$delimiter/g"
}

function genNewItem() {
	local host=$1
	local user=$2
	local pass=$3
	local des=$4
	local now=$(TZ="Asia/Shanghai" date "+%F_%T")
	echo -n "${host}${delimiter}${user}${delimiter}${pass}${delimiter}${des}${delimiter}${now}"
}

function writeConfig() {
	echo "${cfg}" | sed "s/$delimiter/ /g" >"$sshConfig"
}

function readShowInfo() {
	if [ ! -f ${sshConfig} ]; then
		touch ${sshConfig}
	fi
	local content=$(<"$sshConfig")
	echo "${content}" | awk '{$3="";print $0}' | column -t
}

# init
cfg=$(readConfig)
showInfo=$(readShowInfo)

# main
select=$(echo "${showInfo}" | fzf --reverse)
fzfExistCode=$?
if [ ${fzfExistCode} -eq 130 ]; then # ctrl+c
	exit 0
fi

# handle input
user=""
host=""
pass=""
des=""
key=""
if [ -z "${select}" ]; then
	read -p "host / user@host：" userHost
	user=$(echo "${userHost}" | awk -F'@' '{print $1}')
	host=$(echo "${userHost}" | awk -F'@' '{print $2}')
	if [ -z "$host" ]; then
		user="root"
		host="$userHost"
	fi
	if [ -z "$host" ]; then
		echo "input error: host is empty"
		exit 1
	fi
	read -p "password：" pass
	if [ -z "$host" ]; then
		echo "input error: password is empty"
		exit 1
	fi
	read -p "description (default: -)：" des
	if [ -z "$des" ]; then
		des="-"
	else
		des=$(echo "$des" | sed 's/ /_/g')
	fi
	key="${host}${delimiter}${user}${delimiter}"
else
	line=$(echo "${select}" | sed 's/^[^[:alnum:]]*//')
	host=$(echo "${line}" | awk '{print $1}')
	user=$(echo "${line}" | awk '{print $2}')

	key="${host}${delimiter}${user}${delimiter}"
	activeItem=$(echo "${cfg}" | grep "${key}")
	pass=$(echo "${activeItem}" | awk -F"${delimiter}" '{print $3}')
	des=$(echo "${activeItem}" | awk -F"${delimiter}" '{print $4}')
fi

# delete match item and add this item
cfg=$(delete_string_item "${cfg}" "${key}")
newItem=$(genNewItem ${host} ${user} ${pass} ${des})
cfg=$(add_string_item "${cfg}" "${newItem}")

# update config
writeConfig

# need install sshpass
sshpasscode=0
case ${action} in
"ssh")
	echo -e "ssh ${user}@\033[34m${host}\033[0m # ${des} ..."
	sshpass -p ${pass} ssh -o StrictHostKeyChecking=no ${user}@${host} || sshpasscode=$?
	;;
"scp")
	read -p "push to (default: /tmp/): " dir
	if [ -z "${dir}" ]; then
		dir="/tmp/"
	fi
	echo -e "scp -r ${f} ${user}@\033[34m${host}\033[0m:${dir} # ${des} ..."
	sshpass -p ${pass} scp -r -o StrictHostKeyChecking=no ${f} ${user}@${host}:${dir} || sshpasscode=$?
	;;
"pcs")
	#read -p "pull from: " dir
	#if [ -z "${dir}" ]; then
	#	echo "input error: file is empty"
	#	exit 1
	#fi
	dir=""
	while true; do
		lscode=0
		if [[ ${dir} != "" ]]; then
			sshpass -p ${pass} ssh -o StrictHostKeyChecking=no ${user}@${host} "ls -al ${dir}" || lscode=$?
			echo ${dir}
		fi
		if [[ ${dir} == "" || ${lscode} -eq 2 ]]; then # emtpy or not such file
			read -p "pull from: " new
			dir=${new}
			continue
		fi

		read -p "confirm / new: " new
		if [ -n "${new}" ]; then
			dir=${new}
			continue
		fi
		break
	done
	echo -e "scp -r ${user}@\033[34m${host}\033[0m:${dir} ./ # ${des} ..."
	sshpass -p ${pass} scp -r -o StrictHostKeyChecking=no ${user}@${host}:${dir} ./ || sshpasscode=$?
	;;
*)
	echo "unknow action: ${action}"
	exit 1
	;;
esac

# handle error
if [ ${sshpasscode} -eq 130 ]; then # ctrl+c
	exit 0
fi
if [ ${sshpasscode} -ne 0 ]; then
	echo -e "exit code: \033[31m${sshpasscode}\033[0m"
	read -p "delete item ? (y/n): " deleteItem
	if [ "${deleteItem}" == "y" ]; then
		cfg=$(delete_string_item "${cfg}" "${key}")
		writeConfig
	fi
fi
exit 0
