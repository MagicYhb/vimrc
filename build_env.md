1.1 dash改bash
sudo dpkg-reconfigure dash   弹框后选择[NO]

1.2 flex
sudo apt-get install flex

1.3 bison
sudo apt-get install bison

1.4 cmake 
sudo apt-get install cmake

1.5 mtd-utils
sudo apt-get install mtd-utils


vim
2.1 python
sudo apt-get install python2.7-dev
sudo apt-get install python3 python3-dev

2.2 vim build
sudo apt-get install libncurses-dev

2.3 fzf 0.55
git clone git@github.com:junegunn/fzf.git
cd fzf 
./install





./configure --with-features=huge \
--enable-multibyte \
--enable-rubyinterp=yes \
--enable-pythoninterp=yes \
--enable-python3interp=yes \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
--enable-perlinterp=yes \
--enable-luainterp=yes \
--enable-gui=gtk2 --enable-cscope --prefix=/usr
