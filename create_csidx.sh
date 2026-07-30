#!/bin/bash

#/**
#* @file    create_csidx.sh
#* @Synopsis cscope/tags 索引生成工具
#* @author  MagicYang
#* @version 4.0.0
#* @date    2026-07-30
#*
#* @changelog
#*   4.0.0 重构脚本
#*/

DYEL='\E[0;33m'
DYELL='\E[43;30m'
GRN='\E[1;32m'
SKY_BLUE='\E[1;36m'
RES='\E[0m'

## 索引的源文件类型 (find 谓词, 数组形式避免引号问题)
SRC_FILE_PATTERNS=(
    -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp"
    -o -name "*.cc" -o -name "*.java" -o -name "*.mk" -o -name "Makefile"
    -o -name "*.config" -o -name "*.txt" -o -name "*.sh" -o -name "*.md"
)

#########################################################################
# 基础工具函数
#########################################################################

# 生成源文件列表
# 用法: find_source_files <搜索路径> <输出文件> [append]
find_source_files()
{
    if [ x"$3" == x"append" ]; then
        find "$1" "${SRC_FILE_PATTERNS[@]}" >> "$2"
    else
        find "$1" "${SRC_FILE_PATTERNS[@]}" > "$2"
    fi
}

# 路径转索引名: imi_app/miio_source/imi_mike -> imi_app+miio_source+imi_mike
path_to_index_name()
{
    echo "$1" | sed "s#/#+#g"
}

# 由索引文件名推导源码路径: cscope/a+b+c.out -> a/b/c
resolve_rebuild_path()
{
    local tmp=${1%.out}
    tmp=${tmp#cscope/}
    echo "$tmp" | sed "s#+#/#g"
}

# 去掉尾部斜杠后取 basename: path/to/mod/ -> mod
basename_clean()
{
    local s=${1%/}
    echo "${s##*/}"
}

# 判断 target 是否匹配任一 pattern (忽略大小写), 匹配返回 0
# 用法: match_any <target> <pattern...>
match_any()
{
    local target=$1
    shift
    local p ret=1
    shopt -s nocasematch
    for p in "$@"
    do
        case "$target" in
            $p ) ret=0;;
            *) ;;
        esac
    done
    shopt -u nocasematch
    return $ret
}

# 排除判断 (mode 2 风格): 对候选参数取 basename 后与 name 比较
# 用法: is_excluded_basename <name> <候选参数...>
is_excluded_basename()
{
    local name=$1
    shift
    local a
    for a in "$@"
    do
        if match_any "$name" "$(basename_clean "$a")"; then
            return 0
        fi
    done
    return 1
}

# 排除判断 (mode 4/7/9 风格): 候选参数直接与模块名比较
# 用法: is_excluded_direct <模块名> <候选参数...>
is_excluded_direct()
{
    local module=$1
    shift
    local a
    for a in "$@"
    do
        if match_any "$a" "$module"; then
            return 0
        fi
    done
    return 1
}

# 为指定源码目录创建索引 (.files + .out)
# 用法: build_index <源码路径> <索引名(不带后缀)>
# 返回: 0 成功, 1 文件列表为空
build_index()
{
    local src_path=$1
    local index_name=$2
    local files=cscope/"${index_name}".files

    find_source_files "$src_path" "$files"
    if [ ! -s "$files" ]; then
        echo -e "${DYEL}$files is empty, will not build cscope.out ${RES}"
        rm -f "$files"
        return 1
    fi
    cscope -bkq -i "$files" -f cscope/"${index_name}".out
}

# 重建单个索引: 刷新 .files 并重新生成 .out (调用前需保证 .out 非空)
# 用法: rebuild_one <cscope/xxx.out> <源码路径>
rebuild_one()
{
    local rebuild_out=$1
    local rebuild_path=$2
    local rebuild_files=${rebuild_out%.out}.files

    # 文件列表写回 .files (而非 .out), 保证新增源文件能进入 tags/cscope 索引
    rm -f "$rebuild_out"
    find_source_files "$rebuild_path" "$rebuild_files"
    cscope -bkq -i "$rebuild_files" -f "$rebuild_out"
}

