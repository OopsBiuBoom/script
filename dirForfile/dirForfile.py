# 遍历当前文件夹，把所有文件放入数组
# 创建文件夹，使用文件名做目录
# 把内容移动到文件夹里

import os
import subprocess
import shutil

# 脚本全路径包含名称
work_path = os.path.abspath(__file__)
# 获取脚本名
fileName = os.path.basename(work_path)
# 脚本所在目录
script_directory = os.path.dirname(work_path)

# 文件名数组
file_list = []

# 遍历文件夹下所有文件
for fn in os.listdir(script_directory):
    if fn == fileName or fn.startswith('.'):
        continue
    file_list.append(fn)

# 创建文件夹
for fne in file_list:
    # 获取文件名(不包含后缀)
    name, _ = os.path.splitext(fne)
    try:
        # 创建文件夹

        # 要创建的文件夹路径
        file_folder = os.path.join(script_directory, name)
        # 文件路径
        file_path = os.path.join(script_directory, fne)
        # 创建文件夹
        os.mkdir(file_folder)
        # 移动文件到文件夹
        shutil.move(file_path,file_folder)
    except Exception as e:
        print(f"异常：{e}")        


