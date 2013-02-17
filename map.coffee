#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
util = require 'util'

args = process.argv
command = args[args.length - 1]
executeList = []

return if typeof(command) != 'string'

greeny = (string) -> "\u001b[32m\u001b[1m#{string}\u001b[39m"

mapping = (filePath) ->
  mapped = command
  colorized = command

  # fill #it
  mapped = mapped.replace /#it/g, filePath
  colorized = colorized.replace /#it/g, greeny filePath

  # fill #name and #ext
  fileExt = path.extname(filePath)
  if fileExt
    fileName = filePath.replace new RegExp("#{fileExt}$"), ''
    mapped = mapped
    .replace(/#name/g, fileName)
    .replace(/#ext/g, fileExt)
    colorized = colorized
    .replace(/#name/g, greeny fileName)
    .replace(/#ext/g, greeny fileExt)
  else
    if mapped.match /(^|[^\\])#name/
      console.error "#name token used but #{greeny filePath} was not found."
      process.exit 1
    if mapped.match /(^|[^\\])#ext/
      console.error "#ext token used but #{greeny filePath} was not found."
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


