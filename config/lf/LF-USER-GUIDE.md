# LF User Guide

This guide documents the complete behavior of the supplied LF configuration and helper scripts:

- `lfrc`
- `previewer`
- `opener`
- `lf-buffer`
- `lf-clipboard`
- `lfcd.sh`

The configuration targets LF r42 and uses Ranger-style key sequences. It is shared between macOS and Linux; platform-specific behavior is selected at runtime.

## Key notation

- `Ctrl-R` means hold Control and press `R`.
- `Alt-F` means hold Alt/Option and press `F`.
- `F1` means the function key.
- `Space`, `Enter`, `Insert`, and `Backspace` name literal keys.
- A sequence such as `gh`, `yy`, or `dgg` is typed from left to right, without holding the keys together.
- `<key>` in an explanation means the next key you choose, such as a bookmark letter.
- Commands beginning with `:` are LF commands. Commands beginning with `$`, `%`, `!`, or `&` are shell-command modes.

Unless a table says otherwise, bindings apply in Normal mode. LF's `map` bindings are also available in Visual mode, while `nmap` and `vmap` are mode-specific.

## Quick start

| Task | Key |
| --- | --- |
| Move down/up | `j` / `k` |
| Open file or enter directory | `l`, `Right`, or `Enter` |
| Go to parent directory | `h`, `Left`, or `Backspace` |
| View the current preview in a pager | `i` or `F3` |
| Edit a file | `E` or `F4` |
| Toggle selection and move down | `Space` |
| Copy | `yy` |
| Cut/move | `dd` |
| Paste | `pp` |
| Move to Trash | `Dd` |
| Delete permanently | `dD` or `F8` |
| Search | `/` |
| Fuzzy-jump recursively | `gf` |
| Toggle hidden files | `zh` or `Ctrl-H` |
| Reload all directories and previews | `R` or `Ctrl-R` |
| Open a shell | `S` |
| Quit | `q`, `Q`, `ZZ`, `ZQ`, or `F10` |

## Core concepts

### Cursor, selection, Visual mode, tags, and file buffer

These are separate concepts:

- **Cursor:** the single highlighted entry under the cursor.
- **Selection list:** files selected with `Space`, Visual mode, or selection commands. Many actions operate on all selected files.
- **Visual selection:** a temporary contiguous range. Accepting it adds the range to the normal selection list.
- **Tags:** persistent single-character markers, independent of file selection.
- **Copy/cut buffer:** the files queued for a future paste operation.

Commands use LF's path variables:

- `$f`: the file under the cursor.
- `$fx`: all selected files, or `$f` when nothing is selected.
- `$PWD`: the displayed directory.

### Three-pane layout

The default ratios are `1:3:4`:

1. Parent directory.
2. Current directory.
3. File or directory preview.

Previews and directory previews start enabled. Image previews use Chafa symbols on macOS and in Alacritty, and sixel on compatible Linux terminals.

## Opening, viewing, editing, and shells

| Key | Action |
| --- | --- |
| `l`, `Right`, `Enter` | Enter a directory. For a file, run the configured `open` command. Text, XML, JSON, and shell scripts open in `$VISUAL`, then `$EDITOR`, then `vi`. HTML and non-text files use `opener`. |
| `i`, `F3` | Generate the same content used by the preview pane and show it in `less -R`. Press `q` to leave `less`. |
| `E`, `F4` | Open `$fx` directly in `$VISUAL`, `$EDITOR`, or `vi`. This can pass multiple selected paths to the editor. |
| `S` | Start `$SHELL` in the current directory. Exit the shell to return to LF. |
| `?`, `F1`, `g?` | Open LF help. |
| `W` | Open LF's log with `$PAGER`. LF must have been started with `-log PATH`; otherwise an explanatory message is shown. |
| `w` | Show an error explaining that LF has no task view; active operations are displayed in the ruler. |
| `F` | Show an error explaining that LF has no Ranger-style freeze-files mode. |
| `~` | Show an error explaining that LF only provides the Miller-style view. |

