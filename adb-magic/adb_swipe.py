#!/usr/bin/env python3

import adb_config
import subprocess
import sys
# Use the 'show pointer events' setting to change if needed [resx resy resx resy time]
res = [1080, 2200, 1080, 2200, 100] # repeated for code simplicity

# in "x1 y1 x2 y2" order
swipe_coords = {
        "u": [50, 75, 50, 25, 500],
        "d": [50, 25, 50, 75, 500],
        "l": [50, 50, 10, 50, 500],
        "r": [50, 50, 90, 50, 500]
    }

def _get_points_str(direction):
    percs = swipe_coords[direction]
    return " ".join([str(int((percs[i]*res[i])//100)) for i in range(5)])

def swipe(adbpath, direction):
    useless_cat_call = subprocess.Popen([adbpath, "shell"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    output, errors = useless_cat_call.communicate(input="input swipe "+_get_points_str(direction))

if __name__=="__main__":
    swipe(adb_config.getpath(), sys.argv[1])

