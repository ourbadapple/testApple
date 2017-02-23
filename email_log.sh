#!/bin/sh

Path="/Users/patrickw/Desktop/project/code/kartor/kartor3"  #项目所在目录
tempPath=~/Desktop/temp.text  #临时文件
resultPath=~/Desktop/result_log.text  #输出定向

NickNames=("dujianwei" "wanghang" "hecq" "ZhuLuRan" "daviyang35" "沈希" "张凡" "huangj") #开发人员提交用户名
Coders=("杜建为" "王航" "何从强" "朱路然" "杨大伟" "沈希" "梁齐才" "张凡" "黄军")  #真实姓名
ReviewCoders=("何从强" "朱路然" "杜建为" "杜建为" "何从强" "何从强" "沈希" "沈希")    #评审人员

#################################################################

function Write_Log() {
    filePath=$1
    while read line
    do
        index=0
        for ele in ${NickNames[*]}
        do
            if [[ $line =~ $ele ]]
            then
                real=${Coders[$index]}

                ret=${line//$ele/$real}

                reviewer=${ReviewCoders[$index]}

                result="${ret}--${reviewer}"

                echo $result >> $resultPath

            break
            fi
        index=`expr ${index} + 1`
        done

    done < $filePath

    if [ -f $filePath ]
    then
        echo "忽略此警告"
        rm rf $filePath #删除临时文件
    fi
}

#################################################################

echo "请输入提交记录开始时间，格式(yyyy-MM-dd hh:mm:ss)"
read beginDate

echo "请输入提交记录结束时间，格式(yyyy-MM-dd hh:mm:ss)"
read endDate

#################################################################

cd $Path

git log --since="${beginDate}" --before="${endDate}" --pretty=format:"%s--%an" > $tempPath

if [ -f $resultPath ]
then
    rm -rf $resultPath  #删除旧文件
fi

echo "正在处理>>>>>>>"

Write_Log "$tempPath"

echo "已完成<<<<<<<<<"
