niced
=====

a daemon renicing new and existing processes

About
-----

`niced` is a daemon which monitors new (using the Linux netlink connector) and
existing processes and changes their 'niceness' according to configured rules.

It supports modification of processes' `nice`, `ionice` and
`oom_adj`/`oom_score_adj` properties.

This daemon was inspired by the `renice` project and the configuration file
should be backward compatible.

Dependencies
------------

- `python3`
- `forkstat`

Configuration
-------------

Configuration is stored in `/etc/niced.conf` file.

Modifying `niced` behavior:

- `@full_scan_interval = N` in seconds, default is `10`
- `@verbose = N`:
  `-2` silent, `-1` quiet, `0` default, `1` verbose, `2` very, `3` debug

### Configuration line:

`actions regular-expression`

#### Actions:

Actions can be split with a comma, or written together without spacing.

`action[parameter]`

- modifiers:
    - `I` - ignore case
    - `!` - forced
    - `R` - recursive: `1...`, None = `inf`
- nice:
    - `n` - nice: `-20...19`, None = `10`
- ionice:
    - `r` - realtime ionice: `0...7`, None = `4`
    - `b` - best-effort ionice: `0...7`, None = `4`
    - `i` - idle ionice: `0...7`, None = `4`
- oom:
    - `o` - oom_adj: `-17...15`, None = `0`
    - `O` - oom_score_adj: `-1000...1000`, None = `0`

#### Regular expression:

If your regular expression begins with `^` or `(`, it is matched literally. This
means you have to keep in mind a potential full path before the executable name
or the parameters after it.

Otherwise `niced` takes care of those for you by enclosing your rule with the
following regular expression syntax:

`(^|[^\\s]*/)` and `(\\s|$)`

### Examples:

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
n1RI screen
in10 ark
in10 tar
in10 unxz
in10 dpkg
in15 gcc
in15 g++
in15 cc1
in15 cc1plus
in15 dkms
in15 gp
```
