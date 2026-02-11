#!/bin/bash

#/**
#* @file    create_csidx.sh
#* @Synopsis 
#* @author  MagicYang
#* @version 3.1.1 
#* @date    2021-12-14
#*/

DYEL='\E[0;33m'
DYELL='\E[43;30m'
GRN='\E[1;32m'
SKY_BLUE='\E[1;36m'
RES='\E[0m'

## tmpfile
FILE_PATH="./file.log"
EXCLUDE_FILE="./excludefile"
REBUILD_FILE="./rebuildfile"
REMOVE_FILE="./removefile"
IGNORE_FILE=""

EX_FIND_FILE=" -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" "

help_func()
{
    echo -e "${DYELL}example:${RES}"
    echo " "

    echo -e "${DYEL}mode 1: 以目标目录为索引名，创建单个索引  ${RES}"
    echo -e "${GRN}    build module:${RES}    ${SKY_BLUE}./cscope/create_csidx.sh -b path ${RES}"
    echo " "

    echo -e "${DYEL}mode 2: 以目标目录为索引名，创建单个索引，忽略某些文件夹(与rb模式冲突，慎用，不打算修复)  ${RES}"
    echo -e "${GRN}    build module:${RES}    ${SKY_BLUE}./cscope/create_csidx.sh -b path -e module1 module2 module3 ... modulex ${RES}"
    echo " "

    echo -e "${DYEL}mode 3: 以目标目录下的文件夹为索引名，创建多个索引  ${RES}"
    echo -e "${GRN}    build all:${RES}       ${SKY_BLUE}./cscope/create_csidx.sh -b path all ${RES}"
    echo " "

    echo -e "${DYEL}mode 4: 以目标目录下(忽略指定文件夹)的文件夹为索引名，创建多个索引  ${RES}"
    echo -e "${GRN}    build all:${RES}       ${SKY_BLUE}./cscope/create_csidx.sh -b path all -e module1 module2 module3 ... modulex ${RES}"
    echo " "

    echo -e "${DYEL}mode 5: 更新cscope目录下全部索引  ${RES}"
    echo -e "${GRN}    rebuild all:${RES}     ${SKY_BLUE}./cscope/create_csidx.sh -rb ${RES}"
    echo " "

    echo -e "${DYEL}mode 6: 更新cscope目录下单个索引，索引名忽略大小写  ${RES}"
    echo -e "${GRN}    rebuild module:${RES}  ${SKY_BLUE}./cscope/create_csidx.sh -rb module ${RES}"
    echo " "

    echo -e "${DYEL}mode 7: 更新cscope目录下全部索引，忽略某些索引(索引名忽略大小写)  ${RES}"
    echo -e "${GRN}    rebuild module:${RES}  ${SKY_BLUE}./cscope/create_csidx.sh -rb -e module1 module2 module3 ... modulex ${RES}"
    echo " "

    echo -e "${DYEL}mode 8: 查看当前已建立的索引  ${RES}"
    echo -e "${GRN}    show index:${RES}      ${SKY_BLUE}./cscope/create_csidx.sh -ps ${RES}"
    echo " "

    echo -e "${DYEL}mode 9: 删除已建立的索引  ${RES}"
    echo -e "${GRN}    remove module:${RES}   ${SKY_BLUE}./cscope/create_csidx.sh -rm module1 module2 module3 ... modulex ${RES}"
    echo " "

    exit -1
}

remove_func()
{
    if [ -f $EXCLUDE_FILE ]; then
        rm $EXCLUDE_FILE
    fi

    if [ -f $FILE_PATH ]; then
        rm $FILE_PATH
    fi

    if [ -f $REBUILD_FILE ]; then
        rm $REBUILD_FILE
    fi

    if [ -f $REMOVE_FILE ]; then
        rm $REMOVE_FILE
    fi
}

