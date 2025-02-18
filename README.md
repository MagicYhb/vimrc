My personal vim configuration.

## 一、Install:
branch: main

git clone https://github.com/MagicYhb/vimrc.git
cd vimrc
./install

## 二、VimAwesome
https://vimawesome.com/


## 三、vim-interestingwords
let s:interestingWordsTermColors = ['006', '005', '003', '002', '154', '121', '131', '111', '137', '214', '222', '001', '090', '255', '100']

## 四 xhell5 ubuntu20
/etc/ssh/sshd_config

KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group14-sha1

HostKeyAlgorithms +ssh-rsa

PubkeyAcceptedAlgorithms +ssh-rsa

systemctl restart sshd

## 五、vim compelete
### apt install
sudo apt-get install npm silversearcher-ag fzf cscope clangd ccls
sudo apt install exuberant-ctags

sudo apt install python3-pip

### npm
npm i -g bash-language-server

npm install jedi

### before make nodejs
sudo apt-get install python3-distutils

### make nodejs
nodejs(version >= 12.12)

### [coc.nvim] Server languageserver.coc-clangd failed to start: Launching server "languageserver.coc-clangd" using command clangd failed.
sudo apt-get install clangd

## 六、man
###1. sudo apt-get install manpages-posix manpages-posix-dev
###2. sudo apt-get install manpages-zh
###3. 配置中文：sudo gedit /etc/manpath.config& 把其中的/usr/share/man全部修改成/usr/share/man/zh_CN
###4. 测试：man ls显示中文

## 七、vim_tools
git@github.com:MagicYhb/vim_tools.git

## 八、fzf preview
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -999'"

## 九、
export TERM=xterm-256color

## 十、node.js
https://nodejs.cn/download/
https://nodejs.org/dist/

## 十一、 ImportError: No module named Crypto.Cipher
拷贝 ./local/lib/python2.7

## 十二、
安装libiconv的参考网址:
https://www.cnblogs.com/kay2018/p/9936008.html
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
./configure -prefix=/usr/local
make
sudo make install

## 十三、vim plug dir
git@github.com:MagicYhb/vim_plug.git
