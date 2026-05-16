# Neovim Keybindings Reference

> Custom keybindings for this macOS config. **Leader key = Spacebar**

---

## The Leader Key

The **leader key** is `Space`. It's your shortcut prefix.

- `Space` then `w` = Save file
- `Space` then `ff` = Find files

**Press `Space` and wait** → popup shows ALL shortcuts!

---

## Notation

| Notation | Key |
|----------|-----|
| `Space` | Spacebar (leader) |
| `Ctrl+x` | Control + x |
| `Opt+x` | Option (⌥) + x |

---

## Files & Navigation

| Keys | Action |
|------|--------|
| `Space ff` | Find files (fuzzy search) |
| `Space fl` | Live grep (search text in files) |
| `Space fb` | Find open buffers |
| `Space fm` | Find marks |
| `Space fr` | Find registers |
| `Space fh` | Fuzzy find in current buffer |
| `Space pv` | Open virtual file tree (Netrw) |
| `-` | Open file tree (Oil) |
| `Space vp` | Open file tree (Oil) |
| `Space ex` | Open Finder at project |
| `Space hex` | Open Finder at current file |

### Advanced Navigation (Oil + Telescope)

| Keys | Action |
|------|--------|
| `Space pg` | Open Oil at path from clipboard |
| `Space pwc` | Copy current folder path to clipboard |
| `Space =` | Go to folder (Telescope -> Oil) |
| `Space -` | Go to file's folder (Telescope -> Oil) |

---

## Save & Quit

| Keys | Action |
|------|--------|
| `Space w` | Save file |
| `Space W` | Save all files |
| `Space bd` | Close buffer |
| `:qa!` | Quit all (no save) |
| `:QA` | Quit all |

---

## Harpoon (Quick Files)

| Keys | Action |
|------|--------|
| `Space ha` | Add file to harpoon |
| `Space hs` | Open harpoon menu |
| `Space hn` | Next harpoon file |
| `Space hp` | Previous harpoon file |
| `Ctrl+1-9` | Jump to harpoon slot |

---

## Tabs

| Keys | Action |
|------|--------|
| `Space 1-9` | Go to tab 1-9 |
| `Space tn` | New tab |
| `Space tc` | Close tab |
| `Space →` | Next tab |
| `Space ←` | Previous tab |

---

## Windows

| Keys | Action |
|------|--------|
| `Ctrl+w v` / `Space \|` | Vertical split |
| `Ctrl+w s` / `Space -` | Horizontal split (Note: `Space -` also mapped to Telescope->Oil in Oil config, checking priority) |
| `Ctrl+w h/j/k/l` | Navigate windows |
| `Ctrl+w q` / `Space q` | Close window |
| `Opt+h/j/k/l` | Navigate windows (alt) |
| `Ctrl+h/j/k/l` | Fast window navigation |

---

## Clipboard

| Keys | Action |
|------|--------|
| `Space y` | Yank to system clipboard |
| `Space p` | Paste from system clipboard |
| `Space yy` | Yank line to clipboard |
| `Space Y` | Yank to end of line to clipboard |
| `Space yp` | Copy file path |
| `Space yn` | Copy file name |
| `Y` (visual) | Yank to clipboard |
| `P` | Paste from clipboard |
| `Ctrl+v` (insert) | Paste in insert mode |

---

## LSP (Code Intelligence)

| Keys | Action |
|------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `Ctrl+k` (insert) | Signature help |

### LSP Actions

| Keys | Action |
|------|--------|
| `Space ca` | Code actions |
| `Space rn` | Rename symbol |
| `Space cf` | Format buffer |
| `Space lh` | Toggle inlay hints |
| `Space li` | LSP info |

### Diagnostics

| Keys       | Action                       |
|------------|------------------------------|
| `[d`       | Previous diagnostic          |
| `]d`       | Next diagnostic              |
| `Space ld` | Show diagnostic              |
| `Space le` | Buffer diagnostics (Trouble) |
| `Space lE` | All diagnostics (Trouble)    |

---

## Git & GitHub Integration

> [Read the Git Workflow Guide](./GIT_WORKFLOW.md)

| Keys       | Action                          |
|------------|---------------------------------|
| `Space gg` | **Neogit** (Status/Dashboard)   |
| `Space gd` | **Diffview** (Open Diff)        |
| `Space gh` | **Diffview** (File History)     |
| `Space gb` | **Telescope** (Switch Branch)   |
| `Space gc` | **Telescope** (Checkout Commit) |
| `Space gs` | **Telescope** (Git Status)      |
| `Space gi` | **GitHub** (List Issues)        |
| `Space gp` | **GitHub** (List PRs)           |
| `Space gr` | **GitHub** (Search Repo)        |
| `Space g`  | *See popup for more*            |

---

## Debugging (DAP)

| Keys       | Action                   |
|------------|--------------------------|
| `Space dc` | Start/Continue           |
| `Space dn` | Step **n**ext (over)     |
| `Space di` | Step **i**nto            |
| `Space do` | Step **o**ut             |
| `Space db` | Toggle **b**reakpoint    |
| `Space dB` | Conditional breakpoint   |
| `Space du` | Toggle debug **U**I      |
| `Space dr` | Open **R**EPL            |
| `Space ds` | **S**top debugging       |
| `Space dp` | **P**ause                |

*F5/F10/F11/F12 also work (require fn key on MacBook)*

---

## Completion (Just Start Typing!)

Completions appear **automatically** as you type.

| Keys | Action |
|------|--------|
| `Tab` | Select next / expand snippet |
| `Shift+Tab` | Select previous |
| `Enter` | Confirm selection |
| `Escape` | Close menu |
| `↑` `↓` | Navigate (arrow keys work too) |
| `Ctrl+Space` | Force show completions |
| `Ctrl+d/u` | Scroll documentation |

*Ghost text shows preview of completion - just keep typing or press Tab to accept*

---

## Search

| Keys | Action |
|------|--------|
| `*` | Search word under cursor (no jump) |
| `Space /` | Search & replace last search |
| `Space Space` | Clear highlight |
| `Space rr` | Remove trailing spaces |
| `Space <CR>` | Show notification history (Snacks) |

---

## Editing Shortcuts

| Keys | Action |
|------|--------|
| `J` (visual) | Move lines down |
| `K` (visual) | Move lines up |
| `ga` | Select all |
| `Ctrl+d` | Half page down (centered) |
| `Ctrl+u` | Half page up (centered) |
| `Space bi` | Block indent |
| `Space cc` | Add comment prefix |
| `Space cr` | Remove comment prefix |
| `Space x` | Surround selection |

---

## Spell Check

| Keys | Action |
|------|--------|
| `Space ss` | Toggle spell check |
| `Space se` | English spelling |
| `Space sp` | Portuguese spelling |
| `z;` | Next error |
| `z,` | Previous error |
| `z Space` | Suggestions |

---

## Terminal

| Keys | Action |
|------|--------|
| `Space ter` | Open terminal split |
| `Space tew` | Open Warp at project |
| `Space htew` | Open Warp at file |
| `Space new` | Open new Neovim instance in Warp |
| `Ctrl+Space` | Exit terminal mode |

---

## Misc

| Keys | Action |
|------|--------|
| `Backspace` | Play macro (@) |
| `Space mk` | Save session |
| `Space rnu` | Toggle relative numbers |
| `Space lua` | Source current lua file |