### Command and shell prompts

| Key | Prompt/action |
| --- | --- |
| `;` | Open LF's `:` command prompt. |
| `Ctrl-P` | Open the `:` prompt and immediately recall the previous command. |
| `!` | Open a shell-wait prompt. The command runs, then waits for a key so its output remains visible. |
| `@`, `#` | Open a shell-pipe `%` prompt. Output is displayed in LF's bottom status line while the UI remains active. |
| `s` | Open the normal `$` shell-command prompt. LF temporarily yields the UI while the command runs. |
| `r` | Prefill `:open-with-gui `. Enter a GUI program name and optional arguments; the selected paths are appended and the program runs asynchronously. This key does **not** rename files in this configuration. |
| `cd` | Prefill `:cd ` so you can type a destination directory. |

### Direct execution of the selected file

These mappings treat the current path as an executable command:

| Key | Behavior |
| --- | --- |
| `ee` | Run the current file as a regular shell command. |
| `ew` | Run the current file and wait for a key afterward. |
| `ep` | Same behavior as `ew`. |
| `es` | Run the current file asynchronously without attaching its output to the LF UI. |

The selected file must be executable and must have a valid shebang or binary format.

## Navigation

### Basic movement

| Key | Action |
| --- | --- |
| `j`, `Down` | Move down one entry. |
| `k`, `Up` | Move up one entry. |
| `h`, `Left`, `Backspace` | Go to the parent directory. |
| `l`, `Right`, `Enter` | Open the current item or enter the current directory. |
| `gg`, `Home` | Move to the first entry. A numeric count can select a specific line. |
| `G`, `End` | Move to the last entry. A numeric count can select a specific line. |
| `Ctrl-F`, `Page Down` | Move down one page. |
| `Ctrl-B`, `Page Up` | Move up one page. |
| `J`, `Ctrl-D` | Move down half a page. |
| `K`, `Ctrl-U` | Move up half a page. |

### Jump history and parent-column movement

| Key | Action |
| --- | --- |
| `H`, `[` | Go to the previous directory in LF's jumplist. |
| `L`, `]` | Go to the next directory in the jumplist. |
| `{` | Go to the parent, move one entry up there, then open that sibling directory. |
| `}` | Go to the parent, move one entry down there, then open that sibling directory. |
| `)` | Show an error because Ranger's `jump_non` has no LF equivalent. |

### Directory shortcuts

| Key | Destination/action |
| --- | --- |
| `gh` | Home directory, `~`. |
| `ge` | `/etc`. |
| `gu` | `/usr`. |
| `gd` | `/dev`. |
| `gD` | `~/sync/Dropbox`. |
| `gl` | Re-enter the current directory with `cd .`. |
| `gL` | Resolve the symlink under the cursor and select its target. Relative targets are resolved against the symlink's directory. |
| `go` | `/opt`. |
| `gv` | `/var`. |
| `gm`, `gi`, `gM` | Removable-media root: `/Volumes` on macOS; otherwise `/run/media/$USER`, `/media/$USER`, or `/media`, whichever applies. |
| `gs` | `/srv`. |
| `gp` | `/tmp`. |
| `g/` | Filesystem root, `/`. |
| `gR` | LF configuration directory, `~/.config/lf`. |
| `gy` | `~/sync/yandex-disk`. |
| `gr` | `~/remote`. |

### Fuzzy navigation

| Key | Action |
| --- | --- |
| `gf` | Recursively list entries beneath the current directory, choose one with `fzf`, then enter the selected directory or select the chosen file. Symlinks are followed by `find -L`. |

## Information columns

The `custom` field is populated with two-character Git status codes by the `on-load` hook when the current directory is inside a Git worktree.

| Key | Information shown beside entries |
| --- | --- |
| `Mf` | Hide the optional information column. |
| `Mi` | Permissions, user, group, size, modification time, and custom/Git status. |
| `Mm` | Modification time and custom/Git status. |
| `Mp` | Permissions and custom/Git status. |
| `Ms` | Size, modification time, and custom/Git status. |
| `Mt` | Only custom/Git status. |

