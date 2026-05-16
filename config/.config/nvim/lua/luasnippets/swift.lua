local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

return {
    -- MARK: - Protocol
    -- Simple
    s({ trig = "proto", name = "Protocol", dscr = "Empty Protocol" }, fmt(
        [[
protocol {} {{
    {}
}}
        ]], { i(1, "Name"), i(0) }
    )),
    -- Complex
    s({ trig = "protofull", name = "Protocol (Rich)", dscr = "Protocol with associatedtype and func" }, fmt(
        [[
protocol {} {{
    associatedtype {}
    func {}(_ {}) -> {}
}}
        ]], { i(1, "Service"), i(2, "Response"), i(3, "fetch"), i(4, "id: String"), i(5, "Response") }
    )),

    -- MARK: - Struct
    -- Simple
    s({ trig = "struct", name = "Struct", dscr = "Empty Struct" }, fmt(
        [[
struct {} {{
    {}
}}
        ]], { i(1, "Name"), i(0) }
    )),
    -- Complex (Identifiable)
    s({ trig = "structid", name = "Struct (Identifiable)", dscr = "Struct conforming to Identifiable with UUID" }, fmt(
        [[
struct {}: Identifiable {{
    let id = UUID()
    var {}: {}
}}
        ]], { i(1, "Name"), i(2, "name"), i(3, "String") }
    )),
    -- Complex (Codable)
    s({ trig = "structcodable", name = "Struct (Codable)", dscr = "Codable Struct with CodingKeys" }, fmt(
        [[
struct {}: Codable {{
    let {}: {}

    enum CodingKeys: String, CodingKey {{
        case {} = "{}"
    }}
}}
        ]], { i(1, "Response"), i(2, "id"), i(3, "String"), rep(2), i(4, "api_id") }
    )),

    -- MARK: - Class
    -- Simple
    s({ trig = "class", name = "Class", dscr = "Empty Class" }, fmt(
        [[
class {} {{
    {}
}}
        ]], { i(1, "Name"), i(0) }
    )),
    -- Complex (With Init)
    s({ trig = "classinit", name = "Class (Init)", dscr = "Class with properties and initializer" }, fmt(
        [[
class {} {{
    var {}: {}

    init({}: {}) {{
        self.{} = {}
    }}
}}
        ]], { i(1, "Name"), i(2, "name"), i(3, "String"), rep(2), rep(3), rep(2), rep(2) }
    )),
    -- Complex (Singleton)
    s({ trig = "singleton", name = "Singleton", dscr = "Singleton Pattern Class" }, fmt(
        [[
class {} {{
    static let shared = {}()
    private init() {{}}

    func {}() {{
        {}
    }}
}}
        ]], { i(1, "Manager"), rep(1), i(2, "doWork"), i(0) }
    )),

    -- MARK: - Enum
    -- Simple
    s({ trig = "enum", name = "Enum", dscr = "Empty Enum" }, fmt(
        [[
enum {} {{
    case {}
}}
        ]], { i(1, "Name"), i(2, "caseName") }
    )),
    -- Complex (String, CaseIterable)
    s({ trig = "enumfull", name = "Enum (Rich)", dscr = "String-backed CaseIterable Enum" }, fmt(
        [[
enum {}: String, CaseIterable {{
    case {} = "{}"
    case {} = "{}"
}}
        ]], { i(1, "Type"), i(2, "first"), i(3, "First"), i(4, "second"), i(5, "Second") }
    )),

    -- MARK: - Extension
    -- Simple
    s({ trig = "ext", name = "Extension", dscr = "Type Extension" }, fmt(
        [[
extension {} {{
    {}
}}
        ]], { i(1, "Type"), i(0) }
    )),
    -- Complex (Computed Property)
    s({ trig = "extprop", name = "Ext (Computed Prop)", dscr = "Extension with computed property" }, fmt(
        [[
extension {} {{
    var {}: {} {{
        return {}
    }}
}}
        ]], { i(1, "Type"), i(2, "isValid"), i(3, "Bool"), i(4, "true") }
    )),
    -- Complex (Conformance)
    s({ trig = "extconf", name = "Ext (Conformance)", dscr = "Extension with protocol conformance" }, fmt(
        [[
extension {}: {} {{
    func {}(_ {}) -> {} {{
        {}
    }}
}}
        ]], { i(1, "Type"), i(2, "Protocol"), i(3, "requirement"), i(4, "_"), i(5, "Void"), i(0) }
    )),

    -- MARK: - Control Flow
    -- Simple Guard
    s({ trig = "guard", name = "Guard", dscr = "Basic guard statement" }, fmt(
        [[
guard {} else {{ return {} }}
        ]], { i(1, "condition"), i(0) }
    )),
    -- Complex Guard (Print Error)
    s({ trig = "guardlog", name = "Guard (Log)", dscr = "Guard statement with error logging" }, fmt(
        [[
guard let {} = {} else {{
    print("Error: {} not found")
    return {}
}}
        ]], { i(1, "value"), i(2, "optional"), rep(1), i(0) }
    )),

    -- Simple If Let
    s({ trig = "iflet", name = "If Let", dscr = "Basic if let binding" }, fmt(
        [[
if let {} = {} {{
    {}
}}
        ]], { i(1, "x"), i(2, "optional"), i(0) }
    )),
    -- Complex If Let
    s({ trig = "ifletprint", name = "If Let (Print)", dscr = "If let binding with print" }, fmt(
        [[
if let {} = {} {{
    print("Found \({}))
    {}
}}
        ]], { i(1, "value"), i(2, "optional"), rep(1), i(0) }
    )),

    -- MARK: - Concurrency
    -- Simple Task
    s({ trig = "task", name = "Task", dscr = "Basic Task block" }, fmt(
        [[
Task {{
    {}
}}
        ]], { i(0) }
    )),
    -- Complex Task (Do/Catch/Await)
    s({ trig = "taskfull", name = "Task (Do/Catch)", dscr = "Task with do-catch error handling" }, fmt(
        [[
Task {{
    do {{
        let result = try await {}.{}()
        print("Success: \(result)")
    }} catch {{
        print("Error: \(error)")
    }}
}}
        ]], { i(1, "service"), i(2, "fetch") }
    )),

    -- Simple MainActor Task
    s({ trig = "taskm", name = "Task (@MainActor)", dscr = "MainActor Task block" }, fmt(
        [[
Task {{ @MainActor in
    {}
}}
        ]], { i(0) }
    )),
    -- Complex MainActor Task
    s({ trig = "taskmui", name = "Task (UI Update)", dscr = "MainActor Task updating UI state" }, fmt(
        [[
Task {{ @MainActor in
    self.{} = {} // UI Update
}}
        ]], { i(1, "isLoading"), i(2, "false") }
    )),

    -- Simple Actor
    s({ trig = "actor", name = "Actor", dscr = "Empty Actor" }, fmt(
        [[
actor {} {{
    {}
}}
        ]], { i(1, "Name"), i(0) }
    )),
    -- Complex Actor
    s({ trig = "actorfull", name = "Actor (Store)", dscr = "Actor with state store logic" }, fmt(
        [[
actor {} {{
    private var state: {}

    init(state: {}) {{
        self.state = state
    }}

    func update(to newState: {}) {{
        self.state = newState
    }}
}}
        ]], { i(1, "Store"), i(2, "String"), rep(2), rep(2) }
    )),

    -- MARK: - Functions
    -- Simple Func
    s({ trig = "func", name = "Function", dscr = "Basic function definition" }, fmt(
        [[
func {}({}) -> {} {{
    {}
}}
        ]], { i(1, "name"), i(2, "args"), i(3, "Void"), i(0) }
    )),
    -- Complex Async Func
    s({ trig = "funcasync", name = "Function (Async)", dscr = "Async throws function with sleep" }, fmt(
        [[
func {}(_ {}) async throws -> {} {{
    // Simulate latency
    try await Task.sleep(for: .seconds(1))
    return {}
}}
        ]], { i(1, "fetchData"), i(2, "id: String"), i(3, "Data"), i(4, "Data()") }
    )),

    -- MARK: - SwiftUI
    -- Simple View
    s({ trig = "view", name = "SwiftUI View", dscr = "Basic View structure" }, fmt(
        [[
struct {}: View {{
    var body: some View {{
        {}
    }}
}}
        ]], { i(1, "Name"), i(0) }
    )),
    -- Complex View (Demo)
    s({ trig = "viewdemo", name = "View (Demo)", dscr = "View with VStack, Image, Text" }, fmt(
        [[
struct {}: View {{
    var body: some View {{
        VStack(spacing: 20) {{
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, {}!")
                .font(.title)
        }}
        .padding()
    }}
}}
        ]], { i(1, "Name"), rep(1) }
    )),
    -- Complex View (List)
    s({ trig = "viewlist", name = "View (List)", dscr = "View containing a List" }, fmt(
        [[
struct {}: View {{
    let items = ["A", "B", "C"]

    var body: some View {{
        List(items, id: \.self) {{ item in
            Text(item)
        }}
        .navigationTitle("{}")
    }}
}}
        ]], { i(1, "Name"), rep(1) }
    )),

    -- Simple State
    s({ trig = "state", name = "@State", dscr = "State property wrapper" }, fmt(
        [[
@State private var {}: {}
        ]], { i(1, "name"), i(2, "Type") }
    )),
    -- Complex State
    s({ trig = "stateinit", name = "@State (Init)", dscr = "State with initial value" }, fmt(
        [[
@State private var {}: {} = {}
        ]], { i(1, "isLoading"), i(2, "Bool"), i(3, "false") }
    )),

    -- MARK: - Observation
    -- Simple Observable
    s({ trig = "obs", name = "@Observable", dscr = "Observation framework class" }, fmt(
        [[
@Observable class {} {{
    {}
}}
        ]], { i(1, "Name"), i(0) }
    )),
    -- Complex Observable (ViewModel)
    s({ trig = "obsfull", name = "@Observable (VM)", dscr = "Observable ViewModel pattern" }, fmt(
        [[
@Observable
class {} {{
    var {}: {} = {}
    var {}: {} = {}

    func {}() {{
        {}
    }}
}}
        ]], {
            i(1, "ViewModel"),
            i(2, "title"), i(3, "String"), i(4, "\"\""),
            i(5, "items"), i(6, "[String]"), i(7, "[]"),
            i(8, "refresh"), i(0)
        }
    )),

    -- MARK: - SwiftData
    -- Simple Model
    s({ trig = "model", name = "@Model", dscr = "SwiftData Model class" }, fmt(
        [[
@Model class {} {{
    var {}: {}
    init({}: {}) {{ self.{} = {} }}
}}
        ]], { i(1, "Name"), i(2, "prop"), i(3, "Type"), rep(2), rep(3), rep(2), rep(2) }
    )),
    -- Complex Model
    s({ trig = "modelfull", name = "@Model (Full)", dscr = "Full SwiftData Model with UUID" }, fmt(
        [[
@Model
class {} {{
    @Attribute(.unique) var id: UUID
    var {}: {}
    var createdAt: Date

    init({}: {}) {{
        self.id = UUID()
        self.{} = {}
        self.createdAt = .now
    }}
}}
        ]], {
            i(1, "Item"),
            i(2, "name"), i(3, "String"),
            rep(2), rep(3),
            rep(2), rep(2)
        }
    )),

    -- MARK: - Testing
    -- Simple Test
    s({ trig = "test", name = "@Test", dscr = "Swift Testing function" }, fmt(
        [[
@Test func {}() async throws {{
    {}
}}
        ]], { i(1, "name"), i(0) }
    )),
    -- Complex Test
    s({ trig = "testfull", name = "@Test (Expect)", dscr = "Test with expectation" }, fmt(
        [[
@Test func {}() async throws {{
    let {} = {}
    let expected = {}
    #expect({} == expected)
}}
        ]], { i(1, "computationWorks"), i(2, "result"), i(3, "2 + 2"), i(4, "4"), rep(2) }
    )),

    -- Simple Suite
    s({ trig = "suite", name = "@Suite", dscr = "Swift Testing suite struct" }, fmt(
        [[
@Suite struct {}Tests {{
    {}
}}
        ]], { i(1, "Name"), i(0) }
    )),
    -- Complex Suite
    s({ trig = "suitefull", name = "@Suite (Rich)", dscr = "Suite with service mock and tests" }, fmt(
        [[
@Suite("{}")
struct {}Tests {{
    let service = {}()

    @Test func {}() async throws {{
        #expect(service.{}())
    }}
}}
        ]], { i(1, "Feature"), i(2, "Feature"), i(3, "MockService"), i(4, "works"), i(5, "isValid") }
    )),
}
