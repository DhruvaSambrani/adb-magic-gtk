#!/usr/bin/env python3

import adb_config
import subprocess
import re
import sys

def ui(adbpath, searchtext):
    useless_cat_call = subprocess.Popen([adbpath, "shell"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output, errors = useless_cat_call.communicate(input="uiautomator dump && cat /sdcard/window_dump.xml")
    useless_cat_call.wait()
    match = re.search("text=\".*"+searchtext+".*?bounds=\"\[(.*?)\]\"", output)
    ps = match.groups()[0].split("][")
    p1 = [int(i) for i in ps[0].split(",")]
    p2 = [int(i) for i in ps[1].split(",")]
    point = [str(int((p1[0]+p2[0])//2)), str(int((p1[1]+p2[1])//2))]
    useless_cat_call = subprocess.Popen([adbpath, "shell"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    useless_cat_call.communicate(input=("input tap "+" ".join(point)))
    useless_cat_call.wait()

if __name__ == "__main__":
    ui(adb_config.getpath(), sys.argv[1])

