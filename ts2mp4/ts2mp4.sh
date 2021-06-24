#!/bin/bash

prefix=$1

prefixLength=${#prefix}

if (( $prefixLength <= 0 )); then
    echo "需要传入前缀"
    exit 1
fi

echo -e "\033[35m转换开始\033[0m"

# 获取最大长度
maxlength=0
for filename in `ls`
do 
    totalLength=${#filename}
    if (( $maxlength < $totalLength )); then 
        maxlength=$totalLength
    fi
done

maxlength=`expr $maxlength - ${#prefix}`
    
for filename in `ls`
do
    # 是否以ts结尾
    if [ ${filename##*.} = "ts" ]; then
        # 截取右边的内容
        newfilename=${filename##$prefix}
        # 获取长度
        length=${#newfilename}
        sum=`expr $maxlength - $length`
        fix=""
        zero="0"
        for i in `seq 0 $sum`
        do
           fix="$fix$zero" 
        done
        rename="$fix$newfilename"
        `mv $filename $rename`
    fi
done

if [ -f tmp.ts ]; then
    echo -e "\033[35m删除原始tmp.ts文件\033[0m"
    rm tmp.ts
fi

echo -e "\033[35m开始合并tmp.ts\033[0m"
cat *.ts > tmp.ts
if [ $? -ne 0 ]; then
    echo -e "\033[31m合成失败\033[0m"
    exit 1
fi

time=`date +%Y%m%d%H%M%S`

`ffmpeg -i tmp.ts -c copy -map 0:v -map 0:a -bsf:a aac_adtstoasc $time.mp4`
if [ $? -ne 0 ]; then
    echo -e "\033[31mts转mp4失败\033[0m"
    exit 1
fi

echo -e "\033[35m转换结束\033[0m"
open ./
