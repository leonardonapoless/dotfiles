# macOS Neovim Configuration

A high-performance Neovim configuration optimized for macOS development.
Specializes in **C/C++, Swift, Java, Angular, and TypeScript**.

## Quick Start

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this config
git clone <your-repo> ~/.config/nvim

# Launch and let plugins install
nvim
```

Press `k` on the dashboard for full keymaps, or hit `<Space>` to explore.

---

## Philosophy

| Principle | Implementation |
|-----------|----------------|
| **Discoverable** | `<Space>` opens which-key, `k` shows all keymaps |
| **Consistent** | `[` = previous, `]` = next, `g` = go to |
| **macOS-native** | Warp terminal, Finder, clipboard integration |
| **Performant** | Lazy loading, no bloat, fast startup |

---

## Essential Keybindings

> **Leader key is `<Space>`**

### Navigation

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Window navigation |
| `H` / `L` | Start / end of line |
| `-` | Open parent directory (Oil) |
| `<leader>e` | File explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |

### Editing

| Key | Action |
|-----|--------|
| `jk` or `jj` | Escape to normal mode |
| `gcc` | Comment line |
| `gc` (visual) | Comment selection |
| `U` | Redo |
| `<` / `>` (visual) | Indent (keeps selection) |
| `J` / `K` (visual) | Move lines up/down |

### Buffers & Windows

| Key | Action |
|-----|--------|
| `<leader>-` | Horizontal split |
| `<leader>\|` | Vertical split |
| `<leader>q` | Close window |
| `<leader>bd` | Delete buffer |
| `<leader>bn/bp` | Next/prev buffer |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>cf` | Format buffer |
| `]d` / `[d` | Next/prev diagnostic |

### Debug

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dr` | Open REPL |

### Java Specific

| Key | Action |
|-----|--------|
| `<leader>jo` | Organize imports |
| `<leader>jv` | Extract variable |
| `<leader>jm` | Extract method |
| `<leader>jc` | Extract constant |

### Quality of Life

| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlight |
| `<leader>yp` | Copy file path |
| `<leader>yn` | Copy file name |
| `<leader>rr` | Remove trailing whitespace |
| `+` / `_` | Increment/decrement number |
| `]<Space>` / `[<Space>` | Add blank line below/above |
| `]q` / `[q` | Quickfix navigation |

### Terminal (Warp)

| Key | Action |
|-----|--------|
| `<leader>tew` | Open Warp at project |
| `<leader>ex` | Open Finder at project |
| `<Ctrl+Space>` | Exit terminal mode |

---

## Language Setup

### C/C++

- **LSP**: `clangd`
- **Debug**: `codelldb`
- Works with `.c` and `.cpp` files

### Swift

- **LSP**: `sourcekit-lsp` (requires Xcode CLI tools)
- **Debug**: `codelldb`
- Supports Package.swift and Xcode projects

### Java

- **LSP**: `jdtls`
- Works with Maven, Gradle, and plain Java
- `<leader>j*` for Java refactors

### TypeScript / Angular

- **LSP**: `ts_ls`, `angularls`
- Auto-configured for `.ts`, `.tsx`, `.html`

---

## Statusline

Shows:

- Mode
- Git branch + changes
- File path
- Macro recording indicator
- Diagnostics
- Active LSP clients
- File encoding + format
- Position

---

## Troubleshooting

### LSP not attaching

```vim
:LspInfo          " Check LSP status
:RestartLspServers  " Restart all LSP
:Mason            " Manage LSP servers
```

### Slow startup

```vim
:Lazy profile     " Check plugin load times
```

### Missing icons

Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal.

---

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lua/
│   ├── buffer_settings.lua
│   ├── remaps.lua        # Keybindings
│   ├── remap_tools.lua   # Keymap utilities
│   ├── checks.lua        # System checks
│   ├── lsp/
│   │   ├── lsp_config.lua
│   │   └── cmp.lua
│   └── plugin/
│       ├── java.lua      # nvim-jdtls
│       ├── dap.lua       # Debugging
│       ├── lualine.lua   # Statusline
│       └── ...
```

---

## Prefixes

| Prefix | Meaning |
|--------|---------|
| `<leader>f` | Find/Files |
| `<leader>g` | Git |
| `<leader>l` | LSP |
| `<leader>d` | Debug |
| `<leader>j` | Java |
| `<leader>t` | Tab/Terminal |
| `<leader>b` | Buffer |
| `<leader>s` | Spell/Search |
| `<leader>c` | Code/Comments |
| `<leader>y` | Yank |
| `<leader>u` | UI/Toggle |
| `g` | Go to... |
| `[` | Previous... |
| `]` | Next... |
| `z` | Fold/Scroll/Spell |

Press `<Space>` and wait to see all options via which-key!
