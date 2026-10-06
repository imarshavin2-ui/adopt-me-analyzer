repeat task.wait() until game:IsLoaded()

--============================================================
-- SERVICES
--============================================================

local Players =
    game:GetService("Players")

local RS =
    game:GetService("ReplicatedStorage")

local HttpService =
    game:GetService("HttpService")

local UIS =
    game:GetService("UserInputService")

local TextChatService =
    game:GetService("TextChatService")

local TeleportService =
    game:GetService("TeleportService")

local MarketplaceService =
    game:GetService("MarketplaceService")

local LocalPlayer =
    Players.LocalPlayer

local PlayerGui =
    LocalPlayer:WaitForChild("PlayerGui")

local ENV =
    type(getgenv) == "function"
    and getgenv()
    or _G


--============================================================
-- VERSION
--============================================================

local VERSION =
    "11.7.32"

local GUI_NAME =
    "AdoptMeTradeAnalyzerV11720"

local BOOT_NAME =
    "AM_ANALYZER_BOOT_V11720"


print(
    "[AM V" .. VERSION .. "] BOOT"
)

print(
    "[AM V" .. VERSION .. "] INVENTORY SUGGEST 3 > 2 > 1 + DEMAND + PROTECTED OUR 3 STAR PETS"
)


--============================================================
-- GUI PARENT
--============================================================

local GuiParent =
    PlayerGui

if type(gethui) == "function" then

    local ok,
        hui =
        pcall(
            gethui
        )

    if ok and hui then
        GuiParent = hui
    end
end


--============================================================
-- REMOVE OLD GUI
--============================================================

local Runtime = {active = true, jobs = {}, connections = {}, cleanups = {}}
do
    local nativeTask = task
    local key = "__AM_ANALYZER_RUNTIME"
    local previous = ENV[key]
    if type(previous) == "table" and type(previous.stop) == "function" then
        pcall(previous.stop, "replaced by a new analyzer")
    end
    ENV[key] = Runtime
    function Runtime.alive()
        return Runtime.active and ENV[key] == Runtime
    end
    function Runtime.stop(reason)
        if not Runtime.active then return end
        Runtime.active = false
        if Runtime.flow then pcall(Runtime.flow.stop, reason or "stopped") end
        for _, connection in ipairs(Runtime.connections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(Runtime.connections)
        for _, cleanup in ipairs(Runtime.cleanups) do pcall(cleanup) end
        table.clear(Runtime.cleanups)
        for thread in pairs(Runtime.jobs) do
            if thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
                pcall(nativeTask.cancel, thread)
            end
        end
        table.clear(Runtime.jobs)
        for _, object in pairs({Runtime.gui, Runtime.boot}) do
            if object then pcall(function() object:Destroy() end) end
        end
        if ENV[key] == Runtime then ENV[key] = nil end
    end
    function Runtime.connect(signal, callback)
        local connection = signal:Connect(function(...)
            if Runtime.alive() then return callback(...) end
        end)
        Runtime.connections[#Runtime.connections + 1] = connection
        return connection
    end
    local function launch(method, delay, fn, ...)
        local args = table.pack(...)
        local function run()
            if Runtime.alive() then fn(table.unpack(args, 1, args.n)) end
            Runtime.jobs[coroutine.running()] = nil
        end
        local thread
        if delay ~= nil then thread = nativeTask.delay(delay, run)
        else thread = nativeTask[method](run) end
        if type(thread) == "thread" and coroutine.status(thread) ~= "dead" then
            Runtime.jobs[thread] = true
        end
        return thread
    end
    Runtime.task = setmetatable({
        spawn = function(fn, ...) return launch("spawn", nil, fn, ...) end,
        defer = function(fn, ...) return launch("defer", nil, fn, ...) end,
        delay = function(seconds, fn, ...) return launch("delay", seconds, fn, ...) end,
    }, {__index = nativeTask})
end


local OLD_GUI_NAMES = {
    GUI_NAME,
    BOOT_NAME,

    "AdoptMeTradeAnalyzerV11",
    "AdoptMeTradeAnalyzerV111",
    "AdoptMeTradeAnalyzerV112",
    "AdoptMeTradeAnalyzerV113",
    "AdoptMeTradeAnalyzerV114",
    "AdoptMeTradeAnalyzerV115",
    "AdoptMeTradeAnalyzerV1151",
    "AdoptMeTradeAnalyzerV1152",
    "AdoptMeTradeAnalyzerV1153",
    "AdoptMeTradeAnalyzerV1160",
    "AdoptMeTradeAnalyzerV1161",
    "AdoptMeTradeAnalyzerV1162",
    "AdoptMeTradeAnalyzerV1170",
    "AdoptMeTradeAnalyzerV1171",
    "AdoptMeTradeAnalyzerV1172",
    "AdoptMeTradeAnalyzerV1173",
    "AdoptMeTradeAnalyzerV1175",
    "AdoptMeTradeAnalyzerV1176",
    "AdoptMeTradeAnalyzerV1177",
    "AdoptMeTradeAnalyzerV1178",
    "AdoptMeTradeAnalyzerV1179",
    "AdoptMeTradeAnalyzerV11710",
    "AdoptMeTradeAnalyzerV11711",
    "AdoptMeTradeAnalyzerV11712",
    "AdoptMeTradeAnalyzerV11713",
    "AdoptMeTradeAnalyzerV11714",
    "AdoptMeTradeAnalyzerV11715",
    "AdoptMeTradeAnalyzerV11716",
    "AdoptMeTradeAnalyzerV11717",
    "AdoptMeTradeAnalyzerV11718",
    "AdoptMeTradeAnalyzerV11719",

    "AM_ANALYZER_BOOT_V1153",
    "AM_ANALYZER_BOOT_V1160",
    "AM_ANALYZER_BOOT_V1161",
    "AM_ANALYZER_BOOT_V1162",
    "AM_ANALYZER_BOOT_V1170",
    "AM_ANALYZER_BOOT_V1171",
    "AM_ANALYZER_BOOT_V1172",
    "AM_ANALYZER_BOOT_V1173",
    "AM_ANALYZER_BOOT_V1175",
    "AM_ANALYZER_BOOT_V1176",
    "AM_ANALYZER_BOOT_V1177",
    "AM_ANALYZER_BOOT_V1178",
    "AM_ANALYZER_BOOT_V1179",
    "AM_ANALYZER_BOOT_V11710",
    "AM_ANALYZER_BOOT_V11711",
    "AM_ANALYZER_BOOT_V11712",
    "AM_ANALYZER_BOOT_V11713",
    "AM_ANALYZER_BOOT_V11714",
    "AM_ANALYZER_BOOT_V11715",
    "AM_ANALYZER_BOOT_V11716",
    "AM_ANALYZER_BOOT_V11717",
    "AM_ANALYZER_BOOT_V11718",
    "AM_ANALYZER_BOOT_V11719",
}


for _, parent in ipairs({GuiParent, PlayerGui}) do
    for _, object in ipairs(parent:GetChildren()) do
        if table.find(OLD_GUI_NAMES, object.Name) then object:Destroy() end
    end
end


--============================================================
-- COLORS
--============================================================

local C = {

    BG =
        Color3.fromRGB(
            13,
            15,
            20
        ),

    TOP =
        Color3.fromRGB(
            23,
            26,
            34
        ),

    SIDE =
        Color3.fromRGB(
            19,
            22,
            29
        ),

    PANEL =
        Color3.fromRGB(
            25,
            28,
            36
        ),

    PANEL2 =
        Color3.fromRGB(
            30,
            34,
            43
        ),

    SLOT =
        Color3.fromRGB(
            38,
            42,
            53
        ),

    TEXT =
        Color3.fromRGB(
            242,
            244,
            250
        ),

    MUTED =
        Color3.fromRGB(
            145,
            154,
            173
        ),

    ACCENT =
        Color3.fromRGB(
            78,
            132,
            255
        ),

    GREEN =
        Color3.fromRGB(
            76,
            215,
            82
        ),

    RED =
        Color3.fromRGB(
            235,
            80,
            94
        ),

    YELLOW =
        Color3.fromRGB(
            244,
            190,
            72
        ),

    PURPLE =
        Color3.fromRGB(
            218,
            95,
            255
        ),

    ORANGE =
        Color3.fromRGB(
            255,
            153,
            72
        ),
}


--============================================================
-- UI HELPERS
--============================================================

local function corner(
    object,
    radius
)

    local value =
        Instance.new(
            "UICorner"
        )

    value.CornerRadius =
        UDim.new(
            0,
            radius or 8
        )

    value.Parent =
        object

    return value
end


local function stroke(
    object,
    transparency
)

    local value =
        Instance.new(
            "UIStroke"
        )

    value.Color =
        Color3.fromRGB(
            58,
            64,
            78
        )

    value.Transparency =
        transparency
        or 0.35

    value.Thickness =
        1

    value.Parent =
        object

    return value
end


local function label(
    parent,
    text,
    size,
    position,
    font,
    textSize,
    color,
    alignment
)

    local value =
        Instance.new(
            "TextLabel"
        )

    value.BackgroundTransparency =
        1

    value.Size =
        size

    value.Position =
        position

    value.Text =
        text or ""

    value.Font =
        font
        or Enum.Font.Gotham

    value.TextSize =
        textSize
        or 14

    value.TextColor3 =
        color
        or C.TEXT

    value.TextXAlignment =
        alignment
        or Enum.TextXAlignment.Left

    value.TextYAlignment =
        Enum.TextYAlignment.Center

    value.Parent =
        parent

    return value
end


local function button(
    parent,
    text,
    size,
    position
)

    local value =
        Instance.new(
            "TextButton"
        )

    value.Size =
        size

    value.Position =
        position

    value.BackgroundColor3 =
        C.PANEL2

    value.BorderSizePixel =
        0

    value.Text =
        text or ""

    value.TextColor3 =
        C.TEXT

    value.Font =
        Enum.Font.GothamBold

    value.TextSize =
        11

    value.AutoButtonColor =
        true

    value.Parent =
        parent

    corner(
        value,
        7
    )

    return value
end


local function textBox(
    parent,
    text,
    placeholder,
    size,
    position
)

    local value =
        Instance.new(
            "TextBox"
        )

    value.Size =
        size

    value.Position =
        position

    value.BackgroundColor3 =
        C.PANEL2

    value.BorderSizePixel =
        0

    value.Text =
        tostring(
            text or ""
        )

    value.PlaceholderText =
        placeholder
        or ""

    value.PlaceholderColor3 =
        C.MUTED

    value.TextColor3 =
        C.TEXT

    value.Font =
        Enum.Font.Code

    value.TextSize =
        11

    value.ClearTextOnFocus =
        false

    value.Parent =
        parent

    corner(
        value,
        7
    )

    return value
end


local function makeScroll(
    parent,
    size,
    position
)

    local value =
        Instance.new(
            "ScrollingFrame"
        )

    value.Size =
        size

    value.Position =
        position

    value.BackgroundColor3 =
        C.PANEL

    value.BorderSizePixel =
        0

    value.CanvasSize =
        UDim2.fromOffset(
            0,
            0
        )

    value.AutomaticCanvasSize =
        Enum.AutomaticSize.Y

    value.ScrollBarThickness =
        5

    value.Parent =
        parent

    corner(
        value,
        8
    )

    return value
end


local function addListLayout(
    parent,
    padding
)

    local layout =
        Instance.new(
            "UIListLayout"
        )

    layout.Padding =
        UDim.new(
            0,
            padding or 5
        )

    layout.SortOrder =
        Enum.SortOrder.LayoutOrder

    layout.Parent =
        parent


    local pad =
        Instance.new(
            "UIPadding"
        )

    pad.PaddingTop =
        UDim.new(
            0,
            7
        )

    pad.PaddingBottom =
        UDim.new(
            0,
            7
        )

    pad.PaddingLeft =
        UDim.new(
            0,
            7
        )

    pad.PaddingRight =
        UDim.new(
            0,
            7
        )

    pad.Parent =
        parent

    return layout
end


--============================================================
-- BASIC HELPERS
--============================================================

local function num(value)
    local result = type(value) == "number" and value or tonumber(value)
    if result == nil or result ~= result or math.abs(result) == math.huge then return nil end
    return result
end

local function round(value, decimals)
    value = num(value)
    if value == nil then return nil end
    decimals = math.clamp(math.floor(tonumber(decimals) or 6), 0, 12)
    if value == 0 then return 0 end
    -- AMVGG passes a JS Number to big.js; decimal rounding must use the
    -- shortest representation that round-trips to that same double.
    local absolute = math.abs(value)
    local text = string.format("%.17g", absolute)
    for precision = 1, 16 do
        local candidate = string.format("%." .. precision .. "g", absolute)
        if tonumber(candidate) == absolute then text = candidate break end
    end
    local mantissa, exponent = text:match("^([^eE]+)[eE]([+-]?%d+)$")
    mantissa, exponent = mantissa or text, tonumber(exponent) or 0
    local point = mantissa:find(".", 1, true)
    local digits = mantissa:gsub("%.", "")
    local keep = (point and point - 1 or #mantissa) + exponent + decimals
    local retained, nextDigit
    if keep < 0 then return 0 end
    if keep == 0 then
        retained, nextDigit = "0", tonumber(digits:sub(1, 1)) or 0
    elseif keep >= #digits then
        return value
    else
        retained, nextDigit = digits:sub(1, keep), tonumber(digits:sub(keep + 1, keep + 1)) or 0
    end
    local rounded = tonumber(retained) or 0
    if nextDigit >= 5 then rounded += 1 end
    return (value < 0 and -rounded or rounded) / (10 ^ decimals)
end


local function valueText(value)

    if type(value) ~= "number" then
        return "?"
    end

    if
        math.abs(value)
        < 0.000000001
    then

        return "0"
    end

    local text

    if
        math.abs(value)
        >= 100
    then

        text =
            string.format(
                "%.2f",
                value
            )

    elseif
        math.abs(value)
        >= 1
    then

        text =
            string.format(
                "%.4f",
                value
            )

    else

        text =
            string.format(
                "%.6f",
                value
            )
    end

    text =
        text:gsub(
            "0+$",
            ""
        )

    text =
        text:gsub(
            "%.$",
            ""
        )

    return text
end


local function normalize(text)

    text =
        tostring(
            text
            or ""
        )

    text =
        text:lower()

    text =
        text:gsub(
            "’",
            "'"
        )

    text =
        text:gsub(
            "&",
            "and"
        )

    text =
        text:gsub(
            "[^%w]",
            ""
        )

    return text
end


local function aliases(text)

    local result =
        {}

    local function add(value)

        local key =
            normalize(
                value
            )

        if key ~= "" then
            result[key] = true
        end
    end

    local original =
        tostring(
            text
            or ""
        )

    add(
        original
    )

    add(
        original:gsub(
            "%b()",
            ""
        )
    )

    add(
        original:gsub(
            "Chocobunny",
            "Choccybunny"
        )
    )

    add(
        original:gsub(
            "Choccybunny",
            "Chocobunny"
        )
    )

    add(
        original:gsub(
            "%-",
            " "
        )
    )

    return result
end


local function shallowCopy(source)

    local result =
        {}

    if type(source) ~= "table" then
        return result
    end

    for key,
        value in pairs(
            source
        )
    do

        result[key] =
            value
    end

    return result
end


--============================================================
-- BOOT GUI
--============================================================

local BootGui =
    Instance.new(
        "ScreenGui"
    )

BootGui.Name =
    BOOT_NAME

BootGui.ResetOnSpawn =
    false

BootGui.DisplayOrder =
    1000000

BootGui.Parent =
    GuiParent
Runtime.boot = BootGui


local BootFrame =
    Instance.new(
        "Frame"
    )

BootFrame.Size =
    UDim2.fromOffset(
        520,
        86
    )

BootFrame.Position =
    UDim2.new(
        0.5,
        -260,
        0,
        90
    )

BootFrame.BackgroundColor3 =
    C.TOP

BootFrame.BorderSizePixel =
    0

BootFrame.Parent =
    BootGui


corner(
    BootFrame,
    10
)


stroke(
    BootFrame,
    0.2
)


local BootText =
    label(
        BootFrame,
        "",
        UDim2.new(
            1,
            -20,
            1,
            -12
        ),
        UDim2.fromOffset(
            10,
            6
        ),
        Enum.Font.Code,
        13,
        C.TEXT
    )

BootText.TextWrapped =
    true


local function setBoot(
    step,
    text,
    errorState
)

    BootText.Text =
        "ADOPT ME ANALYZER V"
        .. VERSION
        .. "\n"
        .. tostring(step)
        .. "  "
        .. tostring(text)

    BootText.TextColor3 =
        errorState
        and C.RED
        or C.TEXT

    print(
        "[AM V"
        .. VERSION
        .. "]",
        step,
        text
    )
end


local function traceback(errorMessage)

    local result =
        tostring(
            errorMessage
        )

    if
        debug
        and type(
            debug.traceback
        ) == "function"
    then

        local ok,
            trace =
            pcall(
                debug.traceback
            )

        if ok then

            result =
                result
                .. "\n"
                .. tostring(
                    trace
                )
        end
    end

    return result
end


--============================================================
-- ADOPT ME MODULES
--============================================================

setBoot(
    "1/9",
    "LOADING ADOPT ME"
)


local Fsys
local ClientData
local ItemDB
local RouterClient


do

    local ok,
        err =
        xpcall(
            function()

                Fsys =
                    require(
                        RS:
                        WaitForChild(
                            "Fsys"
                        )
                    )

                assert(
                    type(Fsys)
                    == "table",
                    "Fsys invalid"
                )

                assert(
                    type(Fsys.load)
                    == "function",
                    "Fsys.load missing"
                )

                ClientData =
                    Fsys.load(
                        "ClientData"
                    )

                ItemDB =
                    Fsys.load(
                        "ItemDB"
                    )

                pcall(
                    function()

                        RouterClient =
                            Fsys.load(
                                "RouterClient"
                            )
                    end
                )

                assert(
                    type(ClientData)
                    == "table",
                    "ClientData invalid"
                )

                assert(
                    type(ItemDB)
                    == "table",
                    "ItemDB invalid"
                )
            end,

            traceback
        )

    if not ok then

        setBoot(
            "ERROR",
            err,
            true
        )

        return
    end
end


setBoot(
    "2/9",
    "CLIENT DATA OK"
)


--============================================================
-- ITEM DB
--============================================================

local CATEGORY_DISPLAY = {

    pets =
        "PET",

    pet_accessories =
        "PET WEAR",

    strollers =
        "STROLLER",

    food =
        "FOOD",

    vehicles =
        "VEHICLE",

    toys =
        "TOY",

    gifts =
        "GIFT",

    stickers =
        "STICKER",

    houses =
        "HOUSE",
}


local ADOPT_TO_AMVGG = {
    transport = "vehicles",

    pet_accessories =
        "petwear",

    strollers =
        "strollers",

    food =
        "food",

    vehicles =
        "vehicles",

    toys =
        "toys",

    gifts =
        "gifts",

    stickers =
        "stickers",

    houses =
        "houses",
}


local function getItemDB(item)

    if type(item) ~= "table" then
        return nil
    end

    local category =
        ItemDB[
            item.category
        ]

    if type(category) ~= "table" then
        return nil
    end

    return
        category[
            item.kind
        ]
end


local function getItemName(item)

    if type(item) ~= "table" then
        return "Unknown Item"
    end

    local db =
        getItemDB(
            item
        )

    if type(db) == "table" then

        if db.name then

            return
                tostring(
                    db.name
                )
        end

        if db.display_name then

            return
                tostring(
                    db.display_name
                )
        end
    end

    return
        tostring(
            item.kind
            or item.name
            or "Unknown Item"
        )
end


local function getCategoryDisplay(item)

    local category =
        tostring(
            item
            and item.category
            or "unknown"
        )

    return
        CATEGORY_DISPLAY[
            category
        ]
        or category:upper()
end


--============================================================
-- PET VARIANT
--============================================================

local function getVariant(item)
    if type(item) ~= "table" or item.category ~= "pets" then
        return ""
    end

    local p =
        type(item.properties) == "table"
        and item.properties
        or {}

    local F = p.flyable == true
    local R = p.rideable == true
    local N = p.neon == true
    local M = p.mega_neon == true

    if M then
        if F and R then
            return "MFR"
        end

        if F then
            return "MF"
        end

        if R then
            return "MR"
        end

        return "M"
    end

    if N then
        if F and R then
            return "NFR"
        end

        if F then
            return "NF"
        end

        if R then
            return "NR"
        end

        return "N"
    end

    if F and R then
        return "FR"
    end

    if F then
        return "F"
    end

    if R then
        return "R"
    end

    return "NP"
end


--============================================================
-- PET TRADE FILTER
--============================================================
-- Incoming-side rules:
--   1) ANY plain Neon/Mega (variant N or M) without Fly/Ride is ignored.
--   2) Plain NP pets from Common rarity OR the custom junk list below
--      are ignored without Fly/Ride.
--   3) Any potion variant is counted normally.
-- Our-side rules:
--   Common/custom-junk pets are still counted and can be selected by
--   the optimizer so the account can get rid of them faster.
local CommonPetFilter = {}

do
    local commonNames = {
        ["buffalo"] = true,
        ["cat"] = true,
        ["dog"] = true,
        ["otter"] = true,
        ["chicken"] = true,
        ["robin"] = true,
        ["bandicoot"] = true,
        ["chick"] = true,
        ["tasmanian tiger"] = true,
        ["ground sloth"] = true,
        ["stingray"] = true,
        ["wolpertinger"] = true,
        ["walrus"] = true,
        ["bullfrog"] = true,
        ["ant"] = true,
        ["mouse"] = true,
        ["dugong"] = true,
        ["sado mole"] = true,
        ["bali starling"] = true,
        ["malayan tapir"] = true,
        ["malaysian tapir"] = true,
        ["maleo bird"] = true,
        ["liger"] = true,
        ["mosquito"] = true,
        ["piranha"] = true,
        ["flying fish"] = true,
        ["bluebottle fly"] = true,
        ["mongoose"] = true,
        ["cockroach"] = true,
        ["beluga whale"] = true,
        ["beluga"] = true,
        ["armadillo"] = true,
        ["coyote"] = true,
        ["sandfish"] = true,
        ["brachiosaurus"] = true,
        ["garden snake"] = true,
        ["classic teapot"] = true,
        ["kid goat"] = true,
        ["show pony"] = true,
        ["urchin"] = true,
        ["frankenfeline"] = true,
        ["ratatoskr"] = true,
        ["hopbop"] = true,
        ["bakeneko"] = true,
        ["burtaur"] = true,
        ["blue butterfly"] = true,
        ["island tarsier"] = true,
        ["tegu"] = true,
        ["aye aye"] = true,
        ["japanese snow fairy"] = true,
        ["california condor"] = true,
        ["galapagos sea lion"] = true,
        ["jiggly jerboa"] = true,
        ["rubber ducky"] = true,
        ["dirty ducky"] = true,
        ["red panda ducky"] = true,
        ["gecko ducky"] = true,
        ["sheepdog ducky"] = true,
        ["ghost"] = true,
        ["angelfish"] = true,
        ["ash zebra"] = true,
        ["forest sprite"] = true,
        ["ms. muffet"] = true,
        ["ms muffet"] = true,
        ["pinkypillar"] = true,
    }

    -- Extra pets the user does not want to receive as plain NP.
    -- Keep aliases for likely spelling variants so matching stays robust.
    local customUnwantedNames = {
        ["cat"] = true,
        ["tegu"] = true,
        ["buffalo"] = true,
        ["beaver"] = true,
        ["bunny"] = true,
        ["dog"] = true,
        ["snow cat"] = true,
        ["zebra"] = true,
        ["tree frog"] = true,
        ["donkey"] = true,
        ["fennec fox"] = true,
        ["fennex fox"] = true,
        ["chocolate labrador"] = true,
        ["orangutan"] = true,
        ["rabbit"] = true,
        ["puma"] = true,
        ["mouse"] = true,
        ["otter"] = true,
        ["snow puma"] = true,
        ["camel"] = true,
        ["ant"] = true,
        ["crimson cape"] = true,
        ["granny wolf"] = true,
        ["clumpty"] = true,
    }

    -- Ignore these eggs only on THEIR side; OUR copies still count normally.
    local ignoredIncomingEggNames = {
        ["cracked egg"]=true, ["basic egg"]=true, ["pet egg"]=true, ["fairytale egg"]=true,
        ["endangered egg"]=true, ["retired egg"]=true, ["throwback egg"]=true, ["royal egg"]=true,
        ["aztec egg"]=true, ["admin abuse egg"]=true, ["crystal egg"]=true, ["moon egg"]=true,
        ["garden egg"]=true, ["royal fairytale egg"]=true,
    }

    -- Match the same normalized names used by the filter lookups.
    for _, names in ipairs({commonNames, customUnwantedNames, ignoredIncomingEggNames}) do
        for name, enabled in pairs(table.clone(names)) do
            names[normalize(name)] = enabled
        end
    end

    local function rarityText(value)
        if type(value) == "string" then
            return value:lower()
        end

        if type(value) == "table" then
            local nested =
                value.name
                or value.Name
                or value.value
                or value.Value

            if type(nested) == "string" then
                return nested:lower()
            end
        end

        return nil
    end

    function CommonPetFilter.isCommon(item)
        if
            type(item) ~= "table"
            or tostring(item.category or "") ~= "pets"
        then
            return false
        end

        local p =
            type(item.properties) == "table"
            and item.properties
            or {}

        local candidates = {
            item.rarity,
            item.pet_rarity,
            item.petRarity,
            item.rarity_name,
            item.rarityName,
            p.rarity,
            p.pet_rarity,
            p.petRarity,
            p.rarity_name,
            p.rarityName,
        }

        for index = 1, 10 do
            local value = candidates[index]
            local rarity = rarityText(value)

            if rarity == "common" then
                return true
            end

            if
                rarity
                and rarity ~= ""
                and rarity ~= "unknown"
            then
                return false
            end
        end

        local name =
            normalize(
                getItemName(item)
            )

        return commonNames[name] == true
    end

    function CommonPetFilter.isCustomUnwanted(item)
        if
            type(item) ~= "table"
            or tostring(item.category or "") ~= "pets"
        then
            return false
        end

        local name =
            normalize(
                getItemName(item)
            )

        return customUnwantedNames[name] == true
    end

    function CommonPetFilter.isBaseUnwanted(item)
        return
            CommonPetFilter.isCommon(item)
            or CommonPetFilter.isCustomUnwanted(item)
    end

    function CommonPetFilter.hasPotion(item)
        if type(item) ~= "table" then
            return false
        end

        local p =
            type(item.properties) == "table"
            and item.properties
            or {}

        return
            p.flyable == true
            or p.rideable == true
    end

    function CommonPetFilter.isIgnoredIncomingEgg(item)
        return type(item) == "table"
            and ignoredIncomingEggNames[normalize(getItemName(item))] == true
    end

    function CommonPetFilter.shouldIgnoreIncoming(item)
        if
            type(item) ~= "table"
            or tostring(item.category or "") ~= "pets"
            or CommonPetFilter.hasPotion(item)
        then
            return false, nil
        end

        local variant =
            getVariant(item)

        -- Global rule: plain Neon/Mega without potion is worthless to us.
        if variant == "N" or variant == "M" then
            return true, "PLAIN " .. variant .. " NO F/R"
        end

        -- Plain NP is ignored only for Common/custom junk names.
        if
            variant == "NP"
            and CommonPetFilter.isBaseUnwanted(item)
        then
            return true, "UNWANTED NP NO F/R"
        end

        return false, nil
    end

    function CommonPetFilter.shouldBypassOurMinimum(item)
        return CommonPetFilter.isBaseUnwanted(item)
    end
