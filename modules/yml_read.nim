proc readYaml*(filePath : string):seq[string] =
  var file : File

  # adauga error handling
  discard open(file, filePath, fmRead)

  var ymlLines : seq[string]
  for i in file.lines:
    ymlLines.add(i)

  file.close()
  # echo ymlLines
  return ymlLines

proc writeYaml*(filePath : string, data : seq[string]) =
  var resultFile : File = open(filePath, fmWrite)
  echo "Debug: Writing to " & "\"" & filePath & "\""
  for i, line in data:
    resultFile.write(line & "\n")
  resultFile.close()
