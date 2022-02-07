#! /usr/bin/env python3
import sys;
sys.path.append('../../');
sys.path.append('../../shell');
sys.path.append('../../debugger');


from debugger import *;
print ("call to enable debug");
DebugConfig.enableDebug();

print("start shell test");