## Tags, selections, and Visual mode

### Tags and ordinary selection

| Key | Action |
| --- | --- |
| `t` | Toggle the `*` tag on the current file. |
| `ut` | Clear the current file's tag using LF's `:tag; tag-toggle` sequence. |
| `Space` | Toggle selection of the current item, then move down. |
| `v` | Invert selection for every visible item in the current directory. |
| `uV` | Same as `v`: invert selection in the current directory. |
| `uv` | Clear the selection list across all directories. |

### Visual mode

| Key | Mode | Action |
| --- | --- | --- |
| `V` | Normal | Enter Visual mode with the current item as the anchor. Move to extend the contiguous range. |
| `V` | Visual | Accept the visual range, add it to the selection list, and return to Normal mode. |
| `u` | Visual | Remove the visual range from the selection list and return to Normal mode. |
| `Esc` | Visual | Discard the visual range without changing the selection list. |
| `yy` | Visual | Accept the visual range and place it in the copy buffer. |
| `dd` | Visual | Accept the visual range and place it in the cut/move buffer. |

### Range copy and cut from Normal mode

Each command starts Visual mode at the cursor, moves to the indicated endpoint, accepts the range, then copies or cuts it.

| Cut | Copy | Range |
| --- | --- | --- |
| `dgg` | `ygg` | Current entry through the first entry. |
| `dG` | `yG` | Current entry through the last entry. |
| `dj` | `yj` | Current entry and the next entry. |
| `dk` | `yk` | Current entry and the previous entry. |

## Copy, cut, paste, links, deletion, and Trash

### Copy and cut buffers

| Key | Action |
| --- | --- |
| `yy`, `F5` | Replace the buffer with `$fx` in copy mode. |
| `dd`, `F6` | Replace the buffer with `$fx` in cut/move mode. |
| `ya` | Add `$fx` to the copy buffer without discarding existing buffered files. |
| `yr` | Remove `$fx` from the copy buffer. |
| `yt` | Toggle `$fx` in the copy buffer. |
| `da` | Add `$fx` to the cut/move buffer. |
| `dr` | Remove `$fx` from the cut/move buffer. |
| `dt` | Toggle `$fx` in the cut/move buffer. |
| `uy`, `ud` | Clear the copy/cut buffer. Both keys run the same `clear` command. |

The add/remove/toggle commands deduplicate paths, update LF's shared selection file, clear the active selection, and synchronize the server.

### Paste and link creation

| Key | Action |
| --- | --- |
| `pp` | Use LF's built-in paste to copy or move the buffer into the current directory. |
| `po` | Force overwrite: copied paths use `cp -Rf`; moved paths use `mv -f`. A successful move clears the buffer. Existing destinations can be overwritten. |
| `pl` | Create absolute symbolic links in the current directory to all buffered paths. |
| `pL` | Create relative symbolic links in the current directory to all buffered paths. |
| `phl` | Create hard links in the current directory. Hard links generally require regular files on the same filesystem. |
| `pP` | Show an error: append-on-collision paste is unavailable. |
| `pO` | Show an error: append-and-overwrite paste is unavailable. |
| `pht` | Show an error: hardlinked subtree paste is unavailable. |

### Deletion and Trash

| Key | Action |
| --- | --- |
| `Dd` | Move `$fx` to Trash. On macOS, use the `trash` command when available, otherwise ask Finder through AppleScript. On Linux, prefer `trash-put`, then `trash`. |
| `Do` | Enter `~/.Trash` on macOS or the XDG Trash files directory on Linux. |
| `Dr` | On macOS, open `~/.Trash` in Finder for manual restoration. On Linux, run `trash-restore` when installed. |
| `DE` | Empty Trash. On macOS, ask Finder to empty it; on Linux, run `trash-empty`. This is destructive. |
| `dD`, `F8` | Permanently delete `$fx` with `rm -rf` after a `[y/N]` confirmation. This bypasses Trash. |

