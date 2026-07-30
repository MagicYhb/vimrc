# Vim 补全方案 (coc.nvim + coc-tag) 完整文档

> 目标：**模糊匹配 + 函数原型(参数)补全**，不依赖 clangd 语义补全。
> 本文档记录了完整调试历程与最终方案，在新电脑上按"复刻步骤"一章操作即可还原。

---

## 一、最终效果

在任意已索引的 C 文件中输入函数名片段（支持模糊匹配）：

```
输入:  mi_local_storage_cr
弹窗:  mi_local_storage_create      [T]  mi_local_storage_create(media_channel_e v_chn, media_channel_e a_chn)
       mi_local_storage_check_free  [T]  ...
```

- `Tab` / `<C-n>` 向下选择，`Shift+Tab` / `<C-p>` 向上选择
- **Enter 确认后直接插入完整原型**：

```c
mi_local_storage_create(media_channel_e v_chn, media_channel_e a_chn)
```

- 补全界面关闭，无占位符跳转模式，光标在 `)` 后，直接继续编辑

---

## 二、环境组件清单

| 组件 | 版本/来源 | 说明 |
|---|---|---|
| vim | 9.2 自编译 (`~/source_code/github/vim`) | 需 `+popupwin +textprop +python3/dyn` |
| node.js | v22.x (`/usr/local/bin/node`) | coc.nvim 运行时依赖 |
| vim-plug | `~/.vim/autoload/plug.vim` | 插件管理器 |
| coc.nvim | release 分支 (`~/.vim/plugged/coc.nvim`) | 补全框架 |
| coc-tag | 1.2.5 + **本地补丁** | 本文档核心，从 tags 文件补全 |
| ctags | Exuberant Ctags 5.9+ | 生成 tags（含 signature 字段） |
| create_csidx.sh | 项目 `cscope/` 目录 | 索引生成脚本（已改造，同时生成 tags） |

---

## 三、整体架构

```
输入字符
   │
   ▼
coc.nvim 补全框架 (浮动补全窗口)
   ├── [LS] clangd 源 (可选, 需 compile_commands.json)
   ├── [T]  tag 源 (coc-tag + 本地补丁)  ← 本方案核心
   │         └─ 读取项目根目录 tags 文件 (含 signature 字段)
   │         └─ doComplete:    返回 函数名 + insertText(完整原型)
   │         └─ onCompleteDone: 确认后把已插入的函数名替换为完整原型
   ├── [B]  buffer 源 (其他已打开 buffer 的词, 需 set hidden)
   ├── [A]  around 源 (当前 buffer 的词)
   └── [F]  file 源 (文件路径)

tags 文件由 cscope/create_csidx.sh 生成:
   ctags --c-kinds=+p --fields=+iaS --extra=+q
   (--c-kinds=+p 让头文件中的函数原型声明也成为标签, 是参数补全的关键)
```

---

## 四、新电脑复刻步骤

### 1. 基础环境

```bash
# node.js (coc 必需, v18+)
# 官网或 nvm 安装, 验证:
node --version

# ctags
sudo apt install exuberant-ctags    # 或 universal-ctags (更好)

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

vim 建议自编译 9.x（参考 `~/source_code/github/vim/build.sh`），关键是带 `+popupwin +textprop`，这是 coc 浮动补全窗口的前提。编译后记得 `cd src && sudo make installruntime` 安装运行时文件，否则报 `E484: Can't open file .../syntax.vim`。

### 2. vimrc 关键配置

```vim
" ---- 插件声明 ----
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" ---- coc 全局扩展 (首次启动自动安装) ----
let g:coc_global_extensions = [
    \ 'coc-tag',
    \ 'coc-json',
    \ 'coc-sh',
    \ 'coc-vimlsp']

" ---- 关键选项 ----
set hidden
" 切换 buffer 时不卸载旧 buffer。不设此项时 :e 切换文件会卸载旧 buffer,
" coc 将其 document detach, buffer 补全源就找不到其他文件的词了

set tags=./tags;,tags
" tags 文件向上搜索: 在任意子目录打开文件也能找到项目根目录的 tags

" ---- 补全键位映射 ----
" 注意: coc 的补全菜单有两种形态 —— coc 浮动窗口 (coc#pum#visible) 和
" vim 原生菜单 (pumvisible), 两套判断必须都写, 否则一边失效
inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"

" 确认补全: 必须走 coc 的确认通道 (coc#pum#confirm / coc#_select_confirm),
" 原生 C-y 只会插入 word, 不会应用补全项的 insertText (函数参数会丢失)
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
```

