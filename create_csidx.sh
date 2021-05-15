#!/bin/bash


DYEL='\E[0;33m'
DYELL='\E[43;30m'
DRED='\E[41;30m'
RES='\E[0m'

echo " "

if [ $# -lt 1 ]; then
    echo "example:"
    echo " "
    echo -e "${DYEL}mode 1 single:    ./create_csidx.sh path${RES}"
    echo " "
    echo -e "${DYEL}mode 2 rebuild:   ./create_csidx.sh rebuild${RES}"
    echo " "
    echo -e "${DYEL}mode 3 all:       ./create_csidx.sh path all${RES}"
    echo " "
    exit -1
fi

set -x
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
    echo "mode is all"
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
    echo "mode is rebuild"
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
    echo "mode is once"
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
