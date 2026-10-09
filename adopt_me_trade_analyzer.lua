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

local PlayerGui

local ENV =
    type(getgenv) == "function"
    and getgenv()
    or _G


--============================================================
-- VERSION
--============================================================

local VERSION =
    "11.7.43"

local GUI_NAME =
    "AdoptMeTradeAnalyzerV11720"

local BOOT_NAME =
    "AM_ANALYZER_BOOT_V11720"


print(
    "[AM V" .. VERSION .. "] BOOT"
)

print(
    "[AM V" .. VERSION .. "] POTION FIRST + DEMAND 10/15/20 (0.15pp TOLERANCE) + PROTECTED OUR 3 STAR PETS"
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
    Runtime.nativeTask = nativeTask
    local key = "__AM_ANALYZER_RUNTIME"
    local previous = ENV[key]
    if type(previous) == "table" and type(previous.stop) == "function" then
        pcall(previous.stop, "replaced by a new analyzer")
    end
    ENV[key] = Runtime
    Runtime.initializingThread = coroutine.running()
    function Runtime.alive()
        return Runtime.active and ENV[key] == Runtime
    end
    function Runtime.stop(reason)
        if not Runtime.active then return end
        if Runtime.beginAcceptanceCancellation then pcall(Runtime.beginAcceptanceCancellation, reason or "stopped") end
        Runtime.active = false
        local initializing = Runtime.initializingThread
        Runtime.initializingThread = nil
        if type(initializing) == "thread" and initializing ~= coroutine.running() and coroutine.status(initializing) ~= "dead" then
            pcall(nativeTask.cancel, initializing)
        end
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
            local ok, err = pcall(function()
                if Runtime.alive() then fn(table.unpack(args, 1, args.n)) end
            end)
            Runtime.jobs[coroutine.running()] = nil
            if not ok then error(err, 0) end
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


PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
if not Runtime.alive() then return end
GuiParent = GuiParent or PlayerGui
if not GuiParent then warn("AM: PlayerGui unavailable") Runtime.stop("PlayerGui unavailable") return end

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

function Runtime.priceFieldsValid(entry)
    if type(entry) ~= "table" then return false end
    local any = false
    for _, field in ipairs({"value","regularValue","neonValue","megaValue","npRegularValue","npNeonValue","npMegaValue","fValue","rValue","frValue","nfValue","nrValue","mfValue","mrValue"}) do
        if entry[field] ~= nil then
            local price = num(entry[field])
            if price == nil or price < 0 then return false end
            any = true
        end
    end
    return any
end

Runtime.catalogFields = {
    "category", "value", "regularValue", "neonValue", "megaValue", "npRegularValue", "npNeonValue", "npMegaValue",
    "fValue", "rValue", "frValue", "nfValue", "nrValue", "mfValue", "mrValue",
    "demand", "regularDemand", "neonDemand", "megaDemand", "npRegularDemand", "npNeonDemand", "npMegaDemand",
    "fDemand", "rDemand", "frDemand", "nfDemand", "nrDemand", "mfDemand", "mrDemand",
    "rarity", "pet_rarity", "petRarity", "rarity_name", "rarityName",
}
function Runtime.normalizeCatalogDemand(raw)
    if type(raw)=="number" then
        if raw==1 or raw==2 or raw==3 then return raw end
    elseif type(raw)=="string" then
        local label=raw:match("^%s*(.-)%s*$"):lower()
        if label=="1" or label=="2" or label=="3" then return tonumber(label) end
        return ({low=1,medium=2,decent=2,high=3})[label]
    end
    return nil
end
function Runtime.catalogRarity(raw)
    if type(raw)=="table" then raw=raw.name or raw.Name or raw.value or raw.Value end
    if type(raw)~="string" then return nil end
    local key=raw:lower():gsub("’", "'"):gsub("&", "and"):gsub("[^%w]","")
    if ({common=true,uncommon=true,rare=true,ultrarare=true,legendary=true})[key] then return key end
    return nil
end
function Runtime.catalogFieldValue(field,value)
    if value==nil then return "missing" end
    if field=="category" or field:lower():find("value",1,true) then
        local parsed=num(value)
        return parsed and string.format("%.17g",parsed) or "invalid:" .. tostring(value)
    end
    if field:lower():find("demand",1,true) then
        local stars=Runtime.normalizeCatalogDemand(value)
        if stars then return "stars:" .. stars end
    elseif field:lower():find("rarity",1,true) then
        local rarity=Runtime.catalogRarity(value)
        if rarity then return "rarity:" .. rarity end
    end
    return type(value) .. ":" .. tostring(value):lower()
end
function Runtime.catalogFieldsConflict(a,b)
    local rarityA,rarityB
    for _,field in ipairs(Runtime.catalogFields) do
        if a[field]~=nil and b[field]~=nil
            and Runtime.catalogFieldValue(field,a[field])~=Runtime.catalogFieldValue(field,b[field]) then return true end
        if field:lower():find("rarity",1,true) then
            local ar,br=Runtime.catalogRarity(a[field]),Runtime.catalogRarity(b[field])
            if ar then
                if rarityA and rarityA~=ar then return true end
                rarityA=ar
            end
            if br then
                if rarityB and rarityB~=br then return true end
                rarityB=br
            end
        end
    end
    return rarityA~=nil and rarityB~=nil and rarityA~=rarityB
end
function Runtime.catalogEntryFingerprint(entry)
    local values={string.format("%q",tostring(entry.name))}
    for _,field in ipairs(Runtime.catalogFields) do
        values[#values+1]=string.format("%q",Runtime.catalogFieldValue(field,entry[field]))
    end
    return table.concat(values,":")
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

    local original = tostring(text or ""):lower()

    add(
        original
    )

    -- Parenthetical qualifiers are meaningful item identity, never a generic alias.

    add(
        original:gsub(
            "chocobunny",
            "choccybunny"
        )
    )

    add(
        original:gsub(
            "choccybunny",
            "chocobunny"
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

function Runtime.bootCall(fn, seconds)
    local operation = {done=false}
    local thread = Runtime.task.spawn(function()
        local result = table.pack(pcall(fn))
        if not operation.abandoned then operation.result, operation.done = result, true end
    end)
    local deadline = os.clock() + seconds
    while Runtime.alive() and not operation.done and os.clock() < deadline do Runtime.task.wait(.05) end
    if not Runtime.alive() or not operation.done then
        operation.abandoned = true
        if type(thread) == "thread" then pcall(Runtime.task.cancel, thread) Runtime.jobs[thread] = nil end
        return false, Runtime.alive() and "MODULE LOAD TIMEOUT" or "MODULE LOAD CANCELLED"
    end
    return table.unpack(operation.result, 1, operation.result.n)
end

function Runtime.loadBootModule(label, fn, seconds)
    local ok, value = Runtime.bootCall(fn, seconds or 15)
    if not ok then error(label .. ": " .. tostring(value)) end
    return value
end


do

    local ok,
        err =
        xpcall(
            function()

                local module = RS:WaitForChild("Fsys", 15)
                assert(module, "Fsys module unavailable")
                Fsys = Runtime.loadBootModule("Fsys require", function() return require(module) end, 15)

                if not Runtime.alive() then return end

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

                ClientData = Runtime.loadBootModule("ClientData", function() return Fsys.load("ClientData") end, 15)

                if not Runtime.alive() then return end

                ItemDB = Runtime.loadBootModule("ItemDB", function() return Fsys.load("ItemDB") end, 15)

                if not Runtime.alive() then return end

                pcall(
                    function()

                        RouterClient = Runtime.loadBootModule("RouterClient", function() return Fsys.load("RouterClient") end, 10)
                    end
                )

                if not Runtime.alive() then return end

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

    if not Runtime.alive() then return end
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
        return Runtime.catalogRarity(value)
    end

    function CommonPetFilter.isCommon(item)
        if type(item) ~= "table" or tostring(item.category or "") ~= "pets" then return false end
        local db = getItemDB(item)
        local p = type(item.properties) == "table" and item.properties or {}
        local sources = {item, p, type(db) == "table" and db or {}}
        for _, source in ipairs(sources) do
            local fields = {"rarity", "pet_rarity", "petRarity", "rarity_name", "rarityName"}
            for _, field in ipairs(fields) do
                local rarity = rarityText(source[field])
                if rarity then return rarity == "common" end
            end
        end
        return commonNames[normalize(getItemName(item))] == true
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


function Runtime.runBounded(fn, seconds, current)
    local operation = {done=false, abandoned=false}
    Runtime.boundedChildren = Runtime.boundedChildren or setmetatable({}, {__mode="k"})
    local parent, thread = coroutine.running(), nil
    local function unlink()
        local siblings = parent and Runtime.boundedChildren[parent]
        if siblings and thread then
            siblings[thread] = nil
            if next(siblings) == nil then Runtime.boundedChildren[parent] = nil end
        end
    end
    local function invoke()
        local result = table.pack(pcall(fn))
        operation.done = true
        if not operation.abandoned then operation.result = result end
        unlink()
    end
    if type(Runtime.task.spawn) == "function" then thread = Runtime.task.spawn(invoke)
    else thread = coroutine.create(invoke) coroutine.resume(thread) end
    if parent and type(thread) == "thread" and coroutine.status(thread) ~= "dead" then
        local siblings = Runtime.boundedChildren[parent] or {}
        Runtime.boundedChildren[parent] = siblings
        siblings[thread] = true
    end
    local function abandon(reason)
        operation.abandoned, operation.result = true, nil
        if thread then Runtime.cancelBounded(thread) end
        unlink()
        return false, reason
    end
    local deadline = os.clock() + seconds
    for _ = 1, math.ceil(seconds / .05) + 2 do
        if not Runtime.alive() or (current and not current()) then return abandon("OPERATION CANCELLED") end
        if operation.done then
            unlink()
            local result = operation.result
            if not result then return false, "OPERATION CANCELLED" end
            return table.unpack(result, 1, result.n)
        end
        if os.clock() >= deadline then return abandon("OPERATION TIMEOUT") end
        Runtime.task.wait(.05)
    end
    return abandon("OPERATION TIMEOUT")
end

function Runtime.cancelBounded(thread)
    local children = Runtime.boundedChildren and Runtime.boundedChildren[thread]
    if children then
        Runtime.boundedChildren[thread] = nil
        for child in pairs(children) do Runtime.cancelBounded(child) end
    end
    if type(thread) == "thread" and coroutine.status(thread) ~= "dead" then
        if type(Runtime.task.cancel) == "function" then pcall(Runtime.task.cancel, thread)
        elseif type(coroutine.close) == "function" then pcall(coroutine.close, thread) end
    end
    if Runtime.jobs then Runtime.jobs[thread] = nil end
end


local function httpGet(url, headers)
    local generation = Runtime.priceRefreshGeneration
    local function current() return Runtime.priceRefreshGeneration == generation end
    local ok, body, status = Runtime.runBounded(function()
        if type(REQUEST) == "function" then
            local requested, response = pcall(REQUEST, {Url=url, URL=url, Method="GET", Headers=headers or {}})
            if not current() or not Runtime.alive() then return nil, 0 end
            if requested then
                if type(response) == "string" then return response, 200 end
                if type(response) == "table" then
                    return response.Body or response.body, tonumber(response.StatusCode or response.Status or response.status_code) or 0
                end
            end
        end
        if not current() or not Runtime.alive() then return nil, 0 end
        return game:HttpGet(url, true), 200
    end, 8, current)
    if ok then return body, status or 0 end
    Runtime.lastHTTPError = tostring(body)
    return nil, 0
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
    return type(object) == "table" and type(object.name) == "string"
        and object.name ~= "" and Runtime.priceFieldsValid(object)
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
                    if (previous.id ~= nil and object.id ~= nil and tostring(previous.id) ~= tostring(object.id))
                        or Runtime.catalogFieldsConflict(previous, object) then
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
    local generation = Runtime.priceRefreshGeneration
    local token = tostring(os.time()) .. tostring(math.random(100000, 999999))
    local attempts = {
        {url="https://amvgg.com/values/" .. slug .. "?_rsc=" .. token, headers={RSC="1"}},
        {url="https://amvgg.com/values/" .. slug .. "?v=" .. token, headers={}},
        {url="https://amvgg.com/values/" .. slug, headers={}},
    }
    local evidence, lastStatus = {}, 0
    for _, attempt in ipairs(attempts) do
        if not Runtime.alive() or Runtime.priceRefreshGeneration ~= generation then return {}, 0, lastStatus end
        local body, status = httpGet(attempt.url, attempt.headers)
        if not Runtime.alive() or Runtime.priceRefreshGeneration ~= generation then return {}, 0, status end
        lastStatus = status
        if status == 429 then return {}, 0, status end
        if status >= 200 and status < 400 and type(body) == "string" then
            local database, count = parseBody(body)
            local fingerprint, valuationFingerprint = Runtime.catalogFingerprint(slug, database, count)
            if fingerprint then
                local key = fingerprint .. "\nVALUES=" .. valuationFingerprint
                evidence[key] = (evidence[key] or 0) + 1
                Runtime.catalogVerified[database] = {slug=slug, fingerprint=fingerprint, valuationFingerprint=valuationFingerprint, sources=evidence[key]}
                -- Unchanged full coverage needs one response. A changed catalog
                -- still needs matching independent response formats.
                if Runtime.catalogComplete(slug, database, count) then return database, count, status end
            end
        end
        Runtime.task.wait(.12)
    end
    return {}, 0, lastStatus
end


local function refresh()
    if not Runtime.alive() then return false end
    if AMVGG.loading then
        local started = Runtime.priceRefreshStarted
        if not started then Runtime.priceRefreshStarted = os.clock() return false end
        if os.clock() - started < 125 then return false end
        Runtime.priceRefreshGeneration = (Runtime.priceRefreshGeneration or 0) + 1
        AMVGG.loading, AMVGG.dataStale = false, true
    end
    Runtime.priceRefreshGeneration = (Runtime.priceRefreshGeneration or 0) + 1
    local generation = Runtime.priceRefreshGeneration
    Runtime.priceRefreshStarted, Runtime.lastHTTPError = os.clock(), nil
    AMVGG.loading = true
    local workers = {}
    local function current() return Runtime.priceRefreshGeneration == generation end
    local ok, snapshot, failure = Runtime.runBounded(function()
        local categories, counts, total, failed = {}, {}, 0, {}
        local nextIndex, completed = 0, 0
        local function worker()
            while Runtime.alive() and current() do
                nextIndex += 1
                local slug = CATEGORY_URLS[nextIndex]
                if not slug then return end
                local loaded, database, count, status = pcall(loadCategory, slug)
                if not Runtime.alive() or not current() then return end
                if not loaded or not Runtime.catalogComplete(slug, database, count) then
                    failed[#failed + 1] = slug .. "(" .. tostring(loaded and status or database) .. ")"
                else
                    categories[slug], counts[slug] = database, count
                    total += count
                end
                completed += 1
                Runtime.task.wait()
            end
        end
        if type(Runtime.task.spawn) == "function" then
            for _ = 1, math.min(3, #CATEGORY_URLS) do workers[#workers + 1] = Runtime.task.spawn(worker) end
            while completed < #CATEGORY_URLS and Runtime.alive() and current() do Runtime.task.wait(.05) end
        else
            worker()
        end
        if not Runtime.alive() or not current() then return nil, "SESSION STOPPED" end
        if completed ~= #CATEGORY_URLS or #failed > 0 or total <= 0 then
            return nil, "REFRESH FAILED: " .. table.concat(failed, ", ") .. (Runtime.lastHTTPError and " | " .. Runtime.lastHTTPError or "")
        end
        return {categories=categories, counts=counts, total=total}
    end, 120, current)
    local owns = current()
    -- Close the generation before cancelling workers. Any uncancellable late
    -- response is discarded and cannot start another request or commit prices.
    if owns then Runtime.priceRefreshGeneration = generation + 1 end
    for _, thread in ipairs(workers) do
        Runtime.cancelBounded(thread)
    end
    if not owns then return false end
    AMVGG.loading, Runtime.priceRefreshStarted = false, nil
    if not Runtime.alive() then return false end
    if not ok or not snapshot then
        AMVGG.error = tostring(ok and failure or snapshot)
        AMVGG.dataStale = true
        Runtime.priceRetryAt = os.clock() + 30
        return false
    end
    AMVGG.categories, AMVGG.counts, AMVGG.total = snapshot.categories, snapshot.counts, snapshot.total
    AMVGG.ready, AMVGG.dataStale, AMVGG.error = true, false, nil
    AMVGG.version += 1
    AMVGG.lastRefresh = os.time()
    Runtime.lastRefreshClock, Runtime.priceRetryAt = os.clock(), nil
    return true
end


--============================================================
-- AMVGG LOOKUP
--============================================================

local function findCategory(slug, itemName)
    local category = AMVGG.categories[slug]
    if type(category) ~= "table" then return nil end
    local exact = normalize(itemName)
    local direct = category[exact]
    if type(direct) == "table" and direct.__ambiguous then return nil end
    if type(direct) == "table" and type(direct.name) == "string" and normalize(direct.name) == exact then
        return direct, exact
    end
    Runtime.lookupIndexes = Runtime.lookupIndexes or {}
    local version = AMVGG.version
    local index = Runtime.lookupIndexes[slug]
    if not index or index.database ~= category or index.version ~= version then
        index = {database=category, version=version, exact={}, aliases={}}
        local function insert(map, name, entry, key)
            local previous = map[name]
            if previous == false then return end
            if previous and previous.entry ~= entry then map[name] = false
            else map[name] = {entry=entry, key=key} end
        end
        local scanned = 0
        for key, entry in pairs(category) do
            if type(entry) == "table" and type(entry.name) == "string" then
                if entry.__ambiguous then
                    index.exact[normalize(entry.name)] = false
                else
                    insert(index.exact, normalize(entry.name), entry, key)
                    for name in pairs(aliases(entry.name)) do insert(index.aliases, name, entry, key) end
                end
            end
            scanned += 1
            if scanned % 64 == 0 then
                Runtime.task.wait()
                if not Runtime.alive() or AMVGG.categories[slug] ~= category or AMVGG.version ~= version then return nil end
            end
        end
        Runtime.lookupIndexes[slug] = index
        Runtime.lookupIndexBuilds = (Runtime.lookupIndexBuilds or 0) + 1
    end
    local found = index.exact[exact]
    if found == false then return nil end
    if found then return found.entry, found.key end
    -- Missing names are constant-time lookups after one indexed catalog pass.
    for name in pairs(aliases(itemName)) do
        local candidate = index.aliases[name]
        if candidate == false then return nil end
        if candidate then
            if found and found.entry ~= candidate.entry then return nil end
            found = candidate
        end
    end
    if found then return found.entry, found.key end
    return nil
end



-- Read-only baseline verified against all ten public AMVGG catalogs on 2026-10-06.
Runtime.catalogMinimum = {pets=786, eggs=44, petwear=237, strollers=35, food=51,
    vehicles=199, toys=93, gifts=32, stickers=71, houses=37}
Runtime.catalogVerified = setmetatable({}, {__mode="k"})
function Runtime.catalogFingerprint(slug, database, count)
    if type(database) ~= "table" or not num(count) or count % 1 ~= 0 then return nil end
    local identities, valuations, seen, actual = {}, {}, {}, 0
    for key, entry in pairs(database) do
        if type(entry) ~= "table" or type(entry.name) ~= "string" or entry.__ambiguous
            or not Runtime.priceFieldsValid(entry)
            or (Runtime.catalogPriceValid and not Runtime.catalogPriceValid(slug, entry)) then return nil end
        local identity = entry.id ~= nil and "id:" .. tostring(entry.id) or "name:" .. tostring(key)
        if seen[identity] then return nil end
        seen[identity], actual = true, actual + 1
        identities[#identities + 1] = identity
        valuations[#valuations + 1] = string.format("%q:%s", identity, Runtime.catalogEntryFingerprint(entry))
    end
    -- A small catalog edit is allowed only with corroboration below. Large
    -- drops still require an updated verified baseline, never blind acceptance.
    local floor = math.max(1, math.floor((Runtime.catalogMinimum[slug] or 1) * .9), math.floor(((AMVGG.counts or {})[slug] or 0) * .9))
    if actual ~= count or count < floor then return nil end
    table.sort(identities)
    table.sort(valuations)
    return table.concat(identities, "|"), table.concat(valuations, "|")
end

function Runtime.catalogComplete(slug, database, count)
    local fingerprint, valuationFingerprint = Runtime.catalogFingerprint(slug, database, count)
    if not fingerprint then return false end
    local byID = {}
    for _, entry in pairs(database) do if entry.id ~= nil then byID[tostring(entry.id)] = true end end
    local old = AMVGG.categories[slug] or {}
    local changed = count < math.max(Runtime.catalogMinimum[slug] or 1, (AMVGG.counts or {})[slug] or 0)
    for key, previous in pairs(old) do
        if previous.id ~= nil then
            if not byID[tostring(previous.id)] then changed = true end
        elseif not database[key] then
            return false -- without a stable ID, keep the strict coverage rule
        end
    end
    if not changed then return true end -- renaming with the same ID is safe
    local verified = Runtime.catalogVerified[database]
    return verified ~= nil and verified.slug == slug and verified.fingerprint == fingerprint and verified.valuationFingerprint == valuationFingerprint and verified.sources >= 2
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


local function getPetValue(entry, variant)
    if type(entry) ~= "table" then return nil, nil, false, "INVALID ENTRY" end
    if not EXACT_FIELD[variant] then return nil, nil, false, "UNKNOWN VARIANT" end
    local function exact(field)
        local value = num(entry[field])
        if value == nil or value < 0 then return nil, field, false, "MISSING/INVALID " .. field end
        return value, field, false
    end
    -- AMVGG's category-less representation explicitly uses one value/demand.
    if entry.category == nil then return exact("value") end
    local category = num(entry.category)
    if category == 13 then return exact(EXACT_FIELD[variant]) end
    if category == nil then return nil, nil, false, "NO CATEGORY" end
    if not MULTIPLIERS[category] then return nil, nil, false, "NO MULTIPLIER FOR CATEGORY " .. tostring(category) end
    if variant == "FR" then return exact("regularValue") end
    if variant == "NFR" then return exact("neonValue") end
    if variant == "MFR" then return exact("megaValue") end
    local family = variant:sub(1,1)
    local field = family == "M" and "megaValue" or (family == "N" and variant ~= "NP") and "neonValue" or "regularValue"
    local base = num(entry[field])
    if base == nil or base < 0 then return nil, field, false, "MISSING/INVALID " .. field end
    local regular = num(entry.regularValue)
    if category == 11 and field ~= "regularValue" and (regular == nil or regular < 0) then
        return nil, "regularValue", false, "MISSING/INVALID regularValue FOR CATEGORY 11"
    end
    -- Unused families are not required, and never supply the requested value.
    local variants = calculateCategoryVariants(category,
        field == "regularValue" and base or math.max(0, regular or 0),
        field == "neonValue" and base or 0, field == "megaValue" and base or 0)
    local value = variants and variants[variant]
    return value, "CALC/CAT=" .. tostring(category), false, value == nil and "CALCULATED NIL" or nil
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


function Runtime.catalogPriceValid(slug, entry)
    if not Runtime.priceFieldsValid(entry) then return false end
    if slug ~= "pets" then return genericValue(entry) ~= nil end
    for variant in pairs(EXACT_FIELD) do
        if getPetValue(entry, variant) ~= nil then return true end
    end
    return false
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
        if entry.category == nil then return entry.demand end
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
        return Runtime.normalizeCatalogDemand(raw)
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
            if stars == 3 then return rawValue / 1.0985, "3STAR" end
            if stars == 2 then return rawValue / 1.1485, "2STAR" end
            if stars == 1 then return rawValue / 1.1985, "1STAR" end
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

    result.entry = entry
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

Runtime.numberLimits = {
                        minProfitPercent={0,500}, itemMinimumWinPercent={0,500},
                        myMinItemValue={0.0005,1000000}, theirMinItemValue={0.0005,1000000}, allMinItemValue={0.0005,1000000},
                        maxOurItems={1,18}, optimizerBeam={80,2000}, newItemHours={0,720}, refreshMinutes={1,1440},
                        requestTimeout={1,300}, firstItemTimeout={5,3600}, addTimeout={5,3600}, unknownBlockTimeout={5,3600},
                        playerCooldown={0,86400}, settleSeconds={0,60}, partnerRebuildDelay={0,120}, maxTradeSeconds={180,7200},
                        showcaseDelay={0,120}, itemActionDelay={0.1,10}, postRebuildDelay={0.25,30}, preAcceptDelay={0,120},
                        secondConfirmDelay={0,120}, plazaHopMinutes={0,1440},
                        waitWindowProfile={0,1}, askAddWindowProfile={0,1}, plazaHopProfile={0,1},
                    }

function Runtime.numberValue(key,value,fallbackMin,fallbackMax)
    local parsed=num(value)
    if not parsed then return nil end
    local bounds=Runtime.numberLimits[key] or {fallbackMin or 0,fallbackMax or 1000000}
    parsed=math.clamp(parsed,bounds[1],bounds[2])
    if key=="maxOurItems" or key=="optimizerBeam" then parsed=math.floor(parsed) end
    return parsed
end

local SETTINGS_FILE =
    "am_trade_v1170_" .. tostring(LocalPlayer.UserId) .. ".json"

local FIRST_SEEN_FILE =
    "am_first_seen_v1170_" .. tostring(LocalPlayer.UserId) .. ".json"


local Settings = {

    ownPotionsOnly = false,

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
    return Runtime.readSavedJSON(path)
end

Runtime.fileSchemas = Runtime.fileSchemas or {}
Runtime.fileReadBlocked = Runtime.fileReadBlocked or {}
Runtime.fileLastGood = Runtime.fileLastGood or {}
Runtime.storageErrorKinds = Runtime.storageErrorKinds or {}
Runtime.legacyFiles = {[SETTINGS_FILE]="am_trade_v1170.json", [FIRST_SEEN_FILE]="am_first_seen_v1170.json"}
Runtime.settingsDefaults = shallowCopy(Settings)
Runtime.settingsLocalOverrides = {}
Runtime.settingsObserved = shallowCopy(Settings)
Runtime.settingsUI = {}
Runtime.fileSchemas[SETTINGS_FILE] = function(data)
    local known = 0
    for key, value in pairs(data) do
        local default = Runtime.settingsDefaults[key]
        if default ~= nil then
            known += 1
            if type(default) == "number" then
                if num(value) == nil then return false end
            elseif type(default) == "boolean" then
                if type(value) ~= "boolean" and value ~= "true" and value ~= "false" then return false end
            elseif type(value) ~= type(default) then return false end
        end
    end
    return known > 0
end

function Runtime.storageIssue(path, message, kind)
    Runtime.storageErrors = Runtime.storageErrors or {}
    Runtime.storageErrorKinds = Runtime.storageErrorKinds or {}
    local errors = Runtime.storageErrorKinds[path] or {}
    Runtime.storageErrorKinds[path] = errors
    errors[kind or "general"] = message
    local messages = {}
    for _, key in ipairs({"read", "write", "general"}) do
        if errors[key] then messages[#messages+1] = errors[key] end
    end
    local combined = #messages > 0 and table.concat(messages, " | ") or nil
    if combined and Runtime.storageErrors[path] ~= combined then
        warn("[AM STORAGE] " .. tostring(path) .. ": " .. combined)
    end
    Runtime.storageErrors[path] = combined
end

function Runtime.savedJSONValid(path, data)
    if type(data) ~= "table" then return false end
    local validator = Runtime.fileSchemas[path]
    return not validator or validator(data) == true
end

function Runtime.readSavedJSON(path)
    local function read(candidate)
        if type(isfile) ~= "function" or type(readfile) ~= "function" then error("FILE API UNAVAILABLE") end
        if not isfile(candidate) then return nil, "MISSING" end
        local text = readfile(candidate)
        local data = HttpService:JSONDecode(text)
        if not Runtime.savedJSONValid(path, data) then error("INVALID SAVED JSON SCHEMA") end
        return data, "READ", text
    end
    local ok, data, status, text = pcall(read, path)
    if ok and status == "READ" then
        Runtime.fileLastGood[path], Runtime.fileReadBlocked[path] = text, nil
        Runtime.storageIssue(path, nil, "read")
        return data, "READ"
    end
    local backupOK, backup, backupStatus, backupText = pcall(read, path .. ".bak")
    if backupOK and backupStatus == "READ" then
        Runtime.fileLastGood[path], Runtime.fileReadBlocked[path] = backupText, nil
        Runtime.storageIssue(path, "RECOVERED VERIFIED BACKUP; MAIN FILE NEEDS REPAIR", "read")
        return backup, "READ", "BACKUP"
    end
    -- Recover the first verified history even if committing main failed.
    -- A stage is never preferred to an existing trusted committed history.
    if path == FIRST_SEEN_FILE then
        local stageOK, stage, stageStatus, stageText = pcall(read, path .. ".tmp")
        if stageOK and stageStatus == "READ" and stage.initialized == true then
            Runtime.fileLastGood[path], Runtime.fileReadBlocked[path] = stageText, nil
            Runtime.storageIssue(path, "RECOVERED HISTORY STAGING; MAIN FILE NEEDS REPAIR", "read")
            return stage, "READ", "STAGING"
        end
        if not stageOK or stageStatus ~= "MISSING" then ok, data, status = false, stage, "ERROR" end
    end
    if ok and status == "MISSING" and backupOK and backupStatus == "MISSING" then
        local legacy = Runtime.legacyFiles[path]
        if legacy and legacy ~= path then
            local legacyOK,legacyData,legacyStatus,legacyText=pcall(read,legacy)
            local backupOK,backupData,backupStatus,backupText=pcall(read,legacy .. ".bak")
            if legacyOK and legacyStatus=="READ" or backupOK and backupStatus=="READ" then
                if not legacyOK or legacyStatus~="READ" then legacyData,legacyText=backupData,backupText end
                Runtime.fileLastGood[path],Runtime.fileReadBlocked[path]=legacyText,nil
                Runtime.storageIssue(path,nil,"read")
                return legacyData,"READ","LEGACY"
            end
            if not legacyOK or not backupOK then
                ok,data,status=false,not legacyOK and legacyData or backupData,"ERROR"
            end
        end
        if ok and not Runtime.fileReadBlocked[path] then
            Runtime.fileLastGood[path] = nil
            Runtime.storageIssue(path, nil, "read")
            return nil, "MISSING"
        end
    end
    local message = "READ FAILED: " .. tostring(not ok and data or not backupOK and backup or "TRUSTED FILE UNAVAILABLE"):sub(1,140)
    Runtime.fileReadBlocked[path] = true
    Runtime.storageIssue(path, message, "read")
    return nil, "ERROR", message
end

function Runtime.registerSettingsUI(refresh)
    Runtime.settingsUI[#Runtime.settingsUI+1] = refresh
end
function Runtime.refreshSettingsUI()
    for _, refresh in ipairs(Runtime.settingsUI or {}) do
        local ok, err = pcall(refresh)
        if not ok then warn("[AM SETTINGS UI] " .. tostring(err)) end
    end
end
function Runtime.captureSettingsEdits()
    for key, value in pairs(Settings) do
        if value ~= Runtime.settingsObserved[key] then Runtime.settingsLocalOverrides[key] = value end
    end
end
function Runtime.settingsBaseline()
    Runtime.settingsObserved = shallowCopy(Settings)
end

function Runtime.storageNotice()
    local errors = {}
    for path, message in pairs(Runtime.storageErrors or {}) do
        errors[#errors + 1] = tostring(path) .. ": " .. tostring(message)
    end
    table.sort(errors)
    return #errors > 0 and ("STORAGE ERROR • " .. table.concat(errors, " | ")) or nil
end

local function saveJSON(path, data)
    -- Serialize writers in this executor, including replacement Runtime objects.
    ENV.__AM_ANALYZER_FILE_WRITERS = ENV.__AM_ANALYZER_FILE_WRITERS or {}
    local writers = ENV.__AM_ANALYZER_FILE_WRITERS
    if writers[path] then return false, "STORAGE WRITE BUSY" end
    local owner = {}
    writers[path] = owner
    local function save()
        local _, status = loadJSON(path)
        if status == "ERROR" then return false, Runtime.storageErrors[path] end
        if not Runtime.savedJSONValid(path, data) then return false, "INVALID SAVE SCHEMA" end
        local previous = Runtime.fileLastGood[path]
        local initialMain = isfile(path) and readfile(path) or nil
        if type(writefile) ~= "function" then error("WRITEFILE UNAVAILABLE") end
        local encoded = HttpService:JSONEncode(data)
        if type(encoded) ~= "string" then error("JSON ENCODING FAILED") end
        local function verify(candidate, wanted)
            local actual = readfile(candidate)
            if actual ~= wanted or not Runtime.savedJSONValid(path,HttpService:JSONDecode(actual)) then
                error("WRITE VERIFICATION FAILED")
            end
        end
        local function mainUnchanged()
            return (isfile(path) and readfile(path) or nil) == initialMain
        end
        writefile(path .. ".tmp", encoded)
        verify(path .. ".tmp", encoded)
        if not mainUnchanged() then return false, "STORAGE WRITE CONFLICT" end
        if previous ~= nil then
            local backupOK, backup = pcall(readfile,path .. ".bak")
            if not backupOK or backup ~= previous then writefile(path .. ".bak",previous) end
            verify(path .. ".bak",previous)
        end
        if not mainUnchanged() then return false, "STORAGE WRITE CONFLICT" end
        writefile(path,encoded)
        verify(path,encoded)
        Runtime.fileLastGood[path] = encoded
        return true
    end
    local called, ok, err = pcall(save)
    if writers[path] == owner then writers[path] = nil end
    if not called then err,ok=ok,false end
    -- Never roll main back: a different process may have committed after us.
    -- Preserve the checked backup/staging for recovery from partial writes.
    local message = not ok and tostring(err or "SAVE FAILED"):sub(1,180) or nil
    Runtime.storageIssue(path,message,"write")
    if ok then Runtime.storageIssue(path,nil,"read") end
    return ok,message
end

function Runtime.applySavedSettings(saved, preserveLocal)
    if type(saved) ~= "table" then return end
    for key,value in pairs(saved) do
        local default = Runtime.settingsDefaults[key]
        if not preserveLocal or Runtime.settingsLocalOverrides[key] == nil then
            if type(default) == "number" then
                local parsed = num(value)
                if parsed then Settings[key]=Runtime.numberValue(key,parsed) end
            elseif type(default) == "boolean" then
                if type(value)=="boolean" then Settings[key]=value
                elseif value=="true" then Settings[key]=true
                elseif value=="false" then Settings[key]=false end
            elseif type(default)=="string" and type(value)=="string" then Settings[key]=value end
        end
    end
end

do

    local saved = nil
    local status,origin
    saved, status, origin = loadJSON(SETTINGS_FILE)
    Runtime.settingsNeedMigration = origin == "LEGACY"
    Runtime.settingsReadFailed = status == "ERROR"
    Runtime.applySavedSettings(saved)
end

function Runtime.normalizeSettings()
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


end
Runtime.normalizeSettings()
Runtime.settingsBaseline()

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

    Runtime.captureSettingsEdits()
    local ok, err = saveJSON(SETTINGS_FILE, Settings)
    if ok then Runtime.settingsBaseline() end
    return ok, err
end
if Runtime.settingsNeedMigration and not Runtime.settingsReadFailed then saveSettings() end


--============================================================
-- FIRST SEEN DATABASE
--============================================================

function Runtime.policySignature()
    local keys = {
        "allowedItems", "minValueMode", "allMinItemValue", "myMinItemValue", "theirMinItemValue",
        "itemMinimumWinPercent", "newItemHours", "blockEstimated", "allowEstimatedOwnPets",
        "excludeUnwantedIncomingNoPotion", "minProfitPercent", "maxOurItems", "optimizerBeam", "ownPotionsOnly",
    }
    local values = {}
    for _, key in ipairs(keys) do values[#values + 1] = key .. "=" .. tostring(Settings[key]) end
    return table.concat(values, "|")
end

function Runtime.disableAutomation()
    Runtime.settingsLocalOverrides.autoTrade = false
    Runtime.potionAddonPlan = nil
    AutoTradeGeneration += 1
    if Runtime.flow then Runtime.flow.stop("Auto Trade disabled") end
    local state = Runtime.state
    if state then
        state.requestSendingAt, state.requestUncertainUntil, state.target, state.requestStarted = nil, nil, nil, nil
        state.chatAskAttempts, state.askSent = nil, nil
        state.optimizedSignature, state.acceptReadySignature, state.acceptReadySince = nil, nil, nil
        state.policySignature, state.optimizedOurSignature, state.confirmPending = nil, nil, nil
    end
    if Runtime.requestStopAcceptance then Runtime.requestStopAcceptance() end
end


Runtime.fileSchemas[FIRST_SEEN_FILE] = function(data)
    return type(data.items) == "table" and type(data.initialized) == "boolean"
end
local FirstSeen = nil
do
    local status
    local origin
    FirstSeen, status, origin = loadJSON(FIRST_SEEN_FILE)
    Runtime.firstSeenDirty = origin ~= nil
    Runtime.firstSeenReadFailed = status == "ERROR"
    Runtime.firstSeenDurable = status == "READ"
end
if type(FirstSeen) ~= "table" then
    FirstSeen = {initialized = Runtime.firstSeenReadFailed, items = {}}
end

if type(FirstSeen.items) ~= "table" then
    FirstSeen.items, FirstSeen.initialized = {}, true
    Runtime.firstSeenReadFailed = true
    Runtime.fileReadBlocked[FIRST_SEEN_FILE] = true
    Runtime.storageIssue(FIRST_SEEN_FILE, "INVALID HISTORY SCHEMA")
end

function Runtime.configurationReady()
    if not Runtime.settingsReadFailed and not Runtime.fileReadBlocked[SETTINGS_FILE] then return true end
    if os.clock() < (Runtime.settingsRecoveryAt or 0) then return false end
    Runtime.settingsRecoveryAt = os.clock()+3
    Runtime.captureSettingsEdits()
    -- Recovery never silently starts automation from a temporary OFF state.
    if Settings.autoTrade == false then Runtime.settingsLocalOverrides.autoTrade = false end
    local saved,status=loadJSON(SETTINGS_FILE)
    if status ~= "READ" then Runtime.settingsReadFailed=true return false end
    Runtime.applySavedSettings(saved,true)
    Runtime.normalizeSettings()
    Runtime.applySavedSettings(Runtime.settingsLocalOverrides,false)
    Runtime.settingsReadFailed=false
    Runtime.settingsBaseline()
    AutoTradeGeneration += 1
    Runtime.newPolicyEpoch=(Runtime.newPolicyEpoch or 0)+1
    Runtime.nextNewExpiry,Runtime.inventorySignatureAt=nil,nil
    if Runtime.state then Runtime.state.optimizedSignature=nil end
    Runtime.refreshSettingsUI()
    return true
end

function Runtime.storageReady(forHistoryUpdate)
    if not Runtime.configurationReady() then return false end
    if Runtime.firstSeenReadFailed or Runtime.fileReadBlocked[FIRST_SEEN_FILE] then
        if os.clock() < (Runtime.savedRecoveryAt or 0) then return false end
        Runtime.savedRecoveryAt=os.clock()+3
        local saved,status=loadJSON(FIRST_SEEN_FILE)
        if status ~= "READ" then Runtime.firstSeenReadFailed=true return false end
        FirstSeen=saved
        Runtime.firstSeenReadFailed=false
        Runtime.firstSeenDurable=true
        Runtime.newPolicyEpoch=(Runtime.newPolicyEpoch or 0)+1
        Runtime.nextNewExpiry=nil
    end
    return forHistoryUpdate == true or (num(Settings.newItemHours) or 24)<=0 or Runtime.firstSeenDurable ~= false
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


function Runtime.firstSeenTimestamp(value, now)
    if type(value) ~= "number" or not num(value) or value < 0 or value > now + 60 then return nil end
    return value > now and now or value
end

function Runtime.repairFirstSeen(id, value)
    FirstSeen.items[id] = value
    Runtime.firstSeenDirty = true
    Runtime.newPolicyEpoch = (Runtime.newPolicyEpoch or 0) + 1
    Runtime.nextNewExpiry = nil
end

local function updateFirstSeen()

    if not Runtime.storageReady(true) then return end
    if not AMVGG.ready then
        return
    end

    local baseline =
        FirstSeen.initialized
        ~= true

    local now =
        os.time()

    local changed = false
    for id, value in pairs(FirstSeen.items) do
        local valid = Runtime.firstSeenTimestamp(value, now)
        if valid == nil or valid ~= value then
            Runtime.repairFirstSeen(id, valid or now)
            changed = true
        end
    end

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

    if changed then Runtime.firstSeenDirty = true end
    if Runtime.firstSeenDirty then
        local saved = saveJSON(FIRST_SEEN_FILE, FirstSeen)
        Runtime.firstSeenDurable = saved
        Runtime.firstSeenDirty = not saved
        -- Keep the current session's NEW restrictions even when storage fails.
    end
end


function Runtime.newPolicySignature()
    local now = os.time()
    if Runtime.nextNewExpiry and now >= Runtime.nextNewExpiry then
        Runtime.newPolicyEpoch = (Runtime.newPolicyEpoch or 0) + 1
        Runtime.nextNewExpiry = nil
    end
    return Runtime.newPolicyEpoch or 0
end

local function isNewEntry(source, entry)
    Runtime.newPolicySignature()
    if type(entry) ~= "table" or not source then return false, 0 end
    if (num(Settings.newItemHours) or 24) <= 0 then return false, 0 end
    if Runtime.firstSeenReadFailed or Runtime.fileReadBlocked[FIRST_SEEN_FILE] then return true, 0 end
    local id = entryID(source, normalize(entry.name or ""), entry)
    local now = os.time()
    local stored = FirstSeen.items[id]
    if stored == nil and FirstSeen.initialized ~= true then return false, 0 end
    local seen = Runtime.firstSeenTimestamp(stored, now)
    if seen == nil or seen ~= stored then
        seen = stored == nil and FirstSeen.initialized ~= true and 0 or (seen or now)
        Runtime.repairFirstSeen(id, seen)
    end
    if seen == 0 then return false, 0 end
    local age = now - seen
    local maxAge = (num(Settings.newItemHours) or 24) * 3600
    local active = age >= 0 and age < maxAge
    if active then Runtime.nextNewExpiry = math.min(Runtime.nextNewExpiry or math.huge, seen + maxAge) end
    return active, age
end



--============================================================
-- EFFECTIVE ITEM VALUE
--============================================================

local function effectiveItemValue(item)
    local analysis = analyzeItem(item)

    local entry, source = analysis.entry, analysis.source

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

function Runtime.playerID(value)
    local id
    if typeof(value) == "Instance" then
        local ok, result = pcall(function() return value.UserId end)
        if ok then id = result end
    elseif type(value) == "table" then
        id = value.UserId or value.userId or value.user_id or value.id
    elseif type(value) == "number" or type(value) == "string" then
        id = value
    end
    id = num(id)
    if id and id > 0 and id % 1 == 0 then return id end
end

local function playerName(value)
    if typeof(value) == "Instance" then return tostring(value.Name) end
    if type(value) == "table" then
        return tostring(value.Name or value.name or value.username or value.player_name or Runtime.playerID(value) or "Unknown")
    end
    return tostring(value or "Unknown")
end

local function isMe(value)
    if value == LocalPlayer then return true end
    local id = Runtime.playerID(value)
    if id then return id == LocalPlayer.UserId end
    if type(value) == "table" and (value.UserId ~= nil or value.userId ~= nil or value.user_id ~= nil or value.id ~= nil) then return false end
    return playerName(value):lower() == LocalPlayer.Name:lower()
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
    local failed=false
    for _,key in ipairs({"trade","trading"}) do
        local ok,trade=pcall(function() return ClientData.get(key) end)
        if ok and type(trade)=="table" and (trade.sender or trade.recipient or trade.sender_offer or trade.recipient_offer) then
            Runtime.lastTradeReadStatus,Runtime.lastTrustedTrade="FOUND",trade
            return trade,"FOUND"
        end
        if not ok or (trade ~= nil and trade ~= false) then failed=true end
    end
    local status=failed and "ERROR" or "ABSENT"
    Runtime.lastTradeReadStatus=status
    if status=="ABSENT" then Runtime.lastTrustedTrade=nil end
    return nil,status
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


function Runtime.instanceUID(item)
    if type(item) ~= "table" then return nil end
    local uid = item.unique or item.uid
    if type(uid) == "string" and uid ~= "" then return uid end
    if type(uid) == "number" and num(uid) and uid >= 0 then return tostring(uid) end
    return nil
end

local function itemSignature(item)
    if type(item) ~= "table" then return "INVALID ITEM" end
    return string.format("%q:%q:%q:%q", tostring(itemUID(item) or "?"),
        tostring(item.kind), tostring(item.category), tostring(getVariant(item)))
end

function Runtime.itemValuationSignature(item)
    if type(item) ~= "table" then return "INVALID ITEM" end
    local values = {itemSignature(item), string.format("%q", getItemName(item))}
    local properties = type(item.properties) == "table" and item.properties or {}
    local db = getItemDB(item)
    for _, source in ipairs({item, properties, type(db) == "table" and db or {}}) do
        for _, field in ipairs({"rarity", "pet_rarity", "petRarity", "rarity_name", "rarityName"}) do
            local value = source[field]
            if type(value) == "table" then value = value.name or value.Name or value.value or value.Value end
            values[#values + 1] = string.format("%q:%q", type(value), tostring(value))
        end
    end
    return table.concat(values, ":")
end

function Runtime.offerValuationSignature(offer)
    local values = {}
    for _, item in pairs(getOfferItems(offer)) do values[#values + 1] = Runtime.itemValuationSignature(item) end
    table.sort(values)
    return table.concat(values, "|")
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
    local id = Runtime.playerID(partner)
    if id then return "id:" .. tostring(id) end
    return "name:" .. playerName(partner):lower()
end

function Runtime.tradeID(trade)
    if type(trade) ~= "table" then return nil end
    local id = trade.trade_id or trade.id
    if type(id) == "string" and id ~= "" then return id end
    if type(id) == "number" and num(id) and id >= 0 then return tostring(id) end
    return nil
end

function Runtime.tradeKey(trade, partner)
    local id = Runtime.tradeID(trade)
    if id == nil then return nil end
    return string.format("%q:%q", id, Runtime.partnerKey(partner))
end

function Runtime.captureTrade(trade)
    local live = getTrade()
    local mine, theirs, _, partner = getTradeSides(live)
    local suppliedMine, suppliedTheirs, _, suppliedPartner = getTradeSides(trade)
    if not mine or not theirs or not suppliedMine or not suppliedTheirs
        or not Runtime.tradeID(live) or not Runtime.tradeID(trade)
        or Runtime.tradeKey(live, partner) ~= Runtime.tradeKey(trade, suppliedPartner)
        or fullSignature(mine, theirs) ~= fullSignature(suppliedMine, suppliedTheirs) then return nil end
    return {
        key = Runtime.tradeKey(live, partner), generation = AutoTradeGeneration, auto = Settings.autoTrade,
        prices = AMVGG.version, policy = Runtime.policySignature(), newPolicy = Runtime.newPolicySignature(),
        mine = offerSignature(mine), theirs = offerSignature(theirs),
        valuationMine = Runtime.offerValuationSignature(mine), valuationTheirs = Runtime.offerValuationSignature(theirs),
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
        if context.valuationTheirs ~= Runtime.offerValuationSignature(theirs) then return nil, "THEIR_METADATA_CHANGED" end
        if checkMine and context.valuationMine ~= Runtime.offerValuationSignature(mine) then return nil, "OUR_METADATA_CHANGED" end
        if AMVGG.dataStale or AMVGG.loading or not AMVGG.ready then return nil, "PRICES_UNAVAILABLE" end
        if AMVGG.version ~= context.prices then return nil, "PRICES_CHANGED" end
        if Runtime.newPolicySignature() ~= context.newPolicy then return nil, "NEW_POLICY_CHANGED" end
        if Runtime.policySignature() ~= context.policy then return nil, "POLICY_CHANGED" end
    end
    return live, nil, mine, theirs
end

function Runtime.optimizationKey(theirOffer)
    return Runtime.offerValuationSignature(theirOffer) .. "|AMVGG=" .. tostring(AMVGG.version) .. "|POLICY=" .. Runtime.policySignature()
        .. "|INVENTORY=" .. Runtime.inventorySignature() .. "|NEW=" .. tostring(Runtime.newPolicySignature())
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
    local seenUIDs = {}

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

        local uid = Runtime.instanceUID(item)
        if uid and seenUIDs[uid] then result.integrityError = true continue end
        if uid then seenUIDs[uid] = true end

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
                and Runtime.bypassOwnMinimum(item, data.name)

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

            if num(data.value) == nil or data.value < 0 or num(result.total + data.value) == nil then
                result.numericError = true
                return
            end
            result.total += data.value

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
            if num(row.effectiveValue) == nil or row.effectiveValue < 0
                or num(result.effectiveTotal + row.effectiveValue) == nil then
                result.numericError = true
                return
            end
            result.effectiveTotal += row.effectiveValue
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

    mine, theirs = num(mine), num(theirs)
    if not mine or not theirs or num(theirs - mine) == nil then return nil end
    return num(((theirs - mine) / mine) * 100)
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

        if direct and Runtime.remoteEndpointUsable(direct) then
            return direct
        end

        for _,
            object in ipairs(
                API:GetDescendants()
            )
        do

            if
                object.Name == name
                and Runtime.remoteEndpointUsable(object)
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

    if ok and result and Runtime.remoteEndpointUsable(result) then
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

    if ok2 and Runtime.remoteEndpointUsable(result2) then
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

        if remote and Runtime.remoteEndpointUsable(remote) then

            return
                remote,
                name
        end

        remote =
            routerGet(
                name
            )

        if remote and Runtime.remoteEndpointUsable(remote) then

            return
                remote,
                name
        end
    end

    return nil
end


local TradeRemote = {}
Runtime.tradeRemoteNames = {
    SendRequest = {"TradeAPI/SendTradeRequest", "TradeAPI/BeginTrade", "TradeAPI/RequestTrade"},
    Add = {"TradeAPI/AddItemToOffer", "TradeAPI/AddItem"},
    Remove = {"TradeAPI/RemoveItemFromOffer", "TradeAPI/RemoveItem"},
    Accept = {"TradeAPI/AcceptNegotiation", "TradeAPI/AcceptTrade"},
    Unaccept = {"TradeAPI/UnacceptNegotiation", "TradeAPI/UnacceptTrade"},
    Confirm = {"TradeAPI/ConfirmTrade"},
    Decline = {"TradeAPI/DeclineTrade", "TradeAPI/CancelTrade"},
    QuickChat = {"TradeAPI/SendQuickChat"},
}
Runtime.tradeRemoteRetryAt = {}
function Runtime.remoteEndpointUsable(remote)
    if typeof(remote) == "Instance" then
        local ok, usable = pcall(function()
            return remote.Parent ~= nil and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction"))
        end)
        return ok and usable == true
    end
    if type(remote) == "function" then return true end
    if type(remote) ~= "table" or rawget(remote, "Destroyed") == true or rawget(remote, "Alive") == false then return false end
    local fireOK, fire = pcall(function() return remote.FireServer end)
    local invokeOK, invoke = pcall(function() return remote.InvokeServer end)
    return (fireOK and type(fire) == "function") or (invokeOK and type(invoke) == "function")
end
function Runtime.invalidateTradeRemote(remote)
    for operation in pairs(Runtime.tradeRemoteNames) do
        if rawget(TradeRemote, operation) == remote then
            rawset(TradeRemote, operation, nil)
            rawset(TradeRemote, operation .. "Name", nil)
            Runtime.tradeRemoteRetryAt[operation] = nil
        end
    end
end
function Runtime.staleRemoteFailure(remote, message)
    if not Runtime.remoteEndpointUsable(remote) then return true end
    message = tostring(message):lower()
    for _, marker in ipairs({"destroyed", "not a valid member", "no longer exists", "unsupported remote", "endpoint disconnected"}) do
        if message:find(marker, 1, true) then return true end
    end
    return false
end
function Runtime.resolveTradeRemote(operation)
    local names = Runtime.tradeRemoteNames[operation]
    if not names then return nil end
    local existing = rawget(TradeRemote, operation)
    if existing and Runtime.remoteEndpointUsable(existing) then return existing end
    if existing then Runtime.invalidateTradeRemote(existing) end
    local now = os.clock()
    if now < (Runtime.tradeRemoteRetryAt[operation] or 0) then return nil end
    Runtime.tradeRemoteRetryAt[operation] = now + 1
    local remote, name = resolveRemote(names)
    if remote and Runtime.remoteEndpointUsable(remote) then
        rawset(TradeRemote, operation, remote)
        rawset(TradeRemote, operation .. "Name", name)
        Runtime.tradeRemoteRetryAt[operation] = nil
    end
    return remote and Runtime.remoteEndpointUsable(remote) and remote or nil
end
setmetatable(TradeRemote, {__index = function(_, key)
    if Runtime.tradeRemoteNames[key] then return Runtime.resolveTradeRemote(key) end
end})
for operation in pairs(Runtime.tradeRemoteNames) do Runtime.resolveTradeRemote(operation) end


local function remoteCall(remote, ...)
    return Runtime.invokeRemote(remote, nil, ...)
end

function Runtime.invokeRemote(remote, expected, ...)
    if not remote then return false, "REMOTE MISSING" end
    if Runtime.remoteEndpointUsable and not Runtime.remoteEndpointUsable(remote) then
        Runtime.invalidateTradeRemote(remote)
        return false, "REMOTE ENDPOINT UNAVAILABLE"
    end
    local function expectedCurrent()
        if not expected then return true end
        if not Settings.autoTrade or expected.context.auto ~= true then return false end
        if expected.prices ~= false and not Runtime.storageReady() then return false end
        local live, _, mine = Runtime.liveContext(expected.context, expected.mine ~= false, expected.prices ~= false)
        if not live then return false end
        if expected.confirmation ~= nil and Runtime.tradeInConfirmation(live) ~= expected.confirmation then return false end
        return not expected.proof or Runtime.ownProofCurrent(expected.proof, mine)
    end
    if not expectedCurrent() then return false, "REMOTE CANCELLED" end
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
        if not expectedCurrent() then operation.done=true operation.result=table.pack(false,"REMOTE CANCELLED") return end
        if expected and expected.acceptRecord then expected.acceptRecord.started=true end
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
        if result[1] == false and Runtime.staleRemoteFailure and Runtime.staleRemoteFailure(remote, result[2]) then
            -- Clear only known stale endpoints. TIMEOUT/BUSY/CANCELLED keep their
            -- uncertainty quarantine and must never cause an automatic resend.
            Runtime.invalidateTradeRemote(remote)
        end
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
        if not Runtime.alive() or generation ~= AutoTradeGeneration or not expectedCurrent() then return false end
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


function Runtime.yieldInventoryWork(index, context, prices, generation)
    if index % 64 ~= 0 then return true end
    Runtime.task.wait()
    return Runtime.alive() and prices == AMVGG.version and generation == AutoTradeGeneration
        and (not context or Runtime.liveContext(context, true, true) ~= nil)
end

local function inventoryItems()
    local operation = getTrade() and Runtime.captureTrade(getTrade())
    local prices, generation, scanned = AMVGG.version, AutoTradeGeneration, 0

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
                scanned += 1
                if not Runtime.yieldInventoryWork(scanned, operation, prices, generation) then return {} end

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

function Runtime.ownOfferProof(context, mine)
    local wanted, proof = {}, {entries={}}
    for _, item in pairs(getOfferItems(mine)) do
        local uid = Runtime.instanceUID(item)
        if not uid or wanted[uid] or itemLocked(item) then return nil end
        wanted[uid] = itemSignature(item)
    end
    local inventory, scanned = getInventory(), 0
    if type(inventory) ~= "table" then return nil end
    for category, bucket in pairs(inventory) do
        if type(bucket) == "table" then
            for key, raw in pairs(bucket) do
                scanned += 1
                if type(raw) == "table" then
                    local item = shallowCopy(raw)
                    item.category, item.unique = item.category or category, item.unique or item.uid or key
                    local uid = Runtime.instanceUID(item)
                    if uid and wanted[uid] then
                        if proof.entries[uid] or itemLocked(item) or itemSignature(item) ~= wanted[uid] then return nil end
                        proof.entries[uid] = {category=category, key=key, signature=wanted[uid]}
                    end
                end
                if scanned % 64 == 0 then
                    Runtime.task.wait()
                    if not Runtime.liveContext(context, true, true) then return nil end
                end
            end
        end
    end
    for uid in pairs(wanted) do if not proof.entries[uid] then return nil end end
    if not Runtime.liveContext(context, true, true) or not Runtime.ownProofCurrent(proof, mine) then return nil end
    return proof
end

function Runtime.ownProofCurrent(proof, mine)
    local inventory = getInventory()
    if type(inventory) ~= "table" then return false end
    local count = 0
    for _, offered in pairs(getOfferItems(mine)) do
        local uid = Runtime.instanceUID(offered)
        local entry = uid and proof.entries[uid]
        local bucket = entry and inventory[entry.category]
        local raw = type(bucket) == "table" and bucket[entry.key]
        if type(raw) ~= "table" or itemLocked(offered) then return false end
        local item = shallowCopy(raw)
        item.category, item.unique = item.category or entry.category, item.unique or item.uid or entry.key
        if itemLocked(item) or itemSignature(item) ~= entry.signature or itemSignature(offered) ~= entry.signature then return false end
        count += 1
    end
    local total = 0 for _ in pairs(proof.entries) do total += 1 end
    return count == total
end

function Runtime.inventorySignature()
    local signatures = {}
    for _, item in ipairs(inventoryItems()) do
        signatures[#signatures + 1] = Runtime.itemValuationSignature(item)
    end
    table.sort(signatures)
    Runtime.inventorySignatureAt, Runtime.inventorySignatureValue = os.clock(), table.concat(signatures, "|")
    return Runtime.inventorySignatureValue
end

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


function Runtime.isTradePotion(name)
    local key = normalize(name)
    return key == normalize("Ride-A-Pet Potion") or key == normalize("Fly-A-Pet Potion")
end

function Runtime.bypassOwnMinimum(item, name)
    return CommonPetFilter.shouldBypassOurMinimum(item)
        or (Settings.ownPotionsOnly == true and Runtime.isTradePotion(name or getItemName(item)))
end

function Runtime.potionItemKey(item)
    return tostring(itemUID(item)) .. ":" .. tostring(item.kind) .. ":" .. tostring(item.category) .. ":" .. getVariant(item)
end

function Runtime.potionAddonAllowed(item)
    local plan = Runtime.potionAddonPlan
    if not item or not plan or Settings.ownPotionsOnly ~= true then return false end
    if not Runtime.liveContext(plan.context, false, true) then return false end
    return plan.addons[tostring(itemUID(item))] == Runtime.potionItemKey(item)
end

function Runtime.potionBasePresent(offer)
    local plan = Runtime.potionAddonPlan
    if not plan or not Runtime.liveContext(plan.context, false, true) then return false end
    local present = {}
    for _, item in pairs(getOfferItems(offer)) do present[tostring(itemUID(item))] = Runtime.potionItemKey(item) end
    local count = 0
    for uid, signature in pairs(plan.base) do
        count += 1
        if present[uid] ~= signature then return false end
    end
    return count > 0
end

local function isAllowed(name, item, selectingAddons)

    if Settings.ownPotionsOnly == true and not Runtime.isTradePotion(name)
        and selectingAddons ~= true and not Runtime.potionAddonAllowed(item) then
        return false
    end

    if HARD_BLOCKED_ITEMS[normalize(name)] then
        return false
    end

    -- This dedicated mode explicitly enables both real potions even when
    -- the normal pet allow-list is populated. Filler items still use that list.
    if Settings.ownPotionsOnly == true and Runtime.isTradePotion(name) then return true end

    local allowed =
        parseAllowed()

    if next(allowed) == nil then
        return tostring(Settings.allowedItems or ""):match("^%s*$") ~= nil
    end

    return

        allowed[
            normalize(
                name
            )
        ]
        == true
end


local function valuedInventory(selectingAddons)
    local operation = getTrade() and Runtime.captureTrade(getTrade())
    local prices, generation, scanned = AMVGG.version, AutoTradeGeneration, 0

    local result =
        {}

    for _,
        item in ipairs(
            inventoryItems()
        )
    do
        scanned += 1
        if not Runtime.yieldInventoryWork(scanned, operation, prices, generation) then return {} end

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
                or Runtime.bypassOwnMinimum(item, data.name)
            )
            -- AUTO TRADE must never build an offer from guessed pet values.
            -- Estimated values may still be displayed outside AUTO TRADE,
            -- but the optimizer only receives exact AMVGG variants.
            and not (
                Settings.autoTrade
                and data.estimated
            )
            and DemandPolicy.ownAnalysisReason(data.analysis) == nil

            and isAllowed(data.name, item, selectingAddons)
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
    theirEffectiveTotal, suppliedCandidates, suppliedSlots
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

    local all = suppliedCandidates or valuedInventory()

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

    local maxItems = math.clamp(math.floor(tonumber(suppliedSlots or Settings.maxOurItems) or 18), 1, 18)

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

        for order, state in ipairs(expanded) do
            state.sortOrder = order
            state.sortValue = state.total <= 1000000 and math.floor(state.total * 1e9 + .5) / 1e9 or state.total
        end
        table.sort(expanded, function(a, b)
            if a.sortValue ~= b.sortValue then return a.sortValue > b.sortValue end
            if (a.petCount or 0) ~= (b.petCount or 0) then return (a.petCount or 0) > (b.petCount or 0) end
            return a.sortOrder < b.sortOrder
        end)

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

function Runtime.optimizeOwnOffer(cap)
    Runtime.potionAddonPlan = nil
    if not Settings.ownPotionsOnly then return optimizeOurOffer(cap) end
    local context = Runtime.captureTrade(getTrade())
    if not Runtime.liveContext(context, true, true) then return {}, 0, cap, "TRADE_CHANGED" end
    local potions = {}
    for _, candidate in ipairs(valuedInventory()) do
        if Runtime.isTradePotion(candidate.name) then potions[#potions + 1] = candidate end
    end
    -- Potion selection always comes first. Never replace a potion with a pet.
    local base, total, _, failure = optimizeOurOffer(cap, potions)
    if failure or not Runtime.liveContext(context, true, true) then return {}, 0, cap, failure or "TRADE_CHANGED" end
    if #base == 0 then return base, total, cap end
    local slots = math.clamp(math.floor(tonumber(Settings.maxOurItems) or 18), 1, 18) - #base
    local remaining = cap - total
    if slots <= 0 or remaining <= 0.000000001 then return base, total, cap end
    local used = {}
    for _, candidate in ipairs(base) do used[candidate.uid] = true end
    for _, candidate in ipairs(potions) do
        if not used[candidate.uid] and candidate.value <= remaining + 0.000000001 then
            -- If the bounded search left a potion that still fits, no pet fallback.
            return base, total, cap
        end
    end
    local fillers = {}
    for _, candidate in ipairs(valuedInventory(true)) do
        if not Runtime.isTradePotion(candidate.name) then fillers[#fillers + 1] = candidate end
    end
    local adds, addValue, _, addFailure = optimizeOurOffer(remaining, fillers, slots)
    if addFailure or not Runtime.liveContext(context, true, true) then return {}, 0, cap, addFailure or "TRADE_CHANGED" end
    if #adds == 0 then return base, total, cap end
    local plan = {context=context, base={}, addons={}}
    for _, candidate in ipairs(base) do plan.base[candidate.uid] = Runtime.potionItemKey(candidate.item) end
    for _, candidate in ipairs(adds) do
        plan.addons[candidate.uid] = Runtime.potionItemKey(candidate.item)
        base[#base + 1] = candidate
    end
    Runtime.potionAddonPlan = plan
    return base, total + addValue, cap
end


function Runtime.potionWaitingOffer()
    local cheapest
    for _, candidate in ipairs(valuedInventory()) do
        if Runtime.isTradePotion(candidate.name) and (not cheapest or candidate.value < cheapest.value) then
            cheapest = candidate
        end
    end
    if cheapest then return {cheapest}, cheapest.value end
    return {}, 0
end

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
            if not isAllowed(data.name, item) then return false, "OUR ITEM NOT ALLOWED" end
            if Settings.ownPotionsOnly and not Runtime.isTradePotion(data.name) then
                local mine = getTradeSides(getTrade())
                if not Runtime.potionBasePresent(mine) then return false, "POTION BASE MISSING" end
            end
            if not data.known or data.newIgnored or data.estimated or data.value <= 0 then return false, "EXACT SAFE VALUE REQUIRED" end
            if data.value < activeMinItemValue("mine") and not Runtime.bypassOwnMinimum(item, data.name) then return false, "OUR ITEM < MIN VALUE" end
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
    local partnerKey = Runtime.partnerKey

    local initial = getTrade()
    local initialMine, initialTheirs, _, initialPartner = getTradeSides(initial)
    if not initialMine or not initialTheirs or not initialPartner then
        return false, "TRADE_CHANGED"
    end
    local initialID = Runtime.tradeID(initial)
    if not initialID then return false, "MISSING_TRADE_ID" end
    local initialPartnerKey = partnerKey(initialPartner)
    local initialGeneration = AutoTradeGeneration
    local initialPrices, initialPolicy = AMVGG.version, Runtime.policySignature()
    local initialNewPolicy = Runtime.newPolicySignature()

    -- Check the operation's trade context after every yield, including remote
    -- replies. An identical incoming offer in another trade is not this build.
    local function contextReason()
        if not Settings.autoTrade or initialGeneration ~= AutoTradeGeneration then
            return "AUTO_DISABLED"
        end
        if not Gui.Parent or not Runtime.alive() then return "GUI_CLOSED" end
        if AMVGG.loading or AMVGG.dataStale or not AMVGG.ready then return "PRICES_UNAVAILABLE" end
        if AMVGG.version ~= initialPrices then return "PRICES_CHANGED" end
        if Runtime.newPolicySignature() ~= initialNewPolicy then return "NEW_POLICY_CHANGED" end
        if Runtime.policySignature() ~= initialPolicy then return "POLICY_CHANGED" end
        local live = getTrade()
        local mine, theirs, _, partner = getTradeSides(live)
        if not mine or not theirs or not partner
            or Runtime.tradeID(live) ~= initialID
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
    for _, candidate in ipairs(desired) do
        if not isAllowed(effectiveItemValue(candidate.item).name, candidate.item) then return false, "OUR ITEM NOT ALLOWED" end
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

local function sendChat(text, expectedContext)
    if not Settings.autoTrade or not Settings.chatRequests or not Runtime.alive() then return false, "CHAT CANCELLED" end
    local generation = AutoTradeGeneration
    local context = expectedContext or (getTrade() and Runtime.captureTrade(getTrade()))
    local function current()
        return Runtime.alive() and Settings.autoTrade and Settings.chatRequests
            and AutoTradeGeneration == generation and (not context or Runtime.liveContext(context, false, false) ~= nil)
    end
    if not current() then return false, "CHAT CANCELLED" end
    local ok, message = Runtime.runBounded(function()
        local channels = TextChatService:FindFirstChild("TextChannels")
        local general = channels and channels:FindFirstChild("RBXGeneral")
        if not general or not current() then return nil end
        return general:SendAsync(text)
    end, 3, current)
    if not ok then Runtime.lastChatError = tostring(message) return false, Runtime.lastChatError end
    if not current() then return false, "CHAT CANCELLED" end
    local function deliveryStatus()
        local ok,status=pcall(function() return message and message.Status end)
        return ok and status or nil
    end
    local status=deliveryStatus()
    local function pending(value)
        local name=tostring(value):match("([^%.]+)$")
        return name=="Sending" or name=="Unknown" or name=="ModerationTimeout"
    end
    if pending(status) then
        local deadline=os.clock()+3
        for _=1,61 do
            if not current() then return false,"CHAT CANCELLED" end
            status=deliveryStatus()
            if not pending(status) then break end
            if os.clock()>=deadline then break end
            Runtime.task.wait(.05)
        end
    end
    if status==Enum.TextChatMessageStatus.Success then Runtime.lastChatError=nil return true end
    if pending(status) or (message~=nil and status==nil) then
        Runtime.lastChatError="CHAT DELIVERY UNCERTAIN: " .. tostring(status)
    else Runtime.lastChatError=tostring(status or "CHAT UNAVAILABLE") end
    return false,Runtime.lastChatError
end

--============================================================
-- GUI MAIN
--============================================================

setBoot(
    "3/9",
    "BUILDING GUI"
)


if not Runtime.alive() then return end
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
local dragInput


Runtime.connect(Top.InputBegan,
    function(input)
        if dragging then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragInput, dragging = input, true

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

        if not dragInput then return end
        if dragInput.UserInputType == Enum.UserInputType.Touch then
            if input ~= dragInput then return end
        elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

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

        if input == dragInput then dragging, dragInput = false, nil end
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

                local value
                if source == "pets" then value = getPetValue(entry, "NP")
                else value = genericValue(entry) end

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
            .. (row.source == "pets" and " • NP" or "")
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

    local storage = Runtime.storageNotice()
    if storage then lines[#lines + 1] = storage end
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
Runtime.registerSettingsUI(renderModes)


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

local function settingInput(title,value,y)
    local caption=label(TestCanvas,title,UDim2.new(.58,-18,0,30),UDim2.fromOffset(12,y),Enum.Font.GothamBold,10,C.MUTED)
    caption.TextWrapped=true
    return textBox(TestCanvas,value,"",UDim2.new(.42,-18,0,30),UDim2.new(.58,6,0,y))
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

    Runtime.registerSettingsUI(function()
        local ok,focused=pcall(function() return input:IsFocused() end)
        if not ok or not focused then input.Text=tostring(Settings[key]) end
    end)
    Runtime.connect(input.FocusLost,
        function()

            local value =
                num(
                    input.Text
                )

            if not value then

                input.Text =
                    tostring(
                        Settings[key]
                    )

                return
            end

            Settings[key] = Runtime.numberValue(key, value, min, max)

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
Runtime.registerSettingsUI(renderMinValueMode)


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
    "ALLOWED ITEMS • English names; blank = all",

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


Runtime.registerSettingsUI(function()
    local ok,focused=pcall(function() return AllowedInput:IsFocused() end)
    if not ok or not focused then AllowedInput.Text=Settings.allowedItems end
    AllowedInput.TextColor3 = normalize(Settings.allowedItems)=="" and not Settings.allowedItems:match("^%s*$") and C.RED or C.TEXT
end)
Runtime.connect(AllowedInput.FocusLost,
    function()

        Settings.allowedItems =
            AllowedInput.Text

        saveSettings()
        Runtime.refreshSettingsUI()
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
Runtime.registerSettingsUI(renderChat)


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
Runtime.registerSettingsUI(renderUnwantedIncoming)

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

do
    local OwnPotionsToggle = button(TestCanvas, "", UDim2.new(1,-24,0,36), UDim2.fromOffset(10,1564))
    local function renderOwnPotions()
        OwnPotionsToggle.Text = "OUR OFFER: RIDE / FLY FIRST + ADDS: " .. (Settings.ownPotionsOnly and "ON" or "OFF")
        OwnPotionsToggle.BackgroundColor3 = Settings.ownPotionsOnly and Color3.fromRGB(40,105,70) or C.PANEL2
    end
    Runtime.registerSettingsUI(renderOwnPotions)
    Runtime.connect(OwnPotionsToggle.Activated, function()
        Settings.ownPotionsOnly = not Settings.ownPotionsOnly
        saveSettings()
        renderOwnPotions()
        -- policySignature invalidates in-flight selection and acceptance.
        -- Approved fillers only complete a potion base within the demand cap.
    end)
    renderOwnPotions()
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


function PlazaRouter.copyHistory(data)
    if type(data) ~= "table" then return nil end
    local copy = newPlazaDatabase()
    for id, value in pairs(data.Active) do
        copy.Active[id] = type(value) == "table" and shallowCopy(value) or value
    end
    for id, value in pairs(data.Visited) do copy.Visited[id] = value end
    return copy
end

function PlazaRouter.historyError(message, kind)
    PlazaRouter.historyErrors = PlazaRouter.historyErrors or {}
    PlazaRouter.historyErrors[kind or "write"] = message
    if message then PlazaRouter.historyFailureEpoch = (PlazaRouter.historyFailureEpoch or 0) + 1 end
    PlazaRouter.storageError = PlazaRouter.historyErrors.read or PlazaRouter.historyErrors.write
    Runtime.storageIssue(PLAZA_HOP_SETTINGS.SharedFile, PlazaRouter.storageError)
end

local function loadPlazaDatabase()
    local path = PLAZA_HOP_SETTINGS.SharedFile
    Runtime.fileSchemas[path] = function(data)
        return type(data.Active) == "table" and type(data.Visited) == "table"
    end
    local data, status = loadJSON(path)
    if status == "ERROR" then
        PlazaRouter.historyReadFailed = true
        PlazaRouter.historyError("HISTORY READ FAILED: " .. tostring(Runtime.storageErrors[path]):sub(1, 140), "read")
        return PlazaRouter.copyHistory(PlazaRouter.historyCache), "ERROR"
    end
    if status == "MISSING" then data = newPlazaDatabase() end
    PlazaRouter.historyReadFailed = false
    PlazaRouter.historyError(nil, "read")
    PlazaRouter.historyCache = PlazaRouter.copyHistory(data)
    return data, status
end

local function savePlazaDatabase(data)
    if PlazaRouter.historyReadFailed then return false end
    local path = PLAZA_HOP_SETTINGS.SharedFile
    Runtime.fileSchemas[path] = function(value)
        return type(value.Active) == "table" and type(value.Visited) == "table"
    end
    local ok, err = saveJSON(path, data)
    PlazaRouter.historyError(ok and nil or err, "write")
    if ok then PlazaRouter.historyCache = PlazaRouter.copyHistory(data) end
    return ok
end

local function cleanPlazaDatabase(data)
    local now = os.time()
    for jobId, info in pairs(data.Active) do
        local timestamp = num(type(info) == "table" and info.Time or info)
        if not timestamp or timestamp < 0 or timestamp > now + 60
            or now - timestamp > PLAZA_HOP_SETTINGS.ActiveServerTimeout then data.Active[jobId] = nil end
    end
    for jobId, value in pairs(data.Visited) do
        local timestamp = num(value)
        if not timestamp or timestamp < 0 or timestamp > now + 60
            or now - timestamp > PLAZA_HOP_SETTINGS.RecentServerMemory then data.Visited[jobId] = nil end
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

    local data, loadStatus = loadPlazaDatabase()
    if not data or loadStatus == "ERROR" then return false end

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

    local data, loadStatus = loadPlazaDatabase()
    if not data or loadStatus == "ERROR" then return false end

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


function PlazaRouter.operationCurrent(generation)
    return Runtime.alive() and Gui.Parent ~= nil and Runtime.configurationReady() and Settings.plazaAutoRoute
        and (generation == nil or generation == (PlazaRouter.operationGeneration or 0))
end

local function decodeHTTPJSON(url, budgetDeadline)
    local generation = PlazaRouter.operationGeneration or 0
    local function current() return PlazaRouter.operationCurrent(generation) end
    local timeout = math.min(8, math.min(PlazaRouter.operationDeadline or (os.clock()+8.2), budgetDeadline or (os.clock()+8.2)) - os.clock() - .2)
    if timeout <= .05 or not current() then return nil end
    local ok, body = Runtime.runBounded(function()
        if type(REQUEST) == "function" then
            local requested, response = pcall(REQUEST, {
                Url=url, URL=url, Method="GET",
                Headers={Accept="application/json", ["Cache-Control"]="no-cache", ["User-Agent"]="Mozilla/5.0"},
            })
            if not current() then return nil end
            if requested then
                if type(response) == "string" then return response end
                if type(response) == "table" then
                    local status = tonumber(response.StatusCode or response.Status or response.status_code) or 200
                    if status < 200 or status >= 400 then return nil end
                    local data = response.Body or response.body
                    if type(data) == "string" then return data end
                end
            end
        end
        if not current() then return nil end
        return game:HttpGet(url, true)
    end, timeout, current)
    if not ok or not current() or type(body) ~= "string" then return nil end
    local decodedOK, decoded = pcall(function() return HttpService:JSONDecode(body) end)
    if decodedOK and current() and type(decoded) == "table" then return decoded end
end


local function getUniversePlacesForPlaza()
    local universeId = tonumber(game.GameId)
    if not universeId or universeId <= 0 then return {} end
    local generation = PlazaRouter.operationGeneration or 0
    local deadline = math.min(PlazaRouter.operationDeadline or (os.clock() + 10), os.clock() + 10)
    local urls = {
        "https://develop.roblox.com/v1/universes/" .. tostring(universeId) .. "/places?limit=100&sortOrder=Asc",
        "https://apis.roblox.com/universes/v1/universes/" .. tostring(universeId) .. "/places?limit=100&sortOrder=Asc",
    }
    local function current()
        return Runtime.alive() and os.clock() < deadline
            and generation == (PlazaRouter.operationGeneration or 0)
            and PlazaRouter.operationCurrent(generation)
    end
    for _, base in ipairs(urls) do
        local places, seen, cursors, cursor = {}, {}, {}, nil
        for _ = 1, 10 do
            if not current() then return {} end
            local url = base
            if cursor then
                local encoded = cursor:gsub("[^%w%-_%.~]", function(char) return string.format("%%%02X", char:byte()) end)
                url = base .. "&cursor=" .. encoded
            end
            local decoded = decodeHTTPJSON(url, deadline)
            if not current() then return {} end
            if type(decoded) ~= "table" or type(decoded.data) ~= "table" then break end
            for _, info in ipairs(decoded.data) do
                local id = type(info) == "table" and tonumber(info.id or info.Id)
                if id and id > 0 and not seen[id] then
                    seen[id] = true
                    places[#places + 1] = info
                end
            end
            cursor = decoded.nextPageCursor
            if cursor == nil or cursor == "" then break end
            if type(cursor) ~= "string" or #cursor > 2048 or cursors[cursor] then break end
            cursors[cursor] = true
        end
        if #places > 0 then return places end
    end
    return {}
end

local function getCurrentPlaceName()
    local generation = PlazaRouter.operationGeneration or 0
    local function current() return PlazaRouter.operationCurrent(generation) end
    local ok, info = Runtime.runBounded(function() return MarketplaceService:GetProductInfo(game.PlaceId) end, 5, current)
    if ok and current() and type(info) == "table" then return tostring(info.Name or "") end
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

    -- Use the known Hub after suitable places returned by discovery.
    if not seen[KNOWN_TRADING_HUB_PLACE_ID] then
        seen[KNOWN_TRADING_HUB_PLACE_ID] = true
        result[#result + 1] = {
            Id = KNOWN_TRADING_HUB_PLACE_ID,
            Name = "Trading Hub",
            Score = 1,
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


local function getPlazaServers(placeId,onPage)
    PlazaRouter.serverScans=PlazaRouter.serverScans or {}
    local key=tostring(placeId)
    local previous=PlazaRouter.serverScans[key]
    local cursor=previous and os.clock()<previous.expires and previous.cursor or nil
    local servers,visited={},{}
    local generation=PlazaRouter.operationGeneration or 0
    for _=1,PLAZA_HOP_SETTINGS.MaxPages do
        if not PlazaRouter.operationCurrent(generation)
            or (PlazaRouter.operationDeadline and os.clock()>=PlazaRouter.operationDeadline-.25) then break end
        local marker=cursor or "FIRST"
        if visited[marker] then PlazaRouter.serverScans[key]=nil break end
        visited[marker]=true
        local url="https://games.roblox.com/v1/games/" .. key .. "/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100"
        if cursor and cursor~="" then url ..= "&cursor=" .. HttpService:UrlEncode(cursor) end
        local decoded=decodeHTTPJSON(url)
        if type(decoded)~="table" or not PlazaRouter.operationCurrent(generation) then break end
        local page={}
        for _,server in ipairs(type(decoded.data)=="table" and decoded.data or {}) do
            if type(server)=="table" and server.id then servers[#servers+1],page[#page+1]=server,server end
        end
        local nextCursor=type(decoded.nextPageCursor)=="string" and decoded.nextPageCursor~="" and decoded.nextPageCursor or nil
        -- Advance before returning a selected target: failed reservations or
        -- teleports must not keep scanning the same already examined pages.
        if nextCursor and nextCursor~=cursor and not visited[nextCursor] then
            PlazaRouter.serverScans[key]={cursor=nextCursor,expires=os.clock()+300}
        else PlazaRouter.serverScans[key]=nil end
        if onPage then
            local target=onPage(page)
            if target then return servers,target end
        end
        if not nextCursor or nextCursor==cursor or visited[nextCursor] then break end
        cursor=nextCursor
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
    local generation = PlazaRouter.operationGeneration or 0
    if not PlazaRouter.operationCurrent(generation) or type(serverId) ~= "string" or serverId == "" or not PlazaRouter.ownsServer(serverId) then return false end

    local data, loadStatus = loadPlazaDatabase()
    if not data or loadStatus == "ERROR" then return false end

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

    PlazaRouter.reservations = PlazaRouter.reservations or {}
    local target = {PlaceId=placeId, JobId=serverId,
        reservation=tostring(PlazaRouter.operationGeneration or 0) .. ":" .. tostring(os.clock())}
    data.Active[serverId].Reservation = target.reservation
    -- Register ownership inside the worker before saving or returning its result.
    PlazaRouter.reservations[serverId] = target
    local saved = savePlazaDatabase(data)
    if not saved or not PlazaRouter.operationCurrent(generation) then
        if PlazaRouter.releaseReservation then PlazaRouter.releaseReservation(target) end
        return false
    end
    return true
end


local function findNewPlazaServer(placeId)

    local generation = PlazaRouter.operationGeneration or 0

    local database, loadStatus = loadPlazaDatabase()
    if not database or loadStatus == "ERROR" then return nil end

    cleanPlazaDatabase(
        database
    )

    local function choose(servers)
    if not PlazaRouter.operationCurrent(generation) then return nil end

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
    local _, target = getPlazaServers(placeId, choose)
    return target
end


local function releasePlazaReservation(target)
    if not target or not target.JobId then return end
    local owned = (PlazaRouter.reservations or {})[target.JobId] or target
    local data, loadStatus = loadPlazaDatabase()
    if not data or loadStatus == "ERROR" then return false end
    local info = data.Active[target.JobId]
    if type(info) == "table" and info.Owner == PLAZA_CLONE_ID
        and (not owned.reservation or info.Reservation == owned.reservation) then
        data.Active[target.JobId], data.Visited[target.JobId] = nil, nil
        if not savePlazaDatabase(data) then return false end
    end
    if PlazaRouter.reservations then PlazaRouter.reservations[target.JobId] = nil end
    return true
end
PlazaRouter.releaseReservation = releasePlazaReservation



function PlazaRouter.runOperation(fn)
    PlazaRouter.operationGeneration = (PlazaRouter.operationGeneration or 0) + 1
    local generation = PlazaRouter.operationGeneration
    local function current() return PlazaRouter.operationCurrent(generation) end
    PlazaRouter.operationDeadline = os.clock() + 30
    local ok, result = Runtime.runBounded(fn, 30, current)
    if PlazaRouter.operationGeneration ~= generation then return false, "ROUTER CANCELLED" end
    PlazaRouter.operationGeneration, PlazaRouter.operationDeadline = generation + 1, nil
    if not ok then
        local target = PlazaRouter.preparedTarget
        PlazaRouter.preparedTarget = nil
        releasePlazaReservation(target)
        for _, owned in pairs(table.clone(PlazaRouter.reservations or {})) do releasePlazaReservation(owned) end
        PlazaRouter.preparing, PlazaRouter.readyForTrading, PlazaRouter.clearSince = false, true, nil
        PlazaRouter.retryAt = os.clock() + PLAZA_HOP_SETTINGS.RetrySeconds
    end
    return ok, result
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
    local pendingRequest = state and state.target and state.target.Parent
        and (state.requestSendingAt ~= nil or (state.requestStarted ~= nil
            and os.clock() < (state.requestUncertainUntil or (state.requestStarted + Settings.requestTimeout))))
    local live,status=getTrade()
    if status=="ERROR" or live or pendingRequest then
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
    if not Runtime.alive() or not Gui.Parent or not Runtime.configurationReady() or not Settings.plazaAutoRoute
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

    local generation = PlazaRouter.operationGeneration or 0

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

    if not PlazaRouter.operationCurrent(generation) then return false end

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

        if not PlazaRouter.operationCurrent(generation) then return false end

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

    for _, targetPlace in ipairs(plazaPlaces) do
        if not PlazaRouter.operationCurrent(generation) then return false end
        plazaLog("NORMAL SERVER -> TRADING PLAZA", targetPlace.Name, "PLACE=", targetPlace.Id)
        setTestStatus("NORMAL SERVER • FINDING TRADING PLAZA", C.YELLOW)
        local historyFailures = PlazaRouter.historyFailureEpoch or 0
        local ok, targetServer = pcall(findNewPlazaServer, targetPlace.Id)
        if not PlazaRouter.operationCurrent(generation) then return false end
        if ok and targetServer then
            plazaLog("ROUTE SERVER", targetServer.JobId, targetServer.Playing .. "/" .. targetServer.MaxPlayers)
            return teleportToPlazaTarget(targetServer.PlaceId, targetServer.JobId)
        end
        if not ok then plazaLog("PLAZA CANDIDATE FAILED", targetPlace.Id, tostring(targetServer)) end
        if (PlazaRouter.historyFailureEpoch or 0) ~= historyFailures then break end
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
    local ok, target = PlazaRouter.runOperation(function() return findNewPlazaServer(placeId) end)
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
    for _, target in pairs(table.clone(PlazaRouter.reservations or {})) do releasePlazaReservation(target) end
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
        elseif not Runtime.configurationReady() then
            PlazaRouter.preparing,PlazaRouter.clearSince=false,nil
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
                    local ok, result = PlazaRouter.runOperation(routeNormalServerToPlaza)
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
    State.requestSendingAt, State.requestUncertainUntil = nil, nil
    State.chatAskAttempts, State.askSent = nil, nil
    State.noStockStarted = nil
    Runtime.potionAddonPlan = nil
    State.firstAcceptObserved, State.firstAcceptSentAt, State.emptyTheirSince = nil, nil, nil
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
    State.showcaseAttempts, State.showcaseStockSignature = nil, nil
    State.showcaseTried =
        {}
end


local function cooldown(player)
    local id = Runtime.playerID(player)

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

    for id,expires in pairs(PlayerCooldowns) do
        if now>=expires then PlayerCooldowns[id]=nil end
    end
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
        if ok and result ~= false then return true, "SENT" end
        if not ok then
            if result == "REMOTE TIMEOUT" or result == "REMOTE CANCELLED" or result == "REMOTE BUSY"
                or result == "REMOTE MISSING" or result == "REMOTE ENDPOINT UNAVAILABLE" then return false,result end
            return false,"REMOTE UNCERTAIN: " .. tostring(result)
        end
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
    State.firstAcceptObserved, State.firstAcceptSentAt = nil, nil
end

function Runtime.observeFirstAccept(trade, mine)
    local signature = fullSignature(mine, select(2, getTradeSides(trade)))
    if accepted(mine) or Runtime.tradeInConfirmation(trade) then
        if State.firstAcceptSignature and State.firstAcceptSignature ~= signature
            and (State.firstAcceptObserved or State.firstAcceptSentAt) then return end
        if not State.firstAcceptObserved or State.firstAcceptSignature ~= signature then
            State.acceptedSignature, State.firstAcceptSignature = signature, signature
            State.firstAcceptAt, State.confirmWaitLoggedSignature = os.clock(), nil
        end
        State.firstAcceptObserved = true
        if Runtime.acceptPending then Runtime.acceptPending.observed=true end
    elseif State.firstAcceptObserved then
        -- This is an observed true -> false transition, not a pending RPC.
        Runtime.clearAcceptState()
        State.acceptReadySignature, State.acceptReadySince = nil, nil
        State.changedAt = os.clock()
    end
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

local function decline(expectedContext)
    if not Settings.autoTrade then return false end
    local context = expectedContext or Runtime.captureTrade(getTrade())
    local live = Runtime.liveContext(context, false, false)
    if not live then return false end
    local mine, _, _, partner = getTradeSides(live)
    if not mine or (State.tradeID and tostring(live.trade_id or live.id or playerName(partner)) ~= State.tradeID) then return false end
    local key = Runtime.tradeKey(live, partner)
    if not State.declineRequested or State.declineRequested.key ~= key then State.declineRequested = {key = key} end
    local pending = State.declineRequested
    if InventoryFlow then InventoryFlow.stop("Trade cancellation requested") end
    if pending.busy or (pending.lastAttempt and os.clock() - pending.lastAttempt < 2) then return false end
    if not TradeRemote.Decline then return false end
    pending.lastAttempt, pending.busy = os.clock(), true
    local ok, result = Runtime.invokeRemote(TradeRemote.Decline, {context=context, mine=false, prices=false})
    pending.busy = false
    local current = Runtime.liveContext(context, false, false)
    local currentMine, _, _, currentPartner = getTradeSides(current)
    if not current or State.declineRequested ~= pending then return false end
    if not currentMine or Runtime.tradeKey(current, currentPartner) ~= key then return ok and result ~= false end
    State.declineSent = ok and result ~= false
    testLog(State.declineSent and "DECLINE SENT • WAIT TRADE CLOSED" or "DECLINE FAILED • RETRY")
    return State.declineSent
end

-- Cancellation is kept separate from GUI and ordinary Runtime cleanup.
function Runtime.beginAcceptanceCancellation(reason, expectedContext)
    local live,readStatus=getTrade()
    if readStatus=="ERROR" then live=Runtime.lastTrustedTrade end
    local mine, _, _, partner = getTradeSides(live)
    local key = Runtime.tradeKey(live, partner)
    if not mine or not key or (expectedContext and expectedContext.key ~= key) then return end
    local request = Runtime.acceptPending
    if not accepted(mine) and not Runtime.tradeInConfirmation(live)
        and not (request and request.key == key and request.started) and not State.firstAcceptSentAt then return end
    local existing = ENV.__AM_ANALYZER_CANCELLATION
    if existing and existing.key == key then Runtime.stopAcceptance=existing existing.tick() return end
    local native = Runtime.nativeTask or task
    local uncertain = request and request.key == key and request.started and not request.observed
    local pending = {key=key, since=os.clock(), reason=reason, calls={}, mustClose=uncertain==true, riskUntil=uncertain and math.max(os.clock()+12,request.expires) or os.clock()+12}
    ENV.__AM_ANALYZER_CANCELLATION, Runtime.stopAcceptance = pending, pending
    local function current()
        if ENV.__AM_ANALYZER_CANCELLATION ~= pending then return nil,nil,"REPLACED" end
        local trade,status=getTrade()
        if status=="ERROR" then return nil,nil,"ERROR" end
        if status=="ABSENT" then return nil,nil,"ABSENT" end
        local own,_,_,other=getTradeSides(trade)
        local liveKey=Runtime.tradeKey(trade,other)
        if not own or not liveKey then return nil,nil,"ERROR" end
        if liveKey~=pending.key then return nil,nil,"REPLACED" end
        return trade,own,"FOUND"
    end
    local function finish()
        if ENV.__AM_ANALYZER_CANCELLATION == pending then ENV.__AM_ANALYZER_CANCELLATION=nil end
        if Runtime.stopAcceptance == pending then Runtime.stopAcceptance=nil end
    end
    local function issue(operation)
        local remote = Runtime.resolveTradeRemote(operation)
        if not remote then return end
        local previous = pending.calls[operation]
        if previous and ((not previous.done and os.clock()-previous.since<30) or os.clock()-previous.since<2) then return end
        local call = {since=os.clock(), done=false}
        pending.calls[operation] = call
        local function invoke()
            if not current() then call.done=true return end
            local ok,err=pcall(function()
                if typeof(remote) == "Instance" then
                    if remote:IsA("RemoteEvent") then remote:FireServer()
                    elseif remote:IsA("RemoteFunction") then remote:InvokeServer() end
                elseif type(remote) == "function" then remote()
                elseif type(remote) == "table" then
                    if type(remote.FireServer) == "function" then remote:FireServer()
                    elseif type(remote.InvokeServer) == "function" then remote:InvokeServer() end
                end
            end)
            if not ok and Runtime.staleRemoteFailure(remote,err) then Runtime.invalidateTradeRemote(remote) end
            call.done = true
        end
        if type(native.spawn) == "function" then native.spawn(invoke)
        else local co=coroutine.create(invoke) coroutine.resume(co) end
    end
    function pending.tick()
        local trade, own, status = current()
        if status=="ERROR" then return end
        if not trade then finish() return end
        local isAccepted = accepted(own) or Runtime.tradeInConfirmation(trade)
        if not pending.mustClose and not isAccepted and os.clock() >= pending.riskUntil then finish() return end
        if os.clock()-pending.since >= 12 then issue("Decline")
        elseif isAccepted then issue("Unaccept") end
        trade, own, status = current()
        if status=="ERROR" then return end
        if not trade or (not pending.mustClose and not accepted(own) and not Runtime.tradeInConfirmation(trade) and os.clock()>=pending.riskUntil) then finish() end
    end
    pending.tick()
    if ENV.__AM_ANALYZER_CANCELLATION == pending and type(native.spawn) == "function" then
        native.spawn(function()
            while ENV.__AM_ANALYZER_CANCELLATION == pending do
                pending.tick()
                if ENV.__AM_ANALYZER_CANCELLATION == pending then native.wait(.25) end
            end
        end)
    end
end

function Runtime.requestStopAcceptance()
    Runtime.beginAcceptanceCancellation("Auto Trade disabled")
end

function Runtime.finishStopAcceptance()
    local pending = ENV.__AM_ANALYZER_CANCELLATION
    if pending then pending.tick() end
end

function Runtime.cancellationPending(key)
    Runtime.finishStopAcceptance()
    local pending = ENV.__AM_ANALYZER_CANCELLATION
    return pending and pending.key == key
end

function Runtime.pruneDisallowed(trade)
    local context = Runtime.captureTrade(trade)
    local live, _, mine = Runtime.liveContext(context, true, true)
    if not live or Runtime.tradeInConfirmation(live) then return false end
    if Settings.ownPotionsOnly and Runtime.potionAddonPlan and not Runtime.potionBasePresent(mine) then
        Runtime.potionAddonPlan = nil
        State.optimizedSignature, State.optimizedOurSignature = nil, nil
    end
    local remove, keep = {}, {}
    for _, item in pairs(getOfferItems(mine)) do
        local data = effectiveItemValue(item)
        local belowMinimum = data.known and not data.newIgnored and data.value < activeMinItemValue("mine")
            and not Runtime.bypassOwnMinimum(item, data.name)
        if not isAllowed(data.name, item) or belowMinimum or not data.known or data.newIgnored
            or data.estimated or DemandPolicy.ownAnalysisReason(data.analysis) or itemLocked(item) then
            remove[#remove + 1] = tostring(itemUID(item))
        else keep[#keep+1] = {uid=tostring(itemUID(item)), value=data.value} end
    end
    table.sort(keep, function(a,b) if a.value==b.value then return a.uid<b.uid end return a.value>b.value end)
    local limit=math.clamp(math.floor(num(Settings.maxOurItems) or 18),1,18)
    for n=limit+1,#keep do remove[#remove+1]=keep[n].uid end
    if #remove == 0 then return true end
    if not unaccept(mine) then return false end
    for _, uid in ipairs(remove) do
        Runtime.task.wait(math.max(0.1, tonumber(Settings.itemActionDelay) or 0.85))
        live, _, mine = Runtime.liveContext(context, false, true)
        if not live or Runtime.tradeInConfirmation(live) or accepted(mine) then return false end
        local ok, result = removeOurItem(uid)
        if not Runtime.liveContext(context, false, true) or not ok or result == false then return false end
        local observed = false
        for _ = 1, 31 do
            live, _, mine = Runtime.liveContext(context, false, true)
            if not live or Runtime.tradeInConfirmation(live) or accepted(mine) then return false end
            if not currentUIDSet(mine)[uid] then observed = true break end
            Runtime.task.wait(.1)
        end
        if not observed then setTestStatus("REMOVE NOT OBSERVED • RETRY", C.YELLOW) return false end
    end
    State.optimizedSignature, State.optimizedOurSignature = nil, nil
    State.acceptReadySignature, State.acceptReadySince = nil, nil
    State.changedAt = os.clock()
    return false
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

    if mine.numericError or theirs.numericError
        or num(mine.total) == nil or num(theirs.total) == nil
        or num(mine.effectiveTotal) == nil or num(theirs.effectiveTotal) == nil then
        result.blocked, result.reason = true, "INVALID VALUE TOTAL"
        return result
    end
    if mine.integrityError or theirs.integrityError then
        result.blocked, result.reason = true, "DUPLICATE ITEM UID"
        return result
    end

    if
        mine.hardBlocked > 0 or theirs.hardBlocked > 0
    then

        result.blocked =
            true

        result.reason =
            "BLOCKED ITEM • TRIKE STROLLER"

        return result
    end

    if Settings.autoTrade then
        if countOfferItems(myOffer) > math.clamp(math.floor(num(Settings.maxOurItems) or 18), 1, 18) then
            result.blocked, result.reason = true, "OUR OFFER EXCEEDS MAX ITEMS"
            return result
        end
        for _, offer in ipairs({myOffer, theirOffer}) do
            for _, item in pairs(getOfferItems(offer)) do
                if not Runtime.instanceUID(item) then
                    result.blocked, result.reason = true, "MISSING UNIQUE ITEM ID"
                    return result
                end
            end
        end
    end

    if Settings.autoTrade and AMVGG.dataStale then
        result.blocked = true
        result.reason = "AMVGG UPDATE FAILED • FRESH PRICES REQUIRED"
        return result
    end

    if Settings.autoTrade then
        for _, row in ipairs(mine.items) do
            if not isAllowed(row.data.name, row.raw) then
                result.blocked, result.reason = true, "OUR ITEM NOT ALLOWED"
                return result
            end
        end
    end

    if Settings.autoTrade and Settings.ownPotionsOnly then
        for _, row in ipairs(mine.items) do
            if not Runtime.isTradePotion(row.data.name) and not Runtime.potionBasePresent(myOffer) then
                result.blocked, result.reason = true, "POTION BASE MISSING"
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

    if mine.total > 0 and result.profit == nil then
        result.blocked, result.reason = true, "INVALID VALUE PROFIT"
        return result
    end
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

function Runtime.revalidatePotionPlan(trade, mine, theirs)
    local old = Runtime.potionAddonPlan
    if not old or not Settings.ownPotionsOnly or AMVGG.loading or AMVGG.dataStale or not AMVGG.ready then return false end
    local context = Runtime.captureTrade(trade)
    if not context or context.key ~= old.context.key or context.generation ~= old.context.generation
        or context.theirs ~= old.context.theirs then return false end
    local safe = {}
    for _, candidate in ipairs(valuedInventory(true)) do safe[candidate.uid] = candidate end
    local present, baseCount = {}, 0
    for _, item in pairs(getOfferItems(mine)) do
        local uid = tostring(itemUID(item))
        local expected = old.base[uid] or old.addons[uid]
        local candidate = safe[uid]
        if not expected or not candidate or expected ~= Runtime.potionItemKey(item)
            or expected ~= Runtime.potionItemKey(candidate.item) or present[uid] then return false end
        present[uid] = true
    end
    for uid in pairs(old.base) do if not present[uid] then return false end baseCount += 1 end
    for uid in pairs(old.addons) do if not present[uid] then return false end end
    if baseCount == 0 then return false end
    -- Evaluate the unchanged composition against fresh prices and all current
    -- rules; no server action occurs while the tentative plan is installed.
    local nextPlan = {context=context, base=old.base, addons=old.addons}
    Runtime.potionAddonPlan = nextPlan
    local evaluation = evaluateTrade(mine, theirs)
    if evaluation.blocked or not evaluation.valid or not Runtime.liveContext(context, true, true) then
        Runtime.potionAddonPlan = nil
        return false
    end
    return true
end


local function secureAccept(trade, myOffer, theirOffer, expectedContext)
    if not Runtime.storageReady() then unaccept(myOffer) return false end
    if expectedContext and not Runtime.liveContext(expectedContext, true, true) then return false end
    local context = Runtime.captureTrade(trade)
    local live, _, mine, theirs = Runtime.liveContext(context, true, true)
    if not live or fullSignature(mine, theirs) ~= fullSignature(myOffer, theirOffer) then return false end
    if Runtime.cancellationPending(context and context.key) then return false end
    if State.declineRequested then return false end
    if State.unacceptRequired then unaccept(mine) return false end
    Runtime.observeFirstAccept(live, mine)
    if Runtime.tradeInConfirmation(live) and Settings.ownPotionsOnly and Runtime.potionAddonPlan
        and not Runtime.liveContext(Runtime.potionAddonPlan.context, false, true) then
        Runtime.revalidatePotionPlan(live, mine, theirs)
    end
    local evaluation = evaluateTrade(mine, theirs)
    live, _, mine, theirs = Runtime.liveContext(context, true, true)
    if not live or not Settings.autoTrade or Runtime.cancellationPending(context.key) then return false end
    if evaluation.blocked or not evaluation.valid then unaccept(mine) return false end
    local proof = Runtime.ownOfferProof(context, mine)
    if not proof then
        live, _, mine = Runtime.liveContext(context, true, true)
        if live then unaccept(mine) end
        return false
    end
    live, _, mine, theirs = Runtime.liveContext(context, true, true)
    if not live then return false end
    local currentEvaluation = evaluateTrade(mine, theirs)
    live, _, mine, theirs = Runtime.liveContext(context, true, true)
    if not live or not Settings.autoTrade or Runtime.cancellationPending(context.key) then return false end
    if currentEvaluation.blocked or not currentEvaluation.valid then unaccept(mine) return false end
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
        live, _, mine, theirs = Runtime.liveContext(context, true, true)
        if not live or not Settings.autoTrade or Runtime.cancellationPending(context.key) then return false end
        if final.blocked or not final.valid then unaccept(mine) return false end
        proof = Runtime.ownOfferProof(context, mine)
        if not proof then if Runtime.liveContext(context,true,true) then unaccept(mine) end return false end
        live, _, mine, theirs = Runtime.liveContext(context, true, true)
        if not live or not Runtime.tradeInConfirmation(live) or State.unacceptRequired or State.declineRequested then return false end
        local latest = evaluateTrade(mine, theirs)
        live, _, mine, theirs = Runtime.liveContext(context, true, true)
        if not live or not Runtime.tradeInConfirmation(live) or Runtime.cancellationPending(context.key)
            or State.unacceptRequired or State.declineRequested then return false end
        if latest.blocked or not latest.valid then unaccept(mine) return false end
        if confirmed(mine) then State.confirmPending = nil return true end
        local pending = State.confirmPending
        if pending and (pending.key ~= context.key or pending.signature ~= signature) then
            unaccept(mine)
            return false
        end
        if pending then
            if os.clock() - pending.since >= 12 then
                setTestStatus("CONFIRM NOT OBSERVED • DECLINING", C.RED)
                decline(context)
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
        local ok, result = Runtime.invokeRemote(TradeRemote.Confirm, {context=context, proof=proof, confirmation=true})
        if not Runtime.liveContext(context, true, true) then return false end
        if not ok or result == false then testLog("CONFIRM FAILED") return false end
        if State.confirmPending ~= pending then return false end
        pending.acknowledged = true
        testLog("SECOND CONFIRM SENT AFTER", requiredDelay, "SECONDS")
        return true
    end

    if not accepted(mine) then
        if State.firstAcceptSignature == signature and State.firstAcceptAt then
            if os.clock() - (State.firstAcceptSentAt or State.firstAcceptAt) >= 12 then decline(context) return false end
            setTestStatus("ACCEPT SENT • WAIT LIVE RESULT", C.YELLOW)
            return true
        end
        if not TradeRemote.Accept then return false end
        if not Runtime.liveContext(context, true, true) or not Runtime.ownProofCurrent(proof,mine) then return false end
        local request = {key=context.key, signature=signature, since=os.clock(), expires=os.clock()+30}
        Runtime.acceptPending = request
        local ok, result = Runtime.invokeRemote(TradeRemote.Accept, {context=context, proof=proof, acceptRecord=request, confirmation=false})
        request.done, request.acknowledged = true, ok and result ~= false
        if not request.started or (ok and result==false) then
            if Runtime.acceptPending == request then Runtime.acceptPending=nil end
        end
        local current, _, freshMine = Runtime.liveContext(context, true, true)
        if not current then
            if request.started then Runtime.beginAcceptanceCancellation("Accept interrupted", context) end
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
            if request.started and not ok then Runtime.beginAcceptanceCancellation("Accept result unknown", context) end
            Runtime.clearAcceptState()
            testLog("FIRST ACCEPT FAILED")
            return false
        end
        State.acceptedSignature, State.firstAcceptSignature = signature, signature
        State.firstAcceptAt, State.confirmWaitLoggedSignature = os.clock(), nil
        State.firstAcceptSentAt, State.firstAcceptObserved = os.clock(), false
        Runtime.observeFirstAccept(current, freshMine)
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
    if countOfferItems(myOffer)>0 then return true,"OBSERVED" end
    if not TradeRemote.Add then return false,"REMOTE MISSING" end
    local context=Runtime.captureTrade(getTrade())
    if not context or not Runtime.liveContext(context,true,true) then return false,"TRADE_CHANGED" end
    local pending=State.showcasePending
    if pending then
        if pending.key~=context.key then State.showcasePending=nil return false,"TRADE_CHANGED" end
        local mine=getTradeSides(getTrade())
        if currentUIDSet(mine)[pending.uid] then State.showcasePending=nil return true,"OBSERVED" end
        if os.clock()<pending.untilAt then return false,"PENDING" end
        local tried=State.showcaseAttempts and State.showcaseAttempts[pending.uid]
        if tried then tried.nextAt=math.max(tried.nextAt,os.clock()+2) end
        State.showcasePending=nil
    end
    State.showcaseAttempts=State.showcaseAttempts or {}
    local waiting=false
    for _,candidate in ipairs(valuedInventory()) do
        if not Runtime.liveContext(context,true,true) then return false,"TRADE_CHANGED" end
        local uid=tostring(candidate.uid)
        local attempt=State.showcaseAttempts[uid] or {count=0,nextAt=0}
        if attempt.count<3 then
            if os.clock()<attempt.nextAt then waiting=true
            else
                attempt.count+=1 attempt.nextAt=os.clock()+2
                State.showcaseAttempts[uid]=attempt
                State.showcaseTried[uid]=true
                local ok,result=addOurItem(candidate.uid)
                if not Runtime.liveContext(context,false,true) then return false,"TRADE_CHANGED" end
                local mine=getTradeSides(getTrade())
                if currentUIDSet(mine)[uid] then return true,"OBSERVED" end
                if ok and result~=false then State.showcasePending={key=context.key,uid=uid,untilAt=os.clock()+4}
                elseif Runtime.uncertainResult(result) then State.showcasePending={key=context.key,uid=uid,untilAt=os.clock()+30} end
                return false,ok and result~=false and "PENDING" or "FAILED"
            end
        end
    end
    return false,waiting and "PENDING" or "EXHAUSTED"
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
function Runtime.uncertainResult(reason)
    reason=tostring(reason or "")
    return reason:find("TIMEOUT",1,true)~=nil or reason:find("CANCEL",1,true)~=nil or reason:find("BUSY",1,true)~=nil or reason:find("UNCERTAIN",1,true)~=nil
end

InventoryFlow = {}
do
    local MainState = State
    local previous = ENV.__AM_ANALYZER_INVENTORY_FLOW
    if type(previous) == "table" and type(previous.stop) == "function" then pcall(previous.stop, "inventory automation removed") end
    ENV.__AM_ANALYZER_INVENTORY_FLOW = InventoryFlow
    Runtime.flow = InventoryFlow
    function InventoryFlow.stop(reason)
        if reason == "trade state reset" or reason == "partner changed inside current trade" or not Runtime.alive() then
            InventoryFlow.greetedTrade, InventoryFlow.greetingAttempt = nil, nil
        elseif InventoryFlow.greetingAttempt and InventoryFlow.greetingAttempt.busy then
            InventoryFlow.greetingAttempt.busy, InventoryFlow.greetingAttempt.uncertain = false, true
        end
    end
    function InventoryFlow.engaged() return false end
    function InventoryFlow.holdAccept() return false end
local function identity(value)
    local id = Runtime.playerID(value)
    if id then return id, playerName(value) end
    if type(value) == "string" then
        local player = Players:FindFirstChild(value)
        if player and player.ClassName == "Player" then return Runtime.playerID(player), player.Name end
    end
end

    function InventoryFlow.sendQuickChat(partner,index,fallback)
        if not Settings.autoTrade or not Settings.chatRequests then return false,"CHAT CANCELLED" end
        local live=getTrade()
        local context=live and Runtime.captureTrade(live)
        if not context or not Runtime.liveContext(context,false,false) then return false,"CHAT CANCELLED" end
        if TradeRemote.QuickChat then
            local _,_,_,other=getTradeSides(live)
            local id,name=identity(partner)
            if not id or identity(other)~=id or Runtime.tradeID(live)~=MainState.tradeID then return false,"CHAT CANCELLED" end
            local target=typeof(partner)=="Instance" and partner or (name and Players:FindFirstChild(name)) or Players:GetPlayerByUserId(id)
            if not target or target.ClassName~="Player" or target.UserId~=id then return false,"CHAT TARGET UNAVAILABLE" end
            local ok,result=Runtime.invokeRemote(TradeRemote.QuickChat,{context=context,mine=false,prices=false},target,index)
            if ok and result~=false then return true end
            if Runtime.uncertainResult(result) or not Runtime.liveContext(context,false,false) then return false,result end
        end
        if not Runtime.liveContext(context,false,false) or not Settings.autoTrade then return false,"CHAT CANCELLED" end
        return sendChat(fallback,context)
    end

    function Runtime.sendAddRequest(partner, context, slot, signature)
        if not Settings.chatRequests then return false, nil end
        if not Runtime.liveContext(context, true, false) then return false, nil end
        MainState.chatAskAttempts = MainState.chatAskAttempts or {}
        local key = context.key .. "|" .. signature
        local attempt = MainState.chatAskAttempts[slot]
        if not attempt or attempt.key ~= key then
            attempt = {key=key, count=0, nextAt=0, since=os.clock()}
            MainState.chatAskAttempts[slot] = attempt
        end
        if attempt.sent then return true, attempt end
        if attempt.busy or attempt.uncertain or attempt.count >= 3 or os.clock() < attempt.nextAt then return false, attempt end
        attempt.busy, attempt.count = true, attempt.count + 1
        local ok, reason = InventoryFlow.sendQuickChat(partner, 4, "please add +")
        attempt.busy, attempt.nextAt = false, os.clock() + 2
        attempt.reason = reason
        if ok then attempt.sent = true
        elseif Runtime.uncertainResult(reason) then attempt.uncertain = true end
        if not Runtime.liveContext(context, true, false) or not MainState.chatAskAttempts
            or MainState.chatAskAttempts[slot] ~= attempt then return false, nil end
        if not ok then testLog("ASK CHAT FAILED", attempt.count, reason or "DELIVERY REJECTED") end
        return ok, attempt
    end

    function InventoryFlow.step(trade,partner)
        if not Settings.autoTrade or not Settings.chatRequests then return false end
        local key=MainState.tradeID
        if not key or InventoryFlow.greetedTrade==key then return false end
        if os.clock()-(MainState.tradeStarted or os.clock())<3 then return false end
        local context=Runtime.captureTrade(trade)
        if not Runtime.liveContext(context,true,true) then return false end
        local attempt=InventoryFlow.greetingAttempt
        if not attempt or attempt.key~=key then attempt={key=key,count=0,nextAt=0} InventoryFlow.greetingAttempt=attempt end
        if attempt.busy or attempt.uncertain or attempt.count>=3 or os.clock()<attempt.nextAt then return false end
        attempt.busy=true attempt.count+=1 attempt.nextAt=os.clock()+2
        local ok,reason=InventoryFlow.sendQuickChat(partner,1,"👋 Lets, trade")
        attempt.busy=false
        -- Preserve the outcome even if prices or our offer changed during send.
        -- A different trade/partner resets this history explicitly.
        if InventoryFlow.greetingAttempt == attempt then
            if ok then InventoryFlow.greetedTrade=key
            elseif Runtime.uncertainResult(reason) then attempt.uncertain=true end
        end
        if not Runtime.liveContext(context,true,true) then return false end
        return false
    end


end


function Runtime.waitForPotionStock(expectedContext)
    State.noStockStarted = State.noStockStarted or os.clock()
    State.optimizedSignature, State.optimizedOurSignature = nil, nil
    State.askStarted, State.askSignature = nil, nil
    local remaining = math.max(0, 30 - (os.clock() - State.noStockStarted))
    setTestStatus(string.format("NO AVAILABLE RIDE / FLY POTIONS • %.0fs", remaining), C.YELLOW)
    if remaining <= 0 then decline(expectedContext) end
end

local function manageAutoTrade(trade)
    if not Runtime.storageReady() then
        Runtime.beginAcceptanceCancellation("Saved data unavailable", Runtime.captureTrade(trade))
        setTestStatus("AUTO BLOCKED • RESTORE SAVED SETTINGS / NEW HISTORY", C.RED)
        return
    end
    if not Settings.autoTrade then return end
    if not Runtime.tradeID(trade) then
        setTestStatus("AUTO BLOCKED • MISSING TRADE ID", C.RED)
        return
    end
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

    local id = Runtime.tradeID(trade)
    if not id then
        setTestStatus("AUTO BLOCKED • MISSING TRADE ID", C.RED)
        return
    end

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

        decline(operationContext)
        return
    end

    if State.declineRequested then decline(operationContext) return end
    if State.unacceptRequired then
        if not accepted(myOffer) and not Runtime.tradeInConfirmation(trade) then
            State.unacceptRequired = nil
            Runtime.clearAcceptState()
        elseif os.clock() - State.unacceptRequired.since >= 12 then
            setTestStatus("UNACCEPT TIMED OUT • DECLINING", C.RED)
            decline(operationContext)
            return
        elseif not unaccept(myOffer) then
            setTestStatus("WAIT UNACCEPT • RETRY", C.YELLOW)
            return
        end
        if not Runtime.liveContext(operationContext, true, false) then return end
    end

    Runtime.observeFirstAccept(trade, myOffer)
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
                if not Runtime.liveContext(operationContext, true, false) then return end

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

        if countOfferItems(theirOffer) == 0 then
            if hadPrevious and State.lastTheirSignature ~= "" then
                State.emptyTheirSince, State.initialAsk = os.clock(), false
            end
        else
            State.emptyTheirSince = nil
        end
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

    if AMVGG.loading or not AMVGG.ready then
        Runtime.beginAcceptanceCancellation("Prices unavailable", operationContext)
        setTestStatus("WAIT AMVGG", C.YELLOW) return
    end
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

    if myCount==0 and State.showcaseFinished and State.optimizedSignature==nil then
        local stock=Runtime.inventorySignature()
        if stock~=State.showcaseStockSignature then
            State.showcaseFinished=false State.showcaseAttempts={} State.showcaseTried={}
            State.waitForFirstAt,State.showcaseAddedAt,State.initialAsk=nil,nil,nil
        end
    end
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
        if not Runtime.liveContext(operationContext, false, false) then return end
        if added or showcaseReason == "EXHAUSTED" then
            State.showcaseFinished=true State.showcaseStockSignature=Runtime.inventorySignature()
        end
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

    if Settings.ownPotionsOnly == true and myCount == 0 then
        local available = Runtime.potionWaitingOffer()
        if #available == 0 then
            Runtime.waitForPotionStock(operationContext)
            return
        end
    end

    State.noStockStarted = nil

    -- If the client replicated our showcase between loops before we recorded
    -- the timestamp, start the first-item window now rather than from trade start.
    if myCount > 0 and not State.showcaseAddedAt then
        State.showcaseAddedAt = os.clock()
    end

    -- WAIT FOR THEM
    if theirCount == 0 then
        if not State.waitForFirstAt then State.waitForFirstAt = os.clock() end

        if not State.initialAsk then
            local sent = Runtime.sendAddRequest(partner, operationContext, "initial", "FIRST:" .. tostring(State.theirRevision))
            if not Runtime.liveContext(operationContext, true, false) then return end
            if sent then
                State.initialAsk = true
                testLog("ASK FIRST ITEM SENT")
            end
        end

        local elapsed =
            os.clock()
            - (
                State.emptyTheirSince
                or State.showcaseAddedAt
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

            decline(operationContext)
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

    if not Runtime.liveContext(operationContext, true, true) then return end
    if evaluation.blocked then

        unaccept(
            myOffer
        )
            if not Runtime.liveContext(operationContext, true, false) then return end

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

                decline(operationContext)
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
            Runtime.optimizeOwnOffer(
                evaluation.theirs.effectiveTotal
            )

        if optimizationError or not Runtime.liveContext(operationContext, true, true) then
            State.optimizedSignature = nil
            return
        end
        -- Keep a safe potion visible while asking for a better incoming offer.
        -- This is a display fallback only: evaluateTrade and secureAccept still
        -- enforce the full demand cap before Accept and before Confirm.
        if Settings.ownPotionsOnly == true and #desired == 0 then
            desired, ourValue = Runtime.potionWaitingOffer()
            if not Runtime.liveContext(operationContext, true, true) then return end
            if #desired == 0 then
                Runtime.waitForPotionStock(operationContext)
                return
            end
        end
        if
            #desired > 0
            and ourValue > 0
        then

            testLog(
                ourValue > cap + 0.000000001 and "WAITING POTION • ASK ADD" or "BALANCE TO DEMAND CAP",
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

        State.askStarted, State.askSent = nil, nil
        if State.chatAskAttempts then State.chatAskAttempts.add = nil end

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
                if not Runtime.liveContext(operationContext, true, false) then return end

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
        if not Runtime.liveContext(operationContext, true, false) then return end

    -- ASK ADD: start a fresh inactivity window. If THEIR offer does not
    -- change for the full timeout, decline. A partner add/remove changes
    -- theirSignature and starts a brand-new window after recalculation.
    if State.askSignature ~= theirSignature then
        State.askStarted, State.askSent, State.askSignature = nil, false, theirSignature
    end
    if not State.askSent and Settings.chatRequests then
        local sent, attempt = Runtime.sendAddRequest(partner, operationContext, "add", "ADD:" .. theirSignature)
        if not Runtime.liveContext(operationContext, true, false) then return end
        if sent then
            State.askSent, State.askStarted = true, os.clock()
            testLog("ASK ADD SENT • INACTIVITY WINDOW=", Settings.addTimeout)
        elseif not State.askStarted then
            if attempt and os.clock() - attempt.since >= Settings.addTimeout then decline(operationContext) return end
            local message = attempt and attempt.uncertain and "ASK RESULT UNKNOWN • NO DUPLICATE"
                or attempt and attempt.count >= 3 and "ASK CHAT FAILED • WAITING"
                or "ASK CHAT FAILED • RETRYING"
            setTestStatus(message, C.YELLOW)
            return
        end
    end
    State.askStarted = State.askStarted or os.clock()

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

        decline(operationContext)
    end
end


--============================================================
-- AUTO TRADE MAIN
--============================================================

local function runAutoTrade()
    if not Runtime.storageReady() then
        local live = getTrade()
        if live then Runtime.beginAcceptanceCancellation("Saved data unavailable", Runtime.captureTrade(live)) end
        setTestStatus("AUTO BLOCKED • RESTORE SAVED SETTINGS / NEW HISTORY", C.RED)
        return
    end
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
                    (State.requestUncertainUntil or (State.requestStarted + Settings.requestTimeout)) - os.clock()
                )
            )
            .. "s",
            C.YELLOW
        )

        if os.clock() >= (State.requestUncertainUntil or (State.requestStarted + Settings.requestTimeout)) then

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

    local preflightGeneration=AutoTradeGeneration
    if AMVGG.loading or AMVGG.dataStale or not AMVGG.ready then setTestStatus("WAIT AMVGG",C.YELLOW) return end
    local available=Settings.ownPotionsOnly and Runtime.potionWaitingOffer() or valuedInventory()
    if not Settings.autoTrade or preflightGeneration~=AutoTradeGeneration or not Runtime.alive() or getTrade() then return end
    if #available==0 then
        setTestStatus(Settings.ownPotionsOnly and "NO AVAILABLE RIDE / FLY POTIONS • NO REQUEST" or "NO SAFE ITEMS • NO REQUEST",C.YELLOW)
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

    State.requestStarted, State.requestUncertainUntil = nil, nil
    State.requestSendingAt = os.clock()

    setTestStatus(
        "REQUEST -> "
        .. target.Name,
        C.YELLOW
    )

    testLog(
        "REQUEST",
        target.Name
    )

    local sent, reason = sendTrade(target)
    if not Runtime.alive() or not Settings.autoTrade or AutoTradeGeneration ~= preflightGeneration
        or State.target ~= target then return end
    State.requestSendingAt = nil
    if getTrade() then return end
    if sent then
        State.requestStarted = os.clock()
    elseif reason == "REMOTE TIMEOUT" or reason == "REMOTE BUSY" then
        State.requestStarted = os.clock()
        State.requestUncertainUntil = os.clock() + math.max(30, Settings.requestTimeout)
        testLog("REQUEST RESULT UNKNOWN • WAIT BEFORE NEXT REQUEST")
    else
        testLog("REQUEST FAILED")
        cooldown(target)
        State.target, State.requestStarted, State.requestUncertainUntil = nil, nil, nil
    end

end


--============================================================
-- LIVE TRADE DISPLAY
--============================================================

function Runtime.manualTradeLabel(evaluation)
    local profit = num(evaluation.profit)
    if profit == nil then return "WAITING" end
    local label = math.abs(profit) <= 0.000000001 and "FAIR" or (profit > 0 and "WIN" or "LOSE")
    if profit > 0 and not evaluation.valid then label ..= " • BELOW TARGET" end
    return label
end

local function updateTradeDisplay()
    local trade = getTrade()
    if not trade then
        local storage = Runtime.storageNotice()
        TradeStatus.Text, TradeStatus.TextColor3, TradeInfo.Text = storage and "STORAGE ERROR" or "WAITING FOR TRADE", storage and C.YELLOW or C.MUTED, storage or ""
        return
    end
    local myOffer, theirOffer, _, partner = getTradeSides(trade)
    if not myOffer or not theirOffer then return end
    local evaluation = evaluateTrade(myOffer, theirOffer)
    local mine, theirs = evaluation.mine, evaluation.theirs
    local lines = {"PARTNER: " .. playerName(partner)}
    local storage = Runtime.storageNotice()
    if storage then lines[#lines + 1] = storage end
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
            or Runtime.manualTradeLabel(evaluation)
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

                            Runtime.finishStopAcceptance()
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

function Runtime.waitForPriceRefresh()
    local fallback = os.clock()
    while Runtime.alive() and Gui.Parent do
        local now = os.clock()
        if AMVGG.loading then
            if now - (Runtime.priceRefreshStarted or fallback) >= 125 then return true end
            Runtime.task.wait(1)
        else
            local due
            if AMVGG.dataStale or not AMVGG.ready then
                due = num(Runtime.priceRetryAt) or (fallback + 30)
            else
                local minutes = Runtime.numberValue("refreshMinutes", Settings.refreshMinutes, 1, 1440)
                due = (num(Runtime.lastRefreshClock) or fallback) + minutes * 60
                due = math.max(due, num(Runtime.priceRetryAt) or 0)
            end
            local remaining = due - now
            if remaining <= 0 then return true end
            Runtime.task.wait(math.min(1, remaining))
        end
    end
    return false
end

Runtime.task.spawn(function()
    while Runtime.alive() and Gui.Parent and Runtime.waitForPriceRefresh() do
        local ok, err = pcall(function()
            testLog("AMVGG REFRESH")
            local refreshed = refresh()
            updateFirstSeen()
            Runtime.rebuildSearch()
            return refreshed
        end)
        if not ok or err ~= true then
            Runtime.priceRetryAt = os.clock() + 30
            if not ok then testLog("REFRESH ERROR", err) end
        end
    end
end)


--============================================================


-- PLAYER CLEANUP
--============================================================

Runtime.connect(Players.PlayerRemoving,
    function(player)

        local expires=PlayerCooldowns[player.UserId]
        if expires and os.clock()>=expires then PlayerCooldowns[player.UserId]=nil end

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
Runtime.initializingThread = nil
