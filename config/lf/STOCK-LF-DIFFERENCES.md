# Differences from stock lf

This document describes how this configuration differs from stock lf, what the
custom hotkeys do, and which ranger behaviors could not be reproduced exactly.
It reflects the current [`lfrc`](lfrc), not lf's compiled-in defaults.

## The short version

The configuration deliberately clears lf's normal and visual keymaps with
`clearmaps`, then rebuilds them around the adjacent ranger configuration.
Command-line/readline bindings are retained and extended.

The most important changes for an existing lf user are:

| Stock lf habit | Behavior here |
| --- | --- |
| `y`, `d`, `p` | Use ranger-style `yy`, `dd`, and `pp`. Bare `y`, `d`, and `p` are prefixes. |
| `r` to rename | `r` prompts for a GUI program to open with. Rename with `a`, `cw`, `A`, `I`, or `F2`. |
| `e` to edit | Use `E` or `F4`. Lowercase `e` is an execution prefix such as `ee`. |
| `w` for a shell | `w` reports that lf has no ranger task view. Use `S` for an interactive shell. |
| `s*` sorting | Sorting uses ranger's `o*` family. Lowercase `s` opens a shell-command prompt. |
| `H`/`L` for viewport placement | `H`/`L` move backward/forward through directory history. |
| `;` for find-next | `;` opens lf's command line, like ranger's console. |
| `F` for find-back | `F` reports that lf has no frozen-files mode. |
| `u` to unselect | Use `uv`; in Visual mode, `u` still performs visual-unselect. |
| lf tabs | lf has no tabs. Former ranger tab keys display an explanatory message. |

The `:` command-line mapping survives `clearmaps` because lf preserves it for
safety. It is not redefined in `lfrc`.

## Startup and display behavior

| Area | This configuration | Stock lf difference |
| --- | --- | --- |
| Pane ratios | `1:3:4` | Uses ranger's three-column proportions. |
| Scroll offset | 8 lines | Stock is 0. |
| Mouse | Enabled | Stock is disabled. |
| File previews | Enabled with a custom previewer | Stock previews raw file content unless a previewer is configured. |
| Directory previews | Passed to the custom previewer | Stock does not pass directories to the previewer. |
| Image previews | Automatic `chafa` format: sixel on Linux, symbols on macOS/Alacritty | Stock has no configured image-producing previewer. |
| Preview cursor | Reverse-video | Stock uses an underline. |
| Hidden files | Hidden initially | Same broad default, but more patterns are treated as hidden. |
| Hidden patterns | Dotfiles, `*.pyc`, `*.pyo`, `*.bak`, `*.swp`, `lost+found`, `__cache__`, `__pycache__` | Stock normally only treats dotfiles as hidden. |
| Sorting | Natural, case-insensitive, directories first | Natural and directories-first match current defaults; the choices are explicit here. |
| Info column | Size plus Git/VCS status | Stock has no info column by default. |
| Selection scope | Current directory only | Stock commands can use selections from all directories. |
| Copy preservation | Mode and timestamps | Stock preserves mode only. |
| Refreshing | Filesystem watching plus a 2-second periodic check | Both are disabled by default. |
| Icons | Disabled explicitly | Same visible result as stock. |
| Shell commands | POSIX `sh`, `-eu`, newline `IFS` | Stricter failure handling and safe splitting of lf's file lists. |

### Preview behavior

The custom `previewer` handles:

- syntax-highlighted text using `highlight`, `bat`, or `pygmentize`;
- archive listings using `atool`, `bsdtar`, `tar`, `unrar`, or `7z`;
- PDF text and metadata;
- HTML, JSON, torrents, and OpenDocument files;
- image previews with `chafa`;
- audio/video metadata with `mediainfo`, `exiftool`, or `ffprobe`;
- two-level directory trees using `tree` or a GNU/BSD-compatible `find` fallback;
- a `file(1)` classification fallback.

`zi` disables only image rendering while leaving metadata previews available.
`zv` bypasses the enhanced preview pipeline and displays plain content.
`zp` or `zc` toggles the preview pane and changes the pane ratios at the same
time so the directory columns do not shift awkwardly.

Image output defaults to `auto`: sixel is retained on Linux, while macOS and
Alacritty use symbol rendering. To force a specific format, change:

```text
set user_image_format sixel
```

### File opening

Opening a directory enters it. Opening a regular file uses custom behavior:

1. HTML is sent to the configured graphical opener.
2. Text, XML, JSON, and shell scripts open in `$VISUAL`, then `$EDITOR`, then
   `vi`.
3. Other formats use `opener`, which prefers selected programs from the old
   `rifle.conf`:
   - HTML: `qutebrowser`, `chromium`, `firefox`;
   - PDF: `zathura`, `okular`, `mupdf`, `evince`;
   - images: `pqiv`, `sxiv`, `feh`, `display`;
   - video/audio: `mpv`, `vlc`;
   - `.exe`: `wine`;
   - `.mm`: `freeplane`.