end

-- Exact hard block: this item is never counted or accepted on either side.
local HARD_BLOCKED_ITEMS = {
    trikestroller = true,
}

local function isHardBlockedItem(item)
    return HARD_BLOCKED_ITEMS[normalize(getItemName(item))] == true
end

local function variantColor(v)
    if v:find("M", 1, true) then
        return C.PURPLE
    end

    if v:find("N", 1, true) then
        return C.GREEN
    end

    if v ~= "" and v ~= "NP" then
        return C.ACCENT
    end

    return C.GREEN
end


--============================================================
-- HTTP
--============================================================

local REQUEST =

    rawget(
        ENV,
        "request"
    )

    or rawget(
        ENV,
        "http_request"
    )


if
    not REQUEST
    and syn
then

    REQUEST =
        syn.request
end


if
    not REQUEST
    and http
then

    REQUEST =
        http.request
end


local function httpGet(
    url,
    headers
)

    if type(REQUEST) == "function" then

        local ok,
            response =
            pcall(
                REQUEST,
                {
                    Url = url,
                    URL = url,
                    Method = "GET",
                    Headers =
                        headers
                        or {},
                }
            )

        if ok then

            if
                type(response)
                == "string"
            then

                return
                    response,
                    200
            end

            if
                type(response)
                == "table"
            then

                return

                    response.Body
                    or response.body,

                    tonumber(
                        response.StatusCode
                        or response.Status
                        or response.status_code
                    )
                    or 0
            end
        end
    end

    local ok,
        body =
        pcall(
            function()

                return
                    game:HttpGet(
                        url,
                        true
                    )
            end
        )

    if ok then

        return
            body,
            200
    end

    return
        nil,
        0
end


--============================================================
-- JSON EXTRACT
--============================================================

local function extractObject(
    body,
    startPosition
)

    local depth =
        0

    local inString =
        false

    local escaped =
        false

    for i =
        startPosition,
        #body
    do

        local byte =
            string.byte(
                body,
                i
            )

        if inString then

            if escaped then

                escaped =
                    false

            elseif byte == 92 then

                escaped =
                    true

            elseif byte == 34 then

                inString =
                    false
            end

        else

            if byte == 34 then

                inString =
                    true

            elseif byte == 123 then

                depth =
                    depth
                    + 1

            elseif byte == 125 then

                depth =
                    depth
                    - 1

                if depth == 0 then

                    return

                        body:sub(
                            startPosition,
                            i
                        ),

                        i
                end
            end
        end
    end

    return nil
end


--============================================================
-- AMVGG PARSER
--============================================================

local function validEntry(object)

    if
        type(object)
            ~= "table"
        or type(
            object.name
        ) ~= "string"
    then

        return false
    end

    return

        object.value
            ~= nil

        or object.regularValue
            ~= nil

        or object.neonValue
            ~= nil

        or object.megaValue
            ~= nil

        or object.npRegularValue
            ~= nil

        or object.npNeonValue
            ~= nil

        or object.npMegaValue
            ~= nil

        or object.fValue
            ~= nil

        or object.rValue
            ~= nil

        or object.frValue
            ~= nil
end


local function merge(
    target,
    source
)

    for key,
        value in pairs(
            source
        )
    do

        if value ~= nil then

            target[key] =
                value
        end
    end
end


