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

Configuration is stored in `/etc/nicedrc` file.

Modifying `niced` behavior:

- `@full_scan_interval = N` in seconds, default is 10
- `@verbose = N`: -1 silent, 0 default, 1 verbose

### Configuration line:

`actions regular-expression`

#### Actions:

- modifiers:
    - `!` forced
    - `R` recursive          None =  0,     1...
- nice:
    - `n` nice               None = 10,   -20...19
- ionice:
    - `r` realtime ionice    None =  4,     0...7
    - `b` best-effort ionice None =  4,     0...7
    - `i` idle ionice        None =  4,     0...7
- oom:
    - `o` oom_adj            None =  0,   -17...15
    - `O` oom_score_adj      None =  0, -1000...1000

#### Regular expression:

If your regular expression begins with `^` or `(`, it is matched literally. This
means you have to keep in mind a potential full path before the executable name
or the parameters after it.

Otherwise `niced` takes care of those for you by enclosing your rule with the
following regular expression syntax:

`(^|[^\\s]*/)(` and `)(\\s|$)`