if [ $# -lt 1 ]; then
    help_func
fi

set -e

remove_func
CS_MODE=$1

if [ x"$CS_MODE" == x"-b" ]; then
    STR=$2
    FINAL=${STR: -1}
    
    if [ x'/' == x$FINAL ]; then
        echo ${STR%/*} > $FILE_PATH
    else
        echo $STR > $FILE_PATH 
    fi
    INPUT_PATH=`cat $FILE_PATH`

    if [ x"$#" == x"2" ]; then
        echo -e "${DYELL}in mode 1: 以目标目录为索引名，创建单个索引 ${RES}"
        echo " "
        echo "build $STR"
        echo " "
        CSCOPE_FILE=`sed "s#/#+#g" $FILE_PATH`

        #find "$INPUT_PATH" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > cscope/"$CSCOPE_FILE".files
        find "$INPUT_PATH" -name "*.c"  -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md" > cscope/"$CSCOPE_FILE".files
        if [ ! -s cscope/"$CSCOPE_FILE".files ]; then
            rm cscope/"$CSCOPE_FILE".files
            echo cscope/"$CSCOPE_FILE".files is empty, will not build cscope.out
            echo " "
        else
            cscope -bkq -i cscope/"$CSCOPE_FILE".files -f cscope/"$CSCOPE_FILE".out
        fi
    elif [ x"$3" == x"-e" ]; then
        echo -e "${DYEL}mode 2: 以目标目录为索引名，创建单个索引，忽略某些文件夹  ${RES}"
        echo " "
        echo "build $STR"
        echo " "

        softfiles=`ls "$INPUT_PATH"`
        CSCOPE_FILE=`sed "s#/#+#g" $FILE_PATH`
        if [ -f cscope/"$CSCOPE_FILE".files ]; then
            rm cscope/"$CSCOPE_FILE".files
        fi

        for sfile in ${softfiles}
        do
            MATCHED=0
            count=1
            for i in $@
            do
                if [ "$count" -ge "4" ]; then
                    STR=$i
                    FINAL=${STR: -1}

                    if [ x'/' == x$FINAL ]; then
                        ignore_file=${STR%/*}
                    else
                        ignore_file=$STR
                    fi

                    E=${ignore_file##*/}
                    #echo "ignore_file:$E"

                    shopt -s nocasematch
                    case "$sfile" in
                        $E ) MATCHED=1;;
                        *) ;;
                    esac
                    shopt -u nocasematch
                fi
                let count=count+1
            done

            if [ x"1" == x"$MATCHED" ]; then
                echo -e "${DYELL}match, will exclude:$sfile ${RES}"
            else
                find "$INPUT_PATH/$sfile" -name "*.c"  -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md" >> cscope/"$CSCOPE_FILE".files
            fi
        done

        if [ ! -s cscope/"$CSCOPE_FILE".files ]; then
            echo -e "${DYEL}cscope/"$CSCOPE_FILE".files is empty, will not build cscope.out ${RES}"
            rm cscope/"$CSCOPE_FILE".files
            continue
        fi

        cscope -bkq -i cscope/"$CSCOPE_FILE".files -f cscope/"$CSCOPE_FILE".out

    elif [ x"$#" == x"3" ] && [ x"$3" == x"all" ]; then
        echo -e "${DYELL}in mode 3: 以目标目录下的文件夹为索引名，创建多个索引${RES}"
        echo " "
        softfiles=`ls "$INPUT_PATH"`

        for sfile in ${softfiles}
        do
            echo " "
            echo "build $INPUT_PATH/$sfile"
            echo "$INPUT_PATH/$sfile" > $FILE_PATH
            # 路径转义,为rebuild做准备
            CSCOPE_FILE=`sed "s#/#+#g" $FILE_PATH`

            #find "$INPUT_PATH/$sfile" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > cscope/"$CSCOPE_FILE".files
            find "$INPUT_PATH/$sfile" -name "*.c"  -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md" > cscope/"$CSCOPE_FILE".files
            if [ ! -s cscope/"$CSCOPE_FILE".files ]; then
                echo -e "${DYEL}cscope/"$CSCOPE_FILE".files is empty, will not build cscope.out ${RES}"
                rm cscope/"$CSCOPE_FILE".files
                continue
            fi
            cscope -bkq -i cscope/"$CSCOPE_FILE".files -f cscope/"$CSCOPE_FILE".out
        done

    elif [ x"$3" == x"all" ] && [ x"$4" == x"-e" ]; then
        echo -e "${DYELL}in mode 4: 以目标目录下(忽略指定文件夹)的文件夹为索引名，创建多个索引  ${RES}"
        echo "exclude module:"
        count=1
        for i in $@
        do
            if [ "$count" -ge "4" ]; then
                echo $i
            fi
            let count=count+1
        done
        echo " "

        softfiles=`ls "$INPUT_PATH"`
        for sfile in ${softfiles}
        do
            echo " "
            echo "build $INPUT_PATH/$sfile"
            echo "$INPUT_PATH/$sfile" > $FILE_PATH
            echo "$INPUT_PATH/$sfile" > $EXCLUDE_FILE
            # 路径转义,为rebuild做准备
            CSCOPE_FILE=`sed "s#/#+#g" $FILE_PATH`

            EXCLUDE_PATH=`cat $EXCLUDE_FILE`
            #echo $EXCLUDE_PATH
            #A=${EXCLUDE_PATH%/*}/
            E=${EXCLUDE_PATH##*/}
            #echo A:$A
            #echo E:$E

            MATCHED=0
            count=1
            for i in $@
            do
                if [ "$count" -ge "4" ]; then
                    shopt -s nocasematch
                    case "$i" in
                        $E ) MATCHED=1;;
                        *) ;;
                    esac
                    shopt -u nocasematch
                fi
                let count=count+1
            done

            if [ x"1" == x"$MATCHED" ]; then
                echo -e "${DYELL}match, will exclude ${RES}"
            else
                echo -e "${DYEL}will build  ${RES}"
                #find "$INPUT_PATH/$sfile" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > cscope/"$CSCOPE_FILE".files
                find "$INPUT_PATH/$sfile" -name "*.c"  -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md" > cscope/"$CSCOPE_FILE".files

                if [ ! -s cscope/"$CSCOPE_FILE".files ]; then
                    echo -e "${DYEL}cscope/"$CSCOPE_FILE".files is empty, will not build cscope.out ${RES}"
                    rm cscope/"$CSCOPE_FILE".files
                    continue
                fi

                cscope -bkq -i cscope/"$CSCOPE_FILE".files -f cscope/"$CSCOPE_FILE".out
            fi

        done
    else
        echo -e "${DYELL} unknown mode ... ${RES}"
        echo " "
        help_func
    fi
