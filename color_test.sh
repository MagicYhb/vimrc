#!/bin/bash
 
#> File Name:    color_test.sh
#> Author:       MagicYang
#> Mail:         476080754@qq.com
#> Created Time: 2021年09月13日 星期一 15时53分35秒
 

# For LS_COLORS, print type and description in the relevant color.

IFS=:
for ls_color in $LS_COLORS; do
    color="${ls_color#*=}"
    type="${ls_color%=*}"

    # Add descriptions for named types.
    case "$type" in
        bd) type+=" (block device)" ;;
        ca) type+=" (file with capability)" ;;
        cd) type+=" (character device)" ;;
        di) type+=" (directory)" ;;
    do) type+=" (door)" ;;
        ex) type+=" (executable file)" ;;
        fi) type+=" (regular file)" ;;
        ln) type+=" (symbolic link)" ;;
        mh) type+=" (multi-hardlink)" ;;
        mi) type+=" (missing file)" ;;
        no) type+=" (normal non-filename text)" ;;
        or) type+=" (orphan symlink)" ;;
        ow) type+=" (other-writable directory)" ;;
        pi) type+=" (named pipe, AKA FIFO)" ;;
        rs) type+=" (reset to no color)" ;;
        sg) type+=" (set-group-ID)" ;;
        so) type+=" (socket)" ;;
        st) type+=" (sticky directory)" ;;
        su) type+=" (set-user-ID)" ;;
        tw) type+=" (sticky and other-writable directory)" ;;
    esac
    
    # Separate each color with a newline.
    if [[ $color_prev ]] && [[ $color != $color_prev ]]; then
        echo
    fi
    
    printf "\e[%sm%s\e[m " "$color" "$type"

    # For next loop
    color_prev="$color"
done
    echo

# 字体颜色（30-37）
# ANSI码说明
# 30  黑色
# 31  红色
# 32  绿色
# 33  黄色
# 34  蓝色
# 35  紫色
# 36  天蓝色
# 37  白色
# 背景颜色（40-47）
# ANSI码说明
# 40  黑色
# 41  红色
# 42  绿色
# 43  黄色
# 44  蓝色
# 45  紫色
# 46  天蓝色
# 47  白色
# 字体属性
# ANSI码说明
# 0  常规文本
# 1  粗体文本（高亮度显示）
# 4  含下划线文本
# 5  闪烁文本
# 7  反色（补色文本）
# 8  消隐

BLK='\E[1;30m'
RED='\E[1;31m'
GRN='\E[1;32m'
YEL='\E[1;33m'
BLU='\E[1;34m'
MAG='\E[1;35m'
CYN='\E[1;36m'
WHI='\E[1;37m'
DRED='\E[0;31m'
DGRN='\E[0;32m'
DYEL='\E[0;33m'
DBLU='\E[0;34m'
DMAG='\E[0;35m'
DCYN='\E[0;36m'
DWHI='\E[0;37m'
RES='\E[0m'

DYELL='\E[43;30m'
DBLUL='\E[46;30m'

##    echo -e "\e[字背景颜色；文字颜色m字符串\e[0m"
##    echo -e  "\e[字背景颜色；文字颜色；文字闪动m字符串\e[0m"
## 字体背景颜色
## 40:黑   41:深红  42:绿 43:黄色  44:蓝色  45:紫色  46:深绿  47:白色
## 字体颜色
## 30:黑  31:红  32:绿  33:黄  34:蓝色  35:紫色  36:深绿  37:白色

echo -e " 01- ${BLK} BLK ${RES} "
echo -e " 02- ${RED} RED ${RES} "
echo -e " 03- ${GRN} GRN ${RES} "
echo -e " 04- ${YEL} YEL ${RES} "
echo -e " 05- ${BLU} BLU ${RES} "
echo -e " 06- ${MAG} MAG ${RES} "
echo -e " 07- ${CYN} CYN ${RES} "
echo -e " 08- ${WHI} WHI ${RES} "
echo -e " 09- ${DRED} DRED ${RES} "
echo -e " 10- ${DGRN} DGRN ${RES} "
echo -e " 11- ${DYEL} DYEL ${RES} "
echo -e " 12- ${DBLU} DBLU ${RES} "
echo -e " 13- ${DMAG} DMAG ${RES} "
echo -e " 14- ${DCYN} DCYN ${RES} "
echo -e " 15- ${DWHI} DWHI ${RES} "
echo -e " 16- ${DYELL} DYELL ${RES} "
echo -e " 16- ${DBLUL} DBLUL ${RES} "
