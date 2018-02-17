Dotfiles
========

This is a collection of my configuration files for a variety of tools.

It is meant to be used with [GNU Stow][], and provides scripts to set it up.

Usage
-----

Running `usesh/use` will download a version of [GNU Stow][] for use, if one is not already installed.

Use the executable `./use` instead of `./stow`:

```sh
usesh/use git vim zsh fish
```

`use` will store all `use`d directories, so afterwards synchronizing is done via:

```sh
usesh/use
```

Requirements
------------

- [GNU Stow][]

**OR**

- Perl 5
- `wget`
- `make`

[GNU Stow]: https://www.gnu.org/software/stow/
