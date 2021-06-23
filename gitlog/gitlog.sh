#!/bin/bash

# 用来打印你的git commit日志，写日报，汇报工作等

#--------- 使用说明 ---------#
# 1. 需要填写`用户自定义修改部分`的参数
# 2.1 执行脚本，默认输出当天所选择分支的日志
# 2.2 （可选）执行`./gitlog date`会出现时间选择列表
# 3. 如果没有执行权限使用chmod +x来获取
#----------- end ----------#

# TODO:
# 1. √可以选择：昨天，今天，上周，本周
# 2. √加载完后自动打开
# 3. 添加序号
# 4. 打印多份日志

#----- 用户自定义修改部分 -----#
# .git文件路径，可以输入多个。
# 例子：inputPaths=( '/Users/mac/Documents/working/merry' '/Users/mac/Documents/script' '...')
inputPaths=( '/Users/bii/Documents/working/merry' '/Users/bii/Documents/working/script' )
# 日志输出路径
outPath="/Users/bii/Desktop/"
# 需要查询的用户名或者邮箱，可使用正则
user="lzq"
#----------- end ----------#


#----------- 流程 ----------#
# 脚本传入的第一个参数
param1=$1

# 时间
today="today"
yesterday="yesterday"
week="week"
lastweek="lastweek"

# 修改时间
changeDate() {
    f1=$1
    case $f1 in
        ${today})
            # 当天
            startDate=$(date "+%Y-%m-%d 00:00:00")
            endDate=$(date "+%Y-%m-%d 23:59:59")
            ;;
        ${yesterday})
            # 昨天
            startDate=$(date -v -1d "+%Y-%m-%d 00:00:00")
            endDate=$(date -v -1d "+%Y-%m-%d 23:59:59")
            ;;
        ${week})
            # 本周
            startDate=$(date -v1w "+%Y-%m-%d 00:00:00")
            endDate=$(date -v0w -v+1w "+%Y-%m-%d 23:59:59")
            ;;
        ${lastweek})
            # 上周
            startDate=$(date -v1w -v-1w "+%Y-%m-%d 00:00:00")
            endDate=$(date -v0w "+%Y-%m-%d 23:59:59")
            ;;
    esac
}

if [[ ${param1} == "date" ]];then
    # 时间选择
    while true; do
        echo -e "\033[32m----------------------\033[0m"
        echo -e "\033[32m请选择要打印的时间：\033[0m"
        echo -e "\033[32m1. 今天\033[0m"
        echo -e "\033[32m2. 昨天\033[0m"
        echo -e "\033[32m3. 本周\033[0m"
        echo -e "\033[32m4. 上周\033[0m"
        echo -e "\033[32m----------------------\033[0m"

        read selectDate

        if (( $selectDate > 4 || $selectDate <= 0 ));then
            echo -e "\033[31m超出选择范围，请重新选择\033[0m"
        else
            break
        fi
    done

    paramString=""

    case $selectDate in
        1)
            paramString=${today}
            ;;
        2)
            paramString=${yesterday}
            ;;
        3)
            paramString=${week}
            ;;
        4)
            paramString=${lastweek}
            ;;
    esac

        changeDate ${paramString}
elif [[ ${param1} == '' ]];then
    # 默认打印当前时间
    changeDate ${today}
fi

echo -e "\033[35m打印时间段：${startDate} - ${endDate}\033[0m"

# 获取当前时间
date=$(date "+%Y%m%d%H%M%S")

# 输出文件名
logPath=${outPath}/${date}.txt

for path in ${inputPaths[@]}; do
    echo -e "\033[35m正在打印：${path}\033[0m"
    cd ${path}
    git shortlog --author=${user} --since="${startDate}" --until="${endDate}" >> ${logPath}
done

if [ ! -f ${logPath} ]; then
    echo -e "\033[31m打印失败\033[0m"
else
    echo -e "\033[32m日志打印结束，文件路径${logPath} \033[0m"
    open ${logPath}
fi