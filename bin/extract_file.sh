#!/bin/bash

set -f # 消除$f有*带来的影响

fileName=$(basename -- "$f")
#fileName="${fileName%.*}" # ${fileName%%.*} : 第一个.开始删除
#TZ=Asia/Shanghai
#tmpDir="${fileName}_$(date "+%F_%T")"
tmpDir="extract_${fileName}"

fileType=$(file "${f}" | awk -F':' '{print $2}' | awk -F',' '{print $1}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
case ${fileType} in
"bzip2 compressed data")
	mkdir -p "./${tmpDir}"
	tar xjvf "$f" -C "./${tmpDir}"
	;;
"gzip compressed data")
	mkdir -p "./${tmpDir}"
	tar xzvf "$f" -C "./${tmpDir}"
	;;
"XZ compressed data")
	mkdir -p "./${tmpDir}"
	tar xJvf "$f" -C "./${tmpDir}"
	;;
"POSIX tar archive (GNU)")
	mkdir -p "./${tmpDir}"
	tar xvf "$f" -C "./${tmpDir}"
	;;
"Zip archive data")
	unzip "$f" -d "./${tmpDir}"
	;;
"RAR archive data")
	mkdir -p "./${tmpDir}"
	unrar x "$f" "./${tmpDir}" # 闭源
	#unrar-free -x "$f" # 开源但支持不够
	#7z x "$f"          # 开源但支持不够
	;;
"7-zip archive data")
	7z x "$f" -o"./${tmpDir}"
	;;
"ISO 9660 CD-ROM filesystem data"*)
	7z x "$f" -o"./${tmpDir}"
	;;
"Microsoft OOXML" | "Microsoft Word 2007+")
	unzip "$f" -d "./${tmpDir}" # 系统预装
	#7z x "$f" -o"./${tmpDir}"
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
