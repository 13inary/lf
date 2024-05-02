#!/bin/bash

trashDataDir="${HOME}/.local/share/Trash/files"
trashMetaDir="${HOME}/.local/share/Trash/info"
if [ ! -e "${trashMetaDir}" ]; then
	echo "xx"
fi
if [ ! -e "${trashDataDir}" ]; then
	echo "yy"
fi

# TODO 看ls-t是否影响动态加载
ls -t "${trashMetaDir}" | while IFS= read -r meta; do
	path=""
	deletion_date=""
	while IFS= read -r line; do
		case $line in
		Path=*) path="${line#Path=}" ;;
		DeletionDate=*) deletion_date="${line#DeletionDate=}" ;;
		esac
	done <"$meta"
	formatted_date=$(date -d"$deletion_date" '+%Y-%m-%d_%H:%M:%S')
	echo -e "${formatted_date}\t${path}\t${meta}"
	#| awk '{print $1 " " $2 "\t" $3}'
done | fzf --reverse --with-nth 1..2 -n 1 --delimiter='\t'
#| cut -d$'\t' -f3 >selected_index.txt

echo ${aaa}
echo $selectItem
echo ${index}
echo ${files[0]}

exit

#select=$(echo "${infos}" | fzf --reverse)
#fzfExistCode=$?
#if [ ${fzfExistCode} -eq 130 ]; then # ctrl+c
#	exit 0
#fi

OUTPUT_ARRAY=()
# 遍历info目录下的所有.trashinfo文件
for file in "${trashMetaDir}"/*.trashinfo; do
	# 提取文件名中的MD5值
	#md5=$(basename "$file" .trashinfo | cut -d'_' -f4)

	# 读取文件内容并提取Path和DeletionDate
	while IFS= read -r line; do
		case $line in
		Path=*) path="${line#Path=}" ;;
		DeletionDate=*) deletion_date="${line#DeletionDate=}" ;;
		esac
	done <"$file"

	## 更改日期格式（例如：YYYY-MM-DD HH:MM:SS）
	#formatted_date=$(date -d"$deletion_date" '+%Y-%m-%d %H:%M:%S')

	## 将信息添加到数组
	OUTPUT_ARRAY+=("$file $path $deletion_date")
done

# 将数组内容转换为换行符分隔的字符串
output_string=$(
	IFS=$'\n'
	echo "${OUTPUT_ARRAY[*]}"
)

showContent=$(echo "${output_string}" | awk '{$1="";print $0}' | column -t)

# 使用echo输出结果，或者传递给fzf
#echo "$showContent"
# 使用TODO fzf动态加载
echo "$showContent" | fzf --reverse
#fzf --reverse
