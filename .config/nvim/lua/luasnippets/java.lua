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
    s({ trig = "main", name = "Main", dscr = "public static void main", priority = 1000 }, fmt([[
        public static void main(String[] args) {{
            {}
        }}
    ]], { i(0) })),

    s({ trig = "class", name = "Class", dscr = "Class definition", priority = 900 }, fmt([[
        public class {} {{
            {}
        }}
    ]], { f(filename, {}), i(0) })),

    s({ trig = "classpkg", name = "Class (Package)", dscr = "Class with auto-detected package", priority = 950 }, fmt([[
        package {};

        public class {} {{
            {}
        }}
    ]], { f(package_name, {}), f(filename, {}), i(0) })),

    s({ trig = "interface", name = "Interface", dscr = "Interface definition" }, fmt([[
        public interface {} {{
            {}
        }}
    ]], { i(1, "InterfaceName"), i(0) })),

    s({ trig = "abstract", name = "Abstract Class", dscr = "Abstract class definition" }, fmt([[
        public abstract class {} {{
            {}
        }}
    ]], { i(1, "AbstractClass"), i(0) })),

    s({ trig = "record", name = "Record", dscr = "Record definition" }, fmt([[
        public record {}({}) {{
            {}
        }}
    ]], { f(filename, {}), i(1, "String field"), i(0) })),

    s({ trig = "enum", name = "Enum", dscr = "Enum definition" }, fmt([[
        public enum {} {{
            {};
            {}
        }}
    ]], { f(filename, {}), i(1, "VALUE1, VALUE2"), i(0) })),

    s({ trig = "sealed", name = "Sealed Class", dscr = "Sealed class with permits" }, fmt([[
        public sealed class {} permits {} {{
            {}
        }}
    ]], { i(1, "Base"), i(2, "ChildA, ChildB"), i(0) })),

    -- Methods & Constructors
    s({ trig = "ctor", name = "Constructor", dscr = "Class constructor" }, fmt([[
        public {}({}) {{
            {}
        }}
    ]], { f(filename, {}), i(1, "params"), i(0) })),

    s({ trig = "method", name = "Method", dscr = "Public method" }, fmt([[
        public {} {}({}) {{
            {}
        }}
    ]], { i(1, "void"), i(2, "methodName"), i(3, "params"), i(0) })),

    s({ trig = "static", name = "Static Method", dscr = "Public static method" }, fmt([[
        public static {} {}({}) {{
            {}
        }}
    ]], { i(1, "void"), i(2, "methodName"), i(3, "params"), i(0) })),

    s({ trig = "final", name = "Final Method", dscr = "Public final method" }, fmt([[
        public final {} {}({}) {{
            {}
        }}
    ]], { i(1, "void"), i(2, "methodName"), i(3, "params"), i(0) })),

    -- Getters/Setters
    s({ trig = "get", name = "Getter", dscr = "Getter method" }, fmt([[
        public {} get{}() {{
            return {};
        }}
    ]], {
        i(1, "Type"),
        i(2, "FieldName"),
        f(function(args) return args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2) end, { 2 })
    })),

    s({ trig = "set", name = "Setter", dscr = "Setter method" }, fmt([[
        public void set{}({} {}) {{
            this.{} = {};
        }}
    ]], {
        i(1, "FieldName"),
        i(2, "Type"),
        f(function(args) return args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2) end, { 1 }),
        rep(3), rep(3)
    })),

    s({ trig = "getset", name = "Getter & Setter", dscr = "Getter and Setter pair" }, fmt([[
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
    s({ trig = "tostring", name = "toString()", dscr = "Override toString" }, fmt([[
        @Override
        public String toString() {{
            return "{}{{" +
                    "{}";
        }}
    ]], { f(filename, {}), i(1, "field=' + field + '\\''") })),

    s({ trig = "equals", name = "equals()", dscr = "Override equals" }, fmt([[
        @Override
        public boolean equals(Object o) {{
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            {} that = ({}) o;
            return Objects.equals({}, that.{});
        }}
    ]], { f(filename, {}), rep(1), i(1, "field"), rep(1) })),

    s({ trig = "hashcode", name = "hashCode()", dscr = "Override hashCode" }, fmt([[
        @Override
        public int hashCode() {{
            return Objects.hash({});
        }}
    ]], { i(1, "field1, field2") })),

    -- Control Flow
    s({ trig = "if", name = "If", dscr = "If block" }, fmt([[
        if ({}) {{
            {}
        }}
    ]], { i(1, "condition"), i(0) })),

    s({ trig = "ifelse", name = "If Else", dscr = "If/Else block" }, fmt([[
        if ({}) {{
            {}
        }} else {{
            {}
        }}
    ]], { i(1, "condition"), i(2, "// if branch"), i(0, "// else branch") })),

    s({ trig = "elseif", name = "Else If", dscr = "Else If connector" }, t({ "} else if (", ") {" })),

    s({ trig = "ternary", name = "Ternary", dscr = "Ternary operator" },
        fmt("{} ? {} : {}", { i(1, "condition"), i(2, "ifTrue"), i(3, "ifFalse") })),

    s({ trig = "switch", name = "Switch", dscr = "Switch Statement" }, fmt([[
        switch ({}) {{
            case {} -> {{}};
            default -> {{}};
        }}
    ]], { i(1, "value"), i(2, "CASE1") })),

    s({ trig = "switchpattern", name = "Switch (Pattern)", dscr = "Pattern matching switch" }, fmt([[
        switch ({}) {{
            case {} {} -> {{}};
            case null, default -> {{}};
        }}
    ]], { i(1, "obj"), i(2, "String"), i(3, "s") })),

    -- Loops
    s({ trig = "for", name = "For Loop", dscr = "Classic for loop" }, fmt([[
        for (int {} = 0; {} < {}; {}++) {{
            {}
        }}
    ]], { i(1, "i"), rep(1), i(2, "length"), rep(1), i(0) })),

    s({ trig = "fore", name = "For Each", dscr = "Enhanced for loop" }, fmt([[
        for ({} {} : {}) {{
            {}
        }}
    ]], { i(1, "Type"), i(2, "item"), i(3, "collection"), i(0) })),

    s({ trig = "while", name = "While", dscr = "While loop" }, fmt([[
        while ({}) {{
            {}
        }}
    ]], { i(1, "condition"), i(0) })),

    s({ trig = "dowhile", name = "Do While", dscr = "Do-while loop" }, fmt([[
        do {{
            {}
        }} while ({});
    ]], { i(1, "// code"), i(2, "condition") })),

    -- Exception Handling
    s({ trig = "try", name = "Try Catch", dscr = "Try/Catch block" }, fmt([[
        try {{
            {}
        }} catch ({} e) {{
            {}
        }}
    ]],
        { i(1, "// code"), c(2, { t("Exception"), t("IOException"), t("RuntimeException") }), i(3,
            "log.error(\"Error\", e);") })),

    s({ trig = "tryres", name = "Try Resources", dscr = "Try-with-resources" }, fmt([[
        try ({} {} = {}) {{
            {}
        }} catch ({} e) {{
            {}
        }}
    ]],
        { i(1, "Resource"), i(2, "resource"), i(3, "new Resource()"), i(4, "// use resource"), i(5, "Exception"), i(0,
            "log.error(\"Error\", e);") })),

    s({ trig = "trycatch", name = "Try/Catch/Finally", dscr = "Full exception handling" }, fmt([[
        try {{
            {}
        }} catch ({} e) {{
            {}
        }} finally {{
            {}
        }}
    ]], { i(1, "// code"), i(2, "Exception"), i(3, "// handle"), i(0, "// cleanup") })),

    s({ trig = "throw", name = "Throw", dscr = "Throw new exception" },
        fmt("throw new {}({});", { i(1, "Exception"), i(2, "\"message\"") })),

    -- Collections
    s({ trig = "list", name = "ArrayList", dscr = "New ArrayList" },
        fmt("List<{}> {} = new ArrayList<>();", { i(1, "String"), i(2, "list") })),
    s({ trig = "set", name = "HashSet", dscr = "New HashSet" },
        fmt("Set<{}> {} = new HashSet<>();", { i(1, "String"), i(2, "set") })),
    s({ trig = "map", name = "HashMap", dscr = "New HashMap" },
        fmt("Map<{}, {}> {} = new HashMap<>();", { i(1, "String"), i(2, "Object"), i(3, "map") })),
    s({ trig = "listof", name = "List.of()", dscr = "Immutable List" },
        fmt("List<{}> {} = List.of({});", { i(1, "String"), i(2, "list"), i(3, "elements") })),
    s({ trig = "setof", name = "Set.of()", dscr = "Immutable Set" },
        fmt("Set<{}> {} = Set.of({});", { i(1, "String"), i(2, "set"), i(3, "elements") })),
    s({ trig = "mapof", name = "Map.of()", dscr = "Immutable Map" },
        fmt("Map<{}, {}> {} = Map.of({}, {});",
            { i(1, "String"), i(2, "Object"), i(3, "map"), i(4, "key"), i(5, "value") })),

    -- Streams
    s({ trig = "stream", name = "Stream", dscr = "Stream pipeline" }, fmt([[
        {}.stream()
                .{}
                .collect(Collectors.toList());
    ]], { i(1, "list"), c(2, {
        fmt("map({} -> {})", { i(1, "item"), i(2, "item.transform()") }),
        fmt("filter({} -> {})", { i(1, "item"), i(2, "item.isValid()") }),
        fmt("sorted(Comparator.comparing({}))", { i(1, "Item::getName") })
    }) })),

    s({ trig = "streammap", name = "Stream Map", dscr = "Stream map collect" },
        fmt("{}.stream().map({} -> {}).collect(Collectors.toList());",
            { i(1, "list"), i(2, "item"), i(3, "item.transform()") })),

    s({ trig = "streamfilter", name = "Stream Filter", dscr = "Stream filter collect" },
        fmt("{}.stream().filter({} -> {}).collect(Collectors.toList());",
            { i(1, "list"), i(2, "item"), i(3, "item.isValid()") })),

    s({ trig = "streamreduce", name = "Stream Reduce", dscr = "Stream reduce" },
        fmt("{}.stream().reduce({}, (a, b) -> {});", { i(1, "list"), i(2, "identity"), i(3, "a + b") })),

    s({ trig = "streamcount", name = "Stream Count", dscr = "Stream count" },
        fmt("long count = {}.stream().filter({} -> {}).count();", { i(1, "list"), i(2, "item"), i(3, "item.isValid()") })),

    -- Optional
    s({ trig = "optional", name = "Optional", dscr = "Optional.ofNullable" },
        fmt("Optional<{}> {} = Optional.ofNullable({});", { i(1, "Type"), i(2, "opt"), i(3, "value") })),
    s({ trig = "optmap", name = "Optional Map", dscr = "Optional map orElse" },
        fmt("{}.map({} -> {}).orElse({});", { i(1, "optional"), i(2, "value"), i(3, "transform"), i(4, "default") })),
    s({ trig = "optor", name = "Optional orElse", dscr = "Optional orElse" },
        fmt("{}.orElse({});", { i(1, "optional"), i(2, "defaultValue") })),
    s({ trig = "optthrow", name = "Optional Throw", dscr = "Optional orElseThrow" },
        fmt("{}.orElseThrow(() -> new {}({}));", { i(1, "optional"), i(2, "Exception"), i(3, "\"message\"") })),

    -- Lambdas & Functional
    s({ trig = "lambda", name = "Lambda", dscr = "Lambda expression" },
        fmt("({}) -> {}", { i(1, "params"), i(2, "expression") })),
    s({ trig = "functional", name = "Functional Interface", dscr = "Functional Interface definition" }, fmt([[
        @FunctionalInterface
        public interface {} {{
            {} {}({});
        }}
    ]], { i(1, "Processor"), i(2, "void"), i(3, "process"), i(4, "Object item") })),

    -- Logging
    s({ trig = "logger", name = "Logger", dscr = "SLF4J Logger definition" },
        fmt("private static final Logger logger = LoggerFactory.getLogger({}.class);", { f(filename, {}) })),
    s({ trig = "logdebug", name = "Log Debug", dscr = "Log debug message" },
        fmt("logger.debug({});", { i(1, "\"Debug message\"") })),
    s({ trig = "loginfo", name = "Log Info", dscr = "Log info message" },
        fmt("logger.info({});", { i(1, "\"Info message\"") })),
    s({ trig = "logwarn", name = "Log Warn", dscr = "Log warning message" },
        fmt("logger.warn({});", { i(1, "\"Warning message\"") })),
    s({ trig = "logerror", name = "Log Error", dscr = "Log error with exception" },
        fmt("logger.error({}, e);", { i(1, "\"Error message\"") })),

    -- Concurrency
    s({ trig = "async", name = "CompletableFuture", dscr = "Async supply/apply/exceptionally" }, fmt([[
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

    s({ trig = "executor", name = "ExecutorService", dscr = "New ThreadPool Executor" },
        fmt("ExecutorService executor = Executors.new{}ThreadPool({});",
            { c(1, { t("Fixed"), t("Cached") }), i(2, "10") })),
    s({ trig = "future", name = "Future", dscr = "Executor submit future" },
        fmt("Future<{}> future = executor.submit(() -> {});", { i(1, "Result"), i(2, "computation") })),

    -- Utilities
    s({ trig = "sout", name = "Println", dscr = "System.out.println", priority = 800 },
        fmt("System.out.println({});", { i(1, "\"message\"") })),
    s({ trig = "soutv", name = "Print Var", dscr = "Print variable value" },
        fmt("System.out.println(\"{} = \" + {});", { rep(1), i(1, "variable") })),
    s({ trig = "soutf", name = "Printf", dscr = "System.out.printf" },
        fmt("System.out.printf(\"{}\", {});", { i(1, "%s%n"), i(2, "args") })),

    s({ trig = "var", name = "Var", dscr = "Local variable inference" },
        fmt("var {} = {};", { i(1, "name"), i(2, "value") })),
    s({ trig = "const", name = "Constant", dscr = "Public static final constant" },
        fmt("public static final {} {} = {};", { i(1, "String"), i(2, "CONSTANT"), i(3, "\"value\"") })),

    s({ trig = "builder", name = "Builder Pattern", dscr = "Static Builder Inner Class" }, fmt([[
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
    s({ trig = "singleton", name = "Singleton", dscr = "Singleton Pattern" }, fmt([[
        private static final {} INSTANCE = new {}();

        private {}() {{}}

        public static {} getInstance() {{
            return INSTANCE;
        }}
    ]], { f(filename, {}), rep(1), rep(1), rep(1) })),

    s({ trig = "copyright", name = "Copyright", dscr = "Copyright Header" }, fmt([[
        /*
         * Copyright (c) {} {}
         * All rights reserved.
         */
    ]], { f(current_year, {}), i(1, "Your Company") })),
}
