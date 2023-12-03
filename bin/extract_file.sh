#!/bin/bash

set -f # 消除$f有*带来的影响

fileName=$(basename -- "$f")
#fileName="${fileName%.*}" # ${fileName%%.*} : 第一个.开始删除
#TZ=Asia/Shanghai
#tmpDir="${fileName}_$(date "+%F_%T")"
tmpDir="extract_${fileName}"

# TODO tar docx
fileType=$(file ${f} | awk '{print $2}')
case ${fileType} in
bzip2)
	mkdir -p ./${tmpDir}
	tar xjvf $f -C ./${tmpDir}
	;;
gzip)
	mkdir -p ./${tmpDir}
	tar xzvf $f -C ./${tmpDir}
	;;
XZ)
	mkdir -p ./${tmpDir}
	tar xJvf $f -C ./${tmpDir}
	;;
Zip)
	unzip $f -d ./${tmpDir}
	;;
RAR)
	mkdir -p ./${tmpDir}
	unrar x $f ./${tmpDir} # 闭源
	#unrar-free -x $f # 开源但支持不够
	#7z x $f          # 开源但支持不够
	;;
7-zip)
	7z x $f -o./${tmpDir}
	;;
ISO)
	7z x $f -o./${tmpDir}
	;;
*)
	echo "unsupport file type: "${fileType}
	exit 1
	;;
esac

exit

case $f in
*.tar.bz | *.tar.bz2 | *.tbz | *.tbz2)
	tar xjvf $f
	;;
*.tar.gz | *.tgz)
	tar xzvf $f
	;;
*.tar.xz | *.txz)
	tar xJvf $f
	;;
*.zip)
	unzip $f
	;;
*.rar)
	unrar x $f
	;;
*.7z)
	7z x $f
	;;
esac
