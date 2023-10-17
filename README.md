niced
=====

<!--
    Copyright (C) 2023 Piotr Henryk Dabrowski <phd@phd.re>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
-->

a daemon renicing new and existing processes

Description
-----------

`niced` is a daemon which monitors new (using the Linux netlink connector) and
existing processes and changes their 'niceness' according to configured rules.

It supports modification of processes' `nice`, `ionice` and
`oom_adj`/`oom_score_adj` properties.

This daemon was inspired by the `renice` project and the configuration file
should be backward compatible.

Daemon
------

`systemd` service is provided:

    $ sudo systemctl enable niced.service
    $ sudo systemctl start niced.service

Synopsis
--------

`niced [--config-file PATH] [-h|--help]`

`--config-file`<br>
use given configuration file instead of `/etc/niced.conf`

Configuration
-------------

Configuration is stored in the `/etc/niced.conf` file.

Modifying `niced` behavior:

- `@full_scan_interval = N`<br>
  in seconds, default is `10`
- `@verbose = N`<br>
  `-2` silent, `-1` quiet, `0` default, `1` yes, `2` very, `3` debug

Lines beginning with `#` are comments.

### Configuration rules

Syntax:<br>
`actions pattern`

Actions can be separated with a comma, or written together without separators.

#### Actions

Syntax:<br>
`action[parameter]`

Actions and parameters:

- modifiers:
    - `I` - case-insensitive pattern
    - `F` - forced rule, reapplied every full scan
    - `R` - recursive: `1...`, default is `inf`
- nice:
    - `n` - nice: `-20...19`, default is `10`
- ionice:
    - `r` - realtime ionice: `0...7`, default is `4`
    - `b` - best-effort ionice: `0...7`, default is `4`
    - `i` - idle ionice
- oom:
    - `o` - oom_adj: `-17...15`, default is `0`
    - `O` - oom_score_adj: `-1000...1000`, default is `0`

#### Patterns

Patterns are regular expressions, case-sensitive by default.

The entire command including parameters is matched.

If your pattern begins with `^` or `(`, it is matched literally. This means you
have to keep in mind a potential full path before the executable name or the
parameters after it.

Otherwise `niced` takes care of those for you by enclosing your pattern with the
following regular expression syntax:

`([^\s]*/)?` and `(\s.*)?`

### Examples

`/etc/niced.conf`:

```
@full_scan_interval = 10
@verbose = 3
n-15 Xorg
n-15 kwin_x11
n-15 pulseaudio
n-10 barrier
n-10 mpv
n0R1 plasmashell
n-5  plasmashell
n0R1 krunner
n-5  krunner
n0   konsole
n1RI SCREEN
in10 ark
in10 tar
in10 unxz
in10 dpkg
in10 mandb
in15 gcc
in15 g++
in15 cc1
in15 cc1plus
in15 dkms
in15 gp
```

Files
-----

`/etc/niced.conf`

Dependencies
------------

- `python3`
- `forkstat`

See also
--------

`nice(1)`, `ionice(1)`, `proc(5)`, `forkstat(8)`

Bugs
----

Report bugs or ideas at https://github.com/phd/niced/issues

Author
------

Copyright (C) 2023 Piotr Henryk Dabrowski &lt;phd@phd.re&gt;
