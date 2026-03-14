# Scheduler pentru publicarea modificarilor pe site Jupyter
# Autor: Balas Vlad-George

import std/posix
import std/parsecsv
import std/times
import std/strutils
# from std/os import paramStr
# from std/streams import newFileStream

type Action* = enum
  Hide, unHide, Exclude, unExclude

type ScheduleEntry* = object
   file*: string
   dateTime*: DateTime
   action*: Action

proc cmp*(x, y: ScheduleEntry) : int =
  cmp(x.dateTime, y.dateTime)

proc toString(source: Action) : string =
  case source:
  of Hide: return "hide"
  of unHide: return "show"
  of Exclude: return "exclude"
  of unExclude: return "include"

proc toString*(source: ScheduleEntry) : string =
  return source.dateTime.format("dd-MM-yyyy/hh:mm") & " " & source.action.toString() & " " & source.file

proc parseIntField(srcCsvParser : var CsvParser, fieldName : string) : int =
  let rawString = srcCsvParser.rowEntry(fieldName).strip()
  result = parseInt(rawString)

proc parseStringField(srcCsvParser : var CsvParser, fieldName : string) : string =
  result = srcCsvParser.rowEntry(fieldName).strip()

proc parseActionField(srcCsvParser : var CsvParser) : Action =
  let rawAction = srcCsvParser.rowEntry("Actiune").strip()
  case rawAction:
  of "exclude":
    return Action.Exclude
  of "include":
    return Action.unExclude
  of "hide":
    return Action.Hide
  of "show":
    return Action.unHide

# Citire CSV cu orar
proc readScheduleCsv*(path: string) : seq[ScheduleEntry]=
  var myCsvParser : CsvParser
  myCsvParser.open("schedule.csv")
  myCsvParser.readHeaderRow()

  # TODO: schimba formatul csv-ului in dd-MM-yyyy/hh:mm, action, file
  var parsedCsvData : seq[ScheduleEntry]
  while myCsvParser.readRow():
    # convert to standard 'dd' format
    var myDay = $parseIntField(myCsvParser, "Zi")
    if myDay.len < 2:
      myDay = "0" & myDay

    # convert to standard 'mm' format
    var myMonth = $parseIntField(myCsvParser, "Luna")
    if myMonth.len < 2:
      myMonth = "0" & myMonth

    let myYear = $parseIntField(myCsvParser, "An")
    let myHour = $parseIntField(myCsvParser, "Ora")
    let myMinute = $parseIntField(myCsvParser, "Minut")

    # to be replaced with better method
    let stringDateTime = myDay & "-" & myMonth & "-" & myYear & "/" & myHour & ":" & myMinute
    let dt : DateTime = stringDateTime.parse("dd-MM-yyyy/hh:mm")
    # echo dt

    let myFile = parseStringField(myCsvParser, "Fisier")

    let myAction = parseActionField(myCsvParser)

    parsedCsvData.add(ScheduleEntry(
      file: myFile, dateTime : dt, action : myAction
    ))

  myCsvParser.close()
  return parsedCsvData


proc applyAction*(yamlData : var seq[string], fileToDo : string, actionToDo : Action) : bool =
  for i, line in yamlData:
    if find(line, fileToDo)>=0:
      echo "Debug: ", i, " ", line

      var lineToFind : string = ""

      case actionToDo:
      of Exclude: lineToFind = "exclude"
      of unExclude: lineToFind = "exclude"
      of Hide: lineToFind = "hidden"
      of unHide: lineToFind = "hidden"

      echo "Debug: ", "Line to find -> ", lineToFind

      var tmp = i + 1
      var ok : bool = false

      while not("-" in yamlData[tmp]) and i < yamlData.len - 1:
        if find(yamlData[tmp], lineToFind) >= 0:
          ok = true
          break
        else:
          tmp = tmp + 1

      echo "Debug: ", tmp, " ", ok, " ", yamlData[tmp]

      if ok:
        case actionToDo:
        of Exclude:
          yamlData[tmp] = replace(yamlData[tmp], "false", "true")
        of unExclude:
          yamlData[tmp] = replace(yamlData[tmp], "true", "false")
        of Hide:
          yamlData[tmp] = replace(yamlData[tmp], "false", "true")
        of unHide:
          yamlData[tmp] = replace(yamlData[tmp], "true", "false")
      else:
        var blobToAdd = ""

        case actionToDo:
        of Exclude: blobToAdd = "exclude: true"
        of unExclude: blobToAdd = "exclude: false"
        of Hide: blobToAdd = "hidden: true"
        of unHide: blobToAdd = "hidden: false"

        var lineToAdd = line
        lineToAdd = lineToAdd.replace("- file: " & fileToDo, "  " & blobToAdd)
        yamlData.insert(lineToAdd, i + 1)
      break

  return true