### 3. coc-settings.json

文件位置 `~/.vim/coc-settings.json`：

```json
{
  "suggest.filterGraceful": true
}
```

- `suggest.filterGraceful`: 模糊过滤容忍小的拼写偏差（如 `miwcs` 匹配 `mi_ipc_wifi_connect_start`）
- coc 的过滤本身支持子序列模糊匹配，无需额外配置

### 4. 生成 tags 文件

在项目根目录执行（create_csidx.sh 已内置此逻辑，见第 6 节）：

```bash
cd /path/to/project
# 方式一: 直接用现有 cscope 文件列表 (推荐, 与 cscope 索引范围一致)
cat cscope/*.files | sort -u > cscope/all.files
ctags --c-kinds=+p --fields=+iaS --extra=+q -L cscope/all.files -f tags
rm -f cscope/all.files

# 方式二: 全目录递归
ctags -R --c-kinds=+p --fields=+iaS --extra=+q .
```

参数说明：

| 参数 | 作用 |
|---|---|
| `--c-kinds=+p` | **关键**：把头文件中的函数原型声明 (`p` 类标签) 也纳入，多数函数只有头文件里有声明 |
| `--fields=+iaS` | `S` = 记录 `signature:(参数列表)` 字段，参数补全的数据来源 |
| `--extra=+q` | 限定名（类成员等） |
| `-L filelist` | 从文件列表读取，与 cscope 索引范围一致 |

验证 tags 质量（应看到 `f`/`p` 类标签和 `signature:` 字段）：

```bash
grep -a "^mi_local_storage_create" tags
# mi_local_storage_create  path/to/mi_local_storage.h  /^int mi_local_storage_create(...);$/;"  p  signature:(media_channel_e v_chn, media_channel_e a_chn)
```

### 5. 应用 coc-tag 补丁（核心）

安装 coc-tag 后（vim 中 `:CocInstall coc-tag` 或已在 `g:coc_global_extensions` 里自动装），先备份再用补丁**替换**：

```bash
cd ~/.config/coc/extensions/node_modules/coc-tag
cp index.js index.js.bak
# 然后将下列内容写入 index.js
```

补丁完整内容：

