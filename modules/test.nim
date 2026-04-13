
# fisier de test

import std/osproc
import csv_read
import yml_read
import sched
import strutils
import std/posix
import std/algorithm
import std/times



let res = execCmd("git pull")
echo "Debug : ", res
