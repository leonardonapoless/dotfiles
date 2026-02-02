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

local function current_year()
    return os.date('%Y')
end

local function package_name()
    local path = vim.fn.expand('%:p:h')
    local match = path:match('src/main/java/(.*)') or path:match('src/test/java/(.*)')
    if match then
        return match:gsub('/', '.')
    end
    return 'com.example'
end

return {
    -- Basic Structures

    s("main", fmt([[
        public static void main(String[] args) {{
            {}
        }}
    ]], { i(0) })),

    s("class", fmt([[
        public class {} {{
            {}
        }}
    ]], { f(filename, {}), i(0) })),

    s("classpkg", fmt([[
        package {};

        public class {} {{
            {}
        }}
    ]], { f(package_name, {}), f(filename, {}), i(0) })),

    s("interface", fmt([[
        public interface {} {{
            {}
        }}
    ]], { i(1, "InterfaceName"), i(0) })),

    s("abstract", fmt([[
        public abstract class {} {{
            {}
        }}
    ]], { i(1, "AbstractClass"), i(0) })),

    s("record", fmt([[
        public record {}({}) {{
            {}
        }}
    ]], { f(filename, {}), i(1, "String field"), i(0) })),

    s("enum", fmt([[
        public enum {} {{
            {};
            {}
        }}
    ]], { f(filename, {}), i(1, "VALUE1, VALUE2"), i(0) })),

    s("sealed", fmt([[
        public sealed class {} permits {} {{
            {}
        }}
    ]], { i(1, "Base"), i(2, "ChildA, ChildB"), i(0) })),

    -- Methods & Constructors

    s("ctor", fmt([[
        public {}({}) {{
            {}
        }}
    ]], { f(filename, {}), i(1, "params"), i(0) })),

    s("method", fmt([[
        public {} {}({}) {{
            {}
        }}
    ]], { i(1, "void"), i(2, "methodName"), i(3, "params"), i(0) })),

    s("static", fmt([[
        public static {} {}({}) {{
            {}
        }}
    ]], { i(1, "void"), i(2, "methodName"), i(3, "params"), i(0) })),

    s("final", fmt([[
        public final {} {}({}) {{
            {}
        }}
    ]], { i(1, "void"), i(2, "methodName"), i(3, "params"), i(0) })),

    -- Getters/Setters

    s("get", fmt([[
        public {} get{}() {{
            return {};
        }}
    ]], {
        i(1, "Type"),
        i(2, "FieldName"),
        f(function(args) return args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2) end, { 2 })
    })),

    s("set", fmt([[
        public void set{}({} {}) {{
            this.{} = {};
        }}
    ]], {
        i(1, "FieldName"),
        i(2, "Type"),
        f(function(args) return args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2) end, { 1 }),
        rep(3), rep(3)
    })),

    s("getset", fmt([[
        public {} get{}() {{
            return {};
        }}

        public void set{}({} {}) {{
            this.{} = {};
        }}
    ]], {
        i(1, "Type"), i(2, "FieldName"),
        f(function(args) return args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2) end, { 2 }),
        rep(2), rep(1),
        f(function(args) return args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2) end, { 2 }),
        rep(3), rep(3)
    })),

    -- toString, equals, hashCode

    s("tostring", fmt([[
        @Override
        public String toString() {{
            return "{}{{" +
                    "{}";
        }}
    ]], { f(filename, {}), i(1, "field=' + field + '\\''") })),

    s("equals", fmt([[
        @Override
        public boolean equals(Object o) {{
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            {} that = ({}) o;
            return Objects.equals({}, that.{});
        }}
    ]], { f(filename, {}), rep(1), i(1, "field"), rep(1) })),

    s("hashcode", fmt([[
        @Override
        public int hashCode() {{
            return Objects.hash({});
        }}
    ]], { i(1, "field1, field2") })),

    -- Control Flow

    s("if", fmt([[
        if ({}) {{
            {}
        }}
    ]], { i(1, "condition"), i(0) })),

    s("ifelse", fmt([[
        if ({}) {{
            {}
        }} else {{
            {}
        }}
    ]], { i(1, "condition"), i(2, "// if branch"), i(0, "// else branch") })),

    s("elseif", t({ "} else if (", ") {" })),

    s("ternary", fmt("{} ? {} : {}", { i(1, "condition"), i(2, "ifTrue"), i(3, "ifFalse") })),

    s("switch", fmt([[
        switch ({}) {{
            case {} -> {{}};
            default -> {{}};
        }}
    ]], { i(1, "value"), i(2, "CASE1") })),

    s("switchpattern", fmt([[
        switch ({}) {{
            case {} {} -> {{}};
            case null, default -> {{}};
        }}
    ]], { i(1, "obj"), i(2, "String"), i(3, "s") })),

    -- Loops

    s("for", fmt([[
        for (int {} = 0; {} < {}; {}++) {{
            {}
        }}
    ]], { i(1, "i"), rep(1), i(2, "length"), rep(1), i(0) })),

    s("fore", fmt([[
        for ({} {} : {}) {{
            {}
        }}
    ]], { i(1, "Type"), i(2, "item"), i(3, "collection"), i(0) })),

    s("while", fmt([[
        while ({}) {{
            {}
        }}
    ]], { i(1, "condition"), i(0) })),

    s("dowhile", fmt([[
        do {{
            {}
        }} while ({});
    ]], { i(1, "// code"), i(2, "condition") })),

    -- Exception Handling

    s("try", fmt([[
        try {{
            {}
        }} catch ({} e) {{
            {}
        }}
    ]],
        { i(1, "// code"), c(2, { t("Exception"), t("IOException"), t("RuntimeException") }), i(3,
            "log.error(\"Error\", e);") })),

    s("tryres", fmt([[
        try ({} {} = {}) {{
            {}
        }} catch ({} e) {{
            {}
        }}
    ]],
        { i(1, "Resource"), i(2, "resource"), i(3, "new Resource()"), i(4, "// use resource"), i(5, "Exception"), i(0,
            "log.error(\"Error\", e);") })),

    s("trycatch", fmt([[
        try {{
            {}
        }} catch ({} e) {{
            {}
        }} finally {{
            {}
        }}
    ]], { i(1, "// code"), i(2, "Exception"), i(3, "// handle"), i(0, "// cleanup") })),

    s("throw", fmt("throw new {}({});", { i(1, "Exception"), i(2, "\"message\"") })),

    -- Collections

    s("list", fmt("List<{}> {} = new ArrayList<>();", { i(1, "String"), i(2, "list") })),
    s("set", fmt("Set<{}> {} = new HashSet<>();", { i(1, "String"), i(2, "set") })),
    s("map", fmt("Map<{}, {}> {} = new HashMap<>();", { i(1, "String"), i(2, "Object"), i(3, "map") })),
    s("listof", fmt("List<{}> {} = List.of({});", { i(1, "String"), i(2, "list"), i(3, "elements") })),
    s("setof", fmt("Set<{}> {} = Set.of({});", { i(1, "String"), i(2, "set"), i(3, "elements") })),
    s("mapof",
        fmt("Map<{}, {}> {} = Map.of({}, {});",
            { i(1, "String"), i(2, "Object"), i(3, "map"), i(4, "key"), i(5, "value") })),

    -- Streams

    s("stream", fmt([[
        {}.stream()
                .{}
                .collect(Collectors.toList());
    ]], { i(1, "list"), c(2, {
        fmt("map({} -> {})", { i(1, "item"), i(2, "item.transform()") }),
        fmt("filter({} -> {})", { i(1, "item"), i(2, "item.isValid()") }),
        fmt("sorted(Comparator.comparing({}))", { i(1, "Item::getName") })
    }) })),

    s("streammap",
        fmt("{}.stream().map({} -> {}).collect(Collectors.toList());",
            { i(1, "list"), i(2, "item"), i(3, "item.transform()") })),
    s("streamfilter",
        fmt("{}.stream().filter({} -> {}).collect(Collectors.toList());",
            { i(1, "list"), i(2, "item"), i(3, "item.isValid()") })),
    s("streamreduce", fmt("{}.stream().reduce({}, (a, b) -> {});", { i(1, "list"), i(2, "identity"), i(3, "a + b") })),
    s("streamcount",
        fmt("long count = {}.stream().filter({} -> {}).count();", { i(1, "list"), i(2, "item"), i(3, "item.isValid()") })),

    -- Optional

    s("optional", fmt("Optional<{}> {} = Optional.ofNullable({});", { i(1, "Type"), i(2, "opt"), i(3, "value") })),
    s("optmap",
        fmt("{}.map({} -> {}).orElse({});", { i(1, "optional"), i(2, "value"), i(3, "transform"), i(4, "default") })),
    s("optor", fmt("{}.orElse({});", { i(1, "optional"), i(2, "defaultValue") })),
    s("optthrow", fmt("{}.orElseThrow(() -> new {}({}));", { i(1, "optional"), i(2, "Exception"), i(3, "\"message\"") })),

    -- Lambdas & Functional

    s("lambda", fmt("({}) -> {}", { i(1, "params"), i(2, "expression") })),
    s("functional", fmt([[
        @FunctionalInterface
        public interface {} {{
            {} {}({});
        }}
    ]], { i(1, "Processor"), i(2, "void"), i(3, "process"), i(4, "Object item") })),

    -- Logging

    s("logger", fmt("private static final Logger logger = LoggerFactory.getLogger({}.class);", { f(filename, {}) })),
    s("logdebug", fmt("logger.debug({});", { i(1, "\"Debug message\"") })),
    s("loginfo", fmt("logger.info({});", { i(1, "\"Info message\"") })),
    s("logwarn", fmt("logger.warn({});", { i(1, "\"Warning message\"") })),
    s("logerror", fmt("logger.error({}, e);", { i(1, "\"Error message\"") })),

    -- Concurrency

    s("async", fmt([[
        CompletableFuture.supplyAsync(() -> {{
            return {};
        }}).thenApply(result -> {{
            {}
            return result;
        }}).exceptionally(e -> {{
            logger.error("Error: ", e);
            return null;
        }});
    ]], { i(1, "value"), i(2, "// process result") })),

    s("executor",
        fmt("ExecutorService executor = Executors.new{}ThreadPool({});",
            { c(1, { t("Fixed"), t("Cached") }), i(2, "10") })),
    s("future", fmt("Future<{}> future = executor.submit(() -> {});", { i(1, "Result"), i(2, "computation") })),

    -- Utilities

    s("sout", fmt("System.out.println({});", { i(1, "\"message\"") })),
    s("soutv", fmt("System.out.println(\"{} = \" + {});", { rep(1), i(1, "variable") })),
    s("soutf", fmt("System.out.printf(\"{}\", {});", { i(1, "%s%n"), i(2, "args") })),

    s("var", fmt("var {} = {};", { i(1, "name"), i(2, "value") })),
    s("const", fmt("public static final {} {} = {};", { i(1, "String"), i(2, "CONSTANT"), i(3, "\"value\"") })),

    s("builder", fmt([[
        public static class Builder {{
            private {} {};

            public Builder {}({} {}) {{
                this.{} = {};
                return this;
            }}

            public {} build() {{
                return new {}(this);
            }}
        }}
    ]], { i(1, "Type"), i(2, "field"), i(3, "field"), rep(1), rep(2), rep(2), rep(2), f(filename, {}), f(filename, {}) })),
    s("singleton", fmt([[
        private static final {} INSTANCE = new {}();

        private {}() {{}}

        public static {} getInstance() {{
            return INSTANCE;
        }}
    ]], { f(filename, {}), rep(1), rep(1), rep(1) })),

    s("copyright", fmt([[
        /*
         * Copyright (c) {} {}
         * All rights reserved.
         */
    ]], { f(current_year, {}), i(1, "Your Company") })),
}
