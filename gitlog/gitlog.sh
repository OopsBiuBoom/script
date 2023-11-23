#!/bin/bash

# 用来打印你的git commit日志，写日报，汇报工作等

#--------- 使用说明 ---------#
# 1. 需要填写`用户自定义修改部分`的参数
# 2. 执行脚本，默认输出当天所选择分支的日志
# 3. 如果没有执行权限使用chmod +x来获取
# 4. 使用-h参数打印使用方法
#----------- end ----------#

# TODO:
# 1. √可以选择：昨天，今天，上周，本周，本月，上月
# 2. √加载完后自动打开
# 3. 添加序号
# 4. √打印多份日志
# 5. √可打印多用户名日志
# 6. √可选择分支

#----- 用户自定义修改部分 -----#
# .git文件路径，可以输入多个。
# 例子：`inputPaths=( '/Users/mac/Documents/working/merry' '/Users/mac/Documents/script' '...')`
inputPaths=( '/Users/bii/Documents/working/meijia' '/Users/bii/Documents/working/merry' '/Users/bii/Documents/working/MerryMerchant')
# 日志输出路径
outPath="/Users/bii/Desktop/"
# 需要查询的用户名或者邮箱，可使用正则，可打印多人
# 例子：打印用户名`user="lzq\|Bii"`
user="lzq\|Bii"
#----------- end ----------#

#----------- 帮助 ----------#

if [[ $1 == "-h" || $1 == "-help" ]];then
    echo -e "\033[35m---------------------示例---------------------\033[0m"
    echo -e "\033[35m'sh gitlog.sh -d -b'，会弹出选择时间列表和分支列表\n\033[0m"
    echo -e "\033[35m---------以下是可用参数列表---------\033[0m"
    echo -e "\033[35m1. 参数'-d' 或 '-date'：可选择时间\033[0m"
    echo -e "\033[35m2. 参数'-b' 或 '-branch'：可选择分支\033[0m"
    echo -e "\033[35m-------------------------------------\033[0m"
    exit 0
fi

#----------- 流程 ----------#
# 传入参数集合
inputParams=()

optIndex=0
for opt ; do
    inputParams[optIndex]=${opt}
    optIndex=`expr ${optIndex} + 1`
done

# 时间
today="today"
yesterday="yesterday"
week="week"
lastweek="lastweek"
month="month"
lastmonth="lastmonth"

# 分支数组(顺序和inputPaths路径数组位置相同)
branchTextList=()
branchTextIndex=0
# 获取分支信息
selectBranchInfo(){
    for path in ${inputPaths[@]}; do
        cd ${path}

        # 获取分支
        branchIndex=0
        branchList=()
        for item in `git branch --format='%(refname:short)'`
        do
            branchList[branchIndex]=${item}
            branchIndex=`expr ${branchIndex} + 1`
        done

        # 显示分支列表
        echo -e "\033[32m----------------------\033[0m"
        echo -e "\033[32m项目地址：${path}\033[0m"
        echo -e "\033[31m请选择要打印的分支（可多选，序号之间用空格隔开，按回车确定）：\033[0m"
        branchIndex=1
        for item in ${branchList[@]}
        do
            echo -e "\033[32m${branchIndex}. ${item}\033[0m"
            branchIndex=`expr ${branchIndex} + 1`
        done
        echo -e "\033[32m----------------------\033[0m"

        echo -e "\033[32m请输入选择：\033[0m"
        read selectBranch

        selecttext=""
        for selectIndex in $selectBranch
        do
            currentIndex=`expr ${selectIndex} - 1`
            selecttext+=" ${branchList[currentIndex]}"
        done

        branchTextList[branchTextIndex]=${selecttext}

        branchTextIndex=`expr ${branchTextIndex} + 1`
    done

    # 显示分支信息
    pathCount=${#inputPaths[@]}
    for((i=0;i<${pathCount};i++)); do  
        echo -e "地址：${inputPaths[i]}，选择了分支有：${branchTextList[i]}"
    done
}

# 获取当月最后一天
lastDay(){
    f1=$1
    case $f1 in 
        [13578])
            return 31
            ;;
        10)
            return 31
            ;;
        12)
            return 31
            ;;
        [2469])
            return 30
            ;;
        11)
            return 30
            ;;
    esac
}

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
        ${month})
            # 本月
            startDate=$(date "+%Y-%m-01 00:00:00")
            m=$(date "+%b")
            lastDay $m
            endDate=$(date "+%Y-%m-$? 23:59:59")
            ;;
        ${lastmonth})
            # 上月
            startDate=$(date -v-1m "+%Y-%m-01 00:00:00")
            m=$(date -v-1m "+%b")
            lastDay $m
            endDate=$(date -v-1m "+%Y-%m-$? 23:59:59")
            ;;
    esac
}

# 时间选择目录
selectDate() {
    while true; do
        echo -e "\033[32m----------------------\033[0m"
        echo -e "\033[32m请选择要打印的时间：\033[0m"
        echo -e "\033[32m1. 今天\033[0m"
        echo -e "\033[32m2. 昨天\033[0m"
        echo -e "\033[32m3. 本周\033[0m"
        echo -e "\033[32m4. 上周\033[0m"
        echo -e "\033[32m5. 本月\033[0m"
        echo -e "\033[32m6. 上月\033[0m"
        echo -e "\033[32m----------------------\033[0m"

        read selectDate

        if (( $selectDate > 6 || $selectDate <= 0 ));then
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
        5)
            paramString=${month}
            ;;
        6)
            paramString=${lastmonth}
            ;;
    esac

        changeDate ${paramString}
}

# 流程执行
pidx=0
for option in ${inputParams[@]}
do
    # 时间选择
    if [[ ${option} == "-d" || ${option} == "-date" ]];then
        selectDate
    fi

    # 分支选择
    if [[ ${option} == "-b" || ${option} == "-branch" ]];then
        selectBranchInfo
    fi
done

# 如果没有选择时间，默认选择今天
if (( ${#startDate} <= 0 || ${#endDate} <= 0));then
    changeDate ${today}
fi


echo -e "\033[35m打印时间段：${startDate} - ${endDate}\033[0m"

# 获取当前时间
date=$(date "+%Y%m%d%H%M%S")

# 输出文件名
logPath=${outPath}/${date}.txt

# 打印日志
pathCount=${#inputPaths[@]}
for((i=0;i<${pathCount};i++)); do  
    path=${inputPaths[i]}
    branchText=${branchTextList[i]}

    echo -e "\033[35m正在打印：${path}\033[0m"
    cd ${path}
    # echo -e "\033[35m命令 git shortlog --author=${user} --since="${startDate}" --until="${endDate}" ${branchText} >> ${logPath}\033[0m"
    git shortlog --author=${user} --since="${startDate}" --until="${endDate}" ${branchText} >> ${logPath}
done

if [ ! -f ${logPath} ]; then
    echo -e "\033[31m打印失败\033[0m"
else
    echo -e "\033[32m日志打印结束，文件路径${logPath} \033[0m"
    open ${logPath}
fi