function Runtime.decodeAMVGGBody(body)
    local chunks = {}
    for start in body:gmatch('self%.__next_f%.push%(%s*%[%s*1%s*,%s*()"') do
        local escaped = false
        for index = start + 1, #body do
            local byte = body:byte(index)
            if escaped then
                escaped = false
            elseif byte == 92 then
                escaped = true
            elseif byte == 34 then
                local ok, chunk = pcall(function()
                    return HttpService:JSONDecode(body:sub(start, index))
                end)
                if ok and type(chunk) == "string" then chunks[#chunks + 1] = chunk end
                break
            end
        end
    end
    return #chunks > 0 and table.concat(chunks) or body
end

local function parseBody(body)
    local database, count = {}, 0
    if type(body) ~= "string" then return database, count end
    body = Runtime.decodeAMVGGBody(body)
    local cursor, scanned = 1, 0
    while cursor <= #body do
        -- Allow whitespace and a different first property. Invalid containers
        -- are traversed so that nested catalog entries are still discovered.
        local position = body:find('{%s*"[^"\\]+"%s*:', cursor)
        if not position then break end
        local jsonText, ending = extractObject(body, position)
        local ok, object = false, nil
        if jsonText then
            ok, object = pcall(function() return HttpService:JSONDecode(jsonText) end)
        end
        if ok and validEntry(object) then
            local key = normalize(object.name)
            if key ~= "" then
                local previous = database[key]
                if not previous then
                    database[key], count = shallowCopy(object), count + 1
                elseif not previous.__ambiguous then
                    if previous.id ~= nil and object.id ~= nil and tostring(previous.id) ~= tostring(object.id) then
                        database[key] = {name = object.name, __ambiguous = true}
                    else
                        merge(previous, object)
                    end
                end
            end
            cursor = ending + 1
        else
            cursor = position + 1
        end
        scanned += 1
        if scanned % 200 == 0 then
            Runtime.task.wait()
            if not Runtime.alive() then return {}, 0 end
        end
    end
    return database, count
end


--============================================================
-- AMVGG
--============================================================

local AMVGG = {

    loading =
        false,

    ready =
        false,

    error =
        nil,

    version =
        0,

    categories =
        {},

    counts =
        {},

    total =
        0,

    lastRefresh =
        0,
}


local CATEGORY_URLS = {

    "pets",
    "eggs",
    "petwear",
    "strollers",
    "food",
    "vehicles",
    "toys",
    "gifts",
    "stickers",
    "houses",
}


local function loadCategory(slug)

    local token =
        tostring(
            os.time()
        )
        .. tostring(
            math.random(
                100000,
                999999
            )
        )

    local attempts = {

        {
            url =
                "https://amvgg.com/values/"
                .. slug
                .. "?_rsc="
                .. token,

            headers = {
                ["RSC"] =
                    "1",
            },
        },

        {
            url =
                "https://amvgg.com/values/"
                .. slug
                .. "?v="
                .. token,

            headers =
                {},
        },

        {
            url =
                "https://amvgg.com/values/"
                .. slug,

            headers =
                {},
        },
    }

    local bestDatabase =
        {}

    local bestCount =
        0

    local lastStatus =
        0

    for _,
        attempt in ipairs(
            attempts
        )
    do

        local body,
            status =
            httpGet(
                attempt.url,
                attempt.headers
            )

        lastStatus =
            status

        if
            status >= 200
            and status < 400
            and type(body)
                == "string"
        then

            local database,
                count =
                parseBody(
                    body
                )

            if count > bestCount and Runtime.catalogComplete(slug, database, count) then

                bestDatabase =
                    database

                bestCount =
                    count
            end

            -- Read all supported response formats; a tiny partial result is not completion.
        end

        Runtime.task.wait(
            0.12
        )
    end

    return
        bestDatabase,
        bestCount,
        lastStatus
end


local function refresh()
    if AMVGG.loading or not Runtime.alive() then return false end
    AMVGG.loading = true
    local ok, snapshot, failure = pcall(function()
        local categories, counts, total, failed = {}, {}, 0, {}
        for _, slug in ipairs(CATEGORY_URLS) do
            local database, count, status = loadCategory(slug)
            if not Runtime.alive() then return nil, "SESSION STOPPED" end
            if not Runtime.catalogComplete(slug, database, count) then
                failed[#failed + 1] = slug .. "(" .. tostring(status) .. ")"
            else
                categories[slug], counts[slug] = database, count
                total += count
            end
            Runtime.task.wait()
        end
        -- Commit a complete snapshot atomically. A partial update must not
        -- erase good categories or mix price generations in one decision.
        if #failed > 0 or total <= 0 then
            return nil, "REFRESH FAILED: " .. table.concat(failed, ", ")
        end
        return {categories = categories, counts = counts, total = total}
    end)
    AMVGG.loading = false
    if not Runtime.alive() then return false end
    if not ok or not snapshot then
        AMVGG.error = tostring(ok and failure or snapshot)
        AMVGG.dataStale = true
        return false
    end
    AMVGG.categories, AMVGG.counts, AMVGG.total = snapshot.categories, snapshot.counts, snapshot.total
    AMVGG.ready, AMVGG.dataStale, AMVGG.error = true, false, nil
    AMVGG.version += 1
    AMVGG.lastRefresh = os.time()
    return true
end


--============================================================
-- AMVGG LOOKUP
--============================================================

local function findCategory(slug, itemName)
    local category = AMVGG.categories[slug]
    if type(category) ~= "table" then return nil end
    local exact = normalize(itemName)
    local function valid(entry)
        return type(entry) == "table" and not entry.__ambiguous and type(entry.name) == "string"
    end
    local direct = category[exact]
    if type(direct) == "table" and direct.__ambiguous then return nil end
    if valid(direct) and normalize(direct.name) == exact then return direct, exact end
    local found, foundKey
    for key, entry in pairs(category) do
        if valid(entry) and normalize(entry.name) == exact then
            if found and found ~= entry then return nil end
            found, foundKey = entry, key
        end
    end
    if found then return found, foundKey end
    local wanted = aliases(itemName)
    for key, entry in pairs(category) do
        if valid(entry) then
            local names = aliases(entry.name)
            local matches = false
            for name in pairs(wanted) do if names[name] then matches = true break end end
            if matches then
                if found and found ~= entry then return nil end
                found, foundKey = entry, key
            end
        end
    end
    return found, foundKey
end

-- Read-only baseline verified against all ten public AMVGG catalogs on 2026-10-06.
Runtime.catalogMinimum = {pets=786, eggs=44, petwear=237, strollers=35, food=51,
    vehicles=199, toys=93, gifts=32, stickers=71, houses=37}
function Runtime.catalogComplete(slug, database, count)
    if type(database) ~= "table" or not num(count) or count % 1 ~= 0 then return false end
    local actual = 0
    for _, entry in pairs(database) do
        if type(entry) ~= "table" or type(entry.name) ~= "string" or entry.__ambiguous then return false end
        actual += 1
    end
    if count ~= actual or count < math.max(1, Runtime.catalogMinimum[slug] or 1, (AMVGG.counts or {})[slug] or 0) then return false end
    -- A partial response must not silently erase previously verified cards.
    for key, previous in pairs(AMVGG.categories[slug] or {}) do
        local entry = database[key]
        if not entry or (previous.id ~= nil and tostring(previous.id) ~= tostring(entry.id)) then return false end
    end
    return true
end


local function findAMVGG(item)

    if type(item) ~= "table" then
        return nil
    end

    local itemName =
        getItemName(
            item
        )

    if item.category == "pets" then

        if
            itemName:
            lower():
            find(
                "egg",
                1,
                true
            )
        then

            local egg =
                findCategory(
                    "eggs",
                    itemName
                )

            if egg then

                return
                    egg,
                    "eggs"
            end
        end

        local pet =
            findCategory(
                "pets",
                itemName
            )

        if pet then

            return
                pet,
                "pets"
        end

        local egg =
            findCategory(
                "eggs",
                itemName
            )

        if egg then

            return
                egg,
                "eggs"
        end

        return nil
    end

    local slug =
        ADOPT_TO_AMVGG[
            item.category
        ]

    if not slug then
        return nil
    end

    local entry =
        findCategory(
            slug,
            itemName
        )

    if entry then

        return
            entry,
            slug
    end

    return nil
end



-- Live AMVGG rarity metadata, when present, is stronger than the fallback list.
do
    local fallbackIsCommon =
        CommonPetFilter.isCommon

    CommonPetFilter.isCommon =
        function(item)
            if
                type(item) ~= "table"
                or tostring(item.category or "") ~= "pets"
            then
                return false
            end

            local entry, source =
                findAMVGG(item)

            if type(entry) == "table" and source == "pets" then
                local candidates = {entry.rarity, entry.pet_rarity, entry.petRarity, entry.rarity_name, entry.rarityName}
                local recognized = {common=true, uncommon=true, rare=true, ultrarare=true, legendary=true}
                for index = 1, 5 do
                    local rarity = candidates[index]
                    if type(rarity) == "table" then rarity = rarity.name or rarity.Name or rarity.value or rarity.Value end
                    if type(rarity) == "string" then
                        local key = normalize(rarity)
                        if recognized[key] then return key == "common" end
                    end
                end
            end

            return fallbackIsCommon(item)
        end
end


--============================================================
-- AMVGG V11.6.2 VARIANT VALUE ENGINE
-- Exact calculator logic restored from the proven V11.6.2 build.
-- Supports: NP R F FR N NR NF NFR M MR MF MFR.
--============================================================

local MULTIPLIERS = {

    [0] = {
        NP=0.08,R=0.5,F=0.6,
        NNP=0.21,NR=0.6,NF=0.75,
        MNP=0.45,MR=0.65,MF=0.775
    },

    [1] = {
        NP=0.08,R=0.5,F=0.6,
        NNP=0.35,NR=0.725,NF=0.79,
        MNP=0.55,MR=0.675,MF=0.8
    },

    [2] = {
        NP=0.1,R=0.525,F=0.625,
        NNP=0.425,NR=0.75,NF=0.8,
        MNP=0.65,MR=0.75,MF=0.81
    },

    [3] = {
        NP=0.125,R=0.6,F=0.65,
        NNP=0.55,NR=0.8,NF=0.81,
        MNP=0.725,MR=0.8,MF=0.85
    },

    [4] = {
        NP=0.166,R=0.65,F=0.7,
        NNP=0.625,NR=0.81,NF=0.82,
        MNP=0.75,MR=0.825,MF=0.86
    },

    [5] = {
        NP=0.2,R=0.675,F=0.725,
        NNP=0.675,NR=0.82,NF=0.83,
        MNP=0.775,MR=0.85,MF=0.89
    },

    [6] = {
        NP=0.3,R=0.7,F=0.75,
        NNP=0.725,NR=0.85,NF=0.87,
        MNP=0.825,MR=0.9,MF=0.925
    },

    [7] = {
        NP=0.45,R=0.725,F=0.775,
        NNP=0.75,NR=0.9,NF=0.91,
        MNP=0.85,MR=0.92,MF=0.95
    },

    [8] = {
        NP=0.55,R=0.75,F=0.8,
        NNP=0.77,NR=0.9,NF=0.915,
        MNP=0.875,MR=0.93,MF=0.96
    },

    [9] = {
        NP=0.65,R=0.825,F=0.85,
        NNP=0.85,NR=0.925,NF=0.94,
        MNP=0.925,MR=0.95,MF=0.975
    },

    [10] = {
        NP=0.8,R=0.9,F=0.92,
        NNP=0.925,NR=0.96,NF=0.97,
        MNP=1.05,MR=0.98,MF=0.99
    },

    [11] = {
        NP=0.9,R=0.95,F=0.975,
        NNP=1,NR=0.98,NF=0.985,
        MNP=1.05,MR=1,MF=1
    },

    [12] = {
        NP=0.9,R=0.95,F=0.975,
        NNP=1.03,NR=0.98,NF=0.985,
        MNP=1.1,MR=1,MF=1
    },

    [19] = {
        NP=0.775,R=0.875,F=0.9,
        NNP=0.9,NR=0.95,NF=0.975,
        MNP=0.975,MR=0.985,MF=0.992
    },

    [20] = {
        NP=0.775,R=0.875,F=0.9,
        NNP=0.9,NR=0.95,NF=0.975,
        MNP=1,MR=0.985,MF=0.992
    },

    [21] = {
        NP=0.75,R=0.86,F=0.875,
        NNP=0.88,NR=0.93,NF=0.95,
        MNP=1,MR=0.98,MF=0.99
    },

    [22] = {
        NP=0.75,R=0.86,F=0.875,
        NNP=0.88,NR=0.93,NF=0.95,
        MNP=0.97,MR=0.98,MF=0.99
    },

    [23] = {
        NP=0.7,R=0.8,F=0.85,
        NNP=0.85,NR=0.9,NF=0.93,
        MNP=0.95,MR=0.965,MF=0.985
    },

    [33] = {
        NP=0.15,R=0.6,F=0.65,
        NNP=0.35,NR=0.75,NF=0.8,
        MNP=0.5,MR=0.7,MF=0.8
    },

    [44] = {
        NP=0.97,R=0.98,F=0.985,
        NNP=1,NR=1,NF=1,
        MNP=1.025,MR=1,MF=1
    },

    [45] = {
        NP=0.97,R=0.98,F=0.985,
        NNP=1,NR=1,NF=1,
        MNP=1,MR=1,MF=1
    },

    [46] = {
        NP=0.98,R=0.985,F=0.99,
        NNP=1,NR=1,NF=1,
        MNP=1,MR=1,MF=1
    },

    [47] = {
        NP=0.98,R=0.985,F=0.99,
        NNP=1,NR=1,NF=1,
        MNP=1.05,MR=1,MF=1
    },

    [48] = {
        NP=0.985,R=0.99,F=0.995,
        NNP=1,NR=1,NF=1,
        MNP=1,MR=1,MF=1
    },

    [49] = {
        NP=0.985,R=0.99,F=0.995,
        NNP=1,NR=1,NF=1,
        MNP=1.05,MR=1,MF=1
    },

    [50] = {
        NP=0.985,R=0.99,F=0.995,
        NNP=1,NR=1,NF=1,
        MNP=1.025,MR=1,MF=1
    },

    [55] = {
        NP=0.9,R=0.95,F=0.975,
        NNP=1,NR=0.98,NF=0.985,
        MNP=1.075,MR=1,MF=1
    },

    [66] = {
        NP=0.9,R=0.95,F=0.975,
        NNP=1,NR=0.98,NF=0.985,
        MNP=1.125,MR=1,MF=1
    },

    [67] = {
        NP=0.9,R=0.95,F=0.975,
        NNP=0.96,NR=0.98,NF=0.985,
        MNP=1.05,MR=1,MF=1
    },

    [68] = {
        NP=0.9,R=0.95,F=0.975,
        NNP=0.96,NR=0.98,NF=0.985,
        MNP=1.025,MR=1,MF=1
    },

    [69] = {
        NP=0.9,R=0.95,F=0.975,
        NNP=0.96,NR=0.98,NF=0.985,
        MNP=1,MR=1,MF=1
    },

    [70] = {
        NP=0.94,R=0.96,F=0.98,
        NNP=0.97,NR=0.98,NF=0.99,
        MNP=1,MR=1,MF=1
    },

    [71] = {
        NP=0.94,R=0.96,F=0.98,
        NNP=0.97,NR=0.98,NF=0.99,
        MNP=1.025,MR=1,MF=1
    },

    [72] = {
        NP=0.94,R=0.96,F=0.98,
        NNP=0.97,NR=0.98,NF=0.99,
        MNP=1.05,MR=1,MF=1
    },

    [79] = {
        NP=0.97,R=0.98,F=0.985,
        NNP=1,NR=1,NF=1,
        MNP=1.05,MR=1,MF=1
    },

    [81] = {
        NP=0.98,R=0.985,F=0.99,
        NNP=1,NR=1,NF=1,
        MNP=1.025,MR=1,MF=1
    },

    [97] = {
        NP=0.8,R=0.9,F=0.92,
        NNP=0.95,NR=0.975,NF=0.98,
        MNP=1.025,MR=1,MF=1
    },

    [98] = {
        NP=0.8,R=0.9,F=0.92,
        NNP=0.95,NR=0.975,NF=0.98,
        MNP=1.05,MR=1,MF=1
    },

    [99] = {
        NP=0.8,R=0.9,F=0.92,
        NNP=0.95,NR=0.975,NF=0.98,
        MNP=1,MR=1,MF=1
    },

    [111] = {
        NP=0.04,R=0.5,F=0.6,
        NNP=0.125,NR=0.6,NF=0.75,
        MNP=0.33,MR=0.65,MF=0.75
    },

    [222] = {
        NP=0.02,R=0.45,F=0.55,
        NNP=0.07,NR=0.5,NF=0.65,
        MNP=0.275,MR=0.55,MF=0.65
    },

    [333] = {
        NP=0.03,R=0.5,F=0.6,
        NNP=0.1,NR=0.55,NF=0.7,
        MNP=0.3,MR=0.6,MF=0.7
    },
}

local EXACT_FIELD = {
    NP = "npRegularValue",
    F = "fValue",
    R = "rValue",
    FR = "regularValue",

    N = "npNeonValue",
    NF = "nfValue",
    NR = "nrValue",
    NFR = "neonValue",

    M = "npMegaValue",
    MF = "mfValue",
    MR = "mrValue",
    MFR = "megaValue",
}

local function calculateCategoryVariants(category, regularValue, neonValue, megaValue)
    category = tonumber(category)
    local m = MULTIPLIERS[category]
    if not m then return nil end
    regularValue, neonValue, megaValue = num(regularValue), num(neonValue), num(megaValue)
    if not regularValue or not neonValue or not megaValue
        or regularValue < 0 or neonValue < 0 or megaValue < 0 then return nil end
    local function nativeRound(value, requested)
        local precision = value ~= 0 and math.abs(value) < 0.001 and 5 or 4
        return round(value, math.min(requested or 5, precision))
    end
    local regularDecimals = regularValue >= 0.0175 and 3 or 5
    local special = category == 11 and regularValue > 0.08
    return {
        NP = nativeRound(regularValue * (special and 0.95 or m.NP), regularDecimals),
        R = nativeRound(regularValue * (special and 0.975 or m.R), regularDecimals),
        F = nativeRound(regularValue * (special and 0.975 or m.F), regularDecimals),
        FR = regularValue,
        N = nativeRound(neonValue * m.NNP),
        NR = special and neonValue > 0.2 and neonValue or nativeRound(neonValue * m.NR),
        NF = special and neonValue > 0.2 and neonValue or nativeRound(neonValue * m.NF),
        NFR = neonValue,
        M = nativeRound(megaValue * m.MNP),
        MR = special and megaValue > 0.9 and megaValue or nativeRound(megaValue * m.MR),
        MF = special and megaValue > 0.9 and megaValue or nativeRound(megaValue * m.MF),
        MFR = megaValue,
    }
end


local function getPetValue(
    entry,
    variant
)

    if type(entry) ~= "table" then
        return nil, nil, false, "INVALID ENTRY"
    end

    local category = tonumber(entry.category)

    -- Category 13 exposes exact fields for all 12 variants.
    if category == 13 then

        local field = EXACT_FIELD[variant]

        if not field then
            return nil, nil, false, "UNKNOWN VARIANT"
        end

        local value = num(entry[field])
        if value and value < 0 then value = nil end

        return
            value,
            field,
            false,
            value == nil and "CATEGORY 13 FIELD NIL" or nil
    end

    if not category then
        return nil, nil, false, "NO CATEGORY"
    end

    local variants = calculateCategoryVariants(
        category,
        entry.regularValue,
        entry.neonValue,
        entry.megaValue
    )

    if not variants then
        return
            nil,
            nil,
            false,
            "NO MULTIPLIER FOR CATEGORY " .. tostring(category)
    end

    local value = variants[variant]

    return
        value,
        "CALC/CAT=" .. tostring(category),
        false,
        value == nil and "CALCULATED NIL" or nil
end


local function genericValue(entry)

    if type(entry) ~= "table" then
        return nil
    end

    local fields = {
        "value",
        "regularValue",
        "npRegularValue",
    }

    for _, field in ipairs(fields) do
        local value = num(entry[field])
        if value and value < 0 then value = nil end
        if value ~= nil then
            return value, field
        end
    end

    return nil
end


--============================================================
-- ANALYZE ITEM
--============================================================

--============================================================
-- PETS-ONLY DEMAND (V11.6.2 field semantics, current AMVGG data)
-- Observed payload labels: Low=1, Medium/Decent=2, High=3.
-- Unknown formats never inherit AMVGG UI's permissive default of 2.
--============================================================
local DemandPolicy = {}
do
    local EXACT_DEMAND_FIELD = {
        NP = "npRegularDemand", F = "fDemand", R = "rDemand", FR = "regularDemand",
        N = "npNeonDemand", NF = "nfDemand", NR = "nrDemand", NFR = "neonDemand",
        M = "npMegaDemand", MF = "mfDemand", MR = "mrDemand", MFR = "megaDemand",
    }
    local LABEL_STARS = {low = 1, medium = 2, decent = 2, high = 3}

    local function getPetDemand(entry, variant)
        if tonumber(entry.category) == 13 then
            local field = EXACT_DEMAND_FIELD[variant]
            return field and entry[field] or nil
        end
        -- NP means regular No Potion; its N does not mean Neon.
        if variant == "NP" then return entry.regularDemand end
        if variant:find("M", 1, true) then return entry.megaDemand end
        if variant:find("N", 1, true) then return entry.neonDemand end
        return entry.regularDemand
    end

    function DemandPolicy.normalize(raw)
        if type(raw) == "number" then
            if raw == 1 or raw == 2 or raw == 3 then return raw end
        elseif type(raw) == "string" then
            local label = raw:match("^%s*(.-)%s*$"):lower()
            if label == "1" or label == "2" or label == "3" then
                return tonumber(label)
            end
            return LABEL_STARS[label]
        end
        return nil
    end

    function DemandPolicy.read(entry, source, variant)
        -- Adopt Me stores eggs in the pets inventory bucket; use AMVGG's
        -- resolved category instead. Non-pet demand is deliberately ignored.
        if source ~= "pets" then return false, nil, nil end
        local raw = getPetDemand(entry, variant)
        return true, raw, DemandPolicy.normalize(raw)
    end

    function DemandPolicy.ownAnalysisReason(analysis)
        if analysis and analysis.isRealPet then
            if analysis.demandStars == 3 then return "OUR 3 STAR PET PROTECTED" end
            if analysis.demandStars == nil then return "DEMAND UNKNOWN" end
        end
        return nil
    end

    function DemandPolicy.credit(rawValue, analysis, itemMinimumWinPercent)
        if analysis and analysis.isRealPet then
            local stars = analysis.demandStars
            if stars == 3 then return rawValue / 0.98, "3STAR" end
            if stars == 2 then return rawValue / 1.15, "2STAR" end
            if stars == 1 then return rawValue / 1.20, "1STAR" end
            return nil, "DEMAND UNKNOWN"
        end
        return rawValue / (1 + itemMinimumWinPercent / 100), "ITEM"
    end
end

local function analyzeItem(item)

    local result = {

        name =
            getItemName(
                item
            ),

        category =
            getCategoryDisplay(
                item
            ),

        variant =
            getVariant(
                item
            ),

        source =
            nil,

        isRealPet = false,
        rawDemand = nil,
        demandStars = nil,

        value =
            nil,

        field =
            nil,

        estimated =
            false,

        reason =
            nil,
    }

    if not AMVGG.ready then

        result.reason =
            "AMVGG NOT READY"

        return result
    end

    local entry,
        source =
        findAMVGG(
            item
        )

    if not entry then

        result.reason =
            "NOT FOUND"

        return result
    end

    result.source =
        source

    result.isRealPet, result.rawDemand, result.demandStars =
        DemandPolicy.read(entry, source, result.variant)

    if source == "pets" then

        local value,
            field,
            estimated,
            valueReason =
            getPetValue(
                entry,
                result.variant
            )

        result.value =
            value

        result.field =
            field

        -- Values calculated by the V11.6.2 engine mirror AMVGG calculator
        -- logic and are therefore not marked as guessed EST values.
        result.estimated =
            estimated == true

        if value == nil then
            result.reason =
                valueReason
                or "NO VALUE"
        elseif estimated then
            result.reason = "ESTIMATED"
        end

        return result
    end

    result.variant =
        ""

    local value,
        field =
        genericValue(
            entry
        )

    result.value =
        value

    result.field =
        field

    if value == nil then
        result.reason = "NO VALUE"
    end

    return result
end


--============================================================
-- SETTINGS
--============================================================

function DemandPolicy.ownItemReason(item)
    return DemandPolicy.ownAnalysisReason(analyzeItem(item))
end

local SETTINGS_FILE =
    "am_trade_v1170.json"

local FIRST_SEEN_FILE =
    "am_first_seen_v1170.json"


local Settings = {

    autoTrade =
        false,

    minProfitPercent =
        10,

    -- Applies only to counted incoming non-pet items; pet rules are fixed.
    itemMinimumWinPercent =
        15,

    -- Minimum-value filter mode:
    -- ALL      -> ALL MIN ITEM VALUE applies to both sides.
    -- SEPARATE -> MY and THEIR thresholds are independent.
    minValueMode =
        "ALL",

    myMinItemValue =
        0.0005,

    theirMinItemValue =
        0.0005,

    allMinItemValue =
        0.0005,

    requestTimeout =
        15,

    -- Full wait AFTER our first showcase item is actually sent.
    firstItemTimeout =
        50,

    -- Fresh wait after ASK ADD. If THEIR offer does not change for this
    -- entire window, decline. Any real partner add/remove starts a fresh window.
    addTimeout =
        100,

    -- BLOCK UNKNOWN wait window. If an UNKNOWN item remains unchanged for
    -- this many seconds, decline. Any partner offer change starts a fresh wait.
    unknownBlockTimeout =
        65,

    -- One-time migration marker for the new 100-second ASK ADD window.
    askAddWindowProfile =
        0,

    playerCooldown =
        300,

    settleSeconds =
        2,

    -- Debounce THEIR side. Every partner add/remove resets this timer.
    -- We do not rebuild our offer until their side has been unchanged
    -- for the full delay, so 1-2 quick items do not trigger an instant rebuild.
    partnerRebuildDelay =
        10,

    -- Long enough that repeated 70-second add windows are not cut off early.
    maxTradeSeconds =
        600,

    newItemHours =
        24,

    refreshMinutes =
        5,

    allowedItems =
        "",

    chatRequests =
        true,

    maxOurItems =
        18,

    optimizerBeam =
        350,

    -- Wait before exposing our highest safe showcase item at trade start.
    showcaseDelay =
        5,

    -- Migration marker so old saved 25/40 timing values become 50/70 once.
    waitWindowProfile =
        0,

    -- Delay between every add/remove action in our offer.
    -- This prevents the bot from dumping many units into the trade at once.
    itemActionDelay =
        0.85,

    -- Extra wait after the chosen offer has been fully rebuilt.
    postRebuildDelay =
        1.25,

    -- Countdown after the final offer is stable before FIRST ACCEPT.
    preAcceptDelay =
        4,

    -- After FIRST ACCEPT, always wait this many seconds before SECOND CONFIRM.
    -- Adopt Me's confirmation transition can take different amounts of time
    -- depending on the amount of units in the trade, so never confirm instantly.
    secondConfirmDelay =
        10,

    -- Server router / hopper.
    -- If we are in a normal Adopt Me server, route to Trading Plaza.
    -- If already in Trading Plaza, move to another public Plaza server
    -- after this many minutes.
    plazaAutoRoute =
        true,

    plazaHopMinutes =
        15,

    -- One-time migration marker: move the old default 20-minute hop to 15.
    plazaHopProfile =
        0,

    -- Many low/mid pets on AMVGG do not expose an exact NP/R/F field and
    -- fall back to our variant estimate. Allow those estimates only for
    -- OUR pets so the optimizer can actually use pets. Incoming estimated
    -- values can still be blocked by BLOCK ESTIMATED VALUES.
    allowEstimatedOwnPets =
        true,

    blockEstimated =
        true,

    -- Incoming-side junk filter. Potion variants still count.
    -- Also ignores every plain Neon/Mega (N/M) from the other player.
    excludeUnwantedIncomingNoPotion =
        true,
}


local function loadJSON(path)

    if
        type(readfile)
            ~= "function"
        or type(isfile)
            ~= "function"
    then

        return nil
    end

    local ok,
        exists =
        pcall(
            isfile,
            path
        )

    if
        not ok
        or not exists
    then

        return nil
    end

    local ok2,
        result =
        pcall(
            function()

                return
                    HttpService:
                    JSONDecode(
                        readfile(
                            path
                        )
                    )
            end
        )

    if
        ok2
        and type(result)
            == "table"
    then

        return result
    end

    return nil
end


local function saveJSON(
    path,
    data
)

    if type(writefile) ~= "function" then
        return
    end

    pcall(
        function()

            writefile(
                path,

                HttpService:
                JSONEncode(
                    data
                )
            )
        end
    )
end


do

    local saved =
        loadJSON(
            SETTINGS_FILE
        )

    if type(saved) == "table" then

        for key,
            value in pairs(
                saved
            )
        do

            local default = Settings[key]
            if type(default) == "number" then
                local parsed = num(value)
                if parsed then
                    local limits = {
                        minProfitPercent={0,500}, itemMinimumWinPercent={0,500},
                        myMinItemValue={0.0005,1000000}, theirMinItemValue={0.0005,1000000}, allMinItemValue={0.0005,1000000},
                        maxOurItems={1,18}, optimizerBeam={1,2000}, newItemHours={0,720}, refreshMinutes={1,1440},
                        requestTimeout={1,300}, firstItemTimeout={5,3600}, addTimeout={5,3600}, unknownBlockTimeout={5,3600},
                        playerCooldown={0,86400}, settleSeconds={0,60}, partnerRebuildDelay={0,120}, maxTradeSeconds={180,7200},
                        showcaseDelay={0,120}, itemActionDelay={0.1,10}, postRebuildDelay={0.25,30}, preAcceptDelay={0,120},
                        secondConfirmDelay={0,120}, plazaHopMinutes={0,1440},
                        waitWindowProfile={0,1}, askAddWindowProfile={0,1}, plazaHopProfile={0,1},
                    }
                    local bound = limits[key] or {0,1000000}
                    parsed = math.clamp(parsed, bound[1], bound[2])
                    if key == "maxOurItems" or key == "optimizerBeam" then parsed = math.floor(parsed) end
                    Settings[key] = parsed
                end
            elseif type(default) == "boolean" then
                if type(value) == "boolean" then Settings[key] = value
                elseif value == "true" then Settings[key] = true
                elseif value == "false" then Settings[key] = false end
            elseif type(default) == "string" and type(value) == "string" then
                Settings[key] = value
            end
        end
    end
end

-- Saved settings from older versions may not have the new fields, and an
-- old/corrupt settings file could theoretically leave both automation modes
-- enabled. Normalize everything once at boot.
Settings.minValueMode =
    tostring(Settings.minValueMode or "ALL"):upper()

if
    Settings.minValueMode ~= "ALL"
    and Settings.minValueMode ~= "SEPARATE"
then
    Settings.minValueMode = "ALL"
end

Settings.myMinItemValue =
    math.max(0.0005, tonumber(Settings.myMinItemValue) or 0.0005)

Settings.theirMinItemValue =
    math.max(0.0005, tonumber(Settings.theirMinItemValue) or 0.0005)

Settings.allMinItemValue =
    math.max(0.0005, tonumber(Settings.allMinItemValue) or 0.0005)

Settings.itemMinimumWinPercent =
    math.clamp(tonumber(Settings.itemMinimumWinPercent) or 15, 0, 500)

-- V11.7.10 timing migration. Existing users keep the same settings file,
-- so force the new wait-window defaults once instead of silently loading
-- the old 25s / 40s values forever.
if tonumber(Settings.waitWindowProfile) ~= 1 then
    Settings.firstItemTimeout = 50
    Settings.addTimeout = 70
    Settings.showcaseDelay = 5
    Settings.maxTradeSeconds = math.max(600, tonumber(Settings.maxTradeSeconds) or 0)
    Settings.waitWindowProfile = 1
end

-- V11.7.16 ASK ADD migration. Old default was 70 seconds. Move that
-- default to 100 once, but preserve a custom value the user already chose.
if tonumber(Settings.askAddWindowProfile) ~= 1 then
    if
        tonumber(Settings.addTimeout) == nil
        or math.abs(
            (tonumber(Settings.addTimeout) or 0)
            - 70
        ) < 0.000001
    then
        Settings.addTimeout = 100
    end

    Settings.askAddWindowProfile = 1
end

Settings.firstItemTimeout =
    math.max(5, tonumber(Settings.firstItemTimeout) or 50)

Settings.addTimeout =
    math.max(5, tonumber(Settings.addTimeout) or 100)

Settings.unknownBlockTimeout =
    math.max(5, tonumber(Settings.unknownBlockTimeout) or 65)

Settings.excludeUnwantedIncomingNoPotion =
    Settings.excludeUnwantedIncomingNoPotion ~= false

Settings.showcaseDelay =
    math.max(0, tonumber(Settings.showcaseDelay) or 5)

Settings.maxTradeSeconds =
    math.max(180, tonumber(Settings.maxTradeSeconds) or 600)

Settings.secondConfirmDelay =
    math.max(0, tonumber(Settings.secondConfirmDelay) or 10)

Settings.partnerRebuildDelay =
    math.max(0, tonumber(Settings.partnerRebuildDelay) or 10)

-- V11.7.19 PLAZA HOP migration. The previous default was 20 minutes.
-- Move that default to 15 once, while preserving any other custom value.
if tonumber(Settings.plazaHopProfile) ~= 1 then
    if
        tonumber(Settings.plazaHopMinutes) == nil
        or math.abs(
            (tonumber(Settings.plazaHopMinutes) or 0)
            - 20
        ) < 0.000001
    then
        Settings.plazaHopMinutes = 15
    end

    Settings.plazaHopProfile = 1
end

Settings.plazaHopMinutes =
    math.max(0, tonumber(Settings.plazaHopMinutes) or 15)

if Settings.plazaAutoRoute == nil then
    Settings.plazaAutoRoute = true
else
    Settings.plazaAutoRoute =
        Settings.plazaAutoRoute == true
end


local AutoTradeGeneration = 0
local Gui

function Runtime.incomingItemIgnoreReason(item, options)
    if (not options or options.ignoreIncomingEggs == true) and CommonPetFilter.isIgnoredIncomingEgg(item) then
        return "IGNORED EGG"
    end
    if Settings.excludeUnwantedIncomingNoPotion and (not options or options.ignoreUnwantedIncomingNoPotion == true) then
        local ignored, reason = CommonPetFilter.shouldIgnoreIncoming(item)
        if ignored then return reason end
    end
    return nil
end

local function activeMinItemValue(side)

    if Settings.minValueMode == "ALL" then
        return
            math.max(
                0,
                tonumber(Settings.allMinItemValue)
                or 0
            )
    end

    if side == "theirs" then
        return
            math.max(
                0,
                tonumber(Settings.theirMinItemValue)
                or 0
            )
    end

    return
        math.max(
            0,
            tonumber(Settings.myMinItemValue)
            or 0
        )
end


local function saveSettings()

    saveJSON(
        SETTINGS_FILE,
        Settings
    )
end


--============================================================
-- FIRST SEEN DATABASE
--============================================================

function Runtime.policySignature()
    local keys = {
        "allowedItems", "minValueMode", "allMinItemValue", "myMinItemValue", "theirMinItemValue",
        "itemMinimumWinPercent", "newItemHours", "blockEstimated", "allowEstimatedOwnPets",
        "excludeUnwantedIncomingNoPotion", "minProfitPercent", "maxOurItems", "optimizerBeam",
    }
    local values = {}
    for _, key in ipairs(keys) do values[#values + 1] = key .. "=" .. tostring(Settings[key]) end
    return table.concat(values, "|")
end

function Runtime.disableAutomation()
    AutoTradeGeneration += 1
    if Runtime.flow then Runtime.flow.stop("Auto Trade disabled") end
    local state = Runtime.state
    if state then
        state.optimizedSignature, state.acceptReadySignature, state.acceptReadySince = nil, nil, nil
        state.policySignature, state.optimizedOurSignature, state.confirmPending = nil, nil, nil
    end
end


local FirstSeen =
    loadJSON(
        FIRST_SEEN_FILE
    )


if type(FirstSeen) ~= "table" then

    FirstSeen = {

        initialized =
            false,

        items =
            {},
    }
end


if type(FirstSeen.items) ~= "table" then

    FirstSeen.items =
        {}
end


local function entryID(
    source,
    key,
    entry
)

    if
        type(entry) == "table"
        and entry.id ~= nil
    then

        return
            tostring(
                entry.id
            )
    end

    return
        tostring(source)
        .. ":"
        .. tostring(key)
end


local function updateFirstSeen()

    if not AMVGG.ready then
        return
    end

    local baseline =
        FirstSeen.initialized
        ~= true

    local now =
        os.time()

    local changed =
        false

    for source,
        database in pairs(
            AMVGG.categories
        )
    do

        if type(database) == "table" then

            for key,
                entry in pairs(
                    database
                )
            do

                local id =
                    entryID(
                        source,
                        key,
                        entry
                    )

                if
                    FirstSeen.items[
                        id
                    ]
                    == nil
                then

                    if baseline then

                        FirstSeen.items[id] =
                            0

                    else

                        FirstSeen.items[id] =
                            now
                    end

                    changed =
                        true
                end
            end
        end
    end

    if baseline then

        FirstSeen.initialized =
            true

        changed =
            true
    end

    if changed then

        saveJSON(
            FIRST_SEEN_FILE,
            FirstSeen
        )
    end
end


local function isNewEntry(
    source,
    entry
)

    if
        type(entry) ~= "table"
        or not source
    then

        return
            false,
            0
    end

    local id =
        entryID(
            source,
            normalize(
                entry.name
                or ""
            ),
            entry
        )

    local seen =
        tonumber(
            FirstSeen.items[
                id
            ]
        )

    if
        not seen
        or seen <= 0
    then

        return
            false,
            0
    end

    local age =
        os.time()
        - seen

    local maxAge =
        (
            tonumber(
                Settings.newItemHours
            )
            or 24
        )
        * 3600

    return

        age >= 0
        and age < maxAge,

        age
end


--============================================================
-- EFFECTIVE ITEM VALUE
--============================================================

local function effectiveItemValue(item)
    local analysis = analyzeItem(item)

    local entry,
        source =
        findAMVGG(
            item
        )

    if
        entry
        and source
    then

        local isNew,
            age =
            isNewEntry(
                source,
                entry
            )

        if isNew then

            return {

                known =
                    true,

                newIgnored =
                    true,

                estimated =
                    false,

                value =
                    0,

                name =
                    tostring(
                        entry.name
                        or getItemName(
                            item
                        )
                    ),

                age =
                    age,

                analysis = analysis,
            }
        end
    end


    if
        not analysis
        or type(
            analysis.value
        ) ~= "number"
    then

        return {

            known =
                false,

            newIgnored =
                false,

            estimated =
                false,

            value =
                0,

            name =
                analysis
                and analysis.name
                or getItemName(
                    item
                ),

            analysis = analysis,

            reason =
                analysis
                and analysis.reason
                or "UNKNOWN",
        }
    end

    return {

        known =
            true,

        newIgnored =
            false,

        estimated =
            analysis.estimated
            == true,

        value =
            analysis.value,

        name =
            analysis.name,

        analysis =
            analysis,
    }
end


--============================================================
-- PLAYER HELPERS
--============================================================

local function playerName(value)

    if typeof(value) == "Instance" then
        return value.Name
    end

    if type(value) == "table" then

        return
            tostring(
                value.name
                or value.username
                or value.player_name
                or value
            )
    end

    return
        tostring(
            value
            or "Unknown"
        )
end


local function isMe(value)

    if value == LocalPlayer then
        return true
    end

    if type(value) == "number" then

        return
            value
            == LocalPlayer.UserId
    end

    if type(value) == "table" then

        local id =
            tonumber(
                value.user_id
                or value.userId
                or value.id
            )

        if id then

            return
                id
                == LocalPlayer.UserId
        end
    end

    return

        playerName(value):
        lower()

        ==

        LocalPlayer.Name:
        lower()
end


--============================================================
-- TRADE DATA
--============================================================

function Runtime.tradeInConfirmation(trade)
    if type(trade) ~= "table" then return false end
    local stage = tostring(trade.current_stage or trade.stage or trade.state or ""):lower()
    return trade.confirming == true or trade.confirmation_started == true or stage:find("confirm", 1, true) ~= nil
end

local function getTrade()

    local keys = {
        "trade",
        "trading",
    }

    for _,
        key in ipairs(
            keys
        )
    do

        local ok,
            trade =
            pcall(
                function()

                    return
                        ClientData.get(
                            key
                        )
                end
            )

        if
            ok
            and type(trade)
                == "table"
            and (
                trade.sender
                or trade.recipient
                or trade.sender_offer
                or trade.recipient_offer
            )
        then

            return trade
        end
    end

    return nil
end


local function getTradeSides(trade)

    if type(trade) ~= "table" then
        return nil
    end

    if isMe(
        trade.sender
    )
    then

        return

            trade.sender_offer,
            trade.recipient_offer,
            trade.sender,
            trade.recipient
    end

    if isMe(
        trade.recipient
    )
    then

        return

            trade.recipient_offer,
            trade.sender_offer,
            trade.recipient,
            trade.sender
    end

    return nil
end


local function getOfferItems(offer)

    if type(offer) ~= "table" then
        return {}
    end

    if
        type(offer.items)
        == "table"
    then

        return
            offer.items
    end

    if
        type(
            offer.offer_items
        ) == "table"
    then

        return
            offer.offer_items
    end

    return {}
end


local function itemUID(item)

    if type(item) ~= "table" then
        return nil
    end

    return

        item.unique
        or item.uid
        or item.id
end


local function countOfferItems(offer)

    local count =
        0

    for _ in pairs(
        getOfferItems(
            offer
        )
    ) do

        count =
            count
            + 1
    end

    return count
end


local function itemSignature(item)

    return

        tostring(
            itemUID(
                item
            )
            or item.kind
            or "?"
        )

        .. ":"

        .. tostring(
            getVariant(
                item
            )
        )
end


local function offerSignature(offer)

    local list =
        {}

    for _,
        item in pairs(
            getOfferItems(
                offer
            )
        )
    do

        list[
            #list + 1
        ] =
            itemSignature(
                item
            )
    end

    table.sort(
        list
    )

    return
        table.concat(
            list,
            "|"
        )
end


local function fullSignature(
    mine,
    theirs
)

    return

        offerSignature(
            mine
        )

        .. " >>> "

        .. offerSignature(
            theirs
        )
end


--============================================================
-- EVALUATE OFFER
--============================================================

function Runtime.partnerKey(partner)
    if typeof(partner) == "Instance" then return "id:" .. tostring(partner.UserId) end
    if type(partner) == "number" then return "id:" .. tostring(partner) end
    if type(partner) == "table" then
        local id = partner.user_id or partner.userId or partner.UserId or partner.id
        if id ~= nil then return "id:" .. tostring(id) end
    end
    return "name:" .. playerName(partner):lower()
end

function Runtime.tradeKey(trade, partner)
    return tostring(trade.trade_id or trade.id or playerName(partner)) .. ":" .. Runtime.partnerKey(partner)
end

function Runtime.captureTrade(trade)
    local live = getTrade()
    local mine, theirs, _, partner = getTradeSides(live)
    local suppliedMine, suppliedTheirs, _, suppliedPartner = getTradeSides(trade)
    if not mine or not theirs or not suppliedMine or not suppliedTheirs
        or Runtime.tradeKey(live, partner) ~= Runtime.tradeKey(trade, suppliedPartner)
        or fullSignature(mine, theirs) ~= fullSignature(suppliedMine, suppliedTheirs) then return nil end
    return {
        key = Runtime.tradeKey(live, partner), generation = AutoTradeGeneration, auto = Settings.autoTrade,
        prices = AMVGG.version, policy = Runtime.policySignature(),
        mine = offerSignature(mine), theirs = offerSignature(theirs),
    }
end

function Runtime.liveContext(context, checkMine, checkPrices)
    if not context then return nil, "TRADE_CHANGED" end
    if not Runtime.alive() or not Gui.Parent then return nil, "GUI_CLOSED" end
    if AutoTradeGeneration ~= context.generation or Settings.autoTrade ~= context.auto then return nil, "AUTO_DISABLED" end
    local live = getTrade()
    local mine, theirs, _, partner = getTradeSides(live)
    if not mine or not theirs or Runtime.tradeKey(live, partner) ~= context.key then return nil, "TRADE_CHANGED" end
    if offerSignature(theirs) ~= context.theirs then return nil, "THEIR_CHANGED" end
    if checkMine and offerSignature(mine) ~= context.mine then return nil, "OUR_CHANGED" end
    if checkPrices then
        if AMVGG.dataStale or AMVGG.loading or not AMVGG.ready then return nil, "PRICES_UNAVAILABLE" end
        if AMVGG.version ~= context.prices then return nil, "PRICES_CHANGED" end
        if Runtime.policySignature() ~= context.policy then return nil, "POLICY_CHANGED" end
    end
    return live, nil, mine, theirs
end

function Runtime.optimizationKey(theirOffer)
    return offerSignature(theirOffer) .. "|AMVGG=" .. tostring(AMVGG.version) .. "|POLICY=" .. Runtime.policySignature()
end


local function evaluateOffer(
    offer,
    options
)

    options =
        type(options) == "table"
        and options
        or {}

    local allowEstimated =
        options.allowEstimated
        == true

    local minValue =
        math.max(
            0,
            tonumber(options.minValue)
            or 0
        )

    local ignoreBelowMin =
        options.ignoreBelowMin
        == true

    local demandSide = options.demandSide
    local result = {
        effectiveTotal = 0,
        demandUnknown = 0,
        demandUnknownNames = {},
        protectedPets = 0,
        protectedPetNames = {},

        total =
            0,

        count =
            0,

        unknown =
            0,

        estimated =
            0,

        newIgnored =
            0,

        belowMin =
            0,

        hardBlocked =
            0,

        hardBlockedNames =
            {},

        unwantedIncomingIgnored =
            0,

        unwantedIncomingNames =
            {},

        unknownNames =
            {},

        estimatedNames =
            {},

        newNames =
            {},

        belowMinNames =
            {},

        items =
            {},
    }

    for _,
        item in pairs(
            getOfferItems(
                offer
            )
        )
    do

        result.count =
            result.count
            + 1

        local data =
            effectiveItemValue(
                item
            )

        local row = {
            rawValue = data.value,
            isRealPet = data.analysis and data.analysis.isRealPet == true or false,
            variant = getVariant(item),
            rawDemand = data.analysis and data.analysis.rawDemand or nil,
            demandStars = data.analysis and data.analysis.demandStars or nil,
            effectiveValue = 0,
            effectiveRule = "IGNORED",

            raw =
                item,

            data =
                data,

            ignoredByMin =
                false,

            ignoredIncomingUnwanted =
                false,

            ignoredIncomingReason =
                nil,

            bypassedOwnMinimum =
                false,
        }

        result.items[
            #result.items + 1
        ] = row

        if isHardBlockedItem(item) then
            result.hardBlocked =
                result.hardBlocked + 1

            result.hardBlockedNames[
                #result.hardBlockedNames + 1
            ] = data.name

            row.hardBlocked = true
            continue
        end

        local incomingReason = Runtime.incomingItemIgnoreReason(item, options)
        if incomingReason then
            result.unwantedIncomingIgnored += 1
            result.unwantedIncomingNames[#result.unwantedIncomingNames + 1] = data.name
            row.ignoredIncomingUnwanted, row.ignoredIncomingReason = true, incomingReason
            continue
        end

        if demandSide == "mine" and row.isRealPet then
            local ownReason = DemandPolicy.ownAnalysisReason(data.analysis)
            if ownReason == "OUR 3 STAR PET PROTECTED" then
                result.protectedPets = result.protectedPets + 1
                result.protectedPetNames[#result.protectedPetNames + 1] = data.name
            elseif ownReason then
                result.demandUnknown = result.demandUnknown + 1
                result.demandUnknownNames[#result.demandUnknownNames + 1] = data.name
            end
        end

        local function addKnownValue()

            local bypassOwnMinimum =
                options.bypassOwnMinimumForUnwanted == true
                and CommonPetFilter.shouldBypassOurMinimum(
                    item
                )

            if
                type(data.value) == "number"
                and data.value < minValue
                and not bypassOwnMinimum
            then

                result.belowMin =
                    result.belowMin
                    + 1

                result.belowMinNames[
                    #result.belowMinNames + 1
                ] =
                    data.name

                row.ignoredByMin =
                    ignoreBelowMin

                if ignoreBelowMin then
                    return
                end
            elseif
                type(data.value) == "number"
                and data.value < minValue
                and bypassOwnMinimum
            then
                row.bypassedOwnMinimum = true
            end

            result.total =
                result.total
                + data.value

            if demandSide == "theirs" then
                local credit, rule = DemandPolicy.credit(
                    data.value, data.analysis, Settings.itemMinimumWinPercent
                )
                row.effectiveRule = rule
                if credit == nil then
                    result.demandUnknown = result.demandUnknown + 1
                    result.demandUnknownNames[#result.demandUnknownNames + 1] = data.name
                    return
                end
                row.effectiveValue = credit
            else
                row.effectiveValue = data.value
                row.effectiveRule = "RAW"
            end
            result.effectiveTotal = result.effectiveTotal + row.effectiveValue
        end

        if data.known then

            if data.newIgnored then

                result.newIgnored =
                    result.newIgnored
                    + 1

                result.newNames[
                    #result.newNames + 1
                ] =
                    data.name

            elseif
                data.estimated
            then

                result.estimated =
                    result.estimated
                    + 1

                result.estimatedNames[
                    #result.estimatedNames + 1
                ] =
                    data.name

                if
                    allowEstimated
                    or not Settings.blockEstimated
                then
                    addKnownValue()
                end

            else
                addKnownValue()
            end

        else

            result.unknown =
                result.unknown
                + 1

            result.unknownNames[
                #result.unknownNames + 1
            ] =
                data.name
        end
    end

    return result
end

local function profitPercent(
    mine,
    theirs
)

    if
        type(mine)
            ~= "number"
        or type(theirs)
            ~= "number"
        or mine <= 0
    then

        return nil
    end

    return

        (
            (
                theirs
                - mine
            )
            / mine
        )
        * 100
end


--============================================================
-- REMOTE RESOLUTION
--============================================================

local function scanRemote(name)

    local API =
        RS:
        FindFirstChild(
            "API"
        )

    if API then

        local direct =
            API:
            FindFirstChild(
                name
            )

        if direct then
            return direct
        end

        for _,
            object in ipairs(
                API:GetDescendants()
            )
        do

            if
                object.Name == name
                and (
                    object:IsA(
                        "RemoteEvent"
                    )
                    or object:IsA(
                        "RemoteFunction"
                    )
                )
            then

                return object
            end
        end
    end

    return nil
end


local function routerGet(name)

    if type(RouterClient) ~= "table" then
        return nil
    end

    if type(
        RouterClient.get
    ) ~= "function"
    then

        return nil
    end

    local ok,
        result =
        pcall(
            function()

                return
                    RouterClient.get(
                        name
                    )
            end
        )

    if ok and result then
        return result
    end

    local ok2,
        result2 =
        pcall(
            function()

                return
                    RouterClient:get(
                        name
                    )
            end
        )

    if ok2 then
        return result2
    end

    return nil
end


local function resolveRemote(list)

    if type(list) == "string" then
        list = {list}
    end

    for _,
        name in ipairs(
            list
        )
    do

        local remote =
            scanRemote(
                name
            )

        if remote then

            return
                remote,
                name
        end

        remote =
            routerGet(
                name
            )

        if remote then

            return
                remote,
                name
        end
    end

    return nil
end


local TradeRemote =
    {}


TradeRemote.SendRequest,
TradeRemote.SendRequestName =
    resolveRemote({

        "TradeAPI/SendTradeRequest",
        "TradeAPI/BeginTrade",
        "TradeAPI/RequestTrade",
    })


TradeRemote.Add,
TradeRemote.AddName =
    resolveRemote({

        "TradeAPI/AddItemToOffer",
        "TradeAPI/AddItem",
    })


TradeRemote.Remove,
TradeRemote.RemoveName =
    resolveRemote({

        "TradeAPI/RemoveItemFromOffer",
        "TradeAPI/RemoveItem",
    })


TradeRemote.Accept,
TradeRemote.AcceptName =
    resolveRemote({

        "TradeAPI/AcceptNegotiation",
        "TradeAPI/AcceptTrade",
    })


TradeRemote.Unaccept,
TradeRemote.UnacceptName =
    resolveRemote({

        "TradeAPI/UnacceptNegotiation",
        "TradeAPI/UnacceptTrade",
    })


TradeRemote.Confirm,
TradeRemote.ConfirmName =
    resolveRemote({

        "TradeAPI/ConfirmTrade",
    })


TradeRemote.Decline,
TradeRemote.DeclineName =
    resolveRemote({

        "TradeAPI/DeclineTrade",
        "TradeAPI/CancelTrade",
    })


TradeRemote.QuickChat, TradeRemote.QuickChatName = resolveRemote({"TradeAPI/SendQuickChat"})

local function remoteCall(remote, ...)
    if not remote then return false, "REMOTE MISSING" end
    Runtime.remoteCalls = Runtime.remoteCalls or {}
    local previous = Runtime.remoteCalls[remote]
    if previous and not previous.done and os.clock() < previous.expires then
        return false, "REMOTE BUSY"
    end
    local args = table.pack(...)
    local generation = AutoTradeGeneration
    local before = Runtime.captureTrade(getTrade())
    local operation = {done = false, abandoned = false, expires = os.clock() + 30}
    Runtime.remoteCalls[remote] = operation
    local function invoke()
        local result = table.pack(pcall(function()
            if typeof(remote) == "Instance" then
                if remote:IsA("RemoteEvent") then
                    remote:FireServer(table.unpack(args, 1, args.n))
                    return true
                end
                if remote:IsA("RemoteFunction") then return remote:InvokeServer(table.unpack(args, 1, args.n)) end
            elseif type(remote) == "function" then
                return remote(table.unpack(args, 1, args.n))
            elseif type(remote) == "table" then
                if type(remote.FireServer) == "function" then return remote:FireServer(table.unpack(args, 1, args.n)) end
                if type(remote.InvokeServer) == "function" then return remote:InvokeServer(table.unpack(args, 1, args.n)) end
            end
            error("UNSUPPORTED REMOTE")
        end))
        operation.done = true
        if not operation.abandoned then operation.result = result end
        if Runtime.remoteCalls[remote] == operation then Runtime.remoteCalls[remote] = nil end
    end
    local thread
    if type(Runtime.task.spawn) == "function" then
        thread = Runtime.task.spawn(invoke)
    else
        thread = coroutine.create(invoke)
        coroutine.resume(thread)
    end
    local function cancel(reason)
        operation.abandoned = true
        operation.result = nil
        if type(thread) == "thread" and coroutine.status(thread) ~= "dead" then
            if type(Runtime.task.cancel) == "function" then pcall(Runtime.task.cancel, thread)
            elseif type(coroutine.close) == "function" then pcall(coroutine.close, thread) end
        end
        if Runtime.jobs and thread then Runtime.jobs[thread] = nil end
        return false, reason
    end
    local function current()
        if not Runtime.alive() or generation ~= AutoTradeGeneration then return false end
        if before and before.key then
            local after = Runtime.captureTrade(getTrade())
            if not after or after.key ~= before.key then return false end
        end
        return true
    end
    local deadline = os.clock() + 8
    for _ = 1, 162 do
        if not current() then return cancel("REMOTE CANCELLED") end
        if operation.done then return table.unpack(operation.result, 1, operation.result.n) end
        if os.clock() >= deadline then return cancel("REMOTE TIMEOUT") end
        Runtime.task.wait(0.05)
    end
    return cancel("REMOTE TIMEOUT")
end


--============================================================
-- INVENTORY
--============================================================

local function getInventory()

    local ok,
        inventory =
        pcall(
            function()

                return
                    ClientData.get(
                        "inventory"
                    )
            end
        )

    if
        ok
        and type(inventory)
            == "table"
    then

        return inventory
    end

    if
        type(
            ClientData.get_data
        ) == "function"
    then

        local ok2,
            data =
            pcall(
                ClientData.get_data
            )

        if
            ok2
            and type(data)
                == "table"
        then

            if
                type(
                    data.inventory
                ) == "table"
            then

                return
                    data.inventory
            end
        end
    end

    return nil
end


local function itemLocked(item)

    if
        item.locked == true
        or item.is_locked == true
    then

        return true
    end

    if
        type(
            item.properties
        ) == "table"
        and (
            item.properties.locked
                == true
            or item.properties.is_locked
                == true
        )
    then

        return true
    end

    return false
end


local function inventoryItems()

    local inventory =
        getInventory()

    local result =
        {}

    local seen =
        {}

    if type(inventory) ~= "table" then
        return result
    end

    for category,
        bucket in pairs(
            inventory
        )
    do

        if type(bucket) == "table" then

            for uid,
                raw in pairs(
                    bucket
                )
            do

                if type(raw) == "table" then

                    local item =
                        shallowCopy(
                            raw
                        )

                    item.category =
                        item.category
                        or category

                    item.unique =
                        item.unique
                        or item.uid
                        or uid

                    if
                        item.kind
                        and item.category
                        and item.unique
                        and not itemLocked(
                            item
                        )
                    then

                        local key =
                            tostring(
                                item.unique
                            )

                        if not seen[key] then

                            seen[key] =
                                true

                            result[
                                #result + 1
                            ] =
                                item
                        end
                    end
                end
            end
        end
    end

    return result
end


--============================================================
-- ALLOWED ITEMS
--============================================================

local function parseAllowed()

    local text =
        tostring(
            Settings.allowedItems
            or ""
        )

    text =
        text:gsub(
            "\n",
            ","
        )

    text =
        text:gsub(
            ";",
            ","
        )

    local result =
        {}

    for part in text:gmatch(
        "[^,]+"
    ) do

        local key =
            normalize(
                part
            )

        if key ~= "" then
            result[key] = true
        end
    end

    return result
end


local function isAllowed(name)

    if HARD_BLOCKED_ITEMS[normalize(name)] then
        return false
    end

    local allowed =
        parseAllowed()

    if next(allowed) == nil then
        return true
    end

    return

        allowed[
            normalize(
                name
            )
        ]
        == true
end


local function valuedInventory()

    local result =
        {}

    for _,
        item in ipairs(
            inventoryItems()
        )
    do

        local data =
            effectiveItemValue(
                item
            )

        local isPet =
            tostring(
                item.category
                or ""
            )
            == "pets"

        local estimatedAllowed =
            data.estimated
            and isPet
            and Settings.allowEstimatedOwnPets
                == true

        if
            data.known
            and not data.newIgnored
            and (
                not data.estimated
                or estimatedAllowed
                or not Settings.blockEstimated
            )
            and data.value > 0
            and (
                data.value
                    >= activeMinItemValue("mine")
                or CommonPetFilter.shouldBypassOurMinimum(
                    item
                )
            )
            -- AUTO TRADE must never build an offer from guessed pet values.
            -- Estimated values may still be displayed outside AUTO TRADE,
            -- but the optimizer only receives exact AMVGG variants.
            and not (
                Settings.autoTrade
                and data.estimated
            )
            and DemandPolicy.ownAnalysisReason(data.analysis) == nil

            and isAllowed(
                data.name
            )
        then

            result[
                #result + 1
            ] = {

                item =
                    item,

                uid =
                    tostring(
                        itemUID(
                            item
                        )
                    ),

                name =
                    data.name,

                variant =
                    getVariant(
                        item
                    ),

                category =
                    tostring(
                        item.category
                        or "unknown"
                    ),

                isPet =
                    isPet,

                estimated =
                    data.estimated
                    == true,

                value =
                    data.value,
            }
        end
    end

    table.sort(
        result,
        function(a, b)

            if
                math.abs(
                    a.value - b.value
                )
                < 0.000000001
                and a.isPet ~= b.isPet
            then
                return a.isPet
            end

            return
                a.value
                > b.value
        end
    )

    return result
end

--============================================================
-- OPTIMIZER
--============================================================

local function optimizeOurOffer(
    theirEffectiveTotal
)
    -- Per-item demand/item rules already include the required win.
    local cap = tonumber(theirEffectiveTotal) or 0
    local operationContext = Runtime.captureTrade(getTrade())
    local initialPrices, initialPolicy, initialGeneration = AMVGG.version, Runtime.policySignature(), AutoTradeGeneration

    if cap <= 0 then

        return
            {},
            0,
            cap
    end

    local all =
        valuedInventory()

    local candidates =
        {}

    for _,
        candidate in ipairs(
            all
        )
    do

        if
            candidate.value
            <= cap
        then

            candidates[
                #candidates + 1
            ] =
                candidate
        end
    end

    if #candidates == 0 then

        return
            {},
            0,
            cap
    end

    if #candidates > 140 then
        -- Keep useful multiplicity of equal prices and preserve cheap fillers.
        -- This remains bounded beam search, not a promise of a global optimum.
        local perPrice, diverse = {}, {}
        local multiplicity = math.clamp(math.floor(tonumber(Settings.maxOurItems) or 18), 1, 18)
        for _, candidate in ipairs(candidates) do
            local key = string.format("%.7f:%s", candidate.value, tostring(candidate.isPet))
            local count = perPrice[key] or 0
            if count < multiplicity then diverse[#diverse + 1] = candidate perPrice[key] = count + 1 end
        end
        if #diverse > 280 then
            local selected, indices = {}, {}
            local function keep(index) if not indices[index] then indices[index] = true end end
            for index = 1, 70 do keep(index) keep(#diverse - index + 1) end
            for index = 0, 139 do keep(1 + math.floor(index * (#diverse - 1) / 139)) end
            for index, candidate in ipairs(diverse) do if indices[index] then selected[#selected + 1] = candidate end end
            diverse = selected
        end
        candidates = diverse
    end

    local beam = {

        {
            total =
                0,

            petCount =
                0,

            list =
                {},
        }
    }

    local width =
        math.max(
            80,
            math.floor(
                tonumber(
                    Settings.optimizerBeam
                )
                or 350
            )
        )

    local maxItems =
        math.clamp(
            math.floor(
                tonumber(
                    Settings.maxOurItems
                )
                or 18
            ),
            1,
            18
        )

    for candidateIndex,
        candidate in ipairs(
            candidates
        )
    do

        if candidateIndex % 16 == 0 then
            Runtime.task.wait()
            if AMVGG.loading or AMVGG.dataStale or AMVGG.version ~= initialPrices
                or Runtime.policySignature() ~= initialPolicy or AutoTradeGeneration ~= initialGeneration
                or (operationContext and not Runtime.liveContext(operationContext, true, true)) then
                return {}, 0, cap, "OPTIMIZATION CONTEXT CHANGED"
            end
        end
        local expanded =
            {}

        for _,
            state in ipairs(
                beam
            )
        do

            expanded[
                #expanded + 1
            ] =
                state

            if
                #state.list
                < maxItems
            then

                local total =
                    state.total
                    + candidate.value

                if
                    total
                    <= cap
                    + 0.000000001
                then

                    local list =
                        {}

                    for index,
                        old in ipairs(
                            state.list
                        )
                    do

                        list[index] =
                            old
                    end

                    list[
                        #list + 1
                    ] =
                        candidate

                    expanded[
                        #expanded + 1
                    ] = {

                        total =
                            total,

                        petCount =
                            (
                                state.petCount
                                or 0
                            )
                            + (
                                candidate.isPet
                                and 1
                                or 0
                            ),

                        list =
                            list,
                    }
                end
            end
        end

        table.sort(
            expanded,
            function(a, b)

                if
                    math.abs(
                        a.total - b.total
                    )
                    < 0.000000001
                    and (
                        a.petCount
                        or 0
                    )
                    ~= (
                        b.petCount
                        or 0
                    )
                then
                    return
                        (
                            a.petCount
                            or 0
                        )
                        > (
                            b.petCount
                            or 0
                        )
                end

                return
                    a.total
                    > b.total
            end
        )

        local unique =
            {}

        local nextBeam =
            {}

        for _,
            state in ipairs(
                expanded
            )
        do

            local key =
                string.format(
                    "%.7f:%d",
                    state.total,
                    #state.list
                )

            if not unique[key] then

                unique[key] =
                    true

                nextBeam[
                    #nextBeam + 1
                ] =
                    state

                if
                    #nextBeam
                    >= width
                then

                    break
                end
            end
        end

        beam =
            nextBeam
    end

    local best =
        beam[1]

    if not best then

        return
            {},
            0,
            cap
    end

    return

        best.list,
        best.total,
        cap
end


--============================================================
-- OFFER CONTROL
--============================================================

local function addOurItem(uid)

    if not TradeRemote.Add then
        return false
    end

    local context = Runtime.captureTrade(getTrade())
    local live = Runtime.liveContext(context, true, true)
    if not live or Runtime.tradeInConfirmation(live) then return false, "TRADE_CHANGED" end
    local found = false
    for _, item in ipairs(inventoryItems()) do
        if tostring(itemUID(item)) == tostring(uid) then
            local data = effectiveItemValue(item)
            if not isAllowed(data.name) then return false, "OUR ITEM NOT ALLOWED" end
            if not data.known or data.newIgnored or data.estimated or data.value <= 0 then return false, "EXACT SAFE VALUE REQUIRED" end
            if data.value < activeMinItemValue("mine") and not CommonPetFilter.shouldBypassOurMinimum(item) then return false, "OUR ITEM < MIN VALUE" end
            local reason = DemandPolicy.ownItemReason(item)
            if reason then return false, reason end
            found = true
            break
        end
    end
    if not found then return false, "ITEM NO LONGER IN INVENTORY" end

    if not Runtime.liveContext(context, true, true) then return false, "TRADE_CHANGED" end
    return
        remoteCall(
            TradeRemote.Add,
            uid
        )
end


local function removeOurItem(uid)

    if not TradeRemote.Remove then
        return false
    end

    return
        remoteCall(
            TradeRemote.Remove,
            uid
        )
end


local function currentUIDSet(offer)

    local result =
        {}

    for _,
        item in pairs(
            getOfferItems(
                offer
            )
        )
    do

        local uid =
            itemUID(
                item
            )

        if uid then

            result[
                tostring(
                    uid
                )
            ] =
                true
        end
    end

    return result
end


local function rebuildOurOffer(myOffer, desired, expectedTheirSignature)
    local function partnerKey(partner)
        if typeof(partner) == "Instance" then
            return "id:" .. tostring(partner.UserId)
        end
        if type(partner) == "number" then return "id:" .. tostring(partner) end
        if type(partner) == "table" then
            local id = partner.user_id or partner.userId or partner.id
            if id ~= nil then return "id:" .. tostring(id) end
        end
        return "name:" .. playerName(partner):lower()
    end

    local initial = getTrade()
    local initialMine, initialTheirs, _, initialPartner = getTradeSides(initial)
    if not initialMine or not initialTheirs or not initialPartner then
        return false, "TRADE_CHANGED"
    end
    local initialID = tostring(initial.trade_id or initial.id or playerName(initialPartner))
    local initialPartnerKey = partnerKey(initialPartner)
    local initialGeneration = AutoTradeGeneration
    local initialPrices, initialPolicy = AMVGG.version, Runtime.policySignature()

    -- Check the operation's trade context after every yield, including remote
    -- replies. An identical incoming offer in another trade is not this build.
    local function contextReason()
        if not Settings.autoTrade or initialGeneration ~= AutoTradeGeneration then
            return "AUTO_DISABLED"
        end
        if not Gui.Parent or not Runtime.alive() then return "GUI_CLOSED" end
        if AMVGG.loading or AMVGG.dataStale or not AMVGG.ready then return "PRICES_UNAVAILABLE" end
        if AMVGG.version ~= initialPrices then return "PRICES_CHANGED" end
        if Runtime.policySignature() ~= initialPolicy then return "POLICY_CHANGED" end
        local live = getTrade()
        local mine, theirs, _, partner = getTradeSides(live)
        if not mine or not theirs or not partner
            or tostring(live.trade_id or live.id or playerName(partner)) ~= initialID
            or partnerKey(partner) ~= initialPartnerKey then
            return "TRADE_CHANGED"
        end
        local stage = tostring(live.current_stage or live.stage or live.state or ""):lower()
        if live.confirmation_started == true or live.confirming == true
            or stage:find("confirm", 1, true) then
            return "TRADE_CONFIRMING"
        end
        if mine.negotiated == true or mine.accepted == true or mine.is_accepted == true then return "OUR_OFFER_ACCEPTED" end
        if expectedTheirSignature ~= nil and offerSignature(theirs) ~= expectedTheirSignature then
            return "THEIR_CHANGED"
        end
        return nil
    end

    local reason = contextReason()
    if reason then return false, reason end
    for _, item in pairs(getOfferItems(myOffer)) do
        reason = DemandPolicy.ownItemReason(item)
        if reason then return false, reason end
    end
    for _, candidate in ipairs(desired) do
        if not isAllowed(effectiveItemValue(candidate.item).name) then return false, "OUR ITEM NOT ALLOWED" end
        reason = DemandPolicy.ownItemReason(candidate.item)
        if reason then return false, reason end
    end

    local current, wanted = currentUIDSet(myOffer), {}
    for _, candidate in ipairs(desired) do
        if candidate.uid == nil then return false, "MISSING_UID" end
        wanted[tostring(candidate.uid)] = true
    end
    local actionDelay = math.max(0.1, tonumber(Settings.itemActionDelay) or 0.85)
    local settleDelay = math.max(0.25, tonumber(Settings.postRebuildDelay) or 1.25)
    local replicationTimeout = math.clamp(settleDelay * 2, 2, 8)
    local function observe(uid, expected)
        local deadline = os.clock() + replicationTimeout
        for _ = 1, math.ceil(replicationTimeout / 0.1) + 1 do
            local changed = contextReason()
            if changed then return false, changed end
            local mine = getTradeSides(getTrade())
            local actual = currentUIDSet(mine)
            if (actual[tostring(uid)] == true) == expected then return true end
            if os.clock() >= deadline then break end
            Runtime.task.wait(0.1)
        end
        return false, "OFFER_REPLICATION_TIMEOUT"
    end

    for _, item in pairs(getOfferItems(myOffer)) do
        local uid = itemUID(item)
        if uid ~= nil and not wanted[tostring(uid)] then
            Runtime.task.wait(actionDelay)
            reason = contextReason()
            if reason then return false, reason end
            reason = DemandPolicy.ownItemReason(item)
            if reason then return false, reason end
            local ok, result = removeOurItem(tostring(uid))
            reason = contextReason()
            if reason then return false, reason end
            if not ok or result == false then return false, "REMOVE FAILED" end
            local observed, failure = observe(uid, false)
            if not observed then return false, failure end
        end
    end

    Runtime.task.wait(settleDelay * 0.5)
    reason = contextReason()
    if reason then return false, reason end
    for _, candidate in ipairs(desired) do
        current = currentUIDSet(getTradeSides(getTrade()))
        if not current[tostring(candidate.uid)] then
            Runtime.task.wait(actionDelay)
            reason = contextReason()
            if reason then return false, reason end
            local added, result = addOurItem(candidate.uid)
            reason = contextReason()
            if reason then return false, reason end
            if not added or result == false then return false, result or "ADD FAILED" end
            local observed, failure = observe(candidate.uid, true)
            if not observed then return false, failure end
        end
    end
    Runtime.task.wait(settleDelay)
    reason = contextReason()
    if reason then return false, reason end
    local mine = getTradeSides(getTrade())
    local actual = currentUIDSet(mine)
    for uid in pairs(wanted) do if not actual[uid] then return false, "FINAL_OFFER_MISMATCH" end end
    for uid in pairs(actual) do if not wanted[uid] then return false, "FINAL_OFFER_MISMATCH" end end
    return true, nil
end


--============================================================
-- CHAT
--============================================================

local function sendChat(text)

    if not Settings.chatRequests then
        return false
    end

    local sent =
        false

    pcall(
        function()

            local channels =
                TextChatService:
                FindFirstChild(
                    "TextChannels"
                )

            local general =
                channels
                and channels:
                FindFirstChild(
                    "RBXGeneral"
                )

            if general then

                general:
                SendAsync(
                    text
                )

                sent =
                    true
            end
        end
    )

    return sent
end


--============================================================
-- GUI MAIN
--============================================================

setBoot(
    "3/9",
    "BUILDING GUI"
)


Gui =
    Instance.new(
        "ScreenGui"
    )

Gui.Name =
    GUI_NAME

Gui.ResetOnSpawn =
    false

Gui.DisplayOrder =
    999999

Gui.Parent =
    GuiParent
Runtime.gui = Gui
Runtime.connect(Gui.Destroying, function() Runtime.stop("GUI destroyed") end)


local Main =
    Instance.new(
        "Frame"
    )

Main.Size =
    UDim2.new(
        0.94,
        0,
        0.86,
        0
    )

Main.Position =
    UDim2.new(
        0.03,
        0,
        0.06,
        0
    )

Main.BackgroundColor3 =
    C.BG

Main.BorderSizePixel =
    0

Main.ClipsDescendants =
    true

Main.Parent =
    Gui


corner(
    Main,
    12
)


stroke(
    Main,
    0.15
)


local Top =
    Instance.new(
        "Frame"
    )

Top.Size =
    UDim2.new(
        1,
        0,
        0,
        52
    )

Top.BackgroundColor3 =
    C.TOP

Top.BorderSizePixel =
    0

Top.Parent =
    Main


label(
    Top,

    "ADOPT ME  •  TRADE ANALYZER",

    UDim2.new(
        0,
        390,
        1,
        0
    ),

    UDim2.fromOffset(
        18,
        0
    ),

    Enum.Font.GothamBold,
    16,
    C.TEXT
)


local VersionLabel =
    label(
        Top,

        "V"
        .. VERSION,

        UDim2.fromOffset(
            72,
            25
        ),

        UDim2.new(
            0,
            310,
            0.5,
            -12
        ),

        Enum.Font.GothamBold,
        10,
        C.ACCENT,
        Enum.TextXAlignment.Center
    )


VersionLabel.BackgroundTransparency =
    0

VersionLabel.BackgroundColor3 =
    Color3.fromRGB(
        35,
        50,
        80
    )


corner(
    VersionLabel,
    6
)


local CloseButton =
    button(
        Top,
        "X",

        UDim2.fromOffset(
            40,
            34
        ),

        UDim2.new(
            1,
            -50,
            0,
            9
        )
    )


--============================================================
-- DRAG
--============================================================

local dragging =
    false

local dragStart
local dragOrigin


Runtime.connect(Top.InputBegan,
    function(input)

        if
            input.UserInputType
                == Enum.UserInputType.Touch

            or input.UserInputType
                == Enum.UserInputType.MouseButton1
        then

            dragging =
                true

            dragStart =
                input.Position

            dragOrigin =
                Main.Position
        end
    end
)


Runtime.connect(UIS.InputChanged,
    function(input)

        if not dragging then
            return
        end

        if
            input.UserInputType
                ~= Enum.UserInputType.Touch

            and input.UserInputType
                ~= Enum.UserInputType.MouseMovement
        then

            return
        end

        local camera =
            workspace.CurrentCamera

        if not camera then
            return
        end

        local viewport =
            camera.ViewportSize

        local delta =
            input.Position
            - dragStart

        local x =
            dragOrigin.X.Scale
                * viewport.X
            + dragOrigin.X.Offset
            + delta.X

        local y =
            dragOrigin.Y.Scale
                * viewport.Y
            + dragOrigin.Y.Offset
            + delta.Y

        x =
            math.clamp(
                x,
                0,
                math.max(
                    0,
                    viewport.X
                    - Main.AbsoluteSize.X
                )
            )

        y =
            math.clamp(
                y,
                0,
                math.max(
                    0,
                    viewport.Y
                    - Main.AbsoluteSize.Y
                )
            )

        Main.Position =
            UDim2.fromOffset(
                x,
                y
            )
    end
)


Runtime.connect(UIS.InputEnded,
    function(input)

        if
            input.UserInputType
                == Enum.UserInputType.Touch

            or input.UserInputType
                == Enum.UserInputType.MouseButton1
        then

            dragging =
                false
        end
    end
)


--============================================================
-- PAGE SYSTEM
--============================================================

local Sidebar =
    Instance.new(
        "Frame"
    )

Sidebar.Position =
    UDim2.fromOffset(
        0,
        52
    )

Sidebar.Size =
    UDim2.new(
        0,
        145,
        1,
        -52
    )

Sidebar.BackgroundColor3 =
    C.SIDE

Sidebar.BorderSizePixel =
    0

Sidebar.Parent =
    Main


label(
    Sidebar,
    "MENU",

    UDim2.new(
        1,
        -20,
        0,
        30
    ),

    UDim2.fromOffset(
        14,
        10
    ),

    Enum.Font.GothamBold,
    10,
    C.MUTED
)


local Content =
    Instance.new(
        "Frame"
    )

Content.Position =
    UDim2.fromOffset(
        145,
        52
    )

Content.Size =
    UDim2.new(
        1,
        -145,
        1,
        -52
    )

Content.BackgroundTransparency =
    1

Content.Parent =
    Main


local Pages =
    {}

local Navigation =
    {}


local function createPage(name)

    local page =
        Instance.new(
            "Frame"
        )

    page.Name =
        name

    page.Size =
        UDim2.fromScale(
            1,
            1
        )

    page.BackgroundTransparency =
        1

    page.Visible =
        false

    page.Parent =
        Content

    Pages[name] =
        page

    return page
end


local function setPage(name)

    for pageName,
        page in pairs(
            Pages
        )
    do

        page.Visible =
            pageName
            == name
    end

    for buttonName,
        navButton in pairs(
            Navigation
        )
    do

        if buttonName == name then

            navButton.BackgroundColor3 =
                Color3.fromRGB(
                    48,
                    76,
                    130
                )

            navButton.TextColor3 =
                C.TEXT

        else

            navButton.BackgroundColor3 =
                C.PANEL

            navButton.TextColor3 =
                C.MUTED
        end
    end
end


local function nav(
    name,
    y
)

    local value =
        button(
            Sidebar,

            "   "
            .. name,

            UDim2.new(
                1,
                -20,
                0,
                30
            ),

            UDim2.fromOffset(
                10,
                y
            )
        )

    value.TextXAlignment =
        Enum.TextXAlignment.Left

    value.BackgroundColor3 =
        C.PANEL

    value.TextColor3 =
        C.MUTED

    Runtime.connect(value.Activated,
        function()

            setPage(
                name
            )
        end
    )

    Navigation[name] =
        value
end


nav(
    "TRADE",
    42
)

nav(
    "VALUES",
    76
)

nav(
    "UPDATES",
    110
)

nav(
    "SETTINGS",
    144
)

--============================================================
-- TRADE PAGE
--============================================================

local TradePage =
    createPage(
        "TRADE"
    )


label(
    TradePage,
    "LIVE TRADE",

    UDim2.new(
        1,
        -30,
        0,
        32
    ),

    UDim2.fromOffset(
        16,
        8
    ),

    Enum.Font.GothamBold,
    19,
    C.TEXT
)


local TradeStatus =
    label(
        TradePage,
        "WAITING FOR TRADE",

        UDim2.new(
            1,
            -30,
            0,
            26
        ),

        UDim2.fromOffset(
            16,
            42
        ),

        Enum.Font.Code,
        11,
        C.MUTED
    )


local TradeInfo =
    textBox(
        TradePage,
        "",
        "",

        UDim2.new(
            1,
            -30,
            1,
            -100
        ),

        UDim2.fromOffset(
            15,
            72
        )
    )


TradeInfo.MultiLine =
    true

TradeInfo.TextEditable =
    true

TradeInfo.TextWrapped =
    false

TradeInfo.TextXAlignment =
    Enum.TextXAlignment.Left

TradeInfo.TextYAlignment =
    Enum.TextYAlignment.Top

TradeInfo.Font =
    Enum.Font.Code

TradeInfo.TextSize =
    10


--============================================================
-- VALUES PAGE
--============================================================

do -- Values and Updates UI local scope
local ValuesPage =
    createPage(
        "VALUES"
    )


label(
    ValuesPage,
    "AMVGG VALUES",

    UDim2.new(
        1,
        -30,
        0,
        32
    ),

    UDim2.fromOffset(
        16,
        8
    ),

    Enum.Font.GothamBold,
    19,
    C.TEXT
)


local SearchBox =
    textBox(
        ValuesPage,
        "",
        "Search...",

        UDim2.new(
            1,
            -30,
            0,
            34
        ),

        UDim2.fromOffset(
            15,
            48
        )
    )


local SearchResult =
    textBox(
        ValuesPage,
        "",
        "",

        UDim2.new(
            1,
            -30,
            1,
            -105
        ),

        UDim2.fromOffset(
            15,
            92
        )
    )


SearchResult.MultiLine =
    true

SearchResult.TextEditable =
    true

SearchResult.TextXAlignment =
    Enum.TextXAlignment.Left

SearchResult.TextYAlignment =
    Enum.TextYAlignment.Top

SearchResult.Font =
    Enum.Font.Code

SearchResult.TextSize =
    10


function Runtime.rebuildSearch()

    if not AMVGG.ready then

        SearchResult.Text =
            "AMVGG NOT READY"

        return
    end

    local query =
        normalize(
            SearchBox.Text
        )

    local rows =
        {}

    for source,
        database in pairs(
            AMVGG.categories
        )
    do

        for _,
            entry in pairs(
                database
            )
        do

            local name =
                tostring(
                    entry.name
                    or ""
                )

            if
                query == ""
                or normalize(name):
                    find(
                        query,
                        1,
                        true
                    )
            then

                local value =
                    num(
                        entry.regularValue
                    )
                    or num(
                        entry.value
                    )
                    or num(
                        entry.npRegularValue
                    )

                rows[
                    #rows + 1
                ] = {

                    name =
                        name,

                    source =
                        source,

                    value =
                        value,
                }
            end
        end
    end

    table.sort(
        rows,
        function(a, b)

            return
                (
                    a.value
                    or -999
                )
                >
                (
                    b.value
                    or -999
                )
        end
    )

    local lines =
        {}

    for i = 1,
        math.min(
            #rows,
            100
        )
    do

        local row =
            rows[i]

        lines[
            #lines + 1
        ] =
            row.name
            .. "  ["
            .. row.source
            .. "]  = "
            .. valueText(
                row.value
            )
    end

    SearchResult.Text =
        table.concat(
            lines,
            "\n"
        )
end


Runtime.connect(SearchBox:GetPropertyChangedSignal("Text"),
    function()

        Runtime.task.delay(
            0.15,
            Runtime.rebuildSearch
        )
    end
)


--============================================================
-- UPDATES PAGE
--============================================================

local UpdatesPage =
    createPage(
        "UPDATES"
    )


label(
    UpdatesPage,
    "AMVGG UPDATE STATUS",

    UDim2.new(
        1,
        -30,
        0,
        32
    ),

    UDim2.fromOffset(
        16,
        8
    ),

    Enum.Font.GothamBold,
    19,
    C.TEXT
)


local UpdatesText =
    textBox(
        UpdatesPage,
        "",
        "",

        UDim2.new(
            1,
            -30,
            0,
            300
        ),

        UDim2.fromOffset(
            15,
            52
        )
    )


UpdatesText.MultiLine =
    true

UpdatesText.TextEditable =
    true

UpdatesText.TextXAlignment =
    Enum.TextXAlignment.Left

UpdatesText.TextYAlignment =
    Enum.TextYAlignment.Top

UpdatesText.Font =
    Enum.Font.Code


local RefreshButton =
    button(
        UpdatesPage,
        "REFRESH NOW",

        UDim2.fromOffset(
            180,
            36
        ),

        UDim2.fromOffset(
            15,
            368
        )
    )


function Runtime.updateStatusPage()

    local lines = {

        "READY = "
        .. tostring(
            AMVGG.ready
        ),

        "LOADING = "
        .. tostring(
            AMVGG.loading
        ),

        "VERSION = "
        .. tostring(
            AMVGG.version
        ),

        "TOTAL = "
        .. tostring(
            AMVGG.total
        ),

        "",
    }

    for _,
        slug in ipairs(
            CATEGORY_URLS
        )
    do

        lines[
            #lines + 1
        ] =
            slug
            .. " = "
            .. tostring(
                AMVGG.counts[
                    slug
                ]
                or 0
            )
    end

    if AMVGG.error then

        lines[
            #lines + 1
        ] =
            ""

        lines[
            #lines + 1
        ] =
            "ERROR = "
            .. AMVGG.error
    end

    UpdatesText.Text =
        table.concat(
            lines,
            "\n"
        )
end


Runtime.connect(RefreshButton.Activated,
    function()

        Runtime.task.spawn(
            function()

                refresh()

                updateFirstSeen()

                Runtime.updateStatusPage()

                Runtime.rebuildSearch()
            end
        )
    end
)


--============================================================
end -- Values and Updates UI local scope

-- SETTINGS PAGE
--============================================================

local SettingsPage =
    createPage(
        "SETTINGS"
    )


label(
    SettingsPage,
    "SETTINGS",

    UDim2.new(
        1,
        -30,
        0,
        32
    ),

    UDim2.fromOffset(
        16,
        8
    ),

    Enum.Font.GothamBold,
    19,
    C.TEXT
)


--============================================================
-- AUTO TRADE CONTROLS (ALL INSIDE SETTINGS)
--============================================================


label(
    SettingsPage,
    "AUTO TRADE",

    UDim2.new(
        1,
        -30,
        0,
        32
    ),

    UDim2.fromOffset(
        16,
        48
    ),

    Enum.Font.GothamBold,
    16,
    C.ACCENT
)


local TestStatus =
    label(
        SettingsPage,
        "STATUS: OFF",

        UDim2.new(
            1,
            -30,
            0,
            24
        ),

        UDim2.fromOffset(
            16,
            78
        ),

        Enum.Font.Code,
        10,
        C.MUTED
    )


local TestScroll =
    makeScroll(
        SettingsPage,

        UDim2.new(
            1,
            -30,
            1,
            -120
        ),

        UDim2.fromOffset(
            15,
            108
        )
    )


local TestCanvas =
    Instance.new(
        "Frame"
    )

TestCanvas.Size =
    UDim2.new(
        1,
        -10,
        0,
        1640
    )

TestCanvas.BackgroundTransparency =
    1

TestCanvas.Parent =
    TestScroll


local AutoToggle =
    button(
        TestCanvas,
        "",

        UDim2.new(
            1,
            -24,
            0,
            36
        ),

        UDim2.fromOffset(
            10,
            10
        )
    )


local function renderModes()

    AutoToggle.Text =
        "AUTO TRADE: "
        .. (
            Settings.autoTrade
            and "ON"
            or "OFF"
        )

    AutoToggle.BackgroundColor3 =
        Settings.autoTrade
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end


Runtime.connect(AutoToggle.Activated,
    function()

        Settings.autoTrade =
            not Settings.autoTrade

        if not Settings.autoTrade then Runtime.disableAutomation() end

        if Settings.autoTrade then
            -- Real AUTO TRADE is always strict. The old estimated-value
            -- multipliers are useful only for rough display.
            Settings.blockEstimated = true
        end

        saveSettings()

        renderModes()
    end
)


renderModes()


-- All Auto Trade controls live inside SETTINGS.
label(
    TestCanvas,
    "AUTO TRADE SETTINGS",

    UDim2.new(
        1,
        -24,
        0,
        24
    ),

    UDim2.fromOffset(
        12,
        54
    ),

    Enum.Font.GothamBold,
    10,
    C.ACCENT
)


local TestEstimatedToggle =
    button(
        TestCanvas,
        "",

        UDim2.new(
            1,
            -24,
            0,
            22
        ),

        UDim2.fromOffset(
            10,
            82
        )
    )


local function renderTestEstimated()
    TestEstimatedToggle.Text = "PRICES: EXACT AMVGG ONLY"
    TestEstimatedToggle.Active, TestEstimatedToggle.AutoButtonColor = false, false
end
renderTestEstimated()

local AllowEstimatedOwnPetsToggle = button(TestCanvas, "UNKNOWN PRICES: BLOCKED",
    UDim2.new(1, -24, 0, 22), UDim2.fromOffset(10, 108))
AllowEstimatedOwnPetsToggle.Active, AllowEstimatedOwnPetsToggle.AutoButtonColor = false, false

local function settingInput(
    title,
    value,
    y
)

    label(
        TestCanvas,
        title,

        UDim2.fromOffset(
            210,
            30
        ),

        UDim2.fromOffset(
            12,
            y
        ),

        Enum.Font.GothamBold,
        10,
        C.MUTED
    )

    return
        textBox(
            TestCanvas,
            value,
            "",

            UDim2.fromOffset(
                110,
                30
            ),

            UDim2.fromOffset(
                245,
                y
            )
        )
end


local RefreshMinutesInput =
    settingInput(
        "AMVGG REFRESH MINUTES",
        Settings.refreshMinutes,
        164
    )


local ProfitInput =
    settingInput(
        "MIN PROFIT % (MANUAL)",
        Settings.minProfitPercent,
        202
    )


local AddTimeoutInput =
    settingInput(
        "ASK ADD TIMEOUT",
        Settings.addTimeout,
        240
    )


local FirstTimeoutInput =
    settingInput(
        "FIRST ITEM TIMEOUT",
        Settings.firstItemTimeout,
        278
    )


local RequestTimeoutInput =
    settingInput(
        "REQUEST TIMEOUT",
        Settings.requestTimeout,
        316
    )


local CooldownInput =
    settingInput(
        "PLAYER COOLDOWN",
        Settings.playerCooldown,
        354
    )


local NewHoursInput =
    settingInput(
        "NEW ITEM HOURS",
        Settings.newItemHours,
        392
    )


local ItemActionDelayInput =
    settingInput(
        "ITEM ACTION DELAY",
        Settings.itemActionDelay,
        430
    )


local ShowcaseDelayInput =
    settingInput(
        "SHOWCASE DELAY",
        Settings.showcaseDelay,
        468
    )


local PreAcceptDelayInput =
    settingInput(
        "PRE ACCEPT DELAY",
        Settings.preAcceptDelay,
        506
    )


local PostRebuildDelayInput =
    settingInput(
        "POST REBUILD WAIT",
        Settings.postRebuildDelay,
        544
    )


local function bindNumber(
    input,
    key,
    min,
    max
)

    Runtime.connect(input.FocusLost,
        function()

            local value =
                tonumber(
                    input.Text
                )

            if not value then

                input.Text =
                    tostring(
                        Settings[key]
                    )

                return
            end

            Settings[key] =
                math.clamp(
                    value,
                    min,
                    max
                )

            input.Text =
                tostring(
                    Settings[key]
                )

            saveSettings()
        end
    )
end


bindNumber(
    RefreshMinutesInput,
    "refreshMinutes",
    1,
    120
)


bindNumber(
    ProfitInput,
    "minProfitPercent",
    0,
    500
)


bindNumber(
    AddTimeoutInput,
    "addTimeout",
    5,
    300
)


bindNumber(
    FirstTimeoutInput,
    "firstItemTimeout",
    5,
    180
)


bindNumber(
    RequestTimeoutInput,
    "requestTimeout",
    5,
    90
)


bindNumber(
    CooldownInput,
    "playerCooldown",
    10,
    7200
)


bindNumber(
    NewHoursInput,
    "newItemHours",
    1,
    168
)


bindNumber(
    ItemActionDelayInput,
    "itemActionDelay",
    0.1,
    5
)


bindNumber(
    ShowcaseDelayInput,
    "showcaseDelay",
    0,
    30
)


bindNumber(
    PreAcceptDelayInput,
    "preAcceptDelay",
    0,
    20
)


bindNumber(
    PostRebuildDelayInput,
    "postRebuildDelay",
    0.25,
    10
)


--============================================================
-- MIN ITEM VALUE FILTERS
--============================================================

local MinValueModeToggle =
    button(
        TestCanvas,
        "",

        UDim2.new(
            1,
            -24,
            0,
            36
        ),

        UDim2.fromOffset(
            10,
            589
        )
    )


local MyMinValueInput =
    settingInput(
        "MY MIN ITEM VALUE",
        Settings.myMinItemValue,
        633
    )


local TheirMinValueInput =
    settingInput(
        "THEIR MIN ITEM VALUE",
        Settings.theirMinItemValue,
        671
    )


local AllMinValueInput =
    settingInput(
        "ALL MIN ITEM VALUE",
        Settings.allMinItemValue,
        709
    )


local MinValueStatus =
    label(
        TestCanvas,
        "",

        UDim2.new(
            1,
            -24,
            0,
            42
        ),

        UDim2.fromOffset(
            12,
            747
        ),

        Enum.Font.Code,
        9,
        C.ACCENT
    )

MinValueStatus.TextWrapped = true
MinValueStatus.TextYAlignment = Enum.TextYAlignment.Top


local function renderMinValueMode()

    MinValueModeToggle.Text =
        "MIN VALUE MODE: "
        .. tostring(
            Settings.minValueMode
        )

    MinValueModeToggle.BackgroundColor3 =
        Settings.minValueMode == "ALL"
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2

    MinValueStatus.Text =
        "ACTIVE FILTER • MY >= "
        .. valueText(
            activeMinItemValue("mine")
        )
        .. " • THEIR >= "
        .. valueText(
            activeMinItemValue("theirs")
        )
end


Runtime.connect(MinValueModeToggle.Activated,
    function()

        Settings.minValueMode =
            Settings.minValueMode == "ALL"
            and "SEPARATE"
            or "ALL"

        saveSettings()
        renderMinValueMode()
    end
)


bindNumber(
    MyMinValueInput,
    "myMinItemValue",
    0.0005,
    1000
)

bindNumber(
    TheirMinValueInput,
    "theirMinItemValue",
    0.0005,
    1000
)

bindNumber(
    AllMinValueInput,
    "allMinItemValue",
    0.0005,
    1000
)

-- Refresh the active-filter text immediately after a numeric edit.
for _, input in ipairs({
    MyMinValueInput,
    TheirMinValueInput,
    AllMinValueInput,
}) do
    Runtime.connect(input.FocusLost,
        function()
            Runtime.task.defer(renderMinValueMode)
        end
    )
end

renderMinValueMode()


label(
    TestCanvas,
    "ALLOWED ITEMS • blank = all",

    UDim2.fromOffset(
        360,
        24
    ),

    UDim2.fromOffset(
        12,
        801
    ),

    Enum.Font.GothamBold,
    10,
    C.MUTED
)


local AllowedInput =
    textBox(
        TestCanvas,

        Settings.allowedItems,

        "Frost Dragon, Owl, Turtle...",

        UDim2.new(
            1,
            -30,
            0,
            60
        ),

        UDim2.fromOffset(
            12,
            821
        )
    )


AllowedInput.MultiLine =
    true

AllowedInput.TextWrapped =
    true


Runtime.connect(AllowedInput.FocusLost,
    function()

        Settings.allowedItems =
            AllowedInput.Text

        saveSettings()
    end
)


local ChatToggle =
    button(
        TestCanvas,
        "",

        UDim2.new(
            1,
            -24,
            0,
            36
        ),

        UDim2.fromOffset(
            10,
            893
        )
    )


local ScanInventory =
    button(
        TestCanvas,
        "SCAN INVENTORY",

        UDim2.new(
            1,
            -24,
            0,
            36
        ),

        UDim2.fromOffset(
            10,
            937
        )
    )


local function renderChat()

    ChatToggle.Text =
        "CHAT REQUEST: "
        .. (
            Settings.chatRequests
            and "ON"
            or "OFF"
        )
end


Runtime.connect(ChatToggle.Activated,
    function()

        Settings.chatRequests =
            not Settings.chatRequests

        saveSettings()

        renderChat()
    end
)


renderChat()


local TestLogs =
    {}


local function testLog(...)

    local parts =
        {}

    for index,
        value in ipairs(
            {...}
        )
    do

        parts[index] =
            tostring(
                value
            )
    end

    local text =
        table.concat(
            parts,
            " "
        )

    TestLogs[
        #TestLogs + 1
    ] =
        os.date(
            "%H:%M:%S"
        )
        .. " "
        .. text

    if #TestLogs > 80 then

        table.remove(
            TestLogs,
            1
        )
    end

    print(
        "[AUTO]",
        text
    )
end

--============================================================
-- ESTIMATED PET DEBUG
--============================================================

local function dumpEstimatedEntry(prefix, row)

    if
        type(row) ~= "table"
        or type(row.data) ~= "table"
        or row.data.estimated ~= true
    then
        return
    end

    local raw = row.raw
    local entry, source = findAMVGG(raw)

    testLog(
        prefix,
        row.data.name,
        getVariant(raw),
        "ESTIMATED • SOURCE=",
        tostring(source or "?")
    )

    if type(entry) ~= "table" then
        testLog("  RAW ENTRY MISSING")
        return
    end

    local fields = {}

    for key, value in pairs(entry) do
        local numberValue = tonumber(value)

        if numberValue ~= nil then
            fields[#fields + 1] =
                tostring(key)
                .. "="
                .. valueText(numberValue)
        end
    end

    table.sort(fields)

    if #fields == 0 then
        testLog("  RAW NUMERIC FIELDS: none")
        return
    end

    -- Split the raw AMVGG fields so the phone log stays readable.
    local batch = {}

    for index, text in ipairs(fields) do
        batch[#batch + 1] = text

        if #batch >= 4 or index == #fields then
            testLog(
                "  RAW",
                table.concat(batch, " | ")
            )
            batch = {}
        end
    end
end



local LogBox =
    textBox(
        TestCanvas,
        "",
        "",

        UDim2.new(
            1,
            -30,
            0,
            300
        ),

        UDim2.fromOffset(
            12,
            989
        )
    )


LogBox.MultiLine =
    true

LogBox.TextEditable =
    true

LogBox.TextXAlignment =
    Enum.TextXAlignment.Left

LogBox.TextYAlignment =
    Enum.TextYAlignment.Top

LogBox.Font =
    Enum.Font.Code

LogBox.TextSize =
    9


-- Safety/server timing controls added in V11.7.11.
local SecondConfirmDelayInput =
    settingInput(
        "SECOND CONFIRM DELAY",
        Settings.secondConfirmDelay,
        1304
    )

local PlazaHopMinutesInput =
    settingInput(
        "PLAZA HOP MINUTES (0=OFF)",
        Settings.plazaHopMinutes,
        1342
    )

bindNumber(
    SecondConfirmDelayInput,
    "secondConfirmDelay",
    0,
    60
)

bindNumber(
    PlazaHopMinutesInput,
    "plazaHopMinutes",
    0,
    180
)

do
    local PartnerRebuildDelayInput =
        settingInput(
            "PARTNER REBUILD DELAY",
            Settings.partnerRebuildDelay,
            1380
        )

    bindNumber(
        PartnerRebuildDelayInput,
        "partnerRebuildDelay",
        0,
        60
    )
end

do
    local UnknownBlockTimeoutInput =
        settingInput(
            "UNKNOWN BLOCK TIMEOUT",
            Settings.unknownBlockTimeout,
            1418
        )

    bindNumber(
        UnknownBlockTimeoutInput,
        "unknownBlockTimeout",
        5,
        300
    )
end

local UnwantedIncomingToggle =
    button(
        TestCanvas,
        "",

        UDim2.new(
            1,
            -24,
            0,
            36
        ),

        UDim2.fromOffset(
            10,
            1462
        )
    )

local function renderUnwantedIncoming()

    UnwantedIncomingToggle.Text =
        "IGNORE THEIR N/M + JUNK NP W/O F/R: "
        .. (
            Settings.excludeUnwantedIncomingNoPotion
            and "ON"
            or "OFF"
        )

    UnwantedIncomingToggle.BackgroundColor3 =
        Settings.excludeUnwantedIncomingNoPotion
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end

Runtime.connect(UnwantedIncomingToggle.Activated,
    function()

        Settings.excludeUnwantedIncomingNoPotion =
            not Settings.excludeUnwantedIncomingNoPotion

        saveSettings()
        renderUnwantedIncoming()
    end
)

renderUnwantedIncoming()


do
    local ItemMinimumWinInput = settingInput(
        "ITEM MINIMUM WIN %", Settings.itemMinimumWinPercent, 1506
    )
    bindNumber(ItemMinimumWinInput, "itemMinimumWinPercent", 0, 500)
end

local function setTestStatus(
    text,
    color
)

    TestStatus.Text =
        "STATUS: "
        .. tostring(
            text
        )

    TestStatus.TextColor3 =
        color
        or C.MUTED
end



--============================================================
-- ADOPT ME TRADING PLAZA ROUTER / SERVER HOP
--
-- Adapted from the user's multi-clone PS99 server-hop pattern:
--   • discover Trading Plaza places inside the CURRENT Adopt Me universe
--   • normal server -> route to Trading Plaza
--   • Trading Plaza -> new public Plaza server every N minutes
--   • disjoint clone slots and separate per-account visit history
--   • helper locals are isolated in a do-scope to avoid Luau local-limit compile failure
--============================================================

local PlazaRouter

do

local PLAZA_HOP_SETTINGS = {

    SharedFile = "ADOPTME_PLAZA_" .. tostring(LocalPlayer.UserId) .. ".json",

    RecentServerMemory =
        3600,

    ActiveServerTimeout =
        180,

    HeartbeatSeconds =
        25,

    RetrySeconds =
        30,

    MaxPages =
        5,
}

-- Current Adopt Me Trading Hub place. Dynamic universe discovery is still
-- used, but this hard fallback keeps the router alive when Roblox API HTTP
-- is blocked by the executor.
local KNOWN_TRADING_HUB_PLACE_ID =
    132388544979740


PlazaRouter = {

    readyForTrading =
        not Settings.plazaAutoRoute,

    currentIsPlaza =
        false,

    currentPlazaPlaceId =
        nil,

    plazaPlaces =
        {},

    lastClassification =
        0,

    teleporting =
        false,
}


do
local PLAZA_CLONE_SLOTS = {
    [8587532561] = 1, [10984363061] = 2, [10989399554] = 3, [10992763544] = 4,
    [10994350515] = 5, [11020997808] = 6, [11021036523] = 7, [11021124973] = 8,
}
PlazaRouter.cloneSlot = tonumber(ENV.AMVGG_PLAZA_CLONE_SLOT) or PLAZA_CLONE_SLOTS[LocalPlayer.UserId] or 1
PlazaRouter.cloneCount = tonumber(ENV.AMVGG_PLAZA_CLONE_COUNT) or (PLAZA_CLONE_SLOTS[LocalPlayer.UserId] and 8 or 1)
PlazaRouter.slotValid = PlazaRouter.cloneSlot % 1 == 0 and PlazaRouter.cloneCount % 1 == 0
    and PlazaRouter.cloneCount >= 1 and PlazaRouter.cloneCount <= 64
    and PlazaRouter.cloneSlot >= 1 and PlazaRouter.cloneSlot <= PlazaRouter.cloneCount
end
function PlazaRouter.ownsServer(serverId)
    if not PlazaRouter.slotValid then return false end
    local hash = 0
    for index = 1, #serverId do hash = (hash * 31 + string.byte(serverId, index)) % 2147483647 end
    return hash % PlazaRouter.cloneCount + 1 == PlazaRouter.cloneSlot
end

local PLAZA_CLONE_ID =
    tostring(
        LocalPlayer.UserId
    )
    .. "_"
    .. tostring(
        math.random(
            100000,
            999999
        )
    )


local function plazaLog(...)

    local parts =
        {}

    for index,
        value in ipairs(
            {...}
        )
    do

        parts[index] =
            tostring(
                value
            )
    end

    local message =
        table.concat(
            parts,
            " "
        )

    print(
        "[PLAZA ROUTER]",
        message
    )

    testLog(
        "PLAZA",
        message
    )
end


local function newPlazaDatabase()

    return {
        Active = {},
        Visited = {},
    }
end


local function loadPlazaDatabase()

    local data =
        newPlazaDatabase()

    if
        type(isfile)
            ~= "function"
        or type(readfile)
            ~= "function"
    then

        return data
    end

    local ok,
        result =
        pcall(
            function()

                if
                    not isfile(
                        PLAZA_HOP_SETTINGS.SharedFile
                    )
                then

                    return nil
                end

                return
                    HttpService:
                    JSONDecode(
                        readfile(
                            PLAZA_HOP_SETTINGS.SharedFile
                        )
                    )
            end
        )

    if
        ok
        and type(result)
            == "table"
    then

        result.Active =
            type(result.Active)
                == "table"
            and result.Active
            or {}

        result.Visited =
            type(result.Visited)
                == "table"
            and result.Visited
            or {}

        return result
    end

    return data
end


local function savePlazaDatabase(data)
    if type(writefile) ~= "function" or type(readfile) ~= "function" then
        PlazaRouter.storageError = "FILE API UNAVAILABLE"
        return false
    end
    local ok, err = pcall(function()
        local encoded = HttpService:JSONEncode(data)
        writefile(PLAZA_HOP_SETTINGS.SharedFile, encoded)
        if readfile(PLAZA_HOP_SETTINGS.SharedFile) ~= encoded then error("WRITE VERIFICATION FAILED") end
    end)
    PlazaRouter.storageError = not ok and tostring(err):sub(1, 160) or nil
    return ok
end


local function cleanPlazaDatabase(data)

    local now =
        os.time()

    for jobId,
        info in pairs(
            data.Active
        )
    do

        local lastSeen =
            0

        if type(info) == "table" then

            lastSeen =
                tonumber(
                    info.Time
                )
                or 0

        elseif type(info) == "number" then

            lastSeen =
                info
        end

        if
            now
            - lastSeen
            > PLAZA_HOP_SETTINGS.ActiveServerTimeout
        then

            data.Active[
                jobId
            ] =
                nil
        end
    end

    for jobId,
        time in pairs(
            data.Visited
        )
    do

        time =
            tonumber(
                time
            )
            or 0

        if
            now
            - time
            > PLAZA_HOP_SETTINGS.RecentServerMemory
        then

            data.Visited[
                jobId
            ] =
                nil
        end
    end
end


local function markCurrentPlazaServer()

    if
        not PlazaRouter.currentIsPlaza
        or not game.JobId
        or game.JobId == ""
    then

        return
    end

    local data =
        loadPlazaDatabase()

    cleanPlazaDatabase(
        data
    )

    data.Active[
        game.JobId
    ] = {

        Owner =
            PLAZA_CLONE_ID,

        UserId =
            LocalPlayer.UserId,

        PlaceId =
            game.PlaceId,

        Time =
            os.time(),
    }

    data.Visited[
        game.JobId
    ] =
        os.time()

    savePlazaDatabase(
        data
    )
end


local function clearCurrentPlazaActive()

    if
        not game.JobId
        or game.JobId == ""
    then

        return
    end

    local data =
        loadPlazaDatabase()

    cleanPlazaDatabase(
        data
    )

    local info =
        data.Active[
            game.JobId
        ]

    if
        type(info)
            ~= "table"
        or info.Owner
            == PLAZA_CLONE_ID
        or info.UserId
            == LocalPlayer.UserId
    then

        data.Active[
            game.JobId
        ] =
            nil
    end

    savePlazaDatabase(
        data
    )
end


local function plazaNameScore(name)

    local lower =
        tostring(
            name
            or ""
        ):
        lower()

    if
        lower:find(
            "trading plaza",
            1,
            true
        )
    then

        return 100
    end

    if
        lower:find(
            "trade plaza",
            1,
            true
        )
    then

        return 95
    end

    if
        lower:find(
            "trading hub",
            1,
            true
        )
    then

        return 90
    end

    if
        lower:find(
            "trade hub",
            1,
            true
        )
    then

        return 85
    end

    if
        lower:find(
            "plaza",
            1,
            true
        )
        and (
            lower:find(
                "trad",
                1,
                true
            )
            ~= nil
        )
    then

        return 80
    end

    -- Last-resort fallback for a universe whose place is simply called
    -- "Trading". Lower priority than explicit Plaza / Hub names.
    if
        lower:find(
            "trading",
            1,
            true
        )
    then

        return 50
    end

    return 0
end


local function decodeHTTPJSON(url)

    local body =
        nil

    -- Delta/executors can block game:HttpGet for Roblox API domains while
    -- request/http_request still works. Prefer the already detected REQUEST.
    if type(REQUEST) == "function" then

        local ok,
            response =
            pcall(
                REQUEST,
                {
                    Url = url,
                    URL = url,
                    Method = "GET",
                    Headers = {
                        ["Accept"] = "application/json",
                        ["Cache-Control"] = "no-cache",
                        ["User-Agent"] = "Mozilla/5.0",
                    },
                }
            )

        if ok then
            if type(response) == "string" then
                body = response
            elseif type(response) == "table" then
                body =
                    response.Body
                    or response.body
            end
        end
    end

    if type(body) ~= "string" then

        local ok,
            result =
            pcall(
                function()
                    return
                        game:HttpGet(
                            url,
                            true
                        )
                end
            )

        if ok and type(result) == "string" then
            body = result
        end
    end

    if type(body) ~= "string" then
        return nil
    end

    local decoded

    local decodeOK =
        pcall(
            function()
                decoded =
                    HttpService:
                    JSONDecode(
                        body
                    )
            end
        )

    if
        not decodeOK
        or type(decoded)
            ~= "table"
    then
        return nil
    end

    return decoded
end

local function getUniversePlacesForPlaza()

    local universeId =
        tonumber(
            game.GameId
        )

    if
        not universeId
        or universeId <= 0
    then

        return {}
    end

    local urls = {

        "https://develop.roblox.com/v1/universes/"
        .. tostring(
            universeId
        )
        .. "/places?limit=100&sortOrder=Asc",

        "https://apis.roblox.com/universes/v1/universes/"
        .. tostring(
            universeId
        )
        .. "/places?limit=100&sortOrder=Asc",
    }

    for _,
        url in ipairs(
            urls
        )
    do

        local decoded =
            decodeHTTPJSON(
                url
            )

        if
            type(decoded)
                == "table"
            and type(decoded.data)
                == "table"
            and #decoded.data > 0
        then

            return
                decoded.data
        end
    end

    return {}
end


local function getCurrentPlaceName()

    local ok,
        info =
        pcall(
            function()

                return
                    MarketplaceService:
                    GetProductInfo(
                        game.PlaceId
                    )
            end
        )

    if
        ok
        and type(info)
            == "table"
    then

        return
            tostring(
                info.Name
                or ""
            )
    end

    return ""
end


local function discoverTradingPlazaPlaces()

    local result =
        {}

    local seen =
        {}

    for _,
        info in ipairs(
            getUniversePlacesForPlaza()
        )
    do

        local id =
            tonumber(
                info.id
                or info.Id
            )

        local name =
            tostring(
                info.name
                or info.Name
                or ""
            )

        local score =
            plazaNameScore(
                name
            )

        if
            id
            and score > 0
            and not seen[id]
        then

            seen[id] =
                true

            result[
                #result + 1
            ] = {

                Id =
                    id,

                Name =
                    name,

                Score =
                    score,
            }
        end
    end

    -- Reliable fallback for the current 2026 Trading Hub.
    if not seen[KNOWN_TRADING_HUB_PLACE_ID] then
        seen[KNOWN_TRADING_HUB_PLACE_ID] = true
        result[#result + 1] = {
            Id = KNOWN_TRADING_HUB_PLACE_ID,
            Name = "Trading Hub",
            Score = 110,
        }
    end

    table.sort(
        result,

        function(a, b)

            if a.Score == b.Score then

                return
                    a.Id
                    < b.Id
            end

            return
                a.Score
                > b.Score
        end
    )

    return result
end


local function shufflePlazaList(list)

    for index =
        #list,
        2,
        -1
    do

        local other =
            math.random(
                1,
                index
            )

        list[index],
        list[other] =
            list[other],
            list[index]
    end
end


local function getPlazaServers(placeId)

    local servers =
        {}

    local cursor =
        nil

    for _ =
        1,
        PLAZA_HOP_SETTINGS.MaxPages
    do

        local url =
            "https://games.roblox.com/v1/games/"
            .. tostring(
                placeId
            )
            .. "/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100"

        if
            cursor
            and cursor ~= ""
        then

            url =
                url
                .. "&cursor="
                .. HttpService:
                    UrlEncode(
                        cursor
                    )
        end

        local decoded =
            decodeHTTPJSON(
                url
            )

        if
            type(decoded)
                ~= "table"
        then

            break
        end

        if
            type(decoded.data)
                == "table"
        then

            for _,
                server in ipairs(
                    decoded.data
                )
            do

                if server.id then

                    servers[
                        #servers + 1
                    ] =
                        server
                end
            end
        end

        cursor =
            decoded.nextPageCursor

        if
            not cursor
            or cursor == ""
        then

            break
        end

        Runtime.task.wait()
    end

    return servers
end


local function plazaServerAllowed(
    serverId,
    database
)

    if
        not serverId
        or serverId == ""
        or serverId == game.JobId
    then

        return false
    end

    if
        database.Active[
            serverId
        ]
        or database.Visited[
            serverId
        ]
    then

        return false
    end

    return true
end


local function reservePlazaServer(
    placeId,
    serverId
)
    if type(serverId) ~= "string" or serverId == "" or not PlazaRouter.ownsServer(serverId) then return false end

    local data =
        loadPlazaDatabase()

    cleanPlazaDatabase(
        data
    )

    if
        data.Active[
            serverId
        ]
        or data.Visited[
            serverId
        ]
    then

        return false
    end

    data.Active[
        serverId
    ] = {

        Owner =
            PLAZA_CLONE_ID,

        UserId =
            LocalPlayer.UserId,

        PlaceId =
            placeId,

        Time =
            os.time(),
    }

    data.Visited[
        serverId
    ] =
        os.time()

    return savePlazaDatabase(data)
end


local function findNewPlazaServer(placeId)

    local database =
        loadPlazaDatabase()

    cleanPlazaDatabase(
        database
    )

    local servers =
        getPlazaServers(
            placeId
        )

    shufflePlazaList(
        servers
    )

    if #servers > 1 then

        local offset =
            (
                LocalPlayer.UserId
                % #servers
            )
            + 1

        local rotated =
            {}

        for index =
            0,
            #servers - 1
        do

            local sourceIndex =
                (
                    (
                        offset
                        + index
                        - 1
                    )
                    % #servers
                )
                + 1

            rotated[
                #rotated + 1
            ] =
                servers[
                    sourceIndex
                ]
        end

        servers =
            rotated
    end

    for _,
        server in ipairs(
            servers
        )
    do

        local serverId =
            tostring(
                server.id
                or ""
            )

        local playing =
            tonumber(
                server.playing
            )
            or 0

        local maxPlayers =
            tonumber(
                server.maxPlayers
            )
            or 0

        if
            maxPlayers > 0
            and playing < maxPlayers
            and plazaServerAllowed(
                serverId,
                database
            )
            and reservePlazaServer(
                placeId,
                serverId
            )
        then

            return {
                PlaceId =
                    placeId,

                JobId =
                    serverId,

                Playing =
                    playing,

                MaxPlayers =
                    maxPlayers,
            }
        end
    end

    return nil
end


local function releasePlazaReservation(target)
    if not target or not target.JobId then return end
    local data = loadPlazaDatabase()
    local info = data.Active[target.JobId]
    if type(info) == "table" and info.Owner == PLAZA_CLONE_ID then
        data.Active[target.JobId], data.Visited[target.JobId] = nil, nil
        savePlazaDatabase(data)
    end
end

local function teleportFailed(reason)
    local pending = PlazaRouter.pendingTeleport
    if not pending then return end
    PlazaRouter.pendingTeleport = nil
    PlazaRouter.teleporting, PlazaRouter.preparing = false, false
    PlazaRouter.readyForTrading = true
    PlazaRouter.clearSince = nil
    PlazaRouter.retryAt = os.clock() + PLAZA_HOP_SETTINGS.RetrySeconds
    releasePlazaReservation(pending.target)
    markCurrentPlazaServer()
    plazaLog("TELEPORT FAILED • TRADING RESUMED • RETRY LATER", tostring(reason))
end

local function plazaTradeClear()
    local state = Runtime.state
    local pendingRequest = state and state.target and state.requestStarted
        and state.target.Parent and os.clock() - state.requestStarted < Settings.requestTimeout
    if getTrade() or pendingRequest then
        PlazaRouter.clearSince = nil
        return false
    end
    PlazaRouter.clearSince = PlazaRouter.clearSince or os.clock()
    return os.clock() - PlazaRouter.clearSince >= 8
end

local function teleportToPlazaTarget(placeId, serverId)
    local target = {PlaceId = placeId, JobId = serverId}
    -- This is the final guard after HTTP and reservation work. No yield is
    -- permitted between this check and initiating the teleport.
    if not Runtime.alive() or not Gui.Parent or not Settings.plazaAutoRoute
        or PlazaRouter.teleporting or not plazaTradeClear() then
        releasePlazaReservation(target)
        return false
    end
    PlazaRouter.preparedTarget = nil
    PlazaRouter.teleporting, PlazaRouter.readyForTrading = true, false
    PlazaRouter.pendingTeleport = {target = target, started = os.clock()}
    local ok, err = pcall(function()
        if serverId and serverId ~= "" then
            TeleportService:TeleportToPlaceInstance(placeId, serverId, LocalPlayer)
        else
            TeleportService:Teleport(placeId, LocalPlayer)
        end
    end)
    if not ok then teleportFailed(err) return false end
    return PlazaRouter.pendingTeleport ~= nil
end


local function routeNormalServerToPlaza()

    local currentPlaceId =
        tonumber(
            game.PlaceId
        )

    -- Fast path: recognize the current Hub without any HTTP dependency.
    if currentPlaceId == KNOWN_TRADING_HUB_PLACE_ID then

        PlazaRouter.currentIsPlaza =
            true

        PlazaRouter.currentPlazaPlaceId =
            currentPlaceId

        PlazaRouter.readyForTrading =
            true

        markCurrentPlazaServer()

        plazaLog(
            "TRADING HUB DETECTED • DIRECT PLACE ID",
            currentPlaceId,
            "HOP IN",
            valueText(Settings.plazaHopMinutes),
            "MIN"
        )

        return true
    end

    local plazaPlaces =
        discoverTradingPlazaPlaces()

    PlazaRouter.plazaPlaces =
        plazaPlaces

    PlazaRouter.lastClassification =
        os.clock()

    for _,
        place in ipairs(
            plazaPlaces
        )
    do

        if
            tonumber(
                place.Id
            )
            == currentPlaceId
        then

            PlazaRouter.currentIsPlaza =
                true

            PlazaRouter.currentPlazaPlaceId =
                currentPlaceId

            PlazaRouter.readyForTrading =
                true

            markCurrentPlazaServer()

            plazaLog(
                "TRADING PLAZA DETECTED",
                place.Name,
                "PLACE=",
                currentPlaceId,
                "HOP IN",
                valueText(
                    Settings.plazaHopMinutes
                ),
                "MIN"
            )

            return true
        end
    end

    -- If the universe-place endpoint is temporarily unavailable, at least
    -- detect that the CURRENT place itself is clearly a Trading Plaza.
    do

        local currentName =
            getCurrentPlaceName()

        if
            plazaNameScore(
                currentName
            )
            > 0
        then

            PlazaRouter.currentIsPlaza =
                true

            PlazaRouter.currentPlazaPlaceId =
                currentPlaceId

            PlazaRouter.readyForTrading =
                true

            markCurrentPlazaServer()

            plazaLog(
                "TRADING PLAZA DETECTED BY CURRENT NAME",
                currentName,
                "PLACE=",
                currentPlaceId
            )

            return true
        end
    end

    PlazaRouter.currentIsPlaza =
        false

    PlazaRouter.currentPlazaPlaceId =
        nil

    PlazaRouter.readyForTrading =
        false

    if #plazaPlaces == 0 then

        plazaLog(
            "PLAZA PLACE NOT FOUND • RETRY IN",
            PLAZA_HOP_SETTINGS.RetrySeconds,
            "SEC"
        )

        return false
    end

    local targetPlace =
        plazaPlaces[1]

    plazaLog(
        "NORMAL SERVER DETECTED -> TRADING PLAZA",
        targetPlace.Name,
        "PLACE=",
        targetPlace.Id
    )

    setTestStatus(
        "NORMAL SERVER • TELEPORTING TO TRADING PLAZA",
        C.YELLOW
    )

    local targetServer =
        findNewPlazaServer(
            targetPlace.Id
        )

    if targetServer then

        plazaLog(
            "ROUTE SERVER",
            targetServer.JobId,
            targetServer.Playing
            .. "/"
            .. targetServer.MaxPlayers
        )

        return
            teleportToPlazaTarget(
                targetServer.PlaceId,
                targetServer.JobId
            )
    end

    -- A random destination would bypass the per-clone partition.
    plazaLog("NO RESERVED PLAZA SERVER • TRADING RESUMED • RETRY LATER",
        PlazaRouter.storageError or "slot " .. PlazaRouter.cloneSlot .. "/" .. PlazaRouter.cloneCount)
    return false
end


local function hopCurrentTradingPlaza()
    if not PlazaRouter.currentIsPlaza or not Runtime.alive() or not Gui.Parent
        or not Settings.plazaAutoRoute or PlazaRouter.teleporting then return false end
    PlazaRouter.preparing = true
    if not plazaTradeClear() then return false end
    local placeId = tonumber(PlazaRouter.currentPlazaPlaceId) or tonumber(game.PlaceId)
    if not placeId then PlazaRouter.preparing = false return false end
    local ok, target = pcall(findNewPlazaServer, placeId)
    if not ok or not target then
        PlazaRouter.preparing = false
        PlazaRouter.retryAt = os.clock() + PLAZA_HOP_SETTINGS.RetrySeconds
        plazaLog("NEW PLAZA SERVER NOT FOUND • RETRY LATER", ok and "" or tostring(target))
        return false
    end
    PlazaRouter.preparedTarget = target
    local hopped = teleportToPlazaTarget(target.PlaceId, target.JobId)
    if not hopped then releasePlazaReservation(target) PlazaRouter.preparedTarget = nil end
    PlazaRouter.preparing = false
    return hopped
end


plazaLog(
    "ROUTER BOOT",
    "ENABLED=",
    Settings.plazaAutoRoute
    and "YES"
    or "NO",
    "PLACE=",
    game.PlaceId,
    "HOP=",
    Settings.plazaHopMinutes,
    "MIN"
)


-- One persistent supervisor owns routing, hopping and failure recovery.
Runtime.connect(TeleportService.TeleportInitFailed, function(player, _, message, placeId, options)
    local pending = PlazaRouter.pendingTeleport
    if player ~= LocalPlayer or not pending or tonumber(placeId) ~= tonumber(pending.target.PlaceId) then return end
    if options and pending.target.JobId then
        local ok, job = pcall(function() return options.ServerInstanceId end)
        if ok and job and job ~= "" and job ~= pending.target.JobId then return end
    end
    teleportFailed(message)
end)
Runtime.cleanups[#Runtime.cleanups + 1] = function()
    releasePlazaReservation(PlazaRouter.preparedTarget)
    if PlazaRouter.pendingTeleport then releasePlazaReservation(PlazaRouter.pendingTeleport.target) end
    clearCurrentPlazaActive()
end

Runtime.task.spawn(function()
    local lastHeartbeat = -math.huge
    local enteredAt = os.clock()
    if tonumber(game.PlaceId) == KNOWN_TRADING_HUB_PLACE_ID then
        PlazaRouter.currentIsPlaza, PlazaRouter.currentPlazaPlaceId = true, tonumber(game.PlaceId)
        PlazaRouter.readyForTrading = true
    end
    while Runtime.alive() and Gui.Parent do
        local now = os.clock()
        if PlazaRouter.pendingTeleport then
            if now - PlazaRouter.pendingTeleport.started >= 45 then
                teleportFailed("No completed departure within 45 seconds")
            end
        elseif not Settings.plazaAutoRoute then
            PlazaRouter.preparing, PlazaRouter.readyForTrading, PlazaRouter.clearSince = false, true, nil
        elseif now >= (PlazaRouter.retryAt or 0) then
            if PlazaRouter.currentIsPlaza then
                if now - lastHeartbeat >= PLAZA_HOP_SETTINGS.HeartbeatSeconds then
                    markCurrentPlazaServer()
                    lastHeartbeat = now
                end
                local minutes = math.max(0, tonumber(Settings.plazaHopMinutes) or 15)
                if minutes > 0 and now - enteredAt >= minutes * 60 then
                    hopCurrentTradingPlaza()
                else
                    PlazaRouter.preparing = false
                    PlazaRouter.clearSince = nil
                end
            else
                -- Stop new outbound requests while preparing. Incoming or
                -- existing trades are still managed by the main controller.
                PlazaRouter.preparing = true
                if plazaTradeClear() then
                    local ok, result = pcall(routeNormalServerToPlaza)
                    if not PlazaRouter.teleporting then
                        PlazaRouter.preparing = false
                        PlazaRouter.readyForTrading = true
                        if ok and result and PlazaRouter.currentIsPlaza then
                            enteredAt, lastHeartbeat = os.clock(), -math.huge
                        else
                            PlazaRouter.retryAt = os.clock() + PLAZA_HOP_SETTINGS.RetrySeconds
                            if not ok then plazaLog("ROUTER ERROR", tostring(result)) end
                        end
                    end
                end
            end
        end
        Runtime.task.wait(1)
    end
end)

end -- PLAZA ROUTER LOCAL SCOPE (prevents Luau main-chunk local limit)

local function scanInventoryAndLog(reason)

    local raw =
        inventoryItems()

    local list =
        valuedInventory()

    local prefix =
        tostring(
            reason
            or "MANUAL SCAN"
        )

    testLog(
        prefix,
        "ALL UNLOCKED =",
        #raw,
        "SAFE =",
        #list
    )

    for i = 1,
        math.min(
            #list,
            15
        )
    do

        local item =
            list[i]

        testLog(
            "#"
            .. i,
            item.isPet
            and "[PET]"
            or "[ITEM]",
            item.name,
            item.variant,
            "=",
            valueText(
                item.value
            ),
            item.estimated
            and "(EST)"
            or ""
        )
    end

    if list[1] then

        testLog(
            "BEST / SHOWCASE =",
            list[1].name,
            list[1].variant,
            valueText(
                list[1].value
            )
        )
    else

        testLog(
            "BEST / SHOWCASE = NONE"
        )
    end

    return list
end


Runtime.connect(ScanInventory.Activated,
    function()

        Runtime.task.spawn(
            function()

                scanInventoryAndLog(
                    "MANUAL SCAN"
                )
            end
        )
    end
)


--============================================================
-- AUTO STATE
--============================================================

local InventoryFlow

local State = {

    target =
        nil,

    requestStarted =
        nil,

    tradeID =
        nil,

    tradeStarted =
        nil,

    partner =
        nil,

    lastSignature =
        nil,

    lastOurSignature =
        nil,

    lastTheirSignature =
        nil,

    theirRevision =
        0,

    changedAt =
        nil,

    theirChangedAt =
        nil,

    acceptedSignature =
        nil,

    firstAcceptAt =
        nil,

    firstAcceptSignature =
        nil,

    confirmWaitLoggedSignature =
        nil,

    acceptReadySignature =
        nil,

    acceptReadySince =
        nil,

    evaluationLoggedSignature =
        nil,

    optimizedSignature =
        nil,

    askStarted =
        nil,

    askSignature =
        nil,

    unknownStarted =
        nil,

    unknownSignature =
        nil,

    initialAsk =
        false,

    showcaseAddedAt =
        nil,

    declineSent =
        false,

    showcaseTried =
        {},
}


Runtime.state = State

local PlayerCooldowns =
    {}


local function resetState()
    InventoryFlow.stop("trade state reset")
    State.unacceptRequired, State.declineRequested, State.policySignature = nil, nil, nil
    State.optimizedOurSignature, State.confirmPending, State.showcasePending, State.showcaseAttemptAt, State.waitForFirstAt = nil, nil, nil, nil, nil

    State.target =
        nil

    State.requestStarted =
        nil

    State.tradeID =
        nil

    State.tradeStarted =
        nil

    State.partner =
        nil

    State.lastSignature =
        nil

    State.lastOurSignature =
        nil

    State.lastTheirSignature =
        nil

    State.theirRevision =
        0

    State.changedAt =
        nil

    State.theirChangedAt =
        nil

    State.acceptedSignature =
        nil

    State.firstAcceptAt =
        nil

    State.firstAcceptSignature =
        nil

    State.confirmWaitLoggedSignature =
        nil

    State.acceptReadySignature =
        nil

    State.acceptReadySince =
        nil

    State.evaluationLoggedSignature =
        nil

    State.optimizedSignature =
        nil

    State.askStarted =
        nil

    State.askSignature =
        nil

    State.unknownStarted =
        nil

    State.unknownSignature =
        nil

    State.initialAsk =
        false

    State.showcaseAddedAt =
        nil

    State.declineSent =
        false

    State.showcaseFinished = nil
    State.showcaseTried =
        {}
end


local function cooldown(player)
    local id
    if typeof(player) == "Instance" then id = tonumber(player.UserId)
    elseif type(player) == "number" or type(player) == "string" then id = tonumber(player)
    elseif type(player) == "table" then id = tonumber(player.user_id or player.userId or player.UserId or player.id) end
    if not id then
        local name = playerName(player):lower()
        for _, candidate in ipairs(Players:GetPlayers()) do
            if candidate.Name:lower() == name then id = candidate.UserId break end
        end
    end
    if id then PlayerCooldowns[id] = os.clock() + Settings.playerCooldown end
end


local function randomPlayer()

    local list =
        {}

    local now =
        os.clock()

    for _,
        player in ipairs(
            Players:GetPlayers()
        )
    do

        if
            player ~= LocalPlayer
            and now
                >= (
                    PlayerCooldowns[
                        player.UserId
                    ]
                    or 0
                )
        then

            list[
                #list + 1
            ] =
                player
        end
    end

    if #list == 0 then
        return nil
    end

    return
        list[
            math.random(
                1,
                #list
            )
        ]
end


--============================================================
-- SEND TRADE
--============================================================

local function sendTrade(player)
    local generation = AutoTradeGeneration
    local id = player and player.UserId
    local function allowed()
        return Runtime.alive() and Settings.autoTrade and generation == AutoTradeGeneration
            and not PlazaRouter.preparing and not PlazaRouter.teleporting and player and player.UserId == id
    end
    if not allowed() or not TradeRemote.SendRequest or getTrade() then return false end
    for _, argument in ipairs({player, player.Name, player.UserId}) do
        if not allowed() or getTrade() then return false end
        local ok, result = remoteCall(TradeRemote.SendRequest, argument)
        if not allowed() then return false end
        if ok then return result ~= false end
        if result == "REMOTE TIMEOUT" or result == "REMOTE CANCELLED" or result == "REMOTE BUSY" then return false end
    end
    return false
end


--============================================================
-- ACCEPT FLAGS
--============================================================

local function accepted(offer)

    return

        type(offer) == "table"

        and (
            offer.negotiated
                == true

            or offer.accepted
                == true

            or offer.is_accepted
                == true
        )
end


local function confirmed(offer)

    return

        type(offer) == "table"

        and (
            offer.confirmed
                == true

            or offer.is_confirmed
                == true
        )
end


function Runtime.clearAcceptState()
    State.acceptedSignature, State.firstAcceptAt, State.firstAcceptSignature = nil, nil, nil
    State.confirmWaitLoggedSignature, State.confirmPending = nil, nil
end

local function unaccept(myOffer)
    local live = getTrade()
    local mine, _, _, partner = getTradeSides(live)
    if not mine or (State.tradeID and tostring(live.trade_id or live.id or playerName(partner)) ~= State.tradeID) then return false end
    if offerSignature(mine) ~= offerSignature(myOffer) then return false end
    local key = Runtime.tradeKey(live, partner)
    if not accepted(mine) and not Runtime.tradeInConfirmation(live) then
        State.unacceptRequired = nil
        Runtime.clearAcceptState()
        return true
    end
    -- Keep this barrier until a live negotiation offer is visibly unaccepted.
    -- Neither an exception nor an RPC acknowledgement proves that transition.
    if not State.unacceptRequired or State.unacceptRequired.key ~= key then
        State.unacceptRequired = {key = key, since = os.clock()}
    end
    local pending = State.unacceptRequired
    if pending.busy or (pending.lastAttempt and os.clock() - pending.lastAttempt < 2) then return false end
    if not TradeRemote.Unaccept then return false end
    pending.lastAttempt, pending.busy = os.clock(), true
    local ok, result = remoteCall(TradeRemote.Unaccept)
    pending.busy = false
    local current = getTrade()
    local currentMine, _, _, currentPartner = getTradeSides(current)
    if State.unacceptRequired ~= pending or not currentMine or Runtime.tradeKey(current, currentPartner) ~= key then return false end
    if not accepted(currentMine) and not Runtime.tradeInConfirmation(current) then
        State.unacceptRequired = nil
        Runtime.clearAcceptState()
        testLog("UNACCEPT OBSERVED")
        return true
    end
    testLog(ok and result ~= false and "UNACCEPT SENT • WAIT LIVE RESET" or "UNACCEPT FAILED • RETRY")
    return false
end

local function decline()
    local live = getTrade()
    local mine, _, _, partner = getTradeSides(live)
    if not mine or (State.tradeID and tostring(live.trade_id or live.id or playerName(partner)) ~= State.tradeID) then return false end
    local key = Runtime.tradeKey(live, partner)
    if not State.declineRequested or State.declineRequested.key ~= key then State.declineRequested = {key = key} end
    local pending = State.declineRequested
    if InventoryFlow then InventoryFlow.stop("Trade cancellation requested") end
    if pending.busy or (pending.lastAttempt and os.clock() - pending.lastAttempt < 2) then return false end
    if not TradeRemote.Decline then return false end
    pending.lastAttempt, pending.busy = os.clock(), true
    local ok, result = remoteCall(TradeRemote.Decline)
    pending.busy = false
    local current = getTrade()
    local currentMine, _, _, currentPartner = getTradeSides(current)
    if State.declineRequested ~= pending then return false end
    if not currentMine or Runtime.tradeKey(current, currentPartner) ~= key then return ok and result ~= false end
    State.declineSent = ok and result ~= false
    testLog(State.declineSent and "DECLINE SENT • WAIT TRADE CLOSED" or "DECLINE FAILED • RETRY")
    return State.declineSent
end

function Runtime.pruneDisallowed(trade)
    local context = Runtime.captureTrade(trade)
    local live, _, mine = Runtime.liveContext(context, true, true)
    if not live or Runtime.tradeInConfirmation(live) then return false end
    local remove = {}
    for _, item in pairs(getOfferItems(mine)) do
        local data = effectiveItemValue(item)
        local belowMinimum = data.known and not data.newIgnored and data.value < activeMinItemValue("mine")
            and not CommonPetFilter.shouldBypassOurMinimum(item)
        if not isAllowed(data.name) or belowMinimum then remove[#remove + 1] = tostring(itemUID(item)) end
    end
    if #remove == 0 then return true end
    if not unaccept(mine) then return false end
    for _, uid in ipairs(remove) do
        Runtime.task.wait(math.max(0.1, tonumber(Settings.itemActionDelay) or 0.85))
        live, _, mine = Runtime.liveContext(context, false, true)
        if not live or Runtime.tradeInConfirmation(live) or accepted(mine) then return false end
        local ok, result = removeOurItem(uid)
        if not Runtime.liveContext(context, false, true) or not ok or result == false then return false end
    end
    State.optimizedSignature, State.acceptReadySignature, State.acceptReadySince = nil, nil, nil
    State.changedAt = os.clock()
    return false -- fetch the replicated offer on the next controller iteration
end

--============================================================
-- TRADE EVALUATION
--============================================================

local function evaluateTrade(
    myOffer,
    theirOffer
)

    local mine =
        evaluateOffer(
            myOffer,
            {
                demandSide = Settings.autoTrade and "mine" or nil,

                allowEstimated =
                    Settings.allowEstimatedOwnPets
                    == true,

                minValue =
                    activeMinItemValue("mine"),

                -- Never hide value that WE are giving. Below-min OUR items
                -- remain counted for W/F/L, then automated modes block them.
                ignoreBelowMin =
                    false,

                -- OUR Common/custom-junk pets stay fully counted and may
                -- bypass MY MIN so the bot can unload them faster.
                bypassOwnMinimumForUnwanted =
                    true,
            }
        )

    local theirs =
        evaluateOffer(
            theirOffer,
            {
                demandSide = Settings.autoTrade and "theirs" or nil,

                minValue =
                    activeMinItemValue("theirs"),

                -- THEIR exact items below the selected floor do not count
                -- toward THEM TOTAL.
                ignoreBelowMin =
                    true,

                -- Listed eggs are worth 0 only on THEIR side.
                ignoreIncomingEggs = true,

                -- THEIR plain N/M without potion are ignored globally.
                -- Plain NP is also ignored for Common/custom-junk pets.
                ignoreUnwantedIncomingNoPotion =
                    true,
            }
        )

    local result = {

        mine =
            mine,

        theirs =
            theirs,

        blocked =
            false,

        valid =
            false,

        reason =
            nil,

        profit =
            nil,
    }

    if
        mine.hardBlocked > 0 or theirs.hardBlocked > 0
    then

        result.blocked =
            true

        result.reason =
            "BLOCKED ITEM • TRIKE STROLLER"

        return result
    end

    if Settings.autoTrade and AMVGG.dataStale then
        result.blocked = true
        result.reason = "AMVGG UPDATE FAILED • FRESH PRICES REQUIRED"
        return result
    end

    if Settings.autoTrade then
        for _, row in ipairs(mine.items) do
            if not isAllowed(row.data.name) then
                result.blocked, result.reason = true, "OUR ITEM NOT ALLOWED"
                return result
            end
        end
    end

    if Settings.autoTrade and mine.protectedPets > 0 then
        result.blocked = true
        result.reason = "OUR 3 STAR PET PROTECTED"
        return result
    end

    -- A catalog entry excluded by the new-item window cannot become a free
    -- outgoing item. Both Accept and Confirm recheck this condition.
    if mine.newIgnored > 0 then
        result.blocked = true
        result.reason = Settings.autoTrade and "OUR NEW ITEM • AUTO ACCEPT BLOCKED" or "OUR NEW ITEM • W/F/L UNAVAILABLE"
        return result
    end

    if
        mine.unknown > 0
        or theirs.unknown > 0
    then

        result.blocked =
            true

        result.reason =
            "UNKNOWN"

        return result
    end

    if Settings.autoTrade and (mine.demandUnknown > 0 or theirs.demandUnknown > 0) then
        result.blocked = true
        result.reason = "DEMAND UNKNOWN"
        return result
    end

    -- AUTO TRADE must never ACCEPT while our side contains a unit
    -- below MY/ALL minimum. The optimizer/showcase already filters these out,
    -- so this mainly protects against a manual/stale item in the offer.
    if
        Settings.autoTrade
        and mine.belowMin > 0
    then

        result.blocked =
            true

        result.reason =
            "OUR ITEM < MIN VALUE"

        return result
    end

    -- CRITICAL AUTO-TRADE SAFETY:
    -- Never make a real trade decision from fallback multipliers such as
    -- regularValue*0.70 or megaValue*0.88. Those are not AMVGG's exact
    -- potion/variant values and can be very far from the calculator.
    if
        Settings.autoTrade
        and (
            mine.estimated > 0
            or theirs.estimated > 0
        )
    then

        result.blocked =
            true

        result.reason =
            "ESTIMATED VARIANT • EXACT VALUE REQUIRED"

        return result
    end

    if
        Settings.blockEstimated
        and (
            theirs.estimated > 0
            or (
                mine.estimated > 0
                and not Settings.allowEstimatedOwnPets
            )
        )
    then

        result.blocked =
            true

        result.reason =
            "ESTIMATED"

        return result
    end

    result.profit =
        profitPercent(
            mine.total,
            theirs.total
        )

    if Settings.autoTrade then
        result.valid = mine.total > 0
            and mine.total <= theirs.effectiveTotal + 0.000000001
    elseif result.profit then

        result.valid =

            result.profit
            >= (num(Settings.minProfitPercent) or 10)
    end

    return result
end


--============================================================
-- SECURE ACCEPT / CONFIRM
--============================================================

local function secureAccept(trade, myOffer, theirOffer, expectedContext)
    if expectedContext and not Runtime.liveContext(expectedContext, true, true) then return false end
    local context = Runtime.captureTrade(trade)
    local live, _, mine, theirs = Runtime.liveContext(context, true, true)
    if not live or fullSignature(mine, theirs) ~= fullSignature(myOffer, theirOffer) then return false end
    if State.declineRequested then return false end
    if State.unacceptRequired then unaccept(mine) return false end
    local evaluation = evaluateTrade(mine, theirs)
    if evaluation.blocked or not evaluation.valid then unaccept(mine) return false end
    local signature = fullSignature(mine, theirs)

    if Runtime.tradeInConfirmation(live) then
        if State.acceptedSignature and State.acceptedSignature ~= signature then unaccept(mine) return false end
        if State.firstAcceptSignature ~= signature or not State.firstAcceptAt then
            -- A genuinely unobserved/manual first acceptance may be recovered.
            -- A failed cancellation is kept behind unacceptRequired above.
            State.acceptedSignature, State.firstAcceptSignature = signature, signature
            State.firstAcceptAt, State.confirmWaitLoggedSignature = os.clock(), nil
        end
        local requiredDelay = math.max(0, tonumber(Settings.secondConfirmDelay) or 10)
        local remaining = requiredDelay - (os.clock() - State.firstAcceptAt)
        if remaining > 0 then
            setTestStatus(string.format("1ST ACCEPTED • 2ND CONFIRM IN %.1fs", remaining), C.YELLOW)
            return true
        end
        live, _, mine, theirs = Runtime.liveContext(context, true, true)
        if not live or not Runtime.tradeInConfirmation(live) or State.unacceptRequired or State.declineRequested then return false end
        local final = evaluateTrade(mine, theirs)
        if final.blocked or not final.valid then unaccept(mine) return false end
        if confirmed(mine) then State.confirmPending = nil return true end
        local pending = State.confirmPending
        if pending and (pending.key ~= context.key or pending.signature ~= signature) then
            unaccept(mine)
            return false
        end
        if pending then
            if os.clock() - pending.since >= 12 then
                setTestStatus("CONFIRM NOT OBSERVED • DECLINING", C.RED)
                decline()
                return false
            end
            if pending.acknowledged or os.clock() - pending.lastAttempt < 2 then
                setTestStatus("CONFIRM SENT • WAIT LIVE RESULT", C.YELLOW)
                return true
            end
        end
        if not TradeRemote.Confirm then return false end
        if not pending then pending = {key=context.key, signature=signature, since=os.clock()} State.confirmPending = pending end
        pending.lastAttempt = os.clock()
        local ok, result = remoteCall(TradeRemote.Confirm)
        if not Runtime.liveContext(context, true, true) then return false end
        if not ok or result == false then testLog("CONFIRM FAILED") return false end
        if State.confirmPending ~= pending then return false end
        pending.acknowledged = true
        testLog("SECOND CONFIRM SENT AFTER", requiredDelay, "SECONDS")
        return true
    end

    if not accepted(mine) then
        if State.firstAcceptSignature == signature and State.firstAcceptAt then
            if os.clock() - State.firstAcceptAt >= 12 then decline() return false end
            setTestStatus("ACCEPT SENT • WAIT LIVE RESULT", C.YELLOW)
            return true
        end
        if not TradeRemote.Accept then return false end
        local ok, result = remoteCall(TradeRemote.Accept)
        local current, _, freshMine = Runtime.liveContext(context, true, true)
        if not current then
            -- If the same trade survived but changed during the reply, require
            -- an observed first-stage reset before any later confirmation.
            local changed = getTrade()
            local changedMine, _, _, changedPartner = getTradeSides(changed)
            if changedMine and Runtime.tradeKey(changed, changedPartner) == context.key
                and AutoTradeGeneration == context.generation then
                State.unacceptRequired = {key = context.key, since = os.clock()}
            end
            return false
        end
        if not ok or result == false then
            Runtime.clearAcceptState()
            testLog("FIRST ACCEPT FAILED")
            return false
        end
        State.acceptedSignature, State.firstAcceptSignature = signature, signature
        State.firstAcceptAt, State.confirmWaitLoggedSignature = os.clock(), nil
        testLog("FIRST ACCEPT SENT")
    elseif State.firstAcceptSignature ~= signature or not State.firstAcceptAt then
        State.acceptedSignature, State.firstAcceptSignature = signature, signature
        State.firstAcceptAt, State.confirmWaitLoggedSignature = os.clock(), nil
    end
    return true
end

--============================================================
-- SHOWCASE
--============================================================

local function showcase(myOffer)
    if countOfferItems(myOffer) > 0 then return true, "OBSERVED" end
    local context = Runtime.captureTrade(getTrade())
    if not context or not Runtime.liveContext(context, true, true) then return false, "TRADE_CHANGED" end
    local pending = State.showcasePending
    if pending then
        if pending.key ~= context.key then State.showcasePending = nil return false, "TRADE_CHANGED" end
        local mine = getTradeSides(getTrade())
        if currentUIDSet(mine)[pending.uid] then State.showcasePending = nil return true, "OBSERVED" end
        if os.clock() - pending.since < 4 then return false, "PENDING" end
        State.showcasePending = nil
        testLog("SHOWCASE NOT OBSERVED; TRY NEXT SAFE ITEM")
    end
    if State.showcaseAttemptAt and os.clock() - State.showcaseAttemptAt < 0.75 then return false, "PENDING" end
    for _, item in ipairs(valuedInventory()) do
        local uid = tostring(item.uid)
        if not State.showcaseTried[uid] then
            State.showcaseTried[uid] = true
            State.showcaseAttemptAt = os.clock()
            testLog("SHOWCASE", item.name, item.variant, "=", valueText(item.value))
            local ok, result = addOurItem(item.uid)
            if not Runtime.liveContext(context, false, true) then return false, "TRADE_CHANGED" end
            if not ok or result == false then return false, "FAILED" end
            local mine = getTradeSides(getTrade())
            if currentUIDSet(mine)[uid] then return true, "OBSERVED" end
            State.showcasePending = {key=context.key, uid=uid, since=os.clock()}
            return false, "PENDING"
        end
    end
    return false, "EXHAUSTED"
end


testLog(
    "SETTINGS AUTO TRADE READY",
    "AUTO TRADE CONTROLS MOVED TO SETTINGS"
)

testLog(
    "ASK ADD TIMEOUT =",
    Settings.addTimeout,
    "SEC • RESETS WHEN PARTNER CHANGES OFFER"
)

testLog(
    "UNKNOWN BLOCK TIMEOUT =",
    Settings.unknownBlockTimeout,
    "SEC"
)

testLog(
    "THEIR JUNK FILTER =",
    Settings.excludeUnwantedIncomingNoPotion
    and "ON"
    or "OFF"
)

testLog(
    "MIN VALUE",
    "MODE=",
    Settings.minValueMode,
    "MY=",
    valueText(activeMinItemValue("mine")),
    "THEIR=",
    valueText(activeMinItemValue("theirs"))
)

testLog(
    "PARTNER REBUILD DELAY =",
    Settings.partnerRebuildDelay,
    "SEC OF NO CHANGES"
)

testLog(
    "SECOND CONFIRM DELAY =",
    Settings.secondConfirmDelay,
    "SEC"
)

testLog(
    "PLAZA ROUTER =",
    Settings.plazaAutoRoute
    and "ON"
    or "OFF",
    "HOP EVERY",
    Settings.plazaHopMinutes,
    "MIN"
)


--============================================================
-- ACTIVE AUTO TRADE
--============================================================

-- Only the greeting and native quick-chat messages remain here.
-- No partner inventory request, inventory observer or Suggest Item worker.
InventoryFlow = {}
do
    local MainState = State
    local previous = ENV.__AM_ANALYZER_INVENTORY_FLOW
    if type(previous) == "table" and type(previous.stop) == "function" then pcall(previous.stop, "inventory automation removed") end
    ENV.__AM_ANALYZER_INVENTORY_FLOW = InventoryFlow
    Runtime.flow = InventoryFlow
    function InventoryFlow.stop()
        InventoryFlow.greetedTrade = nil
    end
    function InventoryFlow.engaged() return false end
    function InventoryFlow.holdAccept() return false end
local function identity(value)
    if typeof(value) == "Instance" and value.ClassName == "Player" then return value.UserId, value.Name end
    if type(value) == "table" then return tonumber(value.user_id or value.userId or value.UserId or value.id), value.username or value.Name or value.name end
    if type(value) == "number" then return value end
    if type(value) == "string" then
        if tonumber(value) then return tonumber(value) end
        local player = Players:FindFirstChild(value)
        if player and player.ClassName == "Player" then return player.UserId, player.Name end
    end
end


    function InventoryFlow.sendQuickChat(partner, index, fallback)
        if not Settings.autoTrade or not Settings.chatRequests then return false end
        if TradeRemote.QuickChat then
            local live = getTrade()
            if not live then return false end
            local _, _, _, other = getTradeSides(live)
            local id, name = identity(partner)
            local liveID = identity(other)
            if not live or not id or liveID ~= id
                or tostring(live.trade_id or live.id or playerName(other)) ~= MainState.tradeID then return false end
            local target = typeof(partner) == "Instance" and partner
                or (name and Players:FindFirstChild(name)) or Players:GetPlayerByUserId(id)
            if not target or target.ClassName ~= "Player" or target.UserId ~= id then return false end
            -- Captured native signature: SendQuickChat(partner Player, emoji index).
            local ok, result = remoteCall(TradeRemote.QuickChat, target, index)
            if ok and result ~= false then return true end
        end
        return sendChat(fallback)
    end


    function InventoryFlow.step(trade, partner)
        if not Settings.autoTrade or not Settings.chatRequests then return false end
        local key = MainState.tradeID
        if not key or InventoryFlow.greetedTrade == key then return false end
        if os.clock() - (MainState.tradeStarted or os.clock()) < 3 then return false end
        local context = Runtime.captureTrade(trade)
        if not Runtime.liveContext(context, true, true) then return false end
        -- Mark before the call: a yielding remote cannot duplicate the greeting.
        InventoryFlow.greetedTrade = key
        InventoryFlow.sendQuickChat(partner, 1, "👋 Lets, trade")
        return false
    end
end


local function manageAutoTrade(trade)
    local operationContext = Runtime.captureTrade(trade)
    if not Runtime.liveContext(operationContext, true, false) then return end

    local myOffer,
        theirOffer,
        _,
        partner =
        getTradeSides(
            trade
        )

    if
        not myOffer
        or not theirOffer
    then

        return
    end

    local id =
        tostring(
            trade.trade_id
            or trade.id
            or playerName(
                partner
            )
        )

    if playerName(partner) == LocalPlayer.Name or (State.tradeID == id and State.partner and playerName(State.partner) ~= playerName(partner)) then
        InventoryFlow.stop("partner changed inside current trade")
        return
    end

    if
        State.tradeID
        ~= id
    then

        local oldTarget =
            State.target

        resetState()

        State.target =
            oldTarget

        State.tradeID =
            id

        State.tradeStarted =
            os.clock()

        State.partner =
            partner

        State.changedAt =
            os.clock()

        testLog(
            "TRADE START",
            playerName(
                partner
            )
        )
    end

    if
        os.clock()
        - State.tradeStarted
        > Settings.maxTradeSeconds
    then

        decline()
        return
    end

    if State.declineRequested then decline() return end
    if State.unacceptRequired and os.clock() - State.unacceptRequired.since >= 12 then
        setTestStatus("UNACCEPT TIMED OUT • DECLINING", C.RED)
        decline()
        return
    end
    if State.unacceptRequired then
        if not unaccept(myOffer) then setTestStatus("WAIT UNACCEPT • RETRY", C.YELLOW) return end
        if not Runtime.liveContext(operationContext, true, false) then return end
    end
    local policy = Runtime.policySignature()
    if State.policySignature ~= policy then
        local changed = State.policySignature ~= nil
        State.policySignature = policy
        State.optimizedSignature, State.acceptReadySignature, State.acceptReadySince = nil, nil, nil
        if changed then
            State.changedAt = os.clock()
            if not unaccept(myOffer) then return end
            if not Runtime.liveContext(operationContext, true, true) then return end
        end
    end

    local ourSignature =
        offerSignature(
            myOffer
        )

    local theirSignature =
        offerSignature(
            theirOffer
        )

    -- Demand/value refreshes and ITEM MINIMUM WIN changes also invalidate
    -- the optimizer target even when the player's item signature is stable.
    local optimizationSignature = Runtime.optimizationKey(theirOffer)
    if State.optimizedOurSignature ~= nil and State.optimizedOurSignature ~= ourSignature then
        State.optimizedSignature, State.optimizedOurSignature = nil, nil
    end

    local signature =
        ourSignature
        .. " >>> "
        .. theirSignature

    -- Any visible trade change invalidates an ACCEPT countdown.
    -- Rebuilds store the observed final own signature. Later manual own
    -- changes invalidate optimization without reacting to our in-flight RPCs.
    if
        State.lastSignature
        ~= signature
    then

        if
            State.acceptedSignature
            and State.acceptedSignature
                ~= signature
        then

            testLog(
                "CHANGED AFTER ACCEPT"
            )

            unaccept(
                myOffer
            )

            if not Runtime.liveContext(operationContext, true, true) or State.unacceptRequired then return end
        end

        State.lastSignature =
            signature

        State.changedAt =
            os.clock()

        State.acceptReadySignature =
            nil

        State.acceptReadySince =
            nil

        State.evaluationLoggedSignature =
            nil
    end

    if
        State.lastTheirSignature
        ~= theirSignature
    then

        local hadPrevious =
            State.lastTheirSignature
            ~= nil

        State.lastTheirSignature =
            theirSignature

        State.theirChangedAt =
            os.clock()

        State.theirRevision =
            (
                State.theirRevision
                or 0
            )
            + 1

        -- Their offer is a new target. Recalculate our whole side.
        State.optimizedSignature =
            nil

        -- Give them a fresh ADD window for every meaningful change.
        State.askStarted =
            nil

        State.askSignature =
            nil

        State.unknownStarted =
            nil

        State.unknownSignature =
            nil

        if hadPrevious then

            testLog(
                "THEIR OFFER CHANGED",
                "REV=",
                State.theirRevision,
                "-> WAIT",
                Settings.partnerRebuildDelay,
                "SEC BEFORE REBUILD"
            )
        end
    end

    State.lastOurSignature =
        ourSignature

    if AMVGG.loading or not AMVGG.ready then setTestStatus("WAIT AMVGG", C.YELLOW) return end
    if AMVGG.dataStale then
        InventoryFlow.stop("Price refresh failed")
        unaccept(myOffer)
        setTestStatus("AMVGG UPDATE FAILED • RETRY REFRESH", C.RED)
        return
    end
    if Runtime.tradeInConfirmation(trade) then
        InventoryFlow.stop("Trade entered confirmation")
        if AMVGG.loading then setTestStatus("CONFIRM: WAIT PRICE UPDATE", C.YELLOW) return end
        secureAccept(trade, myOffer, theirOffer, operationContext)
        return
    end

    if not Runtime.pruneDisallowed(trade) then return end
    InventoryFlow.step(trade, partner)
    if not Runtime.liveContext(operationContext, true, false) then return end

    local myCount =
        countOfferItems(
            myOffer
        )

    local theirCount =
        countOfferItems(
            theirOffer
        )

    if myCount > 0 or State.optimizedSignature ~= nil then State.showcaseFinished = true end

    -- SHOW MOST EXPENSIVE SAFE ITEM, BUT DO NOT EXPOSE IT INSTANTLY.
    -- The countdown begins when the trade itself starts.
    if myCount == 0 and not State.showcaseFinished then

        local requiredShowcaseDelay =
            math.max(
                0,
                tonumber(
                    Settings.showcaseDelay
                )
                or 5
            )

        local showcaseElapsed =
            os.clock()
            - (State.tradeStarted or os.clock())

        local showcaseRemaining =
            requiredShowcaseDelay
            - showcaseElapsed

        if showcaseRemaining > 0 then

            setTestStatus(
                string.format(
                    "SHOWCASE IN %.1fs",
                    showcaseRemaining
                ),
                C.YELLOW
            )

            return
        end

        setTestStatus(
            "SHOWCASE",
            C.YELLOW
        )

        local added, showcaseReason = showcase(myOffer)
        if added or showcaseReason == "EXHAUSTED" then State.showcaseFinished = true end
        if showcaseReason == "EXHAUSTED" and not State.waitForFirstAt then State.waitForFirstAt = os.clock() end
        if added and not State.showcaseAddedAt then
            State.showcaseAddedAt =
                os.clock()

            testLog(
                "FIRST ITEM SENT",
                "THEM GET",
                Settings.firstItemTimeout,
                "SECONDS"
            )
        end

        return
    end

    -- If the client replicated our showcase between loops before we recorded
    -- the timestamp, start the first-item window now rather than from trade start.
    if myCount > 0 and not State.showcaseAddedAt then
        State.showcaseAddedAt = os.clock()
    end

    -- WAIT FOR THEM
    if theirCount == 0 then
        if not State.waitForFirstAt then State.waitForFirstAt = os.clock() end

        if not State.initialAsk then

            State.initialAsk =
                true

            InventoryFlow.sendQuickChat(partner, 4, "please add +")

            testLog(
                "ASK FIRST ITEM"
            )
        end

        local elapsed =
            os.clock()
            - (
                State.showcaseAddedAt
                or State.waitForFirstAt
                or State.tradeStarted
                or os.clock()
            )

        setTestStatus(
            "WAIT ITEM "
            .. math.max(
                0,
                math.ceil(
                    Settings.firstItemTimeout
                    - elapsed
                )
            )
            .. "s",
            C.YELLOW
        )

        if
            elapsed
            >= Settings.firstItemTimeout
            and not State.declineSent
        then

            decline()
        end

        return
    end

    -- PARTNER OFFER DEBOUNCE. Every add/remove on THEIR side restarts
    -- this full timer. We do not evaluate or rebuild until they have stopped
    -- changing their offer for the whole window.
    local partnerRebuildDelay =
        math.max(
            0,
            tonumber(
                Settings.partnerRebuildDelay
            )
            or 10
        )

    local partnerWaited =
        os.clock()
        - (
            State.theirChangedAt
            or os.clock()
        )

    local partnerRemaining =
        partnerRebuildDelay
        - partnerWaited

    if partnerRemaining > 0 then

        setTestStatus(
            string.format(
                "THEIR OFFER CHANGING • REBUILD IN %.1fs",
                partnerRemaining
            ),
            C.YELLOW
        )

        return
    end

    -- STABILIZE OFFER
    if
        os.clock()
        - State.changedAt
        < Settings.settleSeconds
    then

        setTestStatus(
            "OFFER CHANGING",
            C.YELLOW
        )

        return
    end

    local evaluation =
        evaluateTrade(
            myOffer,
            theirOffer
        )

    if evaluation.blocked then

        unaccept(
            myOffer
        )

        -- UNKNOWN gets a dedicated wait window instead of blocking forever.
        -- Any partner add/remove resets this timer through theirSignature.
        if evaluation.reason == "UNKNOWN" or evaluation.reason == "DEMAND UNKNOWN" then

            if
                not State.unknownStarted
                or State.unknownSignature
                    ~= theirSignature
            then

                State.unknownStarted =
                    os.clock()

                State.unknownSignature =
                    theirSignature

                testLog(
                    "BLOCK " .. evaluation.reason,
                    "WAIT",
                    Settings.unknownBlockTimeout,
                    "SECONDS FOR PARTNER CHANGE"
                )
            end

            local unknownElapsed =
                os.clock()
                - State.unknownStarted

            local unknownRemaining =
                math.max(
                    0,
                    math.ceil(
                        Settings.unknownBlockTimeout
                        - unknownElapsed
                    )
                )

            setTestStatus(
                "BLOCK " .. evaluation.reason .. " "
                .. unknownRemaining
                .. "s",
                C.RED
            )

            if
                unknownElapsed
                >= Settings.unknownBlockTimeout
                and not State.declineSent
            then

                testLog(
                    "BLOCK " .. evaluation.reason .. " TIMEOUT -> DECLINE"
                )

                decline()
            end

            return
        end

        State.unknownStarted =
            nil

        State.unknownSignature =
            nil

        setTestStatus(
            "BLOCK "
            .. tostring(
                evaluation.reason
            ),
            C.RED
        )

        -- If AMVGG exact potion/variant fields were not found, show every
        -- numeric field we actually received. This lets us map the real
        -- calculator field instead of inventing another percentage.
        if
            evaluation.mine.estimated > 0
            or evaluation.theirs.estimated > 0
        then
            for _, row in ipairs(evaluation.mine.items) do
                dumpEstimatedEntry("OUR EST", row)
            end

            for _, row in ipairs(evaluation.theirs.items) do
                dumpEstimatedEntry("THEIR EST", row)
            end
        end

        return
    end

    State.unknownStarted =
        nil

    State.unknownSignature =
        nil

    if
        evaluation.mine.newIgnored > 0
        or evaluation.theirs.newIgnored > 0
    then

        testLog(
            "NEW <24H IGNORED",
            "YOU=",
            evaluation.mine.newIgnored,
            "THEM=",
            evaluation.theirs.newIgnored
        )
    end

    if
        evaluation.mine.belowMin > 0
        or evaluation.theirs.belowMin > 0
    then

        testLog(
            "MIN VALUE FILTER",
            "MODE=",
            Settings.minValueMode,
            "MY<MIN=",
            evaluation.mine.belowMin,
            "THEIR<MIN IGNORED=",
            evaluation.theirs.belowMin,
            "MY MIN=",
            valueText(
                activeMinItemValue("mine")
            ),
            "THEIR MIN=",
            valueText(
                activeMinItemValue("theirs")
            )
        )
    end

    if
        evaluation.theirs.unwantedIncomingIgnored > 0
    then

        testLog(
            "THEIR JUNK FILTER",
            "IGNORED=",
            evaluation.theirs.unwantedIncomingIgnored
        )
    end

    if
        State.evaluationLoggedSignature
        ~= signature
    then

        State.evaluationLoggedSignature =
            signature

        testLog(
            "WFL CHECK",
            "OURS=",
            valueText(
                evaluation.mine.total
            ),
            "THEM=",
            valueText(
                evaluation.theirs.total
            ),
            "PROFIT=",
            evaluation.profit
            and string.format(
                "%.2f%%",
                evaluation.profit
            )
            or "?"
        )

        for _, row in ipairs(
            evaluation.mine.items
        ) do
            testLog(
                "  OUR",
                row.data.name,
                getVariant(
                    row.raw
                ),
                "=",
                valueText(
                    row.data.value
                ),
                row.data.estimated
                and "(EST)"
                or "",
                row.ignoredByMin
                and "(<MIN IGNORED)"
                or "",
                row.bypassedOwnMinimum
                and "(OWN JUNK <MIN COUNTED)"
                or "",
                row.data.analysis
                and row.data.analysis.field
                and (
                    "FIELD="
                    .. tostring(
                        row.data.analysis.field
                    )
                )
                or ""
            )
        end

        for _, row in ipairs(
            evaluation.theirs.items
        ) do
            testLog(
                "  THEIR",
                row.data.name,
                getVariant(
                    row.raw
                ),
                "=",
                valueText(
                    row.data.value
                ),
                row.data.estimated
                and "(EST)"
                or "",
                row.ignoredByMin
                and "(<MIN IGNORED)"
                or "",
                row.ignoredIncomingUnwanted
                and (
                    "(THEIR IGNORED "
                    .. tostring(
                        row.ignoredIncomingReason
                        or "JUNK"
                    )
                    .. ")"
                )
                or "",
                row.data.analysis
                and row.data.analysis.field
                and (
                    "FIELD="
                    .. tostring(
                        row.data.analysis.field
                    )
                )
                or ""
            )
        end
    end

    -- ALWAYS OPTIMIZE OUR SIDE BEFORE ACCEPT
    -- Their offer stays fixed; choose the most valuable combination
    -- from our inventory that fits the per-item effective demand cap.
    if
        State.optimizedSignature
        ~= optimizationSignature
    then

        if accepted(myOffer) then
            if not unaccept(myOffer) then setTestStatus("WAIT UNACCEPT BEFORE REBUILD", C.YELLOW) return end
            if not Runtime.liveContext(operationContext, true, true) then return end
        end
        local desired,
            ourValue,
            cap,
            optimizationError =
            optimizeOurOffer(
                evaluation.theirs.effectiveTotal
            )

        if optimizationError or not Runtime.liveContext(operationContext, true, true) then
            State.optimizedSignature = nil
            return
        end
        if
            #desired > 0
            and ourValue > 0
        then

            testLog(
                "BALANCE TO DEMAND CAP",
                "THEM=",
                valueText(
                    evaluation.theirs.total
                ),
                "CAP=",
                valueText(
                    cap
                ),
                "OURS=",
                valueText(
                    ourValue
                ),
                "RULES=PER ITEM"
            )

            for index,
                candidate in ipairs(
                    desired
                )
            do
                testLog(
                    "PICK #"
                    .. index,
                    candidate.isPet
                    and "[PET]"
                    or "[ITEM]",
                    candidate.name,
                    candidate.variant,
                    "=",
                    valueText(
                        candidate.value
                    ),
                    candidate.estimated
                    and "(EST)"
                    or ""
                )
            end

            local rebuildOK,
                rebuildReason =
                rebuildOurOffer(
                    myOffer,
                    desired,
                    theirSignature
                )

            if not rebuildOK then

                State.optimizedSignature =
                    nil

                State.acceptReadySignature =
                    nil

                State.acceptReadySince =
                    nil

                State.changedAt =
                    os.clock()

                setTestStatus(
                    "THEIR OFFER CHANGED • REBUILD",
                    C.YELLOW
                )

                testLog(
                    "REBUILD INTERRUPTED",
                    tostring(
                        rebuildReason
                        or "UNKNOWN"
                    ),
                    "-> RECALCULATE"
                )

                return
            end

            -- Mark this exact partner offer as successfully balanced.
            State.optimizedSignature = optimizationSignature
            State.optimizedOurSignature = offerSignature(getTradeSides(getTrade()))

            State.acceptReadySignature =
                nil

            State.acceptReadySince =
                nil

            State.changedAt =
                os.clock()

            return
        end

        if myCount > 0 then
            local ok = rebuildOurOffer(myOffer, {}, theirSignature)
            if ok then State.optimizedSignature = optimizationSignature State.optimizedOurSignature = offerSignature(getTradeSides(getTrade())) end
            State.acceptReadySignature, State.acceptReadySince = nil, nil
            State.changedAt = os.clock()
            return
        end
        -- Nothing from our inventory can fit below the current cap.
        -- Remember this partner signature so we do not recalculate it
        -- every frame; a new item from them clears it automatically.
        State.optimizedSignature = optimizationSignature
        State.optimizedOurSignature = offerSignature(myOffer)
    end

    -- ACCEPT ONLY AFTER OUR OFFER WAS BALANCED
    -- and remained unchanged for PRE ACCEPT DELAY seconds.
    if evaluation.valid then

        State.askStarted =
            nil

        local finalSignature =
            fullSignature(
                myOffer,
                theirOffer
            )

        if
            State.acceptReadySignature
            ~= finalSignature
        then

            State.acceptReadySignature =
                finalSignature

            State.acceptReadySince =
                os.clock()

            testLog(
                "PRE ACCEPT CHECK START",
                string.format(
                    "+%.2f%%",
                    evaluation.profit
                )
            )
        end

        local requiredDelay =
            math.max(
                0,
                tonumber(
                    Settings.preAcceptDelay
                )
                or 4
            )

        local waited =
            os.clock()
            - (
                State.acceptReadySince
                or os.clock()
            )

        local remaining =
            requiredDelay
            - waited

        if remaining > 0 then

            setTestStatus(
                string.format(
                    "DEMAND OK • RAW %.2f%% • ACCEPT IN %.1fs",
                    evaluation.profit,
                    remaining
                ),
                C.GREEN
            )

            return
        end

        -- One more complete calculation immediately before ACCEPT.
        local finalCheck =
            evaluateTrade(
                myOffer,
                theirOffer
            )

        if
            finalCheck.blocked
            or not finalCheck.valid
        then

            State.acceptReadySignature =
                nil

            State.acceptReadySince =
                nil

            unaccept(
                myOffer
            )

            testLog(
                "PRE ACCEPT RECHECK FAILED"
            )

            return
        end

        setTestStatus(
            string.format(
                "DEMAND OK • RAW %.2f%%",
                finalCheck.profit
            ),
            C.GREEN
        )

        secureAccept(
            trade,
            myOffer,
            theirOffer,
            operationContext
        )

        return
    end

    unaccept(
        myOffer
    )

    -- ASK ADD: start a fresh inactivity window. If THEIR offer does not
    -- change for the full timeout, decline. A partner add/remove changes
    -- theirSignature and starts a brand-new window after recalculation.
    if
        not State.askStarted
        or State.askSignature
            ~= theirSignature
    then

        State.askStarted =
            os.clock()

        State.askSignature =
            theirSignature

        InventoryFlow.sendQuickChat(partner, 4, "please add +")

        testLog(
            "ASK ADD",
            "INACTIVITY WINDOW=",
            Settings.addTimeout,
            "SECONDS • DECLINE IF THEIR OFFER DOES NOT CHANGE"
        )
    end

    local elapsed =
        os.clock()
        - State.askStarted

    setTestStatus(
        "ASK ADD "
        .. math.max(
            0,
            math.ceil(
                Settings.addTimeout
                - elapsed
            )
        )
        .. "s",
        C.YELLOW
    )

    if
        elapsed
        >= Settings.addTimeout
        and not State.declineSent
    then

        decline()
    end
end


--============================================================
-- AUTO TRADE MAIN
--============================================================

local function runAutoTrade()
    if getTrade() then PlazaRouter.clearSince = nil end

    local trade =
        getTrade()

    if trade then

        State.requestStarted =
            nil

        manageAutoTrade(
            trade
        )

        return
    end

    if State.tradeID then

        local endedPartner =
            State.partner

        cooldown(endedPartner)

        setTestStatus(
            "POST-TRADE RESCAN",
            C.YELLOW
        )

        testLog(
            "TRADE ENDED -> RESCAN INVENTORY"
        )

        -- Give ClientData a moment to receive the completed trade result.
        Runtime.task.wait(
            1.25
        )

        scanInventoryAndLog(
            "POST TRADE SCAN"
        )

        resetState()

        -- Do not instantly send another request in the same cycle.
        return
    end

    if
        State.target
        and State.requestStarted
    then

        if
            not State.target.Parent
        then

            resetState()

            return
        end

        local elapsed =
            os.clock()
            - State.requestStarted

        setTestStatus(
            "WAIT "
            .. State.target.Name
            .. " "
            .. math.max(
                0,
                math.ceil(
                    Settings.requestTimeout
                    - elapsed
                )
            )
            .. "s",
            C.YELLOW
        )

        if
            elapsed
            >= Settings.requestTimeout
        then

            cooldown(
                State.target
            )

            State.target =
                nil

            State.requestStarted =
                nil
        end

        return
    end

    local target =
        randomPlayer()

    if not target then

        setTestStatus(
            "NO PLAYER",
            C.YELLOW
        )

        return
    end

    State.target =
        target

    State.requestStarted =
        os.clock()

    setTestStatus(
        "REQUEST -> "
        .. target.Name,
        C.YELLOW
    )

    testLog(
        "REQUEST",
        target.Name
    )

    if
        not sendTrade(
            target
        )
    then

        testLog(
            "REQUEST FAILED"
        )

        cooldown(
            target
        )

        State.target =
            nil

        State.requestStarted =
            nil
    end
end


--============================================================
-- LIVE TRADE DISPLAY
--============================================================

local function updateTradeDisplay()
    local trade = getTrade()
    if not trade then
        TradeStatus.Text, TradeStatus.TextColor3, TradeInfo.Text = "WAITING FOR TRADE", C.MUTED, ""
        return
    end
    local myOffer, theirOffer, _, partner = getTradeSides(trade)
    if not myOffer or not theirOffer then return end
    local evaluation = evaluateTrade(myOffer, theirOffer)
    local mine, theirs = evaluation.mine, evaluation.theirs
    local lines = {"PARTNER: " .. playerName(partner)}
    if AMVGG.dataStale then
        lines[#lines + 1] = "LAST GOOD PRICES • UPDATE FAILED • AUTO ACCEPT BLOCKED"
    end
    local function side(title, result, incoming)
        lines[#lines + 1] = ""
        lines[#lines + 1] = "========== " .. title .. " =========="
        for index, row in ipairs(result.items) do
            local data, notes = row.data, {}
            local value = data.known and valueText(data.value) or "UNKNOWN"
            if data.estimated then value = "~" .. value end
            if data.newIgnored then notes[#notes + 1] = "NEW ITEM • NOT COUNTED" end
            if row.ignoredByMin then notes[#notes + 1] = "BELOW MIN • NOT COUNTED" end
            if row.ignoredIncomingUnwanted then
                notes[#notes + 1] = tostring(row.ignoredIncomingReason) .. " • NOT COUNTED"
            end
            local analysis = data.analysis
            if incoming and analysis and analysis.isRealPet then
                notes[#notes + 1] = analysis.demandStars and ("Demand " .. tostring(analysis.demandStars)) or "DEMAND UNKNOWN"
            end
            lines[#lines + 1] = tostring(index) .. ". " .. data.name .. " " .. getVariant(row.raw)
                .. " = " .. value .. (#notes > 0 and (" [" .. table.concat(notes, " | ") .. "]") or "")
        end
        lines[#lines + 1] = title .. " COUNTED TOTAL = " .. valueText(result.total)
    end
    side("YOU", mine, false)
    side("THEM", theirs, true)
    if Settings.autoTrade then
        lines[#lines + 1] = "THEM DEMAND CREDIT = " .. valueText(theirs.effectiveTotal)
    end
    TradeInfo.Text = table.concat(lines, "\n")
    if evaluation.blocked then
        TradeStatus.Text, TradeStatus.TextColor3 = "BLOCK • " .. tostring(evaluation.reason), C.RED
    elseif not evaluation.profit then
        TradeStatus.Text, TradeStatus.TextColor3 = "WAITING", C.YELLOW
    else
        local label = Settings.autoTrade and (evaluation.valid and "AUTO: VALUE CHECK PASSED" or "AUTO: NEED ADD")
            or (evaluation.valid and "WIN" or "LOSE")
        TradeStatus.Text = string.format("%s • COUNTED PROFIT %+.2f%%", label, evaluation.profit)
        TradeStatus.TextColor3 = evaluation.valid and C.GREEN or C.YELLOW
    end
end


--============================================================
-- REMOTE STATUS LOG
--============================================================

testLog(
    "REQUEST",
    TradeRemote.SendRequest
        and "OK"
        or "MISS",
    TradeRemote.SendRequestName
        or ""
)


testLog(
    "ADD",
    TradeRemote.Add
        and "OK"
        or "MISS",
    TradeRemote.AddName
        or ""
)


testLog(
    "REMOVE",
    TradeRemote.Remove
        and "OK"
        or "MISS",
    TradeRemote.RemoveName
        or ""
)


testLog(
    "ACCEPT",
    TradeRemote.Accept
        and "OK"
        or "MISS"
)


testLog(
    "UNACCEPT",
    TradeRemote.Unaccept
        and "OK"
        or "MISS"
)


testLog(
    "CONFIRM",
    TradeRemote.Confirm
        and "OK"
        or "MISS"
)


testLog(
    "DECLINE",
    TradeRemote.Decline
        and "OK"
        or "MISS"
)


testLog(
    "SUGGEST ITEM",
    TradeRemote.SuggestItem
        and "READY / INVENTORY SUGGEST"
        or "MISS"
)


--============================================================
-- CLOSE / OPEN
--============================================================

local OpenButton =
    button(
        Gui,
        "AM",

        UDim2.fromOffset(
            48,
            48
        ),

        UDim2.fromOffset(
            12,
            12
        )
    )


OpenButton.Visible =
    false

OpenButton.BackgroundColor3 =
    C.ACCENT


Runtime.connect(CloseButton.Activated,
    function()

        Main.Visible =
            false

        OpenButton.Visible =
            true
    end
)


Runtime.connect(OpenButton.Activated,
    function()

        Main.Visible =
            true

        OpenButton.Visible =
            false
    end
)


--============================================================
-- AMVGG INITIAL LOAD
--============================================================

setBoot(
    "4/9",
    "AMVGG LOAD"
)


Runtime.task.spawn(
    function()

        local ok,
            err =
            pcall(
                function()

                    refresh()

                    updateFirstSeen()

                    Runtime.updateStatusPage()

                    Runtime.rebuildSearch()
                end
            )

        if not ok then

            AMVGG.error =
                tostring(
                    err
                )

            warn(
                "[AMVGG ERROR]",
                err
            )
        end
    end
)


--============================================================
-- TRADE DISPLAY LOOP
--============================================================

setBoot(
    "5/9",
    "TRADE LOOP"
)


Runtime.task.spawn(
    function()

        while Gui.Parent do

            local ok,
                err =
                pcall(
                    updateTradeDisplay
                )

            if not ok then

                warn(
                    "[TRADE DISPLAY ERROR]",
                    err
                )
            end

            Runtime.task.wait(
                0.6
            )
        end
    end
)


--============================================================
-- AUTO TRADE LOOP
--============================================================

setBoot(
    "6/9",
    "AUTO LOOP"
)


Runtime.task.spawn(
    function()

        while Gui.Parent do

            local ok,
                err =
                pcall(
                    function()

                        if
                            Settings.plazaAutoRoute
                            and not getTrade()
                            and not (State.target and State.requestStarted)
                            and (not PlazaRouter.readyForTrading or PlazaRouter.preparing or PlazaRouter.teleporting)
                        then

                            setTestStatus(
                                PlazaRouter.teleporting
                                and "TELEPORTING TO TRADING PLAZA"
                                or "PLAZA ROUTER • DETECTING SERVER",
                                C.YELLOW
                            )

                        elseif
                            Settings.autoTrade
                        then

                            runAutoTrade()

                        else

                            InventoryFlow.stop("Auto Trade disabled")
                            setTestStatus(
                                "OFF",
                                C.MUTED
                            )
                        end
                    end
                )

            if not ok then

                testLog(
                    "AUTO ERROR",
                    err
                )

                setTestStatus(
                    "ERROR",
                    C.RED
                )
            end

            Runtime.task.wait(
                0.42
            )
        end
    end
)


--============================================================
-- LOG LOOP
--============================================================

setBoot(
    "7/9",
    "LOG LOOP"
)


Runtime.task.spawn(
    function()

        while Gui.Parent do

            LogBox.Text =
                table.concat(
                    TestLogs,
                    "\n"
                )

            Runtime.updateStatusPage()

            Runtime.task.wait(
                0.8
            )
        end
    end
)


--============================================================
-- PERIODIC AMVGG REFRESH
--============================================================

Runtime.task.spawn(
    function()

        while Gui.Parent do

            local minutes =
                math.max(
                    1,
                    tonumber(
                        Settings.refreshMinutes
                    )
                    or 5
                )

            Runtime.task.wait(
                minutes
                * 60
            )

            if not Gui.Parent then
                break
            end

            local ok,
                err =
                pcall(
                    function()

                        testLog(
                            "AMVGG REFRESH"
                        )

                        refresh()

                        updateFirstSeen()

                        Runtime.rebuildSearch()
                    end
                )

            if not ok then

                testLog(
                    "REFRESH ERROR",
                    err
                )
            end
        end
    end
)


--============================================================
-- PLAYER CLEANUP
--============================================================

Runtime.connect(Players.PlayerRemoving,
    function(player)

        PlayerCooldowns[
            player.UserId
        ] =
            nil

        if
            State.target
            == player
        then

            State.target =
                nil

            State.requestStarted =
                nil
        end
    end
)


--============================================================
-- READY
--============================================================

setBoot(
    "8/9",
    "FINALIZING"
)


setPage(
    "TRADE"
)


saveSettings()


setBoot(
    "9/9",
    "READY"
)


print(
    "[AM V"
    .. VERSION
    .. "] READY"
)


Runtime.task.delay(
    2.5,
    function()

        if
            BootGui
            and BootGui.Parent
        then

            BootGui:Destroy()
        end
    end
)
