# Neovim Configuration

> **macOS-optimized IDE experience** with full language support for Swift, C/C++, Odin, TypeScript, React, Angular, JavaScript, HTML, CSS, and Java.

## ✨ Features

- **Gruvbox Material** dark colorscheme
- **Native LSP** with intelligent code completion
- **Debugging (DAP)** for C/C++, Swift, and JavaScript
- **macOS keybindings** optimized for MacBook keyboards & Warp terminal
- **Which-Key** for keybinding discovery
- **Harpoon** for quick file switching
- **Telescope** for fuzzy finding

## 📖 Documentation

- [**KEYBINDINGS.md**](doc/KEYBINDINGS.md) - Complete keybinding reference
- [**LANGUAGES.md**](doc/LANGUAGES.md) - Language setup guide

---

## 🚀 Quick Start

### macOS Installation

```bash
# Clone the repo
git clone <your-repo-url> ~/.config/nvim

# Open Neovim and sync plugins
nvim
# Then run: :Lazy sync
```

### Dependencies

Install with Homebrew:

```bash
brew install neovim node npm ripgrep fd python
brew install --cask font-jetbrains-mono-nerd-font
```

For Swift support:
```bash
xcode-select --install
```

---

## 🖥️ Platform Support

| Platform | Status |
|----------|--------|
| **macOS** | ✅ Fully supported (primary platform) |
| Linux | ✅ Supported |
| Windows (WSL) | ⚠️ Clipboard setup required |

---

## ⌨️ Key Concepts

- **Leader key**: `<Space>`
- **LSP actions**: `<Space>l...`
- **Find/Search**: `<Space>f...`
- **Harpoon**: `<Space>h...` or `<Ctrl>1-9`
- **Debugging**: `<F5>` to start, `<Space>d...` for actions

Press `<Space>` and wait to see all available keybindings!

---

## 📁 Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lua/
│   ├── colorscheme/      # Gruvbox theme
│   ├── lsp/              # LSP, completion, Mason
│   ├── plugin/           # Plugin configs
│   └── ui/               # UI components
└── doc/                  # Documentation
```
