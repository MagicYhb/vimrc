#!/bin/bash
 
#> File Name:        build.sh
#> Author:           MagicYang
#> Version:          1.0.1
#> Mail:             476080754@qq.com
#> Created Time:     2022-12-01 17:11:54
 
./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.8/config-3.8-x86_64-linux-gnu \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-gui=gtk2 \
    --enable-cscope \
    --prefix=/usr/local/vim9
