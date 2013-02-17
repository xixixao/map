map
===

map command for unix environments.

- Non-unix way to do unix.
- Simplified bash loop.
- Pretty output.
- Fail-fast.

## Installation

You will need `Node.js` version at least 0.6.x

Copy `map` to your preferred `bin` folder.

## Examples

```bash
$ map one two three "touch document_#it.md"
```

```bash
$ map folder/ "convert #it #name.png"
```

Note the `/` at the end of folder name is important.

```bash
$ map folder/ "mv #it #name_backup#ext"
```

```bash
$ map a b c "echo #ext"
#name token used but a was not found.
```
