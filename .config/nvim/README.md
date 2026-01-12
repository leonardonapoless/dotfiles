# About

> This config is a work in progress.

> Made for Linux; other platforms might not work out of the box or may be incompatible.
</br>


# Current state of things
#### Linux
- Everything is working as intended

#### Windows 10/11
* WLS: everything works after configuring the clipboard (win32yank)
* Native: some Linux specific features might not work (embedded shell commands, et cetera)

#### MacOS
* All mappings that use `Alt` as a modifier key are incompatible and need to be changed
* LSP servers managed by <a href='https://github.com/mason-org/mason.nvim'>Mason</a> are unstable

#### Android: <a href='https://github.com/termux/termux-app'>termux</a>
* Some Mason LSP servers may not install<a href='https://github.com/mason-org/mason.nvim'>Mason</a>
> Most Mason LSP server work now
</br>
* Clipboard does not work out of the box

## About GUI clients (Neovide, Nvim-QT, etc)
- They are all untested

</br>

# Installation

- Clone this repo and place its files at the neovim folder. (Linux: ~/.config/nvim)
- Be sure that the folder is empty beforehand

> Linux/MacOS
```bash
git clone https://github.com/bt-glv/nvim-config.git;
cd nvim-config;
mkdir -p ~/.config/nvim;
mv .* ~/.config/nvim;
cd ~/.config/nvim;
```

- Open Neovim; open the Lazy.nvim dashboard ```:Lazy``` and press ```S```.

</br>

# Requirements

<h2>Neovim</h2>
<h4>Version: 0.11.x</h4>
&nbsp;
<h2>Dependencies</h2>
<ul>
    <li><a href='https://www.nerdfonts.com/'>Pacthed Nerd Fonts Font</a> (For Dev-Icons)</li>
    <li><a href='https://alacritty.org/'>Alacritty Terminal Emulator</a> (Can be replaced)</li>
    <li>npm</li>
    <li>node.js</li>
    <li>ripgrep</li>
    <li><a href='https://www.python.org/'>Phyton</a> 
        <ul>
            <li>PIP module: <a href='https://pypi.org/project/neovim-remote/'>neovim-remote</a> (Required for cmd line autocomplete)</li>
        </ul>    
    </li>
    <li><a href='https://github.com/sharkdp/fd'>fd</a></li>
    <li>C compiler: gcc; clang</li>
</ul>



