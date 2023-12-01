#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
import shutil
import re
import sys
import getopt

# 使用方法
# python update_to_agora.py -s testApplication -t agora-brand
# 执行上述命令，指定要复制的文件夹和目标文件夹的名字
#
# 修改 FOLDER_dict中的字符串用作文件路径的修改
# 修改 UPDATE_dict中的字符串用作文件中内容的修改
# walkFile 中判断文件后缀名，按需要修改
#


def main(argv):
    sourcePath = ''
    targetPath = ''

    try:
        opts, args = getopt.getopt(
            argv[1:], "-h-s:-t:", ["source=", "target="])

    except getopt.GetoptError:
        print 'update_to_agora.py -s <source> -t <target>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'update_to_agora.py -s <source> -t <target>'
            sys.exit()
        if opt in ("-s", "--source"):
            sourcePath = arg
            print 'source folder: ', sourcePath
        if opt in ("-t", "--target"):
            targetPath = arg
            print 'target folder: ', targetPath

    if(sourcePath == '' or targetPath == ''):
        print 'need source and target path.'
        return

    # 当前文件路径
    # print(os.path.realpath(__file__))
    # 当前文件所在的目录，即父路径
    currentFolder = os.path.split(os.path.realpath(__file__))[0]
    # print(os.path.split(os.path.realpath(__file__))[0])
    sourcePath = currentFolder + "/" + sourcePath
    targetPath = currentFolder + "/" + targetPath

    print 'target folder: ', targetPath

    if sourcePath == '' or targetPath == '':
        print "missing source or target"
        sys.exit(2)

    copyFolder(sourcePath, targetPath)

    #oldName = outputfile + "/app/src"
    renameFolder(targetPath)
    walkFile(targetPath)


# 需要修改的文件夹名
FOLDER_dict = {
    
}

# 修改文件夹名称


def renameFolder(folderName):
    print 'renameFolder: ' + folderName
    # 修改文件夹名
    for parent, dirnames, filenames in os.walk(folderName, topdown=False):

        for filename in filenames:
            file_ext = filename.rsplit('.', 1)
            if len(file_ext) != 2:
                continue
            changeFileName(parent, filename)

        for dirname in dirnames:
            pathdir = os.path.join(parent, dirname)
            for k in FOLDER_dict.keys():
                if dirname == k:
                    print 'rename: ' + pathdir
                    os.renames(pathdir, pathdir.replace(k, FOLDER_dict.get(k)))


# 需要修改的文件名
FILE_dict = {
    "em_chat_uikit.iml":"agora_chat_uikit.iml",
    "em_chat_uikit.dart":"agora_chat_uikit.dart",
    "em_chat_uikit.podspec":"agora_chat_uikit.podspec",
}


def changeFileName(parent, filename):
    pathdir = os.path.join(parent, filename)
    for k in FILE_dict.keys():
        if filename == k:
            value = FILE_dict.get(k)
            print '%-40s' % filename + value
            os.renames(pathdir, pathdir.replace(k, value))


# 遍历文件夹
def walkFile(file):
    print 'begin walkFile'
    total_yaml_num = 0
    total_gradle_num = 0
    total_dart_num = 0
    total_podspec_num = 0
    total_md_num = 0

    for root, dirs, files in os.walk(file):

        # root 表示当前正在访问的文件夹路径
        # dirs 表示该文件夹下的子目录名list
        # files 表示该文件夹下的文件list

        # 遍历文件
        for f in files:
            #print(os.path.join(root, f))
            file_path = os.path.join(root, f)
            file_ext = file_path.rsplit('.', 1)
            if len(file_ext) != 2:
                # 没有后缀名
                continue
            if file_ext[1] == 'yaml' or file_ext[1] == 'gradle' or file_ext[1] == 'dart' or file_ext[1] == 'podspec' or file_ext[1] == 'md':
                if file_ext[1] == 'yaml':
                    total_yaml_num += 1
                if file_ext[1] == 'gradle':
                    total_gradle_num += 1
                if file_ext[1] == 'dart':
                    total_dart_num += 1
                if file_ext[1] == 'podspec':
                    total_podspec_num += 1
                if file_ext[1] == 'md':
                    total_md_num += 1

                fullname = os.path.join(root, f)
                updateFile(fullname)
                reBackFile(fullname)


        # 遍历所有的文件夹
        # for d in dirs:
        #    print(os.path.join(root, d))

    print 'total .yaml files: ' + str(total_yaml_num)
    print 'total .gradle files: ' + str(total_gradle_num)
    print 'total .dart files: ' + str(total_dart_num)
    print 'total .podspec files: ' + str(total_podspec_num)
    print 'total .md files: ' + str(total_md_num)


# 需要替换的字符串map
UPDATE_dict = {
    "name: em_chat_uikit": "name: agora_chat_uikit",
    "em_chat_uikit.dart":"agora_chat_uikit.dart",
    "em_chat_uikit:":"agora_chat_uikit:",
    "im_flutter_sdk/im_flutter_sdk.dart":"agora_chat_sdk/agora_chat_sdk.dart",
    "EMMessage":"ChatMessage",
    "EMConversation":"ChatConversation",
    "EMError":"ChatError",
    "EMTextMessageBody":"ChatTextMessageBody",
    "EMVoiceMessageBody":"ChatVoiceMessageBody",
    "EMFileMessageBody":"ChatFileMessageBody",
    "EMImageMessageBody":"ChatImageMessageBody",
    "EMGroupMessageAck":"ChatGroupMessageAck",
    "EMClient":"ChatClient",
    "EMChatEventHandler":"ChatEventHandler",
    "EMConnectionEventHandler":"ConnectionEventHandler",
    "EMMultiDeviceEventHandler":"ChatMultiDeviceEventHandler",
    "EMOptions":"ChatOptions",
    "package:em_chat_uikit":"package:agora_chat_uikit",
    "\"em_chat_uikit\"":"\"agora_chat_uikit\"",
    " = 'em_chat_uikit'":" = 'agora_chat_uikit'",
    
    # SDK Version
    "im_flutter_sdk: ^4.0.2":"agora_chat_sdk: 1.1.1",
    
}

# 将修改错误的再改回来
RE_BACK_dict = {
#    "rootProject.name = 'agora_chat_sdk'":"rootProject.name = 'im_flutter_sdk'"
}


# 按照UPDATE_dict中的内容查找替换文件内容


def updateFile(file):
    """
    替换文件中的字符串
    :param file:文件名
    :param old_str:旧字符串
    :param new_str:新字符串
    :return:
    """
    file_data = ""
    with open(file, "r") as f:
        for line in f:
            for k in UPDATE_dict.keys():
                line = line.replace(k, UPDATE_dict.get(k))

            file_data += line

    with open(file, "w") as f:
        f.write(file_data)


def reBackFile(file):
    file_data = ""
    with open(file, "r") as f:
        for line in f:
            for k in RE_BACK_dict.keys():
                line = line.replace(k, RE_BACK_dict.get(k))

            file_data += line

    with open(file, "w") as f:
        f.write(file_data)



# 复制文件夹 


def copyFolder(source, target):
    source_path = source
    target_path = target
    print 'begin copy ' + source
    print 'to         ' + target

    if not os.path.exists(target_path):
        # 如果目标路径不存在原文件夹的话就创建
        os.makedirs(target_path)

    if os.path.exists(source_path):
        # 如果目标路径存在原文件夹的话就先删除
        shutil.rmtree(target_path)

    shutil.copytree(source_path, target_path)
    print('copy dir finished!')


if __name__ == "__main__":
    main(sys.argv)