4. The final fallback is macOS `open`, then `xdg-open`, then `gio open`.

## Key notation

- `<c-x>` means Ctrl+x.
- `<a-x>` means Alt+x.
- `<space>`, `<enter>`, `<backspace>`, and function keys use lf's special-key
  notation.
- A sequence such as `dd` means press the keys consecutively.
- Prefixes such as `g`, `o`, `z`, `d`, `y`, and `p` wait for another key.

## General, console, and execution keys

| Key | Behavior |
| --- | --- |
| `q`, `Q`, `ZZ`, `ZQ`, `F10` | Quit the current lf client. |
| `R`, `<c-r>` | Reload directory data. |
| `<c-l>` | Redraw. |
| `<c-c>`, normal `<esc>` | Redraw/no-op-style escape. |
| Visual `<esc>` | Discard Visual mode. |
| `i`, `F3` | Run the custom previewer through `$PAGER -R` as a full-screen file view. |
| `?`, `F1`, `g?` | Open lf help. |
| `W` | View lf's log; explains how to enable logging if lf was not started with `-log`. |
| `S` | Start `$SHELL`. |
| `;`, `cd` | Open the command line; `cd` prefills `:cd `. |
| `<c-p>` | Open the command line with the previous history entry. |
| `!` | Prompt for a shell-wait command. |
| `@`, `#` | Prompt for a shell-pipe command. |
| `s` | Prompt for a regular shell command. |
| `r` | Prompt for a GUI program and open `$fx` asynchronously with it. |
| `f` | Use lf's filename find mode. |
| `ee` | Execute the current file as a regular shell command. |
| `ew`, `ep` | Execute the current file and wait afterward. |
| `es` | Execute the current file asynchronously. |
| `E`, `F4` | Edit selected files in `$VISUAL`, `$EDITOR`, or `vi`. |
| `du` | Show apparent sizes one level deep. |
| `dU` | Show the same sizes sorted largest-first. |

`w`, `F`, `~`, and `)` intentionally show messages because lf has no task
view, frozen-files mode, alternate viewmode, or ranger `jump_non` equivalent.

## Navigation

| Key | Behavior |
| --- | --- |
| `j`, `k`, arrows | Move down/up. |
| `h`, left arrow, backspace | Go to the parent directory. |
| `l`, right arrow, enter | Enter a directory or open a file. |
| `gg`, Home | Go to the first item. |
| `G`, End | Go to the last item. |
| `J`, `<c-d>` | Move down half a page. |
| `K`, `<c-u>` | Move up half a page. |
| `<c-f>`, Page Down | Move down one page. |
| `<c-b>`, Page Up | Move up one page. |
| `H`, `[` | Previous directory in the jump list. |
| `L`, `]` | Next directory in the jump list. |
| `{` | Go to the parent, move up, then open that entry. |
| `}` | Go to the parent, move down, then open that entry. |

`{` and `}` approximate ranger's parent-column traversal. If the neighboring
parent entry is a file rather than a directory, lf may open it.

### Directory shortcuts

| Key | Destination/action |
| --- | --- |
| `gh` | Home directory |
| `ge` | `/etc` |
| `gu` | `/usr` |
| `gd` | `/dev` |
| `gD` | `~/sync/Dropbox` |
| `gl` | Current directory |
| `gL` | Follow the selected symbolic link |
| `go` | `/opt` |
| `gv` | `/var` |
| `gm`, `gi`, `gM` | `/Volumes` on macOS; `/run/media/$USER`, `/media/$USER`, or `/media` on Linux |
| `gs` | `/srv` |
| `gp` | `/tmp` |
| `g/` | Filesystem root |
| `gR` | `~/.config/lf` |
| `g?` | Help |
| `gy` | `~/sync/yandex-disk` |
| `gr` | `~/remote` |

Paths such as Dropbox, Yandex Disk, removable media, and `~/remote` are not
stock lf behavior and must exist locally to be useful.

## Selection, tags, and Visual mode

| Key | Behavior |
| --- | --- |
| `<space>` | Toggle selection and move down. |
| `v` | Invert selections in the current directory. |
| `uv` | Clear selections. |
| `V` | Enter Visual mode. |
| `uV` | Invert selections. |
| Visual `V` | Accept the visual range into the selection list. |
| Visual `u` | Remove the visual range from the selection list. |
| Visual `yy` | Accept the range and mark it for copying. |
| Visual `dd` | Accept the range and mark it for moving. |
| `t` | Toggle the default tag on the current file. |
| `ut` | Clear the current file's tag. |

