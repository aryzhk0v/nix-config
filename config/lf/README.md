# Cross-platform ranger-to-lf configuration

This directory ports the adjacent `ranger/` setup to current
[lf](https://github.com/gokcehan/lf). It preserves ranger's key sequences where
lf has the same concept, including `dd`/`yy`/`pp`, `cw`/`a`/`A`/`I`, `o*`
sorting, `z*` settings, marks, trash, fzf, media, Yandex Disk, and clipboard
commands. The scripts support both Linux and macOS system utilities.

For a complete list of changed defaults, hotkeys, custom behavior, and
differences from stock lf, see
[`STOCK-LF-DIFFERENCES.md`](STOCK-LF-DIFFERENCES.md).

## Install

Copy or symlink this directory to lf's standard config location. Replace the
example source path with the location of this directory:

```sh
mkdir -p ~/.config
ln -s /path/to/lf ~/.config/lf
```

If `~/.config/lf` already exists, move it aside or merge it manually first.
The scripts `previewer`, `opener`, `lf-buffer`, and `lf-clipboard` must remain
executable.

To make the shell stay in the final directory after lf exits, source `lfcd.sh`
from the shell startup file and launch with `lfcd`:

```sh
. ~/.config/lf/lfcd.sh
```

## Optional tools

The config works without all of these, but enables features as they are found:

- previews: `chafa`, `highlight`, `bat`, `pygmentize`, `atool`/`bsdtar`,
  `poppler-utils`, `mediainfo`, `exiftool`
- integrations: `fzf`, `trash-cli`, `xsel`/`wl-copy`/`xclip`, `cmus`, `moc`,
  `yandex-disk`
- opening: `$VISUAL`/`$EDITOR`, then preferred viewers from the old
  `rifle.conf`, then macOS `open`, `xdg-open`, or `gio open`

Image previews use `auto` mode. It preserves sixel output on Linux and selects
symbol rendering on macOS and in Alacritty, which does not render sixel. You
can override the choice in `lfrc`:

```text
set user_image_format sixel
```

Directory previews use `tree` when it is installed and a portable `find`
fallback otherwise. The fallback works with both GNU find and macOS BSD find.

On macOS, opening files uses the system `open` command, clipboard yanks use
`pbcopy`, removable-volume shortcuts open `/Volumes`, and trash operations use
Finder when a dedicated trash CLI is not installed.

## Intentional differences

lf deliberately has no tabs, task view, frozen directory listing, filter
stack, or ranger linemodes. The old keys are retained and show a short message
where there is no honest equivalent. Use terminal/tmux tabs in place of ranger
tabs. Background copy/move progress is shown in lf's ruler.

`plugin_ipc.py` is unnecessary: lf has built-in server/remote commands.
`commands.py:fzf` is now `gf`, and the `ranger-cmus` plugin commands are
available as `:cmus-play`, `:cmus-queue`, and `:cmus-lib`.

The complete mapping is intentionally kept in `lfrc`, grouped under the same
headings as ranger's `rc.conf`, so future changes can be compared directly.
