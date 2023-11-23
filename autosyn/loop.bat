@echo off

REM 放在SadTaker根目录下，创建change文件夹，目录下放图片用于人物合成。目录两里每个文件夹是一个要合成的视频，需要有一个.MP3的音频即可。

REM 设置环境变量
set MY_PATH=.\ffmpeg\bin
set PATH=%PATH%;%MY_PATH%

REM 工作目录
set "workPath=%CD%"
REM 内容根目录
set "rootPath=%CD%\change"

setlocal enabledelayedexpansion

REM 保存子路径数组
set "subpath[0]="
REM 子路径数组长度
set "subpathLength=0"
REM 计数
set "index=0"
REM 头像名称
set "logoName="

REM 获取头像名
call cd %rootPath%
for /f "delims=" %%i in ('dir /b *.jpg *.jpeg *.png *.gif *.bmp') do (
	set "logoName=%%i"
)

REM 头像路径
set "logoPath=!rootPath!\!logoName!"

REM 遍历获取文件当前文件夹名
for /f "delims=" %%i in ('dir /ad /b') do (
	set "subpath[!index!]=%%i"
	set /a index+=1
)

REM 数组长度，从0开始算
set /a index-=1
set subpathLength=!index!

REM 拼接文件夹路径存放到数组
for /L %%i in (0,1,%subpathLength%) do (
	set "newsub=!subpath[%%i]!"
	set "newPath=!rootPath!\!newsub!"
	set "subpath[%%i]=!newPath!"
)
call cd ..

REM mp3文件名
set "mp3Name="
REM 主流程
for /L %%i in (0,1,%subpathLength%) do (
	REM 进入到子目录
	call cd !subpath[%%i]!
		REM 找到MP3路径
	for /f "delims=" %%i in ('dir /b *.mp3') do (
		set "mp3Name=%%i"
	)
	REM 拼接MP3路径
	set "mp3path=!subpath[%%i]!\!mp3Name!"
	REM 返回上级目录
	call cd !workPath!
	REM 重置mp3文件名
	set "mp3Name="
	REM 最终输出内容
	.\python38\python.exe .\inference.py --driven_audio !mp3path! --source_image !logoPath! --result_dir !subpath[%%i]! --still --preprocess full
)
endlocal

pause