```js
const {sources, workspace} = require('coc.nvim')
const path = require('path')
const fs = require('fs')
const util = require('util')
const readline = require('readline')

// 本地补丁 (基于 coc-tag 1.2.5, 原文件备份为 index.js.bak):
// 1. 解析 tags 中的 signature 字段, 函数类标签 (f/p/m) 确认补全时插入完整函数原型
//    原理: coc 对 createSource 源确认时只插入 word (见 pum.vim s:insert_word),
//          insertText 不会自动应用; 需实现 onCompleteDone 回调,
//          在确认后把 buffer 中已插入的 word 替换为完整原型
// 2. readFileByLine 行数上限 50000 -> 5000000 (大项目/内核 tags 数百万行,
//    超限部分会被静默丢弃, 字母序靠后的函数无法补全)
// 3. 大 tags 性能优化: 首字母索引 + 前缀优先的两遍收集, 上限 MAX_TAG_ITEMS 条
//    (原版每次补全遍历全部 tags 并构造所有同首字母项, 内核级 tags 下每次按键卡 ~180ms)
// 注意: 重新安装/更新 coc-tag 会覆盖本补丁

const TAG_CACHE = {}
const {nvim} = workspace

// 单次补全返回的最大候选项数: 超出时优先保留前缀匹配的项
// (coc 自身有模糊过滤, 输入越长前缀匹配越精确, 截断影响越小)
const MAX_TAG_ITEMS = 20000

async function getTagFiles() {
  let files = await nvim.call('tagfiles')
  if (!files || files.length == 0) return []
  let cwd = await nvim.call('getcwd')
  files = files.map(f => {
    return path.isAbsolute(f) ? f : path.join(cwd, f)
  })
  let tagfiles = []
  for (let file of files) {
    try {
      let stat = await util.promisify(fs.stat)(file)
      if (!stat || !stat.isFile()) continue
      tagfiles.push({file, mtime: stat.mtime})
    } catch (e) {
      // noop
    }
  }
  return tagfiles
}

function readFileByLine(fullpath, onLine, limit = 5000000) {
  const rl = readline.createInterface({
    input: fs.createReadStream(fullpath),
    crlfDelay: Infinity,
    terminal: false,
    highWaterMark: 1024 * 1024
  })
  let n = 0
  rl.on('line', line => {
    n = n + 1
    if (n === limit) {
      rl.close()
    } else {
      onLine(line)
    }
  })
  return new Promise((resolve, reject) => {
    rl.on('close', () => {
      resolve()
    })
    rl.on('error', reject)
  })
}

async function loadTags(fullpath, mtime) {
  let item = TAG_CACHE[fullpath]
  if (item && item.mtime >= mtime) return item
  let words = new Map()
  let letterIndex = new Map()  // 首字母 -> word 数组, 避免每次补全遍历全部 tags
  await readFileByLine(fullpath, line => {
    if (line[0] == '!') return
    let ms = line.split(/\t\s*/)
    if (ms.length < 2) return
    let [word, path] = ms
    // ms[2] 为 ex 模式行 (以 ;" 结尾), ms[3] 为标签类别 (f=函数定义 p=原型声明 m=成员)
    let kind = ms[3] || ''
    let signature = ''
    for (let i = 4; i < ms.length; i++) {
      if (ms[i].startsWith('signature:')) {
        signature = ms[i].slice(10)
        break
      }
    }
    let wordItem = words.get(word)
    if (!wordItem) {
      wordItem = {paths: [], signature: ''}
      words.set(word, wordItem)
      let arr = letterIndex.get(word[0])
      if (!arr) {
        arr = []
        letterIndex.set(word[0], arr)
      }
      arr.push(word)
    }
    wordItem.paths.push(path)
    // 优先记录函数类标签的签名 (f/p/m)
    if (!wordItem.signature && signature && /^[fpm]$/.test(kind)) {
      wordItem.signature = signature
    }
  })
  // eslint-disable-next-line require-atomic-updates
  item = {words, letterIndex, mtime}
  TAG_CACHE[fullpath] = item
  return item
}

exports.activate = context => {
  context.subscriptions.push(sources.createSource({
    name: 'tag',
    doComplete: async function (opt) {
      let {input} = opt
      if (input.length == 0) return null
      let tagfiles = await getTagFiles()
      if (!tagfiles || tagfiles.length == 0) return null
      let list = await Promise.all(tagfiles.map(o => loadTags(o.file, o.mtime)))
      let items = []
      for (let {words, letterIndex} of list) {
        let candidates = letterIndex.get(input[0])
        if (!candidates) continue
        // 两遍收集: 优先前缀匹配的项, 再用其他同首字母项补足 (总数限 MAX_TAG_ITEMS)
        for (let pass = 0; pass < 2 && items.length < MAX_TAG_ITEMS; pass++) {
          for (let word of candidates) {
            if (items.length >= MAX_TAG_ITEMS) break
            if (pass === 0 && !word.startsWith(input)) continue
            let tagInfo = words.get(word)
            let infoList = Array.from(new Set(tagInfo.paths))
            let len = infoList.length
            if (len > 10) {
              infoList = infoList.slice(0, 10)
              infoList.push(`${len - 10} more...`)
            }
            let item = {
              word,
              menu: this.menu,
              info: infoList.join('\n')
            }
            // 有签名信息的函数: insertText 记录完整原型, 由 onCompleteDone 应用
            if (tagInfo.signature) {
              item.documentation = [{filetype: 'txt', content: `${word}${tagInfo.signature}`}]
              item.insertText = `${word}${tagInfo.signature}`
            }
            items.push(item)
          }
        }
      }

      return {items}
    },
    // coc 确认时只插入 word, 这里将已插入的 word 替换为完整原型 (函数名+参数)
    onCompleteDone: async function (item, opt) {
      try {
        if (!item.insertText || item.insertText === item.word) return
        let linenr = opt && opt.linenr ? opt.linenr : await nvim.call('line', ['.'])
        let line = await nvim.call('getline', [linenr])
        let col = await nvim.call('col', ['.'])  // 1-based 字节列, 确认后光标在 word 之后
        let beforeCursor = line.slice(0, col - 1)
        if (!beforeCursor.endsWith(item.word)) return
        let start = col - 1 - item.word.length
        let newline = line.slice(0, start) + item.insertText + line.slice(col - 1)
        await nvim.call('setline', [linenr, newline])
        await nvim.call('cursor', [linenr, start + item.insertText.length + 1])
      } catch (e) {
        // 替换失败时保留已插入的 word, 不影响正常使用
      }
    }
  }))
}
```

