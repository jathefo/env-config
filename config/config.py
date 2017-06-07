#!/usr/bin/python

import os
import subprocess as sp

#targetPath = 'mybin'

homePath = os.environ['HOME']
currPath = os.getcwd()
envPath = homePath + os.sep + 'env-config' #os.path.dirname(currPath)
print 'home path: ' + homePath
print 'environ path: ' + envPath

def isSubstring(str1, str2):
    tag = False
    if str2.find(str1) != -1:
        tag = True
    return tag

#if( not os.path.exists(homePath + os.sep + targetPath)):
#    sp.call(["mkdir", homePath + os.sep + targetPath])
#    fd = open(homePath + os.sep + ".bashrc", "a")
#    fd.write("export PATH=$PATH:~/" + targetPath)

fd = open(homePath + os.sep + ".bashrc", "r+a")
filelist = fd.readlines()
idx = 0
for fileline in filelist[::-1]:
    idx += 1
    if(isSubstring("env-config/bin", fileline)):
        break
if(idx == len(filelist)):
    fd.write("export PATH=$PATH:" + envPath + "/bin\n")
fd.close()

if(not os.path.exists(homePath + os.sep + "/.vimrc")):
    sp.call(["ln","-s", envPath + "/etc/vimrc", homePath + "/.vimrc"])

sp.call(["source " + homePath + os.sep + ".bashrc"], shell=True)
