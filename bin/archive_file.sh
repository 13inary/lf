#!/bin/bash

set -f
archiveName="$1"
TZ=Asia/Shanghai
if [ -z "${archiveName}" ]; then
	archiveName="$(date '+%Y%m%d_%H%M%S')_backup"
else
	archiveName="${archiveName}_$(date '+%Y%m%d_%H%M%S')_backup"
fi

files=""
for file in ${fx}; do
	fileName=$(basename -- "${file}")
	if [ ! -e "$fileName" ]; then # 处理文件不存在的情况
		echo "$fileName not exist"
		exit 1
	fi
	files+="${fileName} "
done
#files="${files% }" # 去掉尾部空格

fileType="gzip"
case ${fileType} in
gzip)
	tar czvf "${archiveName}.tar.gz" ${files} # 后面的files若不存在，退出码依然为0
	echo "${archiveName}.tar.gz"
	;;
Zip)
	zip -r "${archiveName}.zip" ${files}
	echo "${archiveName}.zip"
	;;
esac
if [ $? -eq 0 ]; then
	lf -remote 'send unselect'
fi