Selections are configured with `selmode dir`, so filesystem commands only use
selections from the displayed directory. This differs from stock lf's
cross-directory selection behavior.

## Copy, move, paste, links, and deletion

| Key | Behavior |
| --- | --- |
| `yy`, `F5` | Put selected/current files in lf's copy buffer. |
| `dd`, `F6` | Put selected/current files in lf's move buffer. |
| `pp` | Paste using lf's built-in asynchronous operation. |
| `po` | Paste with `cp -Rf` or `mv -f`, overwriting collisions. |
| `uy`, `ud` | Clear the copy/cut buffer. |
| `ya`, `da` | Add current selections to the copy/move buffer. |
| `yr`, `dr` | Remove current selections from the copy/move buffer. |
| `yt`, `dt` | Toggle current selections in the copy/move buffer. |
| `pl` | Paste absolute symbolic links. |
| `pL` | Paste relative symbolic links. |
| `phl` | Paste hard links. |
| `dD`, `F8` | Permanently delete after an explicit `y`/`Y` confirmation. |
| `Dd` | Move files to the freedesktop trash using `trash-put`. |
| `Do` | Open `~/.Trash` on macOS or the XDG trash directory on Linux. |
| `DE` | Run `trash-empty`, or ask Finder to empty Trash on macOS. |
| `Dr` | Run `trash-restore`, or open Trash in Finder on macOS. |

Important: `po` is intentionally an overwrite operation and does not ask for
confirmation. `dD` ultimately uses `rm -rf`, but only after displaying the
targets and asking for confirmation.

These ranger paste variants have no accurate lf equivalent and display a
message instead:

- `pP`: append-on-collision paste;
- `pO`: append-and-overwrite paste;
- `pht`: hardlinked-subtree paste.

### Range copy/move

| Key | Range |
| --- | --- |
| `dgg`, `ygg` | Cursor through the first item |
| `dG`, `yG` | Cursor through the last item |
| `dj`, `yj` | Cursor plus the item below |
| `dk`, `yk` | Cursor plus the item above |

The `d*` forms cut the accepted range; the `y*` forms copy it.

## Rename, creation, permissions, and clipboard yanks

| Key | Behavior |
| --- | --- |
| `a`, `cw`, `F2` | Rename with the cursor before the extension. |
| `A` | Rename with the cursor at the end. |
| `I` | Rename with the cursor at the beginning. |
| `F7` | Prompt for a directory name and run `mkdir -p`. |
| Insert | Prompt for a filename and run `touch`. |
| `=` | Prompt for a chmod mode. |
| `+[ugoa][rwx]` | Add read/write/execute permission to user/group/other/all. |
| `-[ugoa][rwx]` | Remove read/write/execute permission from user/group/other/all. |
| `yp` | Copy full selected paths to the system clipboard. |
| `yd` | Copy the current directory. |
| `yn` | Copy selected basenames. |
| `y.` | Copy selected basenames without their final extension. |

Clipboard commands prefer `pbcopy` on macOS. On Linux they prefer the active
Wayland or X11 provider, then try the remaining providers. They fail with an
explanatory error when none works.

## Searching and filtering

| Key | Behavior |
| --- | --- |
| `/` | Search. |
| `n`, `N` | Next/previous search match. |
| `cs` | Sort by size and show size. |
| `ci` | Sort by extension. |
| `cc` | Sort/show ctime. |
| `cm` | Sort/show modification time. |
| `ca` | Sort/show access time. |
| `zf`, `zz`, `.n` | Enter lf's filter mode. |
| `.d` | Enable directory-only display. |
| `.f` | Disable directory-only display. |
| `.c`, `.p` | Clear the current filter with `setfilter`. |

lf has one active filter rather than ranger's composable filter stack.
Accordingly `.m`, `.l`, and `ct` display no-equivalent messages, and `..`
points out that the active filter is already shown in lf's prompt.

## Sorting

All lower-case sort choices also turn reverse sorting off; their upper-case
versions turn it on.

| Key | Sort |
| --- | --- |
| `or` | Toggle current sort direction. |
| `on` / `oN` | Natural, ascending/descending. |
| `ob` / `oB` | Name, ascending/descending. |
| `os` / `oS` | Size, ascending/descending. |
| `om` / `oM` | Modification time, ascending/descending. |
| `oc` / `oC` | Change time, ascending/descending. |
| `oa` / `oA` | Access time, ascending/descending. |
| `ot`, `oe` / `oT`, `oE` | Extension, ascending/descending. |
| `dc` | Calculate the selected directory's cumulative size. |

`oz` reports that lf has no random sort. Ranger's separate `type` and
`extension` sorts both map to lf's extension sort.

## Display modes and settings

