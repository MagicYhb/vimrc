#!/bin/bash


DYEL='\E[0;33m'
DYELL='\E[43;30m'
GRN='\E[1;32m'
RES='\E[0m'

echo " "

if [ $# -lt 1 ]; then
    echo -e "${DYELL}example: ${RES}"
    echo " "

    echo -e "${DYEL}mode 1: 以目标目录为索引名，创建单个索引  ${RES}"
    echo -e "${GRN}    build module:    ./create_csidx.sh path ${RES}"
    echo " "

    echo -e "${DYEL}mode 2: 以目标目录下的文件夹为索引名，创建多个索引  ${RES}"
    echo -e "${GRN}    build all:       ./create_csidx.sh path all ${RES}"
    echo " "

    echo -e "${DYEL}mode 3: 更新cscope目录下全部索引  ${RES}"
    echo -e "${GRN}    rebuild all:     ./create_csidx.sh rebuild ${RES}"
    echo " "

    echo -e "${DYEL}mode 4: 更新cscope目录下单个索引，索引名忽略大小写  ${RES}"
    echo -e "${GRN}    rebuild module:  ./create_csidx.sh rebuild module ${RES}"
    echo " "

    exit -1
fi

set -e
FILE_PATH="./file.log"
REBUILD_FILE="./rebuildfile"

STR=$1
FINAL=${STR: -1}

if [ '/' == $FINAL ]; then
    echo ${STR%/*} > $FILE_PATH
else
    echo $STR > $FILE_PATH 
fi

INPUT_PATH=`cat $FILE_PATH`

if [ "all" == "$2" ]; then
    echo -e "${DYELL} in mode 2, build all ${RES}"
    #rm -rf !(create_csidx.sh)

    softfiles=`ls "$INPUT_PATH"`

    for sfile in ${softfiles}
    do
        echo "$INPUT_PATH/$sfile" > $FILE_PATH
        # 路径转义,为rebuild做准备
        CSCOPE_FILE=`sed "s#/#+#g" $FILE_PATH`

        find "$INPUT_PATH/$sfile" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > cscope/"$CSCOPE_FILE".files
        cscope -bkq -i cscope/"$CSCOPE_FILE".files -f cscope/"$CSCOPE_FILE".out
    done
elif [ "rebuild" == "$1" ]; then
    if [ x"" == x"$2" ]; then
        echo -e "${DYELL} in mode 3, rebuild all ${RES}"
        rebuildfiles=`ls cscope/*.files`
        for refiles in ${rebuildfiles}
        do
            echo $refiles > $REBUILD_FILE
            REBUILD_OUT=`sed "s#.files#.out#g" $REBUILD_FILE`
            TMP_PATH=`sed "s#.files##g" $REBUILD_FILE`
            echo $TMP_PATH > $REBUILD_FILE
            TMP_PATH=`sed "s#cscope/##g" $REBUILD_FILE`
            echo $TMP_PATH > $FILE_PATH
            REBUILD_PATH=`sed "s#+#/#g" $FILE_PATH`
            #echo $REBUILD_PATH
            rm $REBUILD_OUT
            find "$REBUILD_PATH" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > $refiles
            cscope -bkq -i $refiles -f $REBUILD_OUT
        done
        rm $REBUILD_FILE
    else
        echo -e "${DYELL} in mode 4, rebuild module ${RES}"
        REBUILD_MODULE=$2
        echo "rebuild module: $REBUILD_MODULE"
        rebuildfiles=`ls cscope/*.files`
        for refiles in ${rebuildfiles}
        do
            echo $refiles > $REBUILD_FILE
            REBUILD_OUT=`sed "s#.files#.out#g" $REBUILD_FILE`
            TMP_PATH=`sed "s#.files##g" $REBUILD_FILE`
            echo $TMP_PATH > $REBUILD_FILE
            TMP_PATH=`sed "s#cscope/##g" $REBUILD_FILE`
            echo $TMP_PATH > $FILE_PATH
            REBUILD_PATH=`sed "s#+#/#g" $FILE_PATH`
            echo $REBUILD_PATH
            #A=${REBUILD_PATH%/*}/
            B=${REBUILD_PATH##*/}
            #echo A:$A
            #echo B:$B

            shopt -s nocasematch
            case "$REBUILD_MODULE" in
                $B ) MATCHED=1;;
                *) MATCHED=0;;
            esac
            shopt -u nocasematch

            if [ x"1" == x"$MATCHED" ]; then
                echo -e "${DYEL}match, will rebuild ${RES}"
                rm $REBUILD_OUT
                find "$REBUILD_PATH" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > $refiles
                cscope -bkq -i $refiles -f $REBUILD_OUT
            else
                echo "not match"
            fi
            echo " "
            
        done

    fi
else
    echo -e "${DYELL} in mode 1, build single ${RES}"
    CSCOPE_FILE=`sed "s#/#+#g" $FILE_PATH`

    find "$INPUT_PATH" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > cscope/"$CSCOPE_FILE".files
    cscope -bkq -i cscope/"$CSCOPE_FILE".files -f cscope/"$CSCOPE_FILE".out
fi

rm $FILE_PATH
echo "`ls cscope/*.out`" >cscope/load_list.vim
rm cscope/load.vim
sed 's/^/cs add &/g' cscope/load_list.vim >>cscope/load.vim
rm cscope/load_list.vim

echo "done"