## Clipboard shortcuts

Clipboard output prefers `pbcopy` on macOS. Linux tries `wl-copy`, `xsel`, and `xclip` according to the active display protocol, with fallbacks.

| Key | Text copied to the system clipboard |
| --- | --- |
| `yp` | Full paths of `$fx`, one per line. |
| `yd` | Current directory path. |
| `yn` | Basenames of `$fx`, one per line. |
| `y.` | Basenames of `$fx` with the final filename extension removed. |

## Rename, create, and permissions

### Rename and create

| Key | Action |
| --- | --- |
| `a`, `cw`, `F2` | Start LF's rename prompt for the current file. |
| `A` | Start rename with the cursor at the end of the name. |
| `I` | Start rename with the cursor at the beginning of the name. |
| `F7` | Prefill `:mkdir ` to create one or more directories. |
| `Insert` | Prefill `:touch ` to create a file. |

### Arbitrary chmod

| Key | Action |
| --- | --- |
| `=` | Prefill `:chmod-mode `. Type a mode expression; it is applied to `$fx`. |

### Generated chmod keys

The pattern is `<operation><scope><permission>`:

- Operation: `+` adds permission; `-` removes permission.
- Scope: `u` owner, `g` group, `o` others, `a` everyone.
- Permission: `r` read, `w` write, `x` execute/search.

Every configured combination is listed below.

| Scope | Add read/write/execute | Remove read/write/execute |
| --- | --- | --- |
| Owner | `+ur`, `+uw`, `+ux` | `-ur`, `-uw`, `-ux` |
| Group | `+gr`, `+gw`, `+gx` | `-gr`, `-gw`, `-gx` |
| Others | `+or`, `+ow`, `+ox` | `-or`, `-ow`, `-ox` |
| Everyone | `+ar`, `+aw`, `+ax` | `-ar`, `-aw`, `-ax` |

## Search, find, and filters

### Search and find

| Key | Action |
| --- | --- |
| `f` | Start LF's filename `find` prompt and jump to a matching entry. |
| `/` | Start pattern search. |
| `n` | Jump to the next search match. |
| `N` | Jump to the previous search match. |
| `ct` | Show an error because Ranger's tag-ordered search has no LF equivalent. |

### Search-related sort shortcuts

These keys change sorting and the visible information field, but do not force ascending or descending order; the current `reverse` value remains active.

| Key | Sort and information |
| --- | --- |
| `cs` | Sort by size; show size and custom/Git status. |
| `ci` | Sort by extension; show custom/Git status. |
| `cc` | Sort by inode/status-change time; show that time and custom/Git status. |
| `cm` | Sort by modification time; show that time and custom/Git status. |
| `ca` | Sort by access time; show that time and custom/Git status. |

### Filtering

| Key | Action |
| --- | --- |
| `zf`, `zz`, `.n` | Open LF's interactive filename filter prompt. Only matching entries remain visible. |
| `.c`, `.p` | Run `setfilter` without an argument, clearing the active filter. |
| `.d` | Enable directory-only view. |
| `.f` | Disable directory-only view and show files again. |
| `.m` | Show an error: LF has one filter rather than Ranger's MIME filter stack. |
| `.l` | Show an error: no symlink-only filter is configured. |
| `..` | Show an explanation that LF already displays the active filter in its prompt. |

## Sorting and directory sizes

### Sort direction

| Key | Action |
| --- | --- |
| `or` | Toggle the current sort direction. |
| `oz` | Show an error because LF has no random sort mode. |

### Ascending and reverse sort presets

Lowercase final letters select `reverse false`; uppercase final letters select `reverse true`.

| Sort type | Normal direction | Reverse direction | Information shown |
| --- | --- | --- | --- |
| Size | `os` | `oS` | Size and custom/Git status. |
| Lexical name | `ob` | `oB` | Custom/Git status. |
| Natural name | `on` | `oN` | Custom/Git status. Natural ordering places `file2` before `file10`. |
| Modification time | `om` | `oM` | Modification time and custom/Git status. |
| Inode/status-change time | `oc` | `oC` | Change time and custom/Git status. |
| Access time | `oa` | `oA` | Access time and custom/Git status. |
| Extension | `ot`, `oe` | `oT`, `oE` | Custom/Git status. |

