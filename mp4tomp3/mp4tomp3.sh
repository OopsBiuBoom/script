#!/bin/bash
# MP4转MP3

# 创建目录
mkdir -p mp3

for filename in `ls`
do
    # 是否以mp4结尾
    if [ ${filename##*.} = "mp4" ]; then

        # 获取名字
        mp3name=${filename%.*}

        # 转成mp3放到指定文件夹中
        ffmpeg -i ${filename} -b:a 192K -vn ./mp3/${mp3name}.mp3
    fi
done