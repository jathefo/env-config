#!/usr/bin/python

import os
import subprocess as sp

#targetPath = 'mybin'

homePath = os.environ['HOME']
currPath = os.getcwd()
envPath = os.path.dirname(currPath)

#if( not os.path.exists(homePath + os.sep + targetPath)):
#    sp.call(["mkdir", homePath + os.sep + targetPath])
#    fd = open(homePath + os.sep + ".bashrc", "a")
#    fd.write("export PATH=$PATH:~/" + targetPath)
fd = open(homePath + os.sep + ".bashrc", "a")
fd.write("export PATH=$PATH:" + envPath + "/bin\n")
fd.close()


#sp.call(["ln","-s",envPath + "/bin/cs.sh",homePath + os.sep + targetPath + "/cs.sh"])

