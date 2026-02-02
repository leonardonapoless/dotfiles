local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- Helper functions
local function filename()
    return vim.fn.expand('%:t:r')
end

local function header_guard()
    local name = vim.fn.expand('%:t'):upper():gsub('[.-]', '_')
    return name .. '_'
end

local function namespace_from_path()
    local path = vim.fn.expand('%:p:h')
    local match = path:match('/([^/]+)$')
    return match or "myapp"
end

return {
    -- Main with includes
    s("main", fmt([[
        #include <iostream>

        int main(int argc, char* argv[])
        {{
            {}
            return 0;
        }}
    ]], { i(0) })),

    -- Class with auto header guard and filename
    s("class", fmt([[
        class {}
        {{
        public:
            {}();
            ~{}();

            {}

        private:
            {}
        }};
    ]], {
        f(filename, {}),
        rep(1),
        rep(1),
        i(2, "// Public methods"),
        i(0, "// Private members")
    })),

    -- Header file with guard
    s("header", fmt([[
        #ifndef {}
        #define {}

        {}

        #endif // {}
    ]], {
        f(header_guard, {}),
        rep(1),
        i(0),
        rep(1)
    })),

    -- Namespace with auto-detection
    s("namespace", fmt([[
        namespace {}
        {{
        {}
        }} // namespace {}
    ]], {
        f(namespace_from_path, {}),
        i(0),
        rep(1)
    })),

    -- Smart pointer with choice
    s("unique", fmt([[
        auto {} = std::make_unique<{}>({}); ]], {
        i(1, "ptr"),
        i(2, "Type"),
        i(3, "args")
    })),

    s("shared", fmt([[
        auto {} = std::make_shared<{}>({}); ]], {
        i(1, "ptr"),
        i(2, "Type"),
        i(3, "args")
    })),

    -- Range-based for loop with auto type
    s("forr", fmt([[
        for (auto& {} : {}) {{
            {}
        }}
    ]], {
        i(1, "item"),
        i(2, "container"),
        i(0)
    })),

    -- Lambda with choice for capture
    s("lambda", fmt([[
        auto {} = [{}]({}){} {{
            {}
        }};
    ]], {
        i(1, "lambda"),
        c(2, { t("&"), t("="), t(""), t("this") }),
        i(3, "params"),
        c(4, { t(""), t(" -> auto"), i(nil, " -> ReturnType") }),
        i(0, "return value;")
    })),

    -- Template function
    s("template", fmt([[
        template<typename {}>
        {} {}({})
        {{
            {}
        }}
    ]], {
        i(1, "T"),
        i(2, "void"),
        i(3, "functionName"),
        fmt("const {}& {}", { rep(1), i(1, "arg") }),
        i(0)
    })),

    -- Rule of 5 with class name
    s("rule5", fmt([[
        class {}
        {{
        public:
            {}();                                    // Constructor
            ~{}();                                   // Destructor
            {}(const {}& other);                    // Copy constructor
            {}& operator=(const {}& other);         // Copy assignment
            {}({}&&other) noexcept;              // Move constructor
            {}& operator=({}&& other) noexcept;     // Move assignment

            {}

        private:
            {}
        }};
    ]], {
        f(filename, {}),
        rep(1), rep(1),
        rep(1), rep(1),
        rep(1), rep(1),
        rep(1), rep(1),
        rep(1), rep(1),
        i(2, "// Public interface"),
        i(0, "// Private members")
    })),

    -- RAII wrapper
    s("raii", fmt([[
        class {}
        {{
        public:
            explicit {}({}* resource) : resource_(resource) {{}}

            ~{}()
            {{
                if (resource_)
                {{
                    {}(resource_);
                }}
            }}

            // Delete copy
            {}(const {}&) = delete;
            {}& operator=(const {}&) = delete;

            // Allow move
            {}({}&&other) noexcept : resource_(other.resource_)
            {{
                other.resource_ = nullptr;
            }}

            {}* get() const {{ return resource_; }}

        private:
            {}* resource_;
        }};
    ]], {
        i(1, "ResourceWrapper"),
        rep(1),
        i(2, "ResourceType"),
        rep(1),
        i(3, "cleanup"),
        rep(1), rep(1),
        rep(1), rep(1),
        rep(1), rep(1),
        rep(2),
        rep(2)
    })),

    -- Thread with lambda
    s("thread", fmt([[
        std::thread {}([{}]() {{
            {}
        }});
        {}.join(); // or {}.detach();
    ]], {
        i(1, "worker"),
        c(2, { t(""), t("&"), t("="), t("this") }),
        i(3, "// Work"),
        rep(1),
        rep(1)
    })),

    -- Mutex with lock guard
    s("mutex", fmt([[
        std::mutex {};
        std::lock_guard<std::mutex> {}({});
        {}
    ]], {
        i(1, "mtx"),
        i(2, "lock"),
        rep(1),
        i(0)
    })),

    -- constexpr with auto return type
    s("constexpr", fmt([[
        constexpr auto {}({}) -> {}
        {{
            return {};
        }}
    ]], {
        i(1, "functionName"),
        i(2, "params"),
        c(3, { t("auto"), i(nil, "ReturnType") }),
        i(0, "value")
    })),

    -- Concept (C++20)
    s("concept", fmt([[
        template<typename {}>
        concept {} = requires({} {}) {{
            {{ {}.{}() }} -> std::convertible_to<{}>;
        }};
    ]], {
        i(1, "T"),
        i(2, "ConceptName"),
        rep(1),
        i(3, "t"),
        rep(3),
        i(4, "method"),
        i(5, "ReturnType")
    })),

    -- Smart cout with variable
    s("cout", fmt('std::cout << "{} = " << {} << std::endl;', {
        rep(1),
        i(1, "variable")
    })),

    -- Timer/benchmark
    s("timer", fmt([[
        auto {} = std::chrono::high_resolution_clock::now();
        {}
        auto {} = std::chrono::high_resolution_clock::now();
        auto {} = std::chrono::duration_cast<std::chrono::milliseconds>({} - {});
        std::cout << "Elapsed: " << {}.count() << "ms" << std::endl;
    ]], {
        i(1, "start"),
        i(0, "// Code to benchmark"),
        i(2, "end"),
        i(3, "duration"),
        rep(2),
        rep(1),
        rep(3)
    })),

    -- Optional with pattern matching
    s("optional", fmt([[
        std::optional<{}> {} = {};
        if ({}.has_value()) {{
            auto {} = {}.value();
            {}
        }}
    ]], {
        i(1, "Type"),
        i(2, "opt"),
        i(3, "value"),
        rep(2),
        i(4, "val"),
        rep(2),
        i(0)
    })),

    -- Variant with visitor
    s("variant", fmt([[
        std::variant<{}> {} = {};
        std::visit([](auto&& arg) {{
            using T = std::decay_t<decltype(arg)>;
            {}
        }}, {});
    ]], {
        i(1, "Type1, Type2"),
        i(2, "var"),
        i(3, "value"),
        i(0, "// Handle variants"),
        rep(2)
    })),
}