elif [ x"$CS_MODE" == x"-rb" ]; then
    if [ x"$#" == x"1" ]; then
        echo -e "${DYELL}in mode 5: 更新cscope目录下全部索引 ${RES}"
        echo " "

        FILE_COUNT=$(ls cscope/*.files 2> /dev/null | wc -l)
        if [ "$FILE_COUNT" == "0" ]; then
            echo "there is no *.files"
        else 
            rebuildfiles=`ls cscope/*.out`
            for refiles in ${rebuildfiles}
            do
                if [ ! -s $refiles ]; then
                    echo -e "${DYEL}$refiles is empty, will not build cscope.out ${RES}"
                    rm $refiles
                    continue
                fi
                echo $refiles > $REBUILD_FILE
                REBUILD_OUT=$refiles
                TMP_PATH=`sed "s#.out##g" $REBUILD_FILE`
                echo $TMP_PATH > $REBUILD_FILE
                TMP_PATH=`sed "s#cscope/##g" $REBUILD_FILE`
                echo $TMP_PATH > $FILE_PATH
                REBUILD_PATH=`sed "s#+#/#g" $FILE_PATH`
                echo "rebuild $REBUILD_PATH"
                echo " "
                if [ -f $REBUILD_OUT ]; then
                    rm $REBUILD_OUT
                fi
                #find "$REBUILD_PATH" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > $refiles
                find "$REBUILD_PATH" -name "*.c"  -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md" > $refiles
                cscope -bkq -i $refiles -f $REBUILD_OUT
            done
        fi

    elif [ x"$#" == x"2" ]; then
        echo -e "${DYELL}in mode 6: 更新cscope目录下单个索引，索引名忽略大小写 ${RES}"
        echo " "

        REBUILD_MODULE=$2
        echo "rebuild module: $REBUILD_MODULE"
        echo " "

        FILE_COUNT=$(ls cscope/*.files 2> /dev/null | wc -l)
        if [ "$FILE_COUNT" == "0" ]; then
            echo "there is no *.files"
        else
            rebuildfiles=`ls cscope/*.out`
            for refiles in ${rebuildfiles}
            do
                if [ ! -s $refiles ]; then
                    echo -e "${DYEL}$refiles is empty, will not build cscope.out ${RES}"
                    rm $refiles
                    continue
                fi
                echo $refiles > $REBUILD_FILE
                REBUILD_OUT=$refiles
                TMP_PATH=`sed "s#.out##g" $REBUILD_FILE`
                echo $TMP_PATH > $REBUILD_FILE
                TMP_PATH=`sed "s#cscope/##g" $REBUILD_FILE`
                echo $TMP_PATH > $FILE_PATH
                REBUILD_PATH=`sed "s#+#/#g" $FILE_PATH`
                echo $REBUILD_PATH
                #A=${REBUILD_PATH%/*}/
                R=${REBUILD_PATH##*/}
                #echo A:$A
                #echo R:$R

                shopt -s nocasematch
                case "$REBUILD_MODULE" in
                    $R ) MATCHED=1;;
                    *) MATCHED=0;;
                esac
                shopt -u nocasematch

                if [ x"1" == x"$MATCHED" ]; then
                    echo -e "${DYEL}match, will rebuild ${RES}"
                    if [ -f $REBUILD_OUT ]; then
                        rm $REBUILD_OUT
                    fi
                    #find "$REBUILD_PATH" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > $refiles
                    find "$REBUILD_PATH" -name "*.c"  -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md" > $refiles
                    cscope -bkq -i $refiles -f $REBUILD_OUT
                else
                    echo "not match"
                fi
                echo " "

            done
        fi

    elif [ x"$2" == x"-e" ]; then
        echo -e "${DYELL}in mode 7: 更新cscope目录下全部索引，忽略某些索引(索引名忽略大小写)  ${RES}"
        echo "exclude module:"

        count=1
        for i in $@
        do
            if [ "$count" -ge "3" ]; then
                echo $i
            fi
            let count=count+1
        done
        echo " "

        FILE_COUNT=$(ls cscope/*.files 2> /dev/null | wc -l)
        if [ "$FILE_COUNT" == "0" ]; then
            echo "there is no *.files"
        else
            rebuildfiles=`ls cscope/*.out`
            for refiles in ${rebuildfiles}
            do
                if [ ! -s $refiles ]; then
                    echo -e "${DYEL}$refiles is empty, will not build cscope.out ${RES}"
                    rm $refiles
                    continue
                fi
                echo $refiles > $REBUILD_FILE
                REBUILD_OUT=$refiles
                TMP_PATH=`sed "s#.out##g" $REBUILD_FILE`
                echo $TMP_PATH > $REBUILD_FILE
                TMP_PATH=`sed "s#cscope/##g" $REBUILD_FILE`
                echo $TMP_PATH > $FILE_PATH
                REBUILD_PATH=`sed "s#+#/#g" $FILE_PATH`
                echo $REBUILD_PATH
                #A=${REBUILD_PATH%/*}/
                E=${REBUILD_PATH##*/}
                #echo A:$A
                #echo E:$E

                MATCHED=0
                count=1
                for i in $@
                do
                    if [ "$count" -ge "3" ]; then
                        shopt -s nocasematch
                        case "$i" in
                            $E ) MATCHED=1;;
                            *) ;;
                        esac
                        shopt -u nocasematch
                    fi
                    let count=count+1
                done

                if [ x"1" == x"$MATCHED" ]; then
                    echo -e "${DYELL}match, will exclude ${RES}"
                else
                    echo -e "${DYEL}will rebuild  ${RES}"
                    if [ -f $REBUILD_OUT ]; then
                        rm $REBUILD_OUT
                    fi
                    #find "$REBUILD_PATH" -name "*.c" -o -name  "*.cpp" -o -name ".cc" -o -name "*.h" -o -name "*.java" > $refiles
                    find "$REBUILD_PATH" -name "*.c"  -o -name "*.h" -o -name "*.cpp" -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile" -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md" > $refiles
                    cscope -bkq -i $refiles -f $REBUILD_OUT
                fi
                echo " "
            done
        fi
    else
        echo -e "${DYELL} unknown mode ... ${RES}"
        echo " "
        help_func
    fi
