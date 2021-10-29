#!/bin/bash

# 功能：根据输入的命令循环执行

# 使用：sh autoLoad.sh ‘命令’。
# 例子 sh autoLoad.sh 'pip install scrapy'，这条命令会执行pip install scrapy命令，直到成功，失败重试


com=$1

# 重试次数
count=0

trap 'onCtrlC' INT

function onCtrlC () {
	echo '手动退出'
	exit 130
}

while true
do

eval $com
if [ $? -ne 0 ]; then
	count=`expr $count + 1`
    echo -e "\033[35m第 $count 次尝试...\033[0m"
else
	echo -e "\033[47;30misDone！！🍻\033[0m"
	exit 0
fi

done



