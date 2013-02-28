map
===

**map** command for unix environments.

- Non-unix way to do unix.
- Simplified bash loop.
- Pretty output.
- Fail-fast.

## Installation

You will need `Node.js` version at least 0.6.x

Copy the file `map` to your preferred `bin` folder.

## Examples

```bash
$ map one two three "touch document_#it.md"
```

```bash
$ map folder/ "convert #it #path.png"
```

Note the `/` at the end of folder name is important.

```bash
$ map folder/ "mv #it #dir/good_#name_backup#ext"
```

```bash
$ map profiles/ "map profiles/ 'diff #it ##it'"
```

```bash
$ map a b c "echo #ext"
#ext token used but a was not found.
```

## Documentation

### Replacement Tokens

Complete:

- `#it` the fully qualified file name: directory location, name and extension

Separate parts:

- `#dir` the containing directory, without a slash at the end
- `#name` only the name of the file, without directory location and extension
- `#ext` the file extension, starting at the last dot in the file name

Joined parts:

- `#path` the path of the file, including its name but without extension
- `#file` the file name, name and extension without directory location

Therefore, `#it` == `#dir/#name#ext` == `#path#ext` == `#dir/#file`

### Silencing

To hide the pretty output from **map**, use the MAPSILENT environment variable.
If set to `true`, map won't print any of its own output, otherwise it displays
the command it is about to execute.

```bash
$ export MAPSILENT=true
```

### Background Processes

If the the supplied command ends in `&` (for a background job), **map** won't wait
for it to finish and will continue executing rest of the commands (asynchronous vs.
synchronous execution).

### Escaping

To use the tokens literally, for any reason, add another hash in front of them.

```bash
$ map adam tom jerry "_('##name').find('#it');" 2> /dev/null

_('#name').find('adam');
_('#name').find('tom');
_('#name').find('jerry');
```

### Nested map

Thanks to escaping, nesting **map**s is easy and can be done to arbitrary level.

```bash
$ map B C D "map am uck ick \"map land ash up 'echo #it##it###it'\""
```
