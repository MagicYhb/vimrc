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


## 四、vim compelete
### apt install
sudo apt-get install npm silversearcher-ag fzf cscope clangd ccls

### npm
npm i -g bash-language-server

### before make nodejs
sudo apt-get install python3-distutils

### make nodejs
nodejs(version >= 12.12)

### [coc.nvim] Server languageserver.coc-clangd failed to start: Launching server "languageserver.coc-clangd" using command clangd failed.
sudo apt-get install clangd
