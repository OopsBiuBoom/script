# 用于单个语音和多张图片合成视频
# 使用方法：把图片和mp3文件放在imgchange文件夹下即可。当前文件要在根目录下执行

import os
import glob
import subprocess

# 设置环境变量
ffmpeg_PATH = r".\ffmpeg\bin"
os.environ["PATH"] += os.pathsep + ffmpeg_PATH

# 获取工作目录
current_folder = os.getcwd()
current_folder += "\imgchange"


# 定义可操作的图片后缀
image_extensions = ['*.jpg', '*.jpeg', '*.png', '*.bmp']

image_paths = []

# 查找当前文件夹下所有图片
for extension in image_extensions:
    image_paths.extend(glob.glob(os.path.join(current_folder,extension)))
    
# 查找当前文件夹下MP3文件
mp3Path = glob.glob(os.path.join(current_folder,"*.mp3"))[0]

# 执行命令
for index, imagePath in enumerate(image_paths):
    com = f".\python38\python.exe .\inference.py --driven_audio {mp3Path} --source_image {imagePath} --result_dir {os.path.join(current_folder,str(index))} --preprocess resize --enhancer gfpgan"
    subprocess.call(com)


