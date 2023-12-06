# 用于多个语音和多张图片合成视频
# 使用方法：把图片和mp3文件放在imgchange文件夹下即可。当前文件要在根目录下执行

import os
import glob
import subprocess

# 设置环境变量
ffmpeg_PATH = r".\ffmpeg\bin"
os.environ["PATH"] += os.pathsep + ffmpeg_PATH

# 获取工作目录
current_folder = os.getcwd()
current_folder = os.path.join(current_folder, 'imgchange')

# 所有图片路径
image_paths = []
# 所有mp3路径
mp3_paths = []

# 定义可操作的图片后缀
image_extensions = ['*.jpg', '*.jpeg', '*.png', '*.bmp']

# 查找当前文件夹下所有图片
for extension in image_extensions:
    image_paths.extend(glob.glob(os.path.join(current_folder,extension)))
    
# 查找当前文件夹下MP3文件
audio_extensions = ['*.mp3']
for extension in audio_extensions:
    mp3_paths.extend(glob.glob(os.path.join(current_folder,extension)))

# 执行命令
# --still: 静态头部
# --preprocess: full 适合全屏配合still更和谐; resize 适合大头
# --enhancer gfpgan: 面部增强
for audio_index, audio_Path in enumerate(mp3_paths):
    for image_index, image_path in enumerate(image_paths):
        tmp_path = f"{audio_index}{image_index}"
        # 全屏：--still --preprocess full
        # com = f".\python38\python.exe .\inference.py --driven_audio {audio_Path} --source_image {image_path} --result_dir {os.path.join(current_folder,str(tmp_path))} --still --preprocess full"
        # 大头: --preprocess resize --enhancer gfpgan
        com = f".\python38\python.exe .\inference.py --driven_audio {audio_Path} --source_image {image_path} --result_dir {os.path.join(current_folder,str(tmp_path))} --preprocess resize --enhancer gfpgan"

        subprocess.call(com)