Directories remain grouped first because `dirfirst` starts enabled.

### Directory-size commands

| Key | Action |
| --- | --- |
| `dc` | Ask LF to calculate the total size of each selected directory. Results appear when the info column includes `size`. |
| `du` | Run `du` for the current entry to one level of depth and display human-readable results. Uses GNU or BSD/macOS syntax automatically. |
| `dU` | Same as `du`, then sort the output from largest to smallest. |

## Preview, visibility, and behavior toggles

| Key | Action |
| --- | --- |
| `zc`, `zp` | Toggle the preview pane. Disabling it changes the layout to `1:4`; enabling it restores `1:3:4`. |
| `zi` | Toggle image rendering in the previewer and reload previews. When disabled, image metadata or file classification is shown instead. |
| `zv` | Toggle the custom preview script and reload. When disabled, the previewer displays raw text or basic file information. |
| `zP` | Toggle directory previews. |
| `zd` | Toggle whether directories are grouped before files. |
| `zh`, `Ctrl-H` | Toggle hidden-file visibility. Hidden patterns include dotfiles, Python bytecode, backups, swap files, `lost+found`, and Python cache directories. |
| `zm` | Toggle mouse support. |
| `zs` | Toggle case-insensitive sorting. Requires LF r42 or later. |
| `zI` | Show an error because LF does not expose Ranger's `flushinput` option. |
| `zu` | Explain that LF calculates directory sizes on demand with `dc`. |

`period` is `0`, so LF does not poll. `watch` is enabled, so LF r42 uses filesystem notifications to refresh changed entries.

## Bookmarks

Bookmark operations are modal: press the command, then a single key that names the bookmark.

| Key | Action |
| --- | --- |
| `m` | Start bookmark saving; press `<key>` to save the current directory under that key. |
| Apostrophe or backtick | Start bookmark loading; press `<key>` to load that bookmark. |
| `um`, `"` | Start bookmark removal; press `<key>` to remove that bookmark. |

The special bookmark `'` tracks the previous location. Therefore `''` returns to the previous bookmark/CD/select location.

## Function and cursor key summary

| Key | Action |
| --- | --- |
| `F1` | Help. |
| `F2` | Rename. |
| `F3` | Display preview in `less -R`. |
| `F4` | Edit. |
| `F5` | Copy to buffer. |
| `F6` | Cut/move to buffer. |
| `F7` | Prefill directory creation. |
| `F8` | Permanently delete after confirmation. |
| `F10` | Quit. |
| `Up`, `Down`, `Left`, `Right` | Move up, move down, go to parent, or open. |
| `Home`, `End` | First or last entry. |
| `Page Up`, `Page Down` | Move one page. |
| `Enter` | Open. |
| `Insert` | Prefill file creation. |
| `Backspace` | Go to parent directory. |

## Session control and redraw

| Key | Action |
| --- | --- |
| `q`, `Q`, `ZZ`, `ZQ`, `F10` | Quit LF. When started through `lfcd`, the shell changes to LF's final directory. |
| `R`, `Ctrl-R` | Flush LF's cache and reload every file and directory. Use this when a listing or preview appears stale. |
| `Ctrl-L` | Synchronize and redraw the terminal. |
| `Ctrl-C`, `Esc` | In Normal mode, redraw rather than quit. |

## Custom local integrations

These commands depend on external tools, files, or personal directories.

