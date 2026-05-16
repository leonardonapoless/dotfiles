local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- Main boilerplate for macOS (AArch64)
    s("main", fmt([[
.global _main
.align 2

_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    {}

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    ]], { i(0) })),

    -- Syscall (macOS)
    s("syscall", fmt([[
    mov x0, #{} // arg0
    mov x1, #{} // arg1
    mov x16, #{} // syscall number
    svc #0x80
    ]], { i(1, "1"), i(2, "0"), i(3, "1") })),

    -- Print string (macOS syscall 4)
    s("write", fmt([[
    mov x0, #1          // stdout
    adrp x1, {}@PAGE    // string address
    add x1, x1, {}@PAGEOFF
    mov x2, #{}         // length
    mov x16, #4         // write syscall
    svc #0x80
    ]], { i(1, "msg"), i(1), i(2, "len") })),

    -- Register save/restore
    s("push", fmt("stp {}, {}, [sp, #-16]!", { i(1, "x29"), i(2, "x30") })),
    s("pop", fmt("ldp {}, {}, [sp], #16", { i(1, "x29"), i(2, "x30") })),

    -- Loop
    s("loop", fmt([[
{}:
    {}
    subs {}, {}, #1
    b.ne {}
    ]], { i(1, "loop_label"), i(0), i(2, "x0"), i(2), i(1) })),

    -- Data section
    s("data", fmt([[
.section __DATA,__data
.align 3
{}: .asciz "{}\n"
{} = . - {}
    ]], { i(1, "msg"), i(2, "Hello World"), i(3, "len"), i(1) })),
}
