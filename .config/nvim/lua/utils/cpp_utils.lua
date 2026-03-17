local M = {}

-- Heuristic to check if a node type requires a semicolon in C/C++
local function needs_semicolon_node(node_type)
    local types = {
        ["expression_statement"] = true,
        ["declaration"] = true,
        ["field_declaration"] = true,
        ["return_statement"] = true,
        ["break_statement"] = true,
        ["continue_statement"] = true,
        ["goto_statement"] = true,
        ["type_definition"] = true,
    }
    return types[node_type] or false
end

-- Fallback regex logic when Tree-sitter is unavailable
local function regex_needs_semicolon(line)
    -- 1. Remove comments and trim
    local clean = line:gsub("//.*$", ""):gsub("/%*.-%*/", ""):gsub("%s+$", "")
    if clean == "" then return false end

    -- 2. Already ends with characters that definitely don't need a semicolon
    local last_char = clean:sub(-1)
    if last_char:match("[;{},%\\]") or last_char == ":" then
        return false
    end

    -- 3. Avoid continuation lines (operators at the end)
    if clean:match("[+%-*/%%&|^=<>!]$") or clean:match("&&$") or clean:match("||$") then
        return false
    end

    -- 4. Preprocessor
    if clean:match("^%s*#") then return false end

    -- 5. Control flow headers and specialized blocks
    local lower = clean:lower()
    if lower:match("^%s*if%s*%(.*%)%s*$") or
       lower:match("^%s*for%s*%(.*%)%s*$") or
       lower:match("^%s*while%s*%(.*%)%s*$") or
       lower:match("^%s*switch%s*%(.*%)%s*$") or
       lower:match("^%s*else%s*$") or
       lower:match("^%s*else%s+if.*$") or
       lower:match("^%s*do%s*$") or
       lower:match("^%s*case%s+.*$") or
       lower:match("^%s*default%s*:$") or
       lower:match("^%s*namespace%s+.*$") or
       lower:match("^%s*extern%s+\".*\"%s*$") or
       lower:match("^%s*public%s*:$") or
       lower:match("^%s*private%s*:$") or
       lower:match("^%s*protected%s*:$") then
        return false
    end

    -- 6. Positive heuristics: What DOES need a semicolon?
    -- Variable declarations (starting with types) or return statements
    local types = { "int", "float", "double", "char", "bool", "void", "auto", "std::", "size_t", "uint", "return" }
    for _, t in ipairs(types) do
        if clean:match("^%s*" .. t) then return true end
    end

    -- Assignments or function calls
    if clean:match("=%s*") or clean:match("%(.*%)%s*$") then
        return true
    end

    return false
end

function M.smart_semicolon()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line_num = cursor[1] - 1
    local line = vim.api.nvim_get_current_line()
    
    -- 1. Regex logic is extremely reliable for simple cases and works everywhere
    if regex_needs_semicolon(line) then
        return true
    end

    -- 2. Tree-sitter logic for more complex structural cases (like do-while)
    local has_ts, parser = pcall(vim.treesitter.get_parser, bufnr)
    if has_ts and parser then
        local tree = parser:parse(true)[1]
        local root = tree:root()
        local trimmed_line = line:gsub("%s+$", "")
        local col = math.max(0, #trimmed_line - 1)
        
        local node = root:named_descendant_for_range(line_num, col, line_num, col)
        
        if node then
            local curr = node
            while curr do
                local type = curr:type()
                
                -- Special cases that regex might miss
                if type == "do_statement" then
                    if line:match("while%s*%(.*%)%s*$") then return true end
                end

                if type == "compound_statement" or type == "function_definition" or type == "preproc_include" then
                    break
                end
                curr = curr:parent()
            end
        end
    end

    return false
end

function M.setup_keymaps(bufnr)
    -- Map Enter in insert mode
    vim.keymap.set('i', '<CR>', function()
        if M.smart_semicolon() then
            -- Leveraging Esc to trigger the InsertLeave autocommand (which trims and adds ;)
            -- Then A to return to insert mode at EOL and <CR> to move to next line
            return "<Esc>A<CR>"
        end
        return "<CR>"
    end, { buffer = bufnr, expr = true, desc = "Smart Semicolon on Enter" })

    -- Map Alt+; to append semicolon at EOL
    vim.keymap.set({ 'n', 'i' }, '<A-;>', function()
        local line = vim.api.nvim_get_current_line()
        local clean = line:gsub("%s+$", "")
        if clean:sub(-1) ~= ";" then
            vim.api.nvim_set_current_line(clean .. ";")
        end
    end, { buffer = bufnr, desc = "Append semicolon at EOL" })

    -- Autofix when leaving insert mode
    local actual_bufnr = (bufnr == true or bufnr == nil or bufnr == 0) and 0 or bufnr
    vim.api.nvim_create_autocmd("InsertLeave", {
        buffer = actual_bufnr,
        callback = function()
            if M.smart_semicolon() then
                local line = vim.api.nvim_get_current_line()
                local clean = line:gsub("%s+$", "")
                if clean:sub(-1) ~= ";" then
                    vim.api.nvim_set_current_line(clean .. ";")
                end
            end
        end,
        desc = "Autofix semicolon on InsertLeave",
    })
end

return M