| Key | Action/dependency |
| --- | --- |
| `,a` | Asynchronously run `foobar2000 /add $fx`. Requires a `foobar2000` command in `PATH`. |
| `,p` | Asynchronously run `mocp -cap $fx`, combining MOC's clear, append, and play options. Requires `mocp`. |
| `,u` | Unmount the current path: `diskutil unmount` on macOS, otherwise `sudo umount`. |
| `,f` | Run `ssfs.sh` as a regular shell command. The script must be in `PATH`. |
| `,g` | Prefill `:open-with-gui glogg `. Add optional arguments and execute to open `$fx` in `glogg`. |
| `Yp` | Publish the current file with `yandex-disk publish` and copy the resulting URL to the system clipboard. |
| `Yu` | Unpublish the current file with `yandex-disk unpublish`. |
| `Ys` | Run `yandex-disk status` and wait so the output remains visible. |

The following custom commands exist but have no hotkeys:

- `:cmus-play` runs `cmus-remote $fx` asynchronously.
- `:cmus-queue` runs `cmus-remote -q $fx` asynchronously.
- `:cmus-lib` runs `cmus-remote -l $fx` asynchronously.

## Deliberately unavailable Ranger features

These keys remain bound so that a familiar Ranger key produces an explanation instead of silently doing something else.

### Tabs

LF does not implement tabs. Use tmux or terminal tabs instead.

| Keys | Result |
| --- | --- |
| `Ctrl-N`, `Ctrl-W`, `Tab`, `Shift-Tab` | Show the no-tabs explanation. |
| `Alt-Right`, `Alt-Left` | Show the no-tabs explanation. |
| `gt`, `gT`, `gn`, `gc` | Show the no-tabs explanation. |
| `Alt-1`, `Alt-2`, `Alt-3`, `Alt-4`, `Alt-5`, `Alt-6`, `Alt-7`, `Alt-8`, `Alt-9` | Show the no-tabs explanation. |
| `uq` | Explain that LF has no closed-tab restore. |

### Other unavailable operations

| Key | Explanation shown |
| --- | --- |
| `F` | No freeze-files mode. |
| `~` | Only the Miller-style view is available. |
| `w` | No task view; operations appear in the ruler. |
| `)` | No `jump_non` equivalent. |
| `ct` | No tag-ordered search. |
| `oz` | No random sorting. |
| `pP` | No append-on-collision paste. |
| `pO` | No append-and-overwrite paste. |
| `pht` | No hardlinked-subtree paste. |
| `zI` | No exposed `flushinput` option. |
| `zu` | Directory size is calculated with `dc`. |
| `.m` | No MIME filter stack. |
| `.l` | No symlink-only filter. |
| `..` | The filter is already visible in the prompt. |

## Command-line editing

These bindings apply while entering an LF command, search, filter, rename, or shell command.

| Key | Action |
| --- | --- |
| `Esc` | Cancel the prompt and return to Normal mode. |
| `Ctrl-C` | Interrupt an active shell-pipe command and return to Normal mode. |
| `Ctrl-P` | Previous history entry. |
| `Ctrl-N` | Next history entry. |
| `Ctrl-B` | Move left one character. |
| `Ctrl-F` | Move right one character. |
| `Ctrl-A` | Move to the beginning of the line. |
| `Ctrl-E` | Move to the end of the line. |
| `Ctrl-D` | Delete the character under the cursor. |
| `Ctrl-H` | Delete the character before the cursor. |
| `Ctrl-W` | Delete the previous whitespace-delimited Unix word. |
| `Ctrl-K` | Delete from the cursor to the end of the line. |
| `Ctrl-U` | Delete from the cursor to the beginning of the line. |
| `Ctrl-Y` | Yank/paste text previously deleted from the command line. |
| `Alt-B` | Move backward one word. |
| `Alt-F` | Move forward one word. |
| `Alt-D` | Delete the next word. |

LF's retained command-line defaults also provide `Enter` to execute, `Tab` to complete, arrow-key history/navigation, and `Backspace` to delete backward.

## Preview behavior

The preview pane and the `i`/`F3` viewer use `previewer`.

