#!/bin/bash

set -x


echo "path:$1"

FILE_PATH="./file.log"

echo "$1" > $FILE_PATH
CSCOPE_FILE=`sed "s#/#_#g" $FILE_PATH`
rm $FILE_PATH

find "$1" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" > cscope/"$CSCOPE_FILE".files

cscope -bkq -i cscope/"$CSCOPE_FILE".files -f cscope/"$CSCOPE_FILE".out

echo "`ls cscope/*.out`" >cscope/load_list.vim
rm cscope/load.vim
sed 's/^/cs add &/g' cscope/load_list.vim >>cscope/load.vim
rm cscope/load_list.vim

echo "done"
