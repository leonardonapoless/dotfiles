local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- Print
    s("pr", fmt('println!("{{:?}}", {});', { i(1) })),
    s("pe", fmt('eprintln!("{{:?}}", {});', { i(1) })),

    -- Function
    s("fn", fmt([[
        fn {}({}) -> {} {{
            {}
        }}
    ]], { i(1, "name"), i(2), i(3, "()"), i(0) })),

    -- Test
    s("test", fmt([[
        #[test]
        fn {}() {{
            {}
        }}
    ]], { i(1, "test_name"), i(0) })),

    -- Async Test
    s("atest", fmt([[
        #[tokio::test]
        async fn {}() {{
            {}
        }}
    ]], { i(1, "test_name"), i(0) })),

    -- Match
    s("match", fmt([[
        match {} {{
            {} => {},
            _ => {},
        }}
    ]], { i(1), i(2), i(3), i(0) })),

    -- Result/Option
    s("ok", fmt("Ok({})", { i(1) })),
    s("err", fmt("Err({})", { i(1) })),
    s("some", fmt("Some({})", { i(1) })),
    s("none", t("None")),

    -- Derives
    s("derive", fmt("#[derive({}, {})]", { i(1, "Debug"), i(2, "Clone") })),

    -- Mod test
    s("modtest", fmt([[
        #[cfg(test)]
        mod tests {{
            use super::*;

            #[test]
            fn {}() {{
                {}
            }}
        }}
    ]], { i(1, "it_works"), i(0) })),
}
