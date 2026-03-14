import csv_read
import yml_read
import std/times
import std/posix
import std/osproc

# Versiunea curenta nu are error-handling
# Si nici locks pe git, desi trebuie
proc scheduledThread*(toDo : ScheduleEntry, buffer : cint, ymlPath : string) =
  var duration : cint = 0
  var rem : cint = 10

  duration = cint((toDo.dateTime - now()).inSeconds()) - buffer

  while rem>0:
    rem = sleep(duration)
    duration = rem

  # 0) lock
  # 1) read yaml
  var yamlData : seq[string] = ymlPath.readYaml()

  # 2) pull
  var res = execCmd("git pull") # `git pull` returneaza 1 pentru orice altceva decat "up to date"
  res = execCmd("git pull")

  # 3) modify
  discard applyAction(yamlData, toDo.file, toDo.action)

  # 4) write
  ymlPath.writeYaml yamlData

  # 5) commit
  res = execCmd("git commit " & ymlPath & " -m " & "\"" & toDo.toString() & "\"" )
  # nu stiu ce eroare ar putea da

  # 6) push
  res = execCmd("git push")

  # 0) unlock
  # 7) repeat
