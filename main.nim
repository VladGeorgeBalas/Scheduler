import modules/csv_read
import modules/yml_read
import strutils
import std/posix
import std/algorithm
import std/times

# Setup and read arguments
let csvPath : string = "schedule.nim"
let ymlPath : string = "myst.yml"

# Gen env data ( csv and yml )
var csvData : seq[ScheduleEntry] = readScheduleCsv(csvPath)
# TODO: citeste log-ul

# Sortam CSV-ul dupa timp
csvData.sort(cmp)
echo csvData

# Complete unapplied actions
# TODO: toate actiunile care sunt in trecut si nefacute in log trebuie
# completate imediat, inainte de a lucra la restul

let timeBuffer = 10 # in seconds
var actionIndex = 0
while actionIndex <= csvData.len - 1:
  # find first action to be performable
  var past : bool = true
  var tmp = actionIndex
  while tmp <= csvData.len - 1:
    if past == true and now() < csvData[tmp].dateTime:
      past = false
      break

  # calculate the period to be waited - buffer
  var duration : cint = cint((now() - csvData[tmp].dateTime).inSeconds() - timeBuffer)

  # wait with loss correction
  var rem : cint = 0
  while true:
    rem = sleep(duration)
    if rem == 0:
      break
    else:
      # correct for time loss
      duration = rem
      rem = 0
