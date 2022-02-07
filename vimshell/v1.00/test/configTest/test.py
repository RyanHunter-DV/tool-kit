#! /usr/bin/env python3
import sys;
sys.path.append('../../');
sys.path.append('../../config');
sys.path.append('../../debugger');


from debugger import *;
print ("call to enable debug");
DebugConfig.enableDebug();
print ("start config test");
from config import *;

config = ConfigTable();
index = config.hasReopen();

if index:
	print ("get reopen index: ", index);
else:
	print ("no reopen option detected");

if config.isListMode():
	print ("listMode Enabled");
else:
	print("no listMode");