### 6. create_csidx.sh 同步生成 tags

项目 `cscope/create_csidx.sh` 已改造：每次 build/rebuild cscope 索引后，自动汇总所有 `.files` 生成项目根目录 `tags`。核心代码段（在脚本末尾 `load.vim` 生成之后）：

```bash
    ## 生成 tags 文件 (供 coc-tag 扩展模糊补全, --c-kinds=+p 包含头文件中的函数原型声明)
    echo -e "${DYEL}generate tags for coc-tag completion${RES}"
    cat cscope/*.files 2> /dev/null | sort -u > cscope/all.files
    if [ -s cscope/all.files ]; then
        ctags --c-kinds=+p --fields=+iaS --extra=+q -L cscope/all.files -f tags
        echo "tags generated: $(wc -l < tags) lines"
    else
        echo "there is no *.files, skip tags"
    fi
    rm -f cscope/all.files
```

日常使用：

```bash
./cscope/create_csidx.sh -b imi_app/miio_source/imi_mike   # 建索引(含tags)
./cscope/create_csidx.sh -rb                                # 全部重建(含tags)
./cscope/create_csidx.sh -ps                                # 查看索引
```

### 7. 验证

```bash
vim imi_app/miio_source/imi_mike/main.c
# 输入 mi_local_storage_cr -> <C-n> 选中 -> Enter
# 应得到: mi_local_storage_create(media_channel_e v_chn, media_channel_e a_chn)
```

---

## 五、调试历程与核心原理（故障排查必读）

### 坑 1：buffer 源补全不到其他文件的函数 —— `set hidden`

**现象**：打开过 xiaomi_api.c，在 main.c 里补全不到其中的函数。

**排查**：开启 coc 调试日志（`NVIM_COC_LOG_FILE=/tmp/coc.log NVIM_COC_LOG_LEVEL=debug vim ...`），发现切换 buffer 瞬间：

```
[core-documents] - document detach 3 file:///xxx/other.c   ← 旧文件被 detach
[completion-complete] - Source "buffer" finished with 0 items
```

**根因**：vim 默认 `nohidden`，`:e` 在同一窗口打开另一个文件时**旧 buffer 被卸载**，coc 检测到 BufUnload 就 detach document，词汇从补全索引移除。`set hidden` 后旧 buffer 驻留内存，日志中 detach 消失，`Source "buffer" finished with 2 items`。

### 坑 2：Tab 不能向下选择，只有 Shift+Tab 能用 —— 两种 pum 形态

**现象**：Tab 无法正序选择，Shift+Tab 可以反序。

**根因**：coc 补全菜单有两种形态，检测函数不同：

| 形态 | 检测函数 | 导航 API |
|---|---|---|
| coc 浮动窗口（主流） | `coc#pum#visible()` | `coc#pum#next(1)` / `coc#pum#prev(1)` |
| vim 原生菜单 | `pumvisible()` | `<C-n>` / `<C-p>` |

原配置 Tab 只判断 `coc#pum#visible()` 且顺序错误，S-Tab 用了 `pumvisible()` —— 两个键各管一种形态。**所有补全键位映射都必须两套判断都写**（见复刻步骤的映射）。

### 坑 3：Enter 确认后参数丢失 —— 确认通道错误

**现象**：弹窗第二列明明显示着完整原型，Enter 后只有函数名。

**排查**：原映射 `complete_info()["selected"] != "-1" ? "\<C-y>" : ...` 只对**原生菜单**有效。coc 浮动窗口下 `complete_info()` 查不到选中项，且原生 `C-y` 只插入 `word` 字段，**不经过 coc 的确认逻辑**，`insertText` 被完全绕过。

**修复**：Enter 走 coc 官方确认通道 `coc#pum#confirm()`（浮动窗口）/ `coc#_select_confirm()`（原生菜单）。

### 坑 4：`insertText` 不生效 —— coc 自定义源的确认机制（最核心）

**现象**：补全项已带 `insertText`（完整原型），Enter 确认通道也对了，还是只插入函数名。

**排查**（读 coc.nvim 源码 build/index.js + autoload/coc/pum.vim）：

1. 浮动窗口确认时，vimscript 层 `s:insert_word()` **只把 `word` 写入 buffer**（`autoload/coc/pum.vim` 的 `coc#pum#close('confirm')`）；
2. `insertText`/`isSnippet` 的自动应用**只对两类源有效**：
   - LSP 源（走 `applyTextEdit`，`newText = textEdit ? ... : insertText ?? label`）
   - vimscript 源（`onCompleteDone` 里 `item.isSnippet && item.insertText` 时展开 snippet）
