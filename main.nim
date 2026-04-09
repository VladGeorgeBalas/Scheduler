import modules/csv_read
import modules/yml_read
import modules/sched
import strutils
import std/posix
import std/algorithm
import std/times

# Setup and read arguments
# TODO: citire argumente din cli si argv
let csvPath : string = "./testFiles/schedule.csv"
let ymlPath : string = "testFiles/myst.yml"

# Gen env data ( csv and yml )
var csvData : seq[ScheduleEntry] = readScheduleCsv(csvPath)
# TODO: sa ai macar un log de citit :))
# TODO: citeste log-ul

# Sortam CSV-ul dupa timp
csvData.sort(cmp)               # sort descrescator dupa timp
echo "Debug : \n", csvData, "\n"

# Completare actiuni nerealizate
# TODO: toate actiunile care sunt in trecut si nefacute in log trebuie
# completate imediat, inainte de a lucra la restul

let timeBuffer : cint = 10 # in secunde
var actionIndex = -1

# prima actiune care poate fi facuta
while actionIndex + 1 <= csvData.len - 1 and now() < csvData[actionIndex + 1].dateTime:
  actionIndex = actionIndex + 1

echo "Debug : Action Index = ", actionIndex, "\n"

# actionIndex ar fi cu 1 dupa index-ul ultimei actiuni
# deci verificam daca e ceva de facut sa nu avem erori la init
if actionIndex >= 0:
  actionIndex = actionIndex
  var threads = newSeq[Thread[thrData]](actionIndex + 1)
  var data = newSeq[thrData](actionIndex + 1)

  echo "Debug : Action Index = ", actionIndex, "\n"

  for i in 0..actionIndex:
    echo "Debug : Adaugare task #", i
    data[i].toDo = csvData[i];
    data[i].ymlPath = ymlPath;
    data[i].buffer = timeBuffer;

  for i in 0..actionIndex:
    createThread(threads[i], scheduledThread, data[i]);

  echo "Debug : join treads"

  for i in 0..actionIndex:
    joinThread(threads[i])
