# 🔍 Spectre: Project-Wide Find & Replace

> **Professional project-wide search and refactor for Neovim**  
> Project-wide search and refactor via ripgrep and sed. Faster and more precise than standard IDE find/replace.

---

## 📚 Table of Contents

1. [Quick Start](#quick-start)
2. [Workflow](#workflow)
3. [Keybindings](#keybindings)
4. [Real-World Examples](#real-world-examples)
5. [Advanced Features](#advanced-features)
6. [Regex Cheat Sheet](#regex-cheat-sheet)
7. [Options & Toggles](#options--toggles)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Tips & Tricks](#tips--tricks)

---

## 🚀 Quick Start

### Installation Check

Spectre is configured at `~/.config/nvim/lua/plugin/spectre.lua`.

> [!NOTE]
> **Leader Key: SPACE**  
> `<leader>` is mapped to **Space**. `<leader>S` is executed via `Space` + `S`.

### First Search

**Execution:**

1. Open Neovim in project root.
2. Press `<leader>S`.
3. Enter pattern in the **Search** field.
4. Enter replacement text in the **Replace** field.
5. Results populate the window below.

---

## 🎯 Workflow

### Step-by-Step

#### **Example: Project-wide Variable Rename**

Scenario: Rename `oldName` to `newName` throughout the project.

**Step 1: Open Spectre**

```
Press: <leader>S
```

**Step 2: Enter Search Pattern**

```
Search: oldName
[Press Enter]
```

**Step 3: Preview**
Spectre searches the project using ripgrep. Result pane displays matches by file and line number:

```
┌────────────────────────────────────────────────────────────
│  Search for: oldName
│  Replace with: [cursor moves here]
│  Path: 
└────────────────────────────────────────────────────────────
│  
│  📁 src/main.cpp
│    12: │  int oldName = 5;
│    45: │  return oldName * 2;
│    67: │  printf("Value: %d", oldName);
│  
│  📁 include/utils.h
│    8:  │  extern int oldName;
│    15: │  void setOldName(int value);
│  
│  📁 tests/test_main.cpp
│    23: │  assert(oldName == 5);
│  
│  Total: 6 matches in 3 files
```

**Step 4: Enter Replacement**

```
Replace with: newName
```

**Step 5: Review & Exclude**

Exclude specific lines (e.g., line 15 in `utils.h`) from the operation:

- Navigate to the match line using `j`/`k`.
- Press `dd` to toggle the match off.

**Step 6: Execute**

```
Press: <leader>R
```

**Confirmation:**

```
Replace 5 occurrences in 3 files? (y/n): y
```

Operation complete. Files are updated on disk.

---

## ⌨️ Keybindings

> [!IMPORTANT]
> **Note:** `<leader>` key is **SPACE**.

### Opening Spectre

| Keymap | Mode | Action | Use Case |
|--------|------|--------|----------|
| `<leader>S` | Normal | Open Spectre window | Project-wide lookup |
| `<leader>sw` | Normal | Search word under cursor | Current symbol lookup |
| `<leader>sw` | Visual | Search selected text | Custom range lookup |
| `<leader>sp` | Normal | Current file search | Local-only refactor |

### Inside Spectre Window

| Keymap | Action | Purpose |
|--------|--------|----------|
| `dd` | Toggle line | Include/exclude match |
| `<CR>` | Jump to file | Open file at match location |
| `<leader>R` | Replace ALL | Run replacement for all included matches |
| `<leader>rc` | Replace current | Run replacement for focused line only |
| `<leader>q` | Send to quickfix | Export matches to quickfix list |
| `<leader>o` | Options menu | Configuration settings |
| `<leader>v` | View mode | Cycle display layouts |
| `<leader>l` | Resume last search | Restore previous session |
| `<leader>c` | Change options | Modify search engine behavior |

### Toggles (Inside Spectre)

| Keymap | Toggle | Default |
|--------|--------|---------|
| `ti` | Ignore case | ON |
| `th` | Hidden files | OFF |
| `tu` | Live update | OFF |
| `trs` | Use `sed` | Active |
| `tro` | Use `oxi` | Inactive |

---

## 💼 Real-World Examples

### Example 1: Function Rename

- **Scenario:** Function `processData()` requires rename to `processUserData()`.
- **Method:** Cursor on `processData` -> `<leader>sw` -> Type `processUserData` in Replace field -> `<leader>R`.

### Example 2: API Version Update

- **Scenario:** API endpoint update from `/api/v1/` to `/api/v2/`.
- **Method:** `<leader>S` -> Search: `/api/v1/` -> Replace: `/api/v2/` -> `<leader>R`.

### Example 3: Class Refactor

- **Scenario:** Rename `OldUserManager` to `UserService` throughout codebase.
- **Method:** `<leader>S` -> Search: `OldUserManager` -> Replace: `UserService` -> Review results -> `dd` to exclude comments -> `<leader>R`.

### Example 4: Typo Correction

- **Scenario:** Fix misspelled variable `recieve` to `receive`.
- **Method:** `<leader>S` -> Search: `recieve` -> Replace: `receive` -> Toggle case-sensitivity `ti` -> `<leader>R`.

### Example 5: Import Update

- **Scenario:** Migration from `./utils` to `@/lib/utils`.
- **Method:** `<leader>S` -> Search: `from ['"].*utils['"]` -> Replace: `from '@/lib/utils'` -> `<leader>R`.

---

## 🔥 Advanced Features

### 1. File Path Filtering

Restrict scope via the **Path** field:

```
Path: *.java        # Java files only
Path: src/          # src/ directory only
Path: !test/        # Exclude test/
Path: *.{cpp,h}     # C++ source and headers only
```

Example: Replace `TODO` with `FIXME` only in `src/*.cpp`.

---

### 2. Regex Patterns

Spectre supports ripgrep/Rust regex.

**Capture Groups:**

```
Search: fn_(\w+)
Replace: function_$1
```

Converts `fn_getData` to `function_getData`.

**Common Patterns:**

| Pattern | Matches |
|---------|---------|
| `\d+` | Numbers |
| `[A-Z]\w+` | CapitalizedWords |
| `(foo|bar)` | Alternation |
| `\bword\b` | Word boundaries |
| `.*\.cpp$` | File extensions |

---

### 3. Quickfix Integration

Export search results for standard navigation:

1. Execute search in Spectre.
2. Press `<leader>q`.
3. Use `:cnext`, `:cprev`, or `:copen` to manage results.

---

### 4. Resume Last Search

Restores the previous search session:

```
<leader>l
```

Useful for refining searches or repeating complex patterns.

---

## 📖 Regex Patterns Cheat Sheet

### Common Patterns

```regex
# Numeric values
\d+              → 123, 456
\d{2,4}          → 12, 123, 1234

# Identifiers
\w+              → word, Word123
[A-Z][a-z]+      → CapitalizedWord

# Whitespace
\s+              → one or more spaces/tabs
\s*              → optional whitespace

# Boundaries
\bword\b         → exact word match
^start           → line beginning
end$             → line end

# Capture Groups
(\w+)            → accessible via $1 in replacement
(.*?)            → non-greedy match

# Classes
[abc]            → individual characters
[^abc]           → exclusion
[A-Z0-9]         → ranges
```

### Replacement Examples

**Prefixing:**

- Search: `fn (\w+)`
- Replace: `fn api_$1`

**Import Paths:**

- Search: `from ["'](.+)["']`
- Replace: `from '@/lib/$1'`

---

## ⚙️ Options & Toggles

### Option Menu (`<leader>o`)

```
Options:
  [I] ignore-case: ON
  [H] hidden: OFF
  
Engine:
  rg (active)
  
Replace method:
  sed (active)
```

### Toggle Mapping

| Option | Command | Impact |
|--------|---------|--------|
| **Ignore Case** | `ti` | Toggles case-sensitivity |
| **Hidden Files** | `th` | Includes dotfiles/hidden folders |
| **Live Update** | `tu` | Refresh results on file changes |

---

## 🔧 Troubleshooting

### No Matches Found

- Verify current working directory (`:pwd`).
- Toggle case-sensitivity (`ti`).
- Enable hidden file search (`th`).
- Verify pattern validity (remove regex for testing).

### Incorrect Replacements

- Inspect preview window before executing `<leader>R`.
- Use `dd` to exclude unrelated matches.
- Use `git checkout .` to revert unintended changes.

### Performance

- Restrict scope using the **Path** field.
- Exclude build/dependency directories (`!node_modules/`, `!target/`).

---

## 💡 Best Practices

- **Match Inspection**: Inspect all results in the preview pane before execution.
- **Symbol Targeting**: Use unique patterns; `processUserData` is safer than `process`.
- **Git Safety**: Verify a clean git tree before global operations.
- **Buffer State**: Run `:wa` to write all buffers before starting.
- **Boundaries**: Use `\b` to prevent partial matches.

---

## 🎓 Tips & Tricks

### Quick Rename

Symbol renaming: Cursor on word -> `<leader>sw` -> Enter replacement -> `<leader>R`.

### Visual Range

Targeted search: Visual select area -> `<leader>sw`. Spectre scopes to the selection.

### Search Persistence

Spectre maintains the state of the last search. Reopen with `<leader>l`.

---

## 📊 Comparison

| Feature | Spectre (Neovim) | VS Code | Xcode |
|---------|------------------|---------|-------|
| Engine | ripgrep | Standard | Standard |
| Speed | High | Medium | Low |
| Regex | Rust (full) | JS | Partial |
| Keyboard | Yes | Partial | Partial |

---

## 🎯 Quick Reference Card

```
┌──────────────── SPECTRE QUICK REFERENCE ────────────────┐
│                                                          │
│  EXECUTION                                               │
│    <leader>S     → Open search/replace window            │
│    <leader>sw    → Search word under cursor              │
│    <leader>sp    → Search in current file                │
│                                                          │
│  NAVIGATION & ACTIONS                                     │
│    dd            → Toggle include/exclude match          │
│    <CR>          → Jump to match                         │
│    <leader>R     → Run global replace                    │
│    <leader>rc    → Run line replace                      │
│    <leader>q     → Open in quickfix                      │
│                                                          │
│  CONFIGURATION                                           │
│    ti            → Toggle Case                           │
│    th            → Toggle Hidden                         │
│    <leader>o     → Options menu                          │
│    <leader>l     → Resume last search                    │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 🎉 Status

Project-wide refactor capabilities are active. Global replacements can be performed with confidence via ripgrep and sed.