3. 对 `sources.createSource` 注册的 **JS 源，coc 的设计是让源自己实现 `onCompleteDone` 回调**处理确认后的逻辑（`confirmCompletion` → `source.onCompleteDone(item, opt)`，源没实现就什么都不做）。

**修复**：补丁中实现 `onCompleteDone(item, opt)` —— 确认后 word 已在 buffer 中且光标在其后，把这段 word 替换为 `insertText`（完整原型）。

**失败方案记录**：
- `isSnippet: true` + snippet 占位符 `${1:param}` → 能插入参数，但进入 snippet 跳转模式，不符合"确认即结束"的需求
- 仅 `insertText` 不设 `isSnippet` → coc 完全忽略，只插入 word

### 排查工具箱

```bash
# 1. coc 调试日志 (最有用)
NVIM_COC_LOG_FILE=/tmp/coc.log NVIM_COC_LOG_LEVEL=debug vim xxx.c
# 日志中关注:
#   [core-documents] - buffer created / document detach   (buffer 附着状态)
#   [completion-complete] - Source "xxx" finished with N items  (各源返回数量)

# 2. 查看补全源注册状态 (vim 内)
:CocList sources

# 3. 单测 coc-tag 补丁逻辑 (不依赖 vim, 用 stub 替代 coc.nvim API)
node -e '
const Module = require("module");
const orig = Module._load;
Module._load = function(request) {
  if (request === "coc.nvim") {
    return {
      sources: { createSource(src) { global.__src = src; return {dispose(){}} } },
      workspace: { nvim: { call: async (fn) => fn === "tagfiles" ? ["tags"] : process.cwd() } }
    };
  }
  return orig.apply(this, arguments);
};
require("/path/to/coc-tag/index.js").activate({subscriptions: []});
(async () => {
  const res = await global.__src.doComplete.call({menu: "[T]"}, {input: "函数前缀"});
  console.log(JSON.stringify(res.items.find(i => i.insertText), null, 2));
})();
'
```

---

## 六、维护注意事项

| 事项 | 说明 |
|---|---|
| **补丁会被覆盖** | 执行 `:CocUpdate` 或重装 coc-tag 会覆盖补丁。恢复方法：按本文档"复刻步骤 5"重打（原文件备份为 `index.js.bak`） |
| **tags 更新** | 代码改动后执行 `./cscope/create_csidx.sh -rb`，tags 与 cscope 索引一并重建 |
| **新增源文件** | 新增的 .c/.h 文件必须 `-rb` 重建后才有原型补全（rebuild 模式已修复为同步刷新 .files，老版本脚本 rebuild 时文件列表写入 .out 导致 .files 不更新，新文件永远进不了 tags） |
| **tags 数量限制** | coc-tag 原版读 tags 上限 50000 行，补丁已提高到 500000 行。超限部分会被**静默丢弃**（tags 按字母序排序，靠后的函数无法补全），项目再大需继续调高 |
| **tags 路径** | tags 在项目根目录，`set tags=./tags;,tags` 保证子目录也能找到；tags 内相对路径基于 tags 文件位置解析（`'tagrelative'` 默认开启） |
| **clangd 可选升级** | 想要"参数占位符填充 + 精确跳转定义"时：安装 bear → `bear -- make` 生成 compile_commands.json → clangd 即可工作（coc-settings.json 中已预留 `--query-driver` 宽匹配配置，多平台工具链通用），与 coc-tag 共存互不干扰 |

---

## 七、相关文件索引

| 文件 | 作用 |
|---|---|
| `~/.vimrc` → `~/vimrc/_vimrc` | 主配置（软链），含 coc 键位映射、`set hidden`、`set tags` |
| `~/.vim/coc-settings.json` | coc 配置（模糊过滤、clangd 预留） |
| `~/.config/coc/extensions/node_modules/coc-tag/index.js` | **补丁文件**（原文件备份为 `index.js.bak`） |
| `项目根/tags` | ctags 生成的符号索引（含 signature） |
| `项目根/cscope/create_csidx.sh` | 索引生成脚本（已改造，同步生成 tags） |
| `~/source_code/github/vim/build.sh` | vim 自编译脚本（configure+make+strip） |
