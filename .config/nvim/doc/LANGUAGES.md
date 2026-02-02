# Language Support Guide

> Setup instructions for all supported languages

## Quick Start

After opening Neovim, run:

```vim
:Lazy sync
:MasonInstall
:TSUpdate
```

---

## Supported Languages

### Auto Configured

These LSP servers are auto-installed by Mason:

| Language | LSP Server | Treesitter |
|----------|------------|------------|
| Lua | lua_ls | ✓ |
| Python | pyright | ✓ |
| JavaScript | ts_ls | ✓ |
| TypeScript | ts_ls | ✓ |
| React (TSX/JSX) | ts_ls + emmet_ls | ✓ |
| Angular | angularls | ✓ |
| HTML | html + emmet_ls | ✓ |
| CSS | cssls | ✓ |
| Tailwind CSS | tailwindcss | ✓ |
| Bash | bashls | ✓ |
| C/C++ | clangd | ✓ |
| Java | jdtls | ✓ |
| GLSL | glsl_analyzer | ✓ |

### ⚙️ Manual Setup Required

#### Swift

Swift uses `sourcekit-lsp` which comes with Xcode.

**Install:**

```bash
# Install Xcode Command Line Tools
xcode-select --install
```

**Verify:**

```bash
sourcekit-lsp --help
```

No additional configuration needed - the LSP is auto-configured.

#### Odin

Odin uses `ols` (Odin Language Server).

**Install:**

```bash
# Clone and build
git clone --recursive https://github.com/DanielGaworski/ols.git
cd ols && ./build.sh

# Add to PATH (add to .zshrc)
export PATH="$HOME/ols:$PATH"
```

**Or via Homebrew (if available):**

```bash
brew tap odin-lang/odin
brew install ols
```

**Verify:**

```bash
ols --help
```

---

## Treesitter Parsers

All parsers are auto-installed on first use. To manually install:

```vim
:TSInstall swift cpp odin typescript tsx java
```

To update all parsers:

```vim
:TSUpdate
```

---

## Debugging (DAP)

### C/C++ and Swift

Uses `codelldb` (auto-installed by Mason).

**Usage:**

1. Build your project with debug symbols (`-g` flag)
2. Set breakpoint with `<Space>db`
3. Start debugging with `<F5>`
4. Enter path to executable when prompted

### JavaScript/TypeScript

Uses `js-debug-adapter` (auto-installed by Mason).

**Usage:**

1. Set breakpoint with `<Space>db`
2. Start debugging with `<F5>`
3. Select launch configuration

---

## Formatting

### C/C++

clangd handles formatting. Create `.clang-format` in project root:

```yaml
BasedOnStyle: LLVM
IndentWidth: 4
```

### JavaScript/TypeScript

Install prettier:

```bash
npm install -g prettier
```

### Swift

Uses swift-format (included with Xcode).

---

## Troubleshooting

### LSP not starting

1. Check `:LspInfo` for status
2. Check `:checkhealth lsp`
3. Verify server is installed: `:Mason`

### Treesitter not highlighting

1. Check `:TSInstallInfo`
2. Reinstall parser: `:TSInstall <language>`

### Server missing

Install manually:

```vim
:MasonInstall <server-name>
```
