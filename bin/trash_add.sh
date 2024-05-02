#!/bin/bash

# TODO 若目标文件在其他磁盘上，导致执行时间过长，会卡光标在状态行

echo "${fx}" | awk '{print}' | while read -r file; do
	if [ ! -e "${file}" ]; then # 处理文件不存在的情况
		echo "${file} not exist"
		exit 1
	fi
done

trashDataDir="${HOME}/.local/share/Trash/files"
trashMetaDir="${HOME}/.local/share/Trash/info"
mkdir -p "${trashDataDir}"
mkdir -p "${trashMetaDir}"

echo "${fx}" | awk '{print}' | while read -r filePath; do # 处理文件名带空格
	# 避免套娃
	dirName=$(dirname "${filePath}")
	if [[ ${dirName} == "${trashMetaDir}" || ${dirName} == "${trashDataDir}" ]]; then
		echo "invalid operation for: ${filePath}"
		continue
	fi

	#echo "del: ${filePath}"
	currentTime=$(date +"%Y-%m-%d %H:%M:%S.%3N")
	dateFormat1=$(date -d "$currentTime" "+%Y%m%d_%H%M%S_%3N")
	dateFormat2=$(date -d "$currentTime" "+%Y-%m-%dT%H:%M:%S")

	trashFileName=${dateFormat1}_$(echo "${filePath}" | md5sum | awk '{print $1}')
	# 处理重复碰撞问题
	appendix=1
	planTrashFileName="${trashFileName}"
	while [ -e "${trashDataDir}/${planTrashFileName}" ]; do
		echo "same data name exist: ${trashDataDir}/${planTrashFileName}"
		planTrashFileName="${trashFileName}-${appendix}"
		((appendix++))
	done
	trashFileName="${planTrashFileName}"
	trashFilePath="${trashDataDir}/${trashFileName}"
	#echo "data path: ${trashFilePath}"

	trashMetaPath="${trashMetaDir}/${trashFileName}.trashinfo"
	#echo "meta path: ${trashMetaPath}"

	# 避免元数据丢失
	if [ -e "${trashMetaPath}" ]; then
		echo "same metadata name exist: ${trashMetaPath}"
		continue
	fi
	# 支持trash-cli
	echo "[Trash Info]
Path=${filePath}
DeletionDate=${dateFormat2}
" >"${trashMetaPath}"

	mv -i "${filePath}" "${trashFilePath}" # -i 再次保底。可能有权限报错
done
