#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
util = require 'util'

args = process.argv
command = args[args.length - 1]
executeList = []

return if typeof(command) != 'string'

color = (color, string) -> "\u001b[#{color}m\u001b[1m#{string}\u001b[22m\u001b[39m"
colorAll = (string) -> color "32", string
colorImportant = (string) -> color "33", string

# #it
# #dir #name #ext
# #dir    #file
#   #path    #ext

pathSplit = (filePath) ->
  dirPath = path.dirname(filePath)
  extension = path.extname(filePath)
  baseName = path.basename(filePath, extension)
  [dirPath, baseName, extension]

mapping = (filePath) ->
  mapped = command
  colorized = command

  [dirPath, baseName, extension] = split = pathSplit filePath
  dirAndName = path.join(dirPath, baseName)

  colorBaseName = colorImportant baseName
  colorDirAndName = dirAndName.replace(new RegExp("#{baseName}$"), colorBaseName)

  map =
    'it': [filePath, colorDirAndName + extension]
    'dir': [dirPath, dirPath]
    'name':  [baseName, colorBaseName]
    'ext':  [extension, extension]
    'file':  [baseName + extension, colorBaseName + extension]
    'path':  [dirAndName, colorDirAndName]

  replace = (string, alias, value) ->
    string
    .replace(new RegExp("(^|[^#])##{alias}", "g"), "$1#{value}")
    .replace(new RegExp("#(##{alias})", "g"), "$1")

  # perform the mapping
  for alias, [value, colorValue] of map
    mapped = replace mapped, alias, value
    colorized = replace colorized, alias, colorAll colorValue

  if !extension?
    for invalid in ['name', 'path', 'ext']
      if mapped.match new RegExp("(^|[^#])##{invalid}")
        console.error "##{invalid} token used but #{clrGreen filePath} was not found."
        process.exit 1

  return [mapped, colorized]

doesExist = (filePath) ->
  if fs.existsSync?
    fs.existsSync filePath
  else if path.existsSync?
    path.existsSync filePath
  else
    throw "Node.js missing either path or fs existsSync"

isDirectory = (filePath) ->
  fileStats = fs.statSync filePath
  return fileStats.isDirectory() &&
         filePath[filePath.length - 1] in ['/', '\\']

mapTo = (list, inside) ->
  for filePath in list
    filePath = path.join inside, filePath if inside?
    isFile = doesExist filePath
    if isFile
      if isDirectory filePath
        mapTo (fs.readdirSync filePath), filePath
        continue
    executeList.push mapping filePath
  return

numberExecuted = 0
execute = (list) ->
  if list.length is 0
    console.log '' if numberExecuted > 0
    return
  console.log '' if numberExecuted is 0
  [mapped, colorized] = list.shift()
  console.log colorized
  numberExecuted++
  exec mapped, (error, stdout, stderr) ->
    util.print stdout if stdout.length
    util.error stderr.replace /\n$/, '' if stderr.length
    execute list
  return

mapTo args[2..-2]
execute executeList