elif [ x"$CS_MODE" == x"-ps" ]; then
    echo -e "${DYELL}in mode 8: 查看当前已建立的索引 ${RES}"
    echo " "
    if [ -f cscope/load.vim ]; then
        if [ -f cscope/index.file ]; then
            rm cscope/index.file
        fi
        if [ -f cscope/index_out.file ]; then
            rm cscope/index_out.file
        fi
        cd cscope
        indexfiles=`ls *.out`
        for outfiles in $indexfiles
        do
            outfiles_name=`echo ${outfiles##*+}`
            echo ${outfiles_name%.*} >> ./index.file
            echo ${outfiles} >> ./index.file
        done

        awk '{if (NR%2==0){print $0} else {printf"%s ",$0}}' ./index.file >> ./index_out.file
        echo "" >> ./index_out.file
        
        total=`awk '{print NR}' ./index.file | tail -n1`
        total=$(expr $total / 2)
        echo "total:$total"
        echo " "

        cat ./index_out.file | column -t

        rm ./index.file
        rm ./index_out.file
        cd ..
    else
        echo "there is no index file"
    fi

elif [ x"$CS_MODE" == x"-rm" ]; then
    echo -e "${DYELL}in mode 9: 删除已建立的索引 ${RES}"
    echo " "

    count=1
    echo "will remove module:"
    for i in $@
    do
        if [ "$count" -ge "2" ]; then
            echo $i
        fi
        let count=count+1
    done
    echo " "

    FILE_COUNT=$(ls cscope/*.files 2> /dev/null | wc -l)
    echo "file count:${FILE_COUNT}"

    if [ "$FILE_COUNT" == "0" ]; then
        echo "there is no *.files"
    else
        allfiles=`ls cscope/*.files`
        for rmfiles in ${allfiles}
        do
            if [ ! -s $rmfiles ]; then
                echo -e "${DYEL}$rmfiles is empty, will not remove cscope.out ${RES}"
                rm $rmfiles
                continue
            fi
            echo $rmfiles > $REMOVE_FILE

            REMOVE_OUT=`sed "s#.files#.out#g" $REMOVE_FILE`
            TMP_PATH=`sed "s#.files##g" $REMOVE_FILE`
            echo $TMP_PATH > $REMOVE_FILE
            TMP_PATH=`sed "s#cscope/##g" $REMOVE_FILE`
            echo $TMP_PATH > $FILE_PATH
            REMOVE_PATH=`sed "s#+#/#g" $FILE_PATH`
            echo $REMOVE_PATH

            #A=${REMOVE_PATH%/*}/
            E=${REMOVE_PATH##*/}
            #echo A:$A
            #echo E:$E

            MATCHED=0
            count=1
            for i in $@
            do
                if [ "$count" -ge "2" ]; then
                    shopt -s nocasematch
                    case "$i" in
                        $E ) MATCHED=1;;
                        *) ;;
                    esac
                    shopt -u nocasematch
                fi
                let count=count+1
            done

            if [ x"1" == x"$MATCHED" ]; then
                echo -e "${DYELL}match, will remove the cscope.out ${RES}"
                rm ./cscope/*${E}.*
            else
                echo -e "${DYEL}will ignore  ${RES}"
            fi
            echo " "
        done
    fi

else
    echo -e "${DYELL} unknown mode ... ${RES}"
    echo " "
    help_func
fi

## remove tmpfile
remove_func

if [ x"$1" != x"-ps" ]; then

    FILE_COUNT=$(ls cscope/*.files 2> /dev/null | wc -l)
    echo "file count:${FILE_COUNT}"

    ## check *.out
    echo -e "${DYEL}check *.out${RES}"

    OUT_COUNT=$(ls cscope/*.out 2> /dev/null | wc -l)

    if [ "$OUT_COUNT" != "0" ]; then
        ls cscope/*.out
        echo "`ls cscope/*.out`" >cscope/load_list.vim
    else
        echo "there is no *.out"
    fi

    #if [ -f cscope/*.out ]; then
    #    ls cscope/*.out
    #    echo "`ls cscope/*.out`" >cscope/load_list.vim
    #else
    #    echo "there is no *.out"
    #fi

    if [ -f cscope/load.vim ]; then
        rm cscope/load.vim
    fi

    if [ -f cscope/load_list.vim ]; then
        sed 's/^/cs add &/g' cscope/load_list.vim >>cscope/load.vim
    fi

    if [ -f cscope/load_list.vim ]; then
        rm cscope/load_list.vim
    fi
fi

## end
echo " "
echo "done"
