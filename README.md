# THE HOT-REBOOT FOR SWOOLE SERVER

> php swoole 快速重启方案

* phper 在一开始接触swoole开发时，发现没有fpm模式下开发来的便捷，频繁的reload让人有点不耐烦了
* 这个是通过 *fswatch* 监听文件修改状态来对swoole server进行重启的方案，需要的可以尝试下

# install fswatch

mac 

> brew install fswatch

linux

> 自行搜索 fswatch 安装即可

# start

这是 easyswoole 的例子

> git clone https://github.com/viliy/hot-reboot-swoole.git

> cd hot-reboot-swoole/

> chmod +x src/bin/hot-reboot.sh

> vim src/conf/swoole.conf

```conf

APP_LISTEN_DIR='~/swoole/App'                   # 需要监听的目录
APP_DIR='~/swoole/'                             # 项目根目录
APP_START='php easyswoole start dev.php'        # 启动命令
APP_STOP='php easyswoole stop'                  # 关闭命令
APP_RELOAD_ONE='php easyswoole stop'            # 重启命令1
APP_RELOAD_TWO='php easyswoole start dev.php'   # 重启命令2
RELOAD_LOG='/tmp/reload.log'                    # 重启日志
RUN_LOG='/tmp/run.log'                          # swoole server运行debug 输出日志
INGORE_FILE='php___jb'                          # 忽略的改动文件关键词 被忽略的文件将不会进行重启

```

> run:  src/bin/hot-reboot.sh src/conf/swoole.conf

这时候新建两个窗口分别：

> tail -f  /tmp/reload.log
> tail -f  /tmp/run.log

debug的日志就会在这显示了
