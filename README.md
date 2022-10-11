# 工作和日常写的一些脚本

## 1. autoLoad
会执行指定的命令，失败会重试，直到成功

### 使用场景
下载依赖的时候有时候网络慢会断开，又需要手动去执行命令，很不方便。使用这个脚本，就可以使用这个脚本去做别的事情了。

### 使用方法
```
sh autoLoad.sh ‘需要执行的命令’
```

## 2. autopod
使用cocoapods拉依赖的时候有时候网络慢会断开，又需要手动去执行命令，很不方便。使用这个脚本，就可以使用这个脚本去做别的事情了。

### 使用方法
```
sh autopod.sh
```

## 3. envchange
配合fastlane用来修改项目中环境变量的脚本

## 4. gitlog
会打印出你的commit简短日志，用来写日报用的，基本上打印出来的直接复制粘贴就能用了。
- 支持多选分支
- 支持多个项目同时打印
- 支持打印指定用户
- 支持时间选择


### 使用方法
打开脚本，根据你的需求修改用户，项目地址和输出路径即可

```
# 查看帮助
sh gitlog.sh -h

# 选择时间
sh gitlog.sh -d

# 选择分支
sh gitlog.sh -b

# 同时选择分支和时间（顺序无所谓）
sh gitlog.sh -b -d
```

## 5. mp4tomp3
mp4转mp3脚本，需要安装FFmpeg

## 6. ts2mp4
多个ts合成一个mp4，需要安装FFmpeg
