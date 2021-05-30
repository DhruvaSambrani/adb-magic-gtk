#!/usr/bin/env python3

import adb_config
import subprocess
import sys
import re

def get_notifs(adbpath):
    useless_cat_call = subprocess.Popen([adbpath, "shell"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output, _ = useless_cat_call.communicate(input="dumpsys notification --noredact")
    useless_cat_call.wait()
    match_iter = re.finditer(r"NotificationRecord.*?pkg=(.*?)\ u.*?text=.*?\((.*?)\)", output, flags=re.DOTALL)
    return [match for match in match_iter]

def open_activity(adbpath, pkg):
    useless_cat_call = subprocess.Popen([adbpath, "shell"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output, err = useless_cat_call.communicate(input="monkey -p " + pkg + " 1")
    useless_cat_call.wait()
    return output, err

if __name__ == "__main__":
    adbpath = adb_config.getpath()
    while True:
        matches = get_notifs(adbpath)
        for i in range(len(matches)):
            match = matches[i]
            print(i, "] ", ".".join(match.groups()[0].split(".")[-2:]), ": ", match.groups()[1].replace("\n", " "))
        inp = input("[NUM/r/q]: ")
        if inp.isdigit():
            idx = int(inp)
            pkg = matches[idx].groups()[0]
            open_activity(adbpath, pkg)
        elif inp=="q":
            break
        else:
            pass

