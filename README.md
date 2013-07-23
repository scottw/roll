roll
====

Creates simple rolling backups for a file or directory.

## installation ##

Just put the file in your `$PATH` and `chmod 0755 roll`.

## options ##

  * `--version`: prints the current version and exits
  * `--debug`: tells you exactly what's going on while it's happening
  * `--separator`: defaults to '.'

## usage ##

    roll /var/log/foo.log 5

This will look for a file named `foo.log.5`; if it is found, `roll`
removes it. `roll` then counts backward, renaming files or directories
as it goes: `foo.log.4` becomes `foo.log.5`, `foo.log.3` becomes
`foo.log.4` and so on. When `foo.log.1` has been renamed, `roll` uses
`rsync` to create a backup of the current `foo.log` named `foo.log.1`.

       +-----------+
    +--> foo.log.5 +----> (rm)
    |  +-----------+
    |
    | (mv)
    |
    |  +-----------+
    +--+ foo.log.4 <--+
       +-----------+  |
                      |
                 (mv) |
                      |
       +-----------+  |
    +--> foo.log.3 +--+
    |  +-----------+
    |
    | (mv)
    |
    |  +-----------+
    +--+ foo.log.2 <--+
       +-----------+  |
                      |
                 (mv) |
                      |
       +-----------+  |
    +--> foo.log.1 +--+
    |  +-----------+
    |
    | (rsync)
    |
    |  +-----------+
    +--+  foo.log  |
       +-----------+

## works on lots of things ##

`roll` will happily archive symlinks, directory hierarchies, and
files. It may work on other kinds of things as well. Symlinks are
always treated as files (i.e., they are never followed).
