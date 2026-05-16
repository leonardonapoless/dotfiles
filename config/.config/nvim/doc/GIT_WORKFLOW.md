# Git & GitHub Workflow in Neovim

## Core Concepts

1. **Neogit (`Space gg`)**: Your main dashboard. Use this for staging, committing, pushing, and pulling. It replaces the command line `git` commands.
2. **Diffview (`Space gd`)**: Your diff viewer. Use this to review changes side-by-side and resolve merge conflicts.
3. **Telescope (`Space gb/gc`)**: Your picker. Use this to search and switch between branches or commits.
4. **Octo (`Space gi/gp`)**: Your GitHub client. Use this to manage Issues and Pull Requests directly from Neovim.

---

## The Dashboard (Neogit)

Press `Space gg` to open Neogit.

* **Staging**:
  * Navigate to a file (or hunk) with `j/k`.
  * Press `s` to **stage** it.
  * Press `u` to **unstage** it.
  * Press `x` to **discard** changes (careful!).
* **Committing**:
  * Press `c` → `c` (triggers "commit") to open the commit message window.
  * Type your message.
  * Press `Ctrl+c` `Ctrl+c` to **confirm** and save the commit.
  * Press `Ctrl+c` `Ctrl+k` to **cancel**.
* **Pushing/Pulling**:
  * Press `P` to open the Push popup (then `p` to push to origin).
  * Press `p` to open the Pull popup.

> **Tip:** Neogit is context-aware! If you open it from an `oil` file browser, it will open for the repository *in that folder*.

---

## Viewing Diffs (Diffview)

* `Space gd`: Open the **Diff View**.
  * Shows a side-by-side view (Left: Old, Right: New).
  * Use `]c` and `[c` to jump between changes.
  * Type `:DiffviewClose` (or just close the tab) to exit.
* `Space gh`: Open **File History** (blame/log for current file).

---

## Branches & History (Telescope)

* `Space gb`: **Switch Branches**.
  * Lists local and remote branches.
  * Press `<CR>` to checkout.
  * Type the name of a *new* branch and press `<C-a>` (or check Telescope mappings) to create it.
* `Space gc`: **Checkout Commit**.
  * Browse commit history and checkout a specific point in time.
* `Space gs`: **Git Status** via Telescope (alternative to Neogit if you just want to see changed files).

---

## GitHub (Octo.nvim)

*Note: Requires `gh auth login` in your terminal first.*

* `Space gi`: **List Issues**.
  * Press `<CR>` on an issue to open it.
  * You can edit the description, add comments, and close it using keybindings shown in the virtual text.
* `Space gp`: **List Pull Requests**.
  * View code changes, leave comments, and merge PRs.

---

## ⚡ Cheat Sheet

| Mapping | Action |
| :--- | :--- |
| **`Space gg`** | **Open Neogit (Dashboard)** |
| **`Space gd`** | **Open Diff View** |
| `Space gh` | File History |
| `Space gb` | Switch Branch |
| `Space gi` | GitHub Issues |
| `Space gp` | GitHub PRs |