# 检查索引 .out 是否为空, 为空则删除并提示
# 用法: check_out_valid <cscope/xxx.out>, 无效返回 1
check_out_valid()
{
    if [ ! -s "$1" ]; then
        echo -e "${DYEL}$1 is empty, will not build cscope.out ${RES}"
        rm -f "$1"
        return 1
    fi
    return 0
}

# 检查是否存在已建立的索引 (.files), 不存在打印提示并返回 1
has_index_files()
{
    local file_count
    file_count=$(ls cscope/*.files 2> /dev/null | wc -l)
    if [ "$file_count" == "0" ]; then
        echo "there is no *.files"
        return 1
    fi
    return 0
}

# 逐行打印列表项
# 用法: print_list <item...>
print_list()
{
    local i
    for i in "$@"
    do
        echo "$i"
    done
    echo " "
}

#########################################################################
# help / 清理
#########################################################################

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

    echo -e "${DYEL}注意: 每次 build/rebuild 索引后, 会自动在项目根目录生成 tags 文件${RES}"
    echo -e "${DYEL}      (供 coc-tag 扩展做全项目函数名模糊补全, 含 --c-kinds=+p 头文件原型声明)${RES}"
    echo " "

    exit -1
}

#########################################################################
# 各模式实现
#########################################################################

# mode 1: 以目标目录为索引名，创建单个索引
mode_build_single()
{
    echo -e "${DYELL}in mode 1: 以目标目录为索引名，创建单个索引 ${RES}"
    echo " "
    echo "build $1"
    echo " "

    build_index "$1" "$(path_to_index_name "$1")" || echo " "
}

# mode 2: 以目标目录为索引名，创建单个索引，忽略某些文件夹
mode_build_single_exclude()
{
    echo -e "${DYEL}mode 2: 以目标目录为索引名，创建单个索引，忽略某些文件夹  ${RES}"
    echo " "
    echo "build $1"
    echo " "

    local input_path=$1
    local index_name
    index_name=$(path_to_index_name "$input_path")
    local files=cscope/"${index_name}".files
    rm -f "$files"

    local sfile
    for sfile in $(ls "$input_path")
    do
        if is_excluded_basename "$sfile" "${@:2}"; then
            echo -e "${DYELL}match, will exclude:$sfile ${RES}"
        else
            find_source_files "$input_path/$sfile" "$files" append
        fi
    done

    if [ ! -s "$files" ]; then
        echo -e "${DYEL}$files is empty, will not build cscope.out ${RES}"
        rm -f "$files"
        return 1
    fi
    cscope -bkq -i "$files" -f cscope/"${index_name}".out
}

# mode 3: 以目标目录下的文件夹为索引名，创建多个索引
mode_build_all()
{
    echo -e "${DYELL}in mode 3: 以目标目录下的文件夹为索引名，创建多个索引${RES}"
    echo " "

    local sfile subdir
    for sfile in $(ls "$1")
    do
        subdir="$1/$sfile"
        echo " "
        echo "build $subdir"
        build_index "$subdir" "$(path_to_index_name "$subdir")" || true
    done
}

# mode 4: 以目标目录下(忽略指定文件夹)的文件夹为索引名，创建多个索引
mode_build_all_exclude()
{
    echo -e "${DYELL}in mode 4: 以目标目录下(忽略指定文件夹)的文件夹为索引名，创建多个索引  ${RES}"
    echo "exclude module:"
    print_list "${@:2}"

    local sfile subdir
    for sfile in $(ls "$1")
    do
        subdir="$1/$sfile"
        echo " "
        echo "build $subdir"

        if is_excluded_direct "$(basename_clean "$subdir")" "${@:2}"; then
            echo -e "${DYELL}match, will exclude ${RES}"
        else
            echo -e "${DYEL}will build  ${RES}"
            build_index "$subdir" "$(path_to_index_name "$subdir")" || true
        fi
    done
}

# mode 5: 更新cscope目录下全部索引
mode_rebuild_all()
{
    echo -e "${DYELL}in mode 5: 更新cscope目录下全部索引 ${RES}"
    echo " "

    has_index_files || return 0

    local refiles rebuild_path
    for refiles in $(ls cscope/*.out)
    do
        check_out_valid "$refiles" || continue
        rebuild_path=$(resolve_rebuild_path "$refiles")
        echo "rebuild $rebuild_path"
        echo " "
        rebuild_one "$refiles" "$rebuild_path"
    done
}

# mode 6: 更新cscope目录下单个索引，索引名忽略大小写
mode_rebuild_one()
{
    echo -e "${DYELL}in mode 6: 更新cscope目录下单个索引，索引名忽略大小写 ${RES}"
    echo " "

    local rebuild_module=$1
    echo "rebuild module: $rebuild_module"
    echo " "

    has_index_files || return 0

    local refiles rebuild_path
    for refiles in $(ls cscope/*.out)
    do
        check_out_valid "$refiles" || continue
        rebuild_path=$(resolve_rebuild_path "$refiles")
        echo "$rebuild_path"

        if match_any "$rebuild_module" "$(basename_clean "$rebuild_path")"; then
            echo -e "${DYEL}match, will rebuild ${RES}"
            rebuild_one "$refiles" "$rebuild_path"
        else
            echo "not match"
        fi
        echo " "
    done
}

# mode 7: 更新cscope目录下全部索引，忽略某些索引(索引名忽略大小写)
mode_rebuild_exclude()
{
    echo -e "${DYELL}in mode 7: 更新cscope目录下全部索引，忽略某些索引(索引名忽略大小写)  ${RES}"
    echo "exclude module:"
    print_list "$@"

    has_index_files || return 0

    local refiles rebuild_path
    for refiles in $(ls cscope/*.out)
    do
        check_out_valid "$refiles" || continue
        rebuild_path=$(resolve_rebuild_path "$refiles")
        echo "$rebuild_path"

        if is_excluded_direct "$(basename_clean "$rebuild_path")" "$@"; then
            echo -e "${DYELL}match, will exclude ${RES}"
        else
            echo -e "${DYEL}will rebuild  ${RES}"
            rebuild_one "$refiles" "$rebuild_path"
        fi
        echo " "
    done
}

# mode 8: 查看当前已建立的索引
mode_show_index()
{
    echo -e "${DYELL}in mode 8: 查看当前已建立的索引 ${RES}"
    echo " "

    if [ -f cscope/load.vim ]; then
        (
            cd cscope || exit 1
            rm -f ./index.file ./index_out.file

            local outfiles outfiles_name
            for outfiles in $(ls *.out)
            do
                outfiles_name=$(echo ${outfiles##*+})
                echo ${outfiles_name%.*} >> ./index.file
                echo ${outfiles} >> ./index.file
            done

            awk '{if (NR%2==0){print $0} else {printf"%s ",$0}}' ./index.file >> ./index_out.file
            echo "" >> ./index_out.file

            local total
            total=$(awk '{print NR}' ./index.file | tail -n1)
            total=$(expr $total / 2)
            echo "total:$total"
            echo " "

            cat ./index_out.file | column -t

            rm ./index.file
            rm ./index_out.file
        )
    else
        echo "there is no index file"
    fi
}

# mode 9: 删除已建立的索引
mode_remove_index()
{
    echo -e "${DYELL}in mode 9: 删除已建立的索引 ${RES}"
    echo " "

    echo "will remove module:"
    print_list "${@:2}"

    local file_count
    file_count=$(ls cscope/*.files 2> /dev/null | wc -l)
    echo "file count:${file_count}"

    has_index_files || return 0

    local rmfiles index_name remove_path
    for rmfiles in $(ls cscope/*.files)
    do
        if [ ! -s "$rmfiles" ]; then
            echo -e "${DYEL}$rmfiles is empty, will not remove cscope.out ${RES}"
            rm -f "$rmfiles"
            continue
        fi

        index_name=${rmfiles#cscope/}
        index_name=${index_name%.files}
        remove_path=$(echo "$index_name" | sed "s#+#/#g")
        echo "$remove_path"

        if is_excluded_direct "${index_name##*+}" "${@:2}"; then
            echo -e "${DYELL}match, will remove the cscope.out ${RES}"
            rm ./cscope/*${index_name##*+}.*
        else
            echo -e "${DYEL}will ignore  ${RES}"
        fi
        echo " "
    done
}

#########################################################################
# 收尾: 生成 load.vim 和 tags
#########################################################################

# 根据现有 .out 生成 vim 加载脚本
gen_load_vim()
{
    local file_count
    file_count=$(ls cscope/*.files 2> /dev/null | wc -l)
    echo "file count:${file_count}"

    ## check *.out
    echo -e "${DYEL}check *.out${RES}"

    local out_count
    out_count=$(ls cscope/*.out 2> /dev/null | wc -l)

    if [ "$out_count" != "0" ]; then
        ls cscope/*.out
        echo "$(ls cscope/*.out)" >cscope/load_list.vim
    else
        echo "there is no *.out"
    fi

    rm -f cscope/load.vim

    if [ -f cscope/load_list.vim ]; then
        sed 's/^/cs add &/g' cscope/load_list.vim >>cscope/load.vim
        rm cscope/load_list.vim
    fi
}

# 生成 tags 文件 (供 coc-tag 扩展模糊补全, --c-kinds=+p 包含头文件中的函数原型声明)
gen_tags()
{
    echo -e "${DYEL}generate tags for coc-tag completion${RES}"
    cat cscope/*.files 2> /dev/null | sort -u > cscope/all.files
    if [ -s cscope/all.files ]; then
        ctags --c-kinds=+p --fields=+iaS --extra=+q -L cscope/all.files -f tags
        echo "tags generated: $(wc -l < tags) lines"
    else
        echo "there is no *.files, skip tags"
    fi
    rm -f cscope/all.files
}

#########################################################################
# 主流程
#########################################################################

if [ $# -lt 1 ]; then
    help_func
fi

set -e

CS_MODE=$1

if [ x"$CS_MODE" == x"-b" ]; then
    INPUT_PATH=${2%/}

    if [ x"$#" == x"2" ]; then
        mode_build_single "$INPUT_PATH"
    elif [ x"$3" == x"-e" ]; then
        mode_build_single_exclude "$INPUT_PATH" "${@:4}"
    elif [ x"$#" == x"3" ] && [ x"$3" == x"all" ]; then
        mode_build_all "$INPUT_PATH"
    elif [ x"$3" == x"all" ] && [ x"$4" == x"-e" ]; then
        mode_build_all_exclude "$INPUT_PATH" "${@:5}"
    else
        echo -e "${DYELL} unknown mode ... ${RES}"
        echo " "
        help_func
    fi
elif [ x"$CS_MODE" == x"-rb" ]; then
    if [ x"$#" == x"1" ]; then
        mode_rebuild_all
    elif [ x"$#" == x"2" ]; then
        mode_rebuild_one "$2"
    elif [ x"$2" == x"-e" ]; then
        mode_rebuild_exclude "${@:3}"
    else
        echo -e "${DYELL} unknown mode ... ${RES}"
        echo " "
        help_func
    fi
elif [ x"$CS_MODE" == x"-ps" ]; then
    mode_show_index
elif [ x"$CS_MODE" == x"-rm" ]; then
    mode_remove_index "$@"
else
    echo -e "${DYELL} unknown mode ... ${RES}"
    echo " "
    help_func
fi

if [ x"$1" != x"-ps" ]; then
    gen_load_vim
    gen_tags
fi

## end
echo " "
echo "done"