| Key | Behavior |
| --- | --- |
| `Mf` | Hide the info column. |
| `Mi` | Show permissions, owner, group, size, time, and VCS info. |
| `Mm` | Show modification time and VCS info. |
| `Mp` | Show permissions and VCS info. |
| `Ms` | Show size, modification time, and VCS info. |
| `Mt` | Show only custom VCS info. |
| `zc`, `zp` | Toggle the preview column and adjust pane ratios. |
| `zd` | Toggle directories-first sorting. |
| `zh`, `<c-h>` | Toggle hidden files. |
| `zi` | Toggle image rendering and reload previews. |
| `zm` | Toggle mouse support. |
| `zP` | Toggle custom previews for directories. |
| `zs` | Toggle case-insensitive sorting. |
| `zv` | Toggle the enhanced preview script and reload. |

`zI` and `zu` show messages because lf has no ranger `flushinput` or automatic
cumulative-size settings. Use `dc` to calculate directory size on demand.

Git status is computed by the asynchronous `on-load` hook and displayed in the
custom info field. Set `user_vcs false` in `lfrc` to disable this extra work.

## Bookmarks

| Key | Behavior |
| --- | --- |
| `m` then a key | Save the current directory as that mark. |
| `'` then a key | Load a mark. |
| Backtick then a key | Also load a mark. |
| `um` then a key | Remove a mark. |
| `"` then a key | Also remove a mark. |

lf stores these in its own marks data file; ranger's bookmark file is not read
or migrated automatically.

## Function keys

| Key | Behavior |
| --- | --- |
| `F1` | Help |
| `F2` | Rename |
| `F3` | Full-screen custom preview |
| `F4` | Edit |
| `F5` | Copy |
| `F6` | Cut/move |
| `F7` | Create directory |
| `F8` | Permanently delete with confirmation |
| `F10` | Quit |

## Local integrations

| Key/command | Behavior/dependency |
| --- | --- |
| `gf` | Recursive `find` piped into `fzf`, then cd/select the result. |
| `,a` | `foobar2000 /add $fx` |
| `,p` | `mocp -cap $fx` |
| `Yp` | Publish with `yandex-disk` and copy the resulting link. |
| `Yu` | Unpublish with `yandex-disk`. |
| `Ys` | Show `yandex-disk status`. |
| `,u` | Run `sudo umount` on selected paths. |
| `,f` | Run `ssfs.sh`. |
| `,g` | Prefill the GUI opener with `glogg`. |
| `:cmus-play` | Send selected paths to `cmus-remote`. |
| `:cmus-queue` | Queue selected paths with `cmus-remote -q`. |
| `:cmus-lib` | Add selected paths with `cmus-remote -l`. |

These commands are not portable stock lf features. If a referenced executable
or directory is absent, the command either fails normally or, for core helpers
such as trash/fzf/clipboard, displays a tailored error.

## Command-line editing

The command line retains readline-style behavior explicitly:

| Key | Behavior |
| --- | --- |
| `<esc>` | Leave command mode. |
| `<c-c>` | Interrupt. |
| `<c-p>`, `<c-n>` | Previous/next history entry. |
| `<c-b>`, `<c-f>` | Move left/right. |
| `<c-a>`, `<c-e>` | Move to beginning/end. |
| `<c-d>`, `<c-h>` | Delete next/previous character. |
| `<c-w>` | Delete previous Unix word. |
| `<c-k>`, `<c-u>` | Delete to end/beginning. |
| `<c-y>` | Yank deleted command-line text. |
| `<a-b>`, `<a-f>` | Move backward/forward one word. |
| `<a-d>` | Delete the next word. |

## Keys retained only as compatibility notices

The following old ranger keys remain mapped, but they display a message rather
than silently doing something unrelated:

- tabs: `<c-n>`, `<c-w>`, Tab, Shift+Tab, Alt+Left/Right, `gt`, `gT`, `gn`,
  `gc`, `uq`, and Alt+1 through Alt+9;
- task/freeze/view: `w`, `F`, `~`;
- unsupported navigation/search: `)`, `ct`;
- unsupported paste variants: `pP`, `pO`, `pht`;
- unsupported filter-stack operations: `.m`, `.l`, `..`;
- unsupported settings/sorts: `zI`, `zu`, `oz`.

Use terminal or tmux windows/tabs instead of ranger tabs. lf's asynchronous
copy/move progress appears in the bottom ruler instead of ranger's task view.

## Supporting files added by this configuration

| File | Purpose |
| --- | --- |
| `lfrc` | Options, commands, and all mappings. |
| `previewer` | Ranger-style rich previews adapted to lf's preview protocol. |
| `opener` | Small replacement for the old `rifle.conf`. |
| `lf-buffer` | Ranger-style add/remove/toggle copy and cut buffers. |
| `lf-clipboard` | Portable system clipboard selection. |
| `lfcd.sh` | Optional shell function that keeps lf's final directory. |
