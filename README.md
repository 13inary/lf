##  README
###   安装
```shell
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf
```

###   配置
```shell
mkdir -p ~/.config/lf
curl https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfrc.example -o ~/.config/lf/lfrc
```


###   退出到当前工作区
```shell
mkdir -p ~/.config/lf
curl https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh -o ~/.config/lf/lfcd.sh

vim ~/.bashrc # 添加下面内容

# === lf ===
LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
    alias ra='lfcd'
fi
# === lf ===
```


###   预览程序
1. 安装
```shell
git clone https://github.com/NikitaIvanovV/ctpv
cd ctpv
make
sudo make install
```
2. 配置`lf`
```shell
vim ~/.config/lf/lfrc

set previewer ctpv
set cleaner ctpvclear
&ctpv -s $id
&ctpvquit $id
```
3. 安装预览需要的程序
| File types    | Programs                           |
|---------------|------------------------------------|
| any           | exiftool cat                       |
|---------------|------------------------------------|
| archive       | atool                              |
|---------------|------------------------------------|
| audio         | ffmpegthumbnailer ffmpeg           |
|---------------|------------------------------------|
| diff          | colordiff delta diff-so-fancy      |
|---------------|------------------------------------|
| directory     | ls                                 |
|---------------|------------------------------------|
| font          | fontimage                          |
|---------------|------------------------------------|
| gpg-encrypted | gpg                                |
|---------------|------------------------------------|
| html          | elinks lynx w3m                    |
|---------------|------------------------------------|
| image         | ueberzug chafa                     |
|---------------|------------------------------------|
| json          | jq                                 |
|---------------|------------------------------------|
| markdown      | glow mdcat                         |
|---------------|------------------------------------|
| office        | libreoffice                        |
|---------------|------------------------------------|
| pdf           | pdftoppm                           |
|---------------|------------------------------------|
| svg           | convert                            |
|---------------|------------------------------------|
| text          | bat cat highlight source-highlight |
|---------------|------------------------------------|
| torrent       | transmission-show                  |
|---------------|------------------------------------|
| video         | ffmpegthumbnailer                  |

3. 卸载
```shell
sudo make uninstall
```


###   其他依赖
```shell
sudo apt install fzf
```


###   相关文件
|--------------|-----------------------------|
| 类型         | 路径                        |
|--------------|-----------------------------|
| 系统配置文件 | `/etc/lf/lfrc`              |
| 用户配置文件 | `~/.config/lf/lfrc`         |
|--------------|-----------------------------|
| 系统颜色文件 | `/etc/lf/colors`            |
| 用户颜色文件 | ` ~/.config/lf/colors`      |
|--------------|-----------------------------|
| 系统图标文件 | `/etc/lf/icons`             |
| 用户图标文件 | ` ~/.config/lf/icons`       |
|--------------|-----------------------------|
| 选择的文件   | ` ~/.local/share/lf/files`  |
|--------------|-----------------------------|
| 标记的文件   | `~/.local/share/lf/marks`   |
|--------------|-----------------------------|
| tag文件      | `~/.local/share/lf/tags`    |
|--------------|-----------------------------|
| 历史文件     | `~/.local/share/lf/history` |
|--------------|-----------------------------|

* 修改默认配置的位置
```shell
$XDG_CONFIG_HOME  ~/.config
$XDG_DATA_HOME    ~/.local/share
```


###   文档
* 本地文件
```shell
lf -doc
```
* 网络最新文件
[官方文档](https://pkg.go.dev/github.com/gokcehan/lf#section-documentation) 
