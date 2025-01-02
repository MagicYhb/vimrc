#!/bin/bash
 
#> File Name:        update_code.sh
#> Author:           MagicYang
#> Version:          1.0.1
#> Mail:             476080754@qq.com
#> Created Time:     2024-12-31 14:23:22

DYEL='\E[0;33m'
DYELL='\E[43;30m'
GRN='\E[1;32m'
SKY_BLUE='\E[1;36m'
RES='\E[0m'
 
# 定义仓库目录和远程仓库URL
PRO_DIR="/home/yhb/files/source_code/project"

#set -x
 
# 进入仓库目录
cd "$PRO_DIR" || exit

# 执行git拉取最新代码
echo "进入代码仓库..."

project_path=`find . -name ".git"`

for i in $project_path
do
    #echo "path:$i"
    if [ -d $i ]; then
        #echo "this is directory"
        cd $i
        git_dir=`pwd`
        #echo "git dir:$git_dir"
        cd - #run update.sh path
        pull_dir="${git_dir:0:-4}"
        #echo "pull dir:$pull_dir"
        cd $pull_dir
        echo -e "${DYELL}will pull code, path:$pull_dir ...${RES}"
        git pull
        cd - #run update.sh path
    fi
done

exit 0