| Content | Preview behavior |
| --- | --- |
| Directory | `tree -a -C -L 2`; if `tree` is unavailable, portable `find` output to two levels, capped at 400 entries. |
| Text, XML, JSON, shell | Syntax-highlight with `highlight`, then `bat`, then `pygmentize`; fall back to the first 500 lines. Files larger than 262,143 bytes skip highlighting. |
| Image | Chafa with animation disabled. Use symbols on macOS/Alacritty and sixel on compatible Linux terminals; fall back to `exiftool` or ImageMagick `identify`. |
| Archive | List with `atool`, `bsdtar`, `tar`, `unrar`, or `7zz`/`7z`, depending on format. |
| PDF | Extract up to ten pages with `pdftotext` or `mutool`, then fall back to metadata. |
| HTML | Dump readable text with `w3m`, `lynx`, or `elinks`. |
| JSON | Pretty-print with `jq`, then Python's JSON tool. |
| ODF document | Convert with `odt2txt`. |
| Torrent | Show metadata with `transmission-show`. |
| Audio/video | Show metadata with `mediainfo`, `exiftool`, or `ffprobe`. |
| Unknown | Show `file` classification. |

`zi` changes whether image rendering is attempted. `zv` changes whether the specialized preview handlers run.

## Graphical opener behavior

Opening a non-text file uses the first suitable handler below:

1. `.exe`: Wine, when installed.
2. `.mm`: Freeplane, when installed.
3. HTML: `qutebrowser`, `chromium`, or `firefox`.
4. PDF: `zathura`, `okular`, `mupdf`, or `evince`.
5. Images: `pqiv`, `sxiv`, `feh`, or ImageMagick `display`.
6. Audio/video: `mpv` or `vlc`.
7. macOS fallback: `open`, using Launch Services and the default application.
8. Linux fallback: `xdg-open`, then `gio open`.

The first available program wins. This means a specifically installed handler such as `mpv` takes precedence over the desktop default.

## Using `lfcd`

The supplied `lfcd.sh` defines a shell function that starts LF and changes the parent shell to LF's final directory when LF exits.

Source it from the interactive shell, as the Home Manager configuration does, then run:

```sh
lfcd
```

Use plain `lf` when you do not want the shell's directory to change afterward.

## Runtime dependencies

Only LF itself is essential. Features degrade gracefully when optional tools are missing.

| Feature | Tools |
| --- | --- |
| Basic previews | `file`, `less`, `tree` |
| Text highlighting | `highlight`, `bat`, or `pygmentize` |
| Images | `chafa`; optionally `exiftool` or ImageMagick |
| Fuzzy jump | `fzf`, `find`, `realpath` when available |
| macOS clipboard | `pbcopy` |
| Linux clipboard | `wl-copy`, `xsel`, or `xclip` |
| macOS Trash | `trash` or Finder/AppleScript |
| Linux Trash | `trash-put`, `trash`, `trash-empty`, `trash-restore` |
| Archives | `atool`, `bsdtar`, `tar`, `unrar`, `7zz`, or `7z` |
| PDF | `pdftotext`, `mutool`, or `exiftool` |
| Media metadata | `mediainfo`, `exiftool`, or `ffprobe` |
| HTML text | `w3m`, `lynx`, or `elinks` |
| Git status column | `git` |

## Troubleshooting

### `unknown option: sortignorecase`

The configuration requires LF r42 or later:

```sh
lf -version
```

Expected output is `r42` or newer.

### `running shell: exit status 127` after pressing `i`

The `display-file` command requires `less`:

```sh
command -v less
```

Install `less` or ensure it is in `PATH`.

### A directory or preview looks stale

Press `R` or `Ctrl-R` to flush LF's cache and reload. LF r42's `watch` option normally refreshes external filesystem changes automatically.

### A custom integration reports command not found

Keys such as `,a`, `,p`, `,f`, `Yp`, `Yu`, `Ys`, and `,g` rely on personal or optional external programs. Install the named command or remove the unused mapping.

### Inspect active mappings from inside LF

Use:

```text
:maps
:nmaps
:vmaps
:cmaps
:cmds
```

These show the mappings and custom commands loaded by the running LF instance.
