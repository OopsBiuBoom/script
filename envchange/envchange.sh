#!/bin/bash 

# ！！！注意
# 使用时不要打开xcode，否则可能因为xcode版本保护的原因导致修改失败
# 如果手动修改了配置之后，记得保存之后再运行脚本，否则脚本运行的时候用的是你修改之前的内容进行修改
# 如果不需要脚本，可到fastlane里注释掉调用脚本的命令

# 使用说明
# 脚本参数：debug表示测试环境。release表示线上环境
# 配合fastlane修改配置文件`AppConstants.h`中的`#define kServerConfig`宏
# 2表示测试环境，3表示线上环境
# 使用`fastlane debug` 或 `fastlane release`都会自动运行此脚本，不需要手动运行


# 通用正则
reg="^#define[ ]+kServerConfig[ ]+[0-9]+$"
# 测试环境正则
debugReg="^#define[ ]+kServerConfig[ ]+2$"
# 线上环境正则
releaseReg="^#define[ ]+kServerConfig[ ]+3$"
# 测试配置
debugConfig="#define kServerConfig 2"
# 线上配置
releaseConfig="#define kServerConfig 3"
# 文件名
fileName="AppConstants.h"
# 文件地址
filePath="../MyMall/Common/Constants/${fileName}"
# debug标识
debugFlag="debug"
# release标识
releaseFlag="release"
# 环境
env=$1

echo -e "\033[32m当前环境${env}\033[0m"

# 参数检查
if [[ ${env} = "" ]]; then
    echo -e "\033[31m需要传入参数，可选择:\n1.测试选项${debugFlag}\n2.发布选项${releaseFlag}\033[0m"
    exit 1
fi

if [[ ${env} == ${debugFlag} || ${env} == ${releaseFlag} ]]; then
    :
else 
    echo -e "\033[31m没有参数${env}。可选择:\n1.测试选项${debugFlag}\n2.发布选项${releaseFlag}\033[0m"
    exit 1
fi

# 检查文件是否存在
if [ ! -f ${filePath} ]; then
    echo -e "\033[31m路径${filePath}下的${fileName}文件不存在\033[0m"
    exit 1
fi

# 检查配置是否成正确.返回0表示成功，其他表示错误
chekConfig(){
    
    echo -e "\033[32m正在进行校验...\033[0m"
    
    checkReg=""
    if [[ ${env} = ${debugFlag} ]]; then
        checkReg=${debugReg}
    elif [[ ${env} = ${releaseFlag} ]]; then
        checkReg=${releaseReg}
    fi

    result=$(egrep "${checkReg}" ${filePath})
    echo -e "\033[32m检查使用的正则：${checkReg}\033[0m"
    echo -e "\033[32m检查文件地址：${filePath}\033[0m"
    echo -e "\033[32m查找结果：\"${result}\" - 内容长度${#result}\033[0m"
    if (( ${#result} == 0 )); then
        echo -e "\033[31m路径${filePath}下的${fileName}文件内未找到环境变量，请检查\033[0m"
        return 1
    else 
        echo -e "\033[32m修改环境变量成功\033[0m"
        return 0
    fi
}

# 根据环境获取对应的配置
config=""
if [ ${env} = ${debugFlag} ]; then
    config=${debugConfig}
elif [ ${env} = ${releaseFlag} ]; then
    config=${releaseConfig}
fi

# 修改配置
echo -e "\033[32m修改使用的正则：${reg}\033[0m"
echo -e "\033[32m使用\"${config}\"修改配置\033[0m"
$(sed -E -i "" "s/${reg}/${config}/g" ${filePath})
if [[ $? != 0 ]]; then 
    echo -e "\033[31m执行命令sed失败\033[0m"
    exit 1
fi

# 检查配置是否修改成功
chekConfig
if [[ $? = 0 ]]; then
    echo -e "\033[32m配置修改成功 \033[0m"
    exit 0
fi

exit 1

