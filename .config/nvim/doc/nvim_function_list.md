

--------
## get current directory
lua print(vim.fn.getcwd())

---------
## execute shell commands

#### Lua way of doing it (silently)
```lua
vim.fn.system("your-bash-command")
```
> this one is platform agnostic


#### "vimscript" way of doing it
```lua
vim.cmd('!ls')
```


---------
## file path

```lua
-- without the file in the path
local filepath = vim.fn.expand('%:p:h')

-- with the file in the path
local filepath = vim.fn.expand('%:p')

```



---------
## Get project path
vim.fn.getcwd()



---------
## Get buffer number
vim.api.nvim_get_current_buf()



---------
## Get buffer name
vim.api.nvim_buf_get_name(bufnr)
vim.api.nvim_buf_get_name(0) -- For current buffer

0 -> THIS BUFNR ALWAYS REFFERS TO THE CURRENT BUFFER 


---------
## Remap repeat count variable 
> >> Test this later
> Detecting if a remap is being executed multiple times or not

Just make use of this variable:
vim.v.count



---------
## feed keys

This function executes in parallel with your code unless specified not to.
Aka. it will send the request for some keys to be typed and immediately moves on to the next lua code line.

> Format
vim.api.nvim_feedkeys(keys::string,mode::string,replace_term_codes::boolean)

> Example
vim.api.nvim_feedkeys("q:","xn",false)


### modes

> Modes can be used in combination with one another
> Ex: xn xt

x       -> Makes the function wait till all keys are fed
t       -> keys will be handled as if they where typed
n       -> ""do not remap keys""

> More about:
> https://neovim.io/doc/user/builtin.html#feedkeys()



----------
## search and replace using vim

vim.fn.substitute()
vim.fn.substitute(input_string, regex_pattern, replace_with_this, mode)

Example:
pick = vim.fn.substitute(pick, [[[/][^/]\+$]], "", "g" )

----------
## match lua string with vim regex

(vim.fn.match(<String>, <vim regex pattern>) ~= -1)
> this will return true or false if there is a match within the string

#### Example
vim.fn.match(bufname, '[[]Command Line[]]$') ~= -1)


