#! /usr/bin/env python3

import adb_config
import adb_key
import adb_swipe
import adb_text
import getpass
import subprocess

def unlock(adbpath, password):
    adb_key.key(adbpath, "wake")
    adb_swipe.swipe(adbpath, "u")
    adb_text.send_text(adbpath, password, False)


if __name__=="__main__":
    unlock(adb_config.getpath(), getpass.getpass())
