repeat task.wait() until game:IsLoaded()

--============================================================
-- ADOPT ME TRADE ANALYZER V11.5.3 FIXED
--
-- FULL VERSION
--
-- CORE:
--   18 TRADE SLOTS
--   LIVE ClientData
--   ItemDB names
--   YOUR / THEIR OFFER
--   HIDE X / REOPEN AM
--
-- PET VARIANTS:
--   NP / F / R / FR
--   N / NF / NR / NFR
--   M / MF / MR / MFR
--
-- AMVGG:
--   PETS
--   EGGS
--   LIVE VALUES
--   VALUE PER SLOT
--   TOTAL VALUE
--   WIN / FAIR / LOSE
--   VALUES SEARCH
--
-- SAFETY:
--   AMVGG CANNOT KILL GUI
--   BOOT CHECKPOINTS
--   ON-SCREEN ERROR STATUS
--
-- AUTO ACCEPT:
--   NOT YET
--============================================================

--============================================================
-- 1/8 SERVICES
--============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ENV =
    type(getgenv) == "function"
    and getgenv()
    or _G

print("[AM ANALYZER V11.5.3] BOOT 1/8 - SERVICES")

--============================================================
-- GUI PARENT
--============================================================

local GuiParent = PlayerGui

if type(gethui) == "function" then
    local ok, result = pcall(gethui)

    if ok and result then
        GuiParent = result
    end
end

--============================================================
-- REMOVE OLD ANALYZERS
--============================================================

local OLD_GUI_NAMES = {
    "AdoptMeTradeAnalyzerV11",
    "AdoptMeTradeAnalyzerV111",
    "AdoptMeTradeAnalyzerV112",
    "AdoptMeTradeAnalyzerV113",
    "AdoptMeTradeAnalyzerV114",
    "AdoptMeTradeAnalyzerV115",
    "AdoptMeTradeAnalyzerV1151",
    "AdoptMeTradeAnalyzerV1152",
    "AdoptMeTradeAnalyzerV1153",
    "AM_ANALYZER_BOOT_V1153",
}

for _, guiName in ipairs(OLD_GUI_NAMES) do
    local old = GuiParent:FindFirstChild(guiName)

    if old then
        old:Destroy()
    end
end

--============================================================
-- EMERGENCY BOOT GUI
--============================================================

local BootGui = Instance.new("ScreenGui")
BootGui.Name = "AM_ANALYZER_BOOT_V1153"
BootGui.ResetOnSpawn = false
BootGui.DisplayOrder = 1000000
BootGui.Parent = GuiParent

local BootFrame = Instance.new("Frame")
BootFrame.Size = UDim2.fromOffset(480, 74)
BootFrame.Position = UDim2.new(0.5, -240, 0, 90)
BootFrame.BackgroundColor3 = Color3.fromRGB(17, 20, 27)
BootFrame.BorderSizePixel = 0
BootFrame.Parent = BootGui

local BootCorner = Instance.new("UICorner")
BootCorner.CornerRadius = UDim.new(0, 10)
BootCorner.Parent = BootFrame

local BootStroke = Instance.new("UIStroke")
BootStroke.Color = Color3.fromRGB(70, 90, 130)
BootStroke.Transparency = 0.25
BootStroke.Parent = BootFrame

local BootText = Instance.new("TextLabel")
BootText.Size = UDim2.new(1, -20, 1, -12)
BootText.Position = UDim2.fromOffset(10, 6)
BootText.BackgroundTransparency = 1
BootText.Font = Enum.Font.Code
BootText.TextSize = 14
BootText.TextColor3 = Color3.fromRGB(240, 243, 250)
BootText.TextWrapped = true
BootText.Text = "ADOPT ME ANALYZER V11.5.3\nBOOT 1/8 - SERVICES"
BootText.Parent = BootFrame

local function setBoot(step, text, isError)
    local line =
        "ADOPT ME ANALYZER V11.5.3\n"
        .. tostring(step)
        .. " - "
        .. tostring(text)

    BootText.Text = line

    if isError then
        BootText.TextColor3 = Color3.fromRGB(255, 110, 110)
    else
        BootText.TextColor3 = Color3.fromRGB(240, 243, 250)
    end

    print(
        "[AM ANALYZER V11.5.3] "
        .. tostring(step)
        .. " - "
        .. tostring(text)
    )
end

local function safeTraceback(err)
    local trace = ""

    local debugLib = rawget(_G, "debug") or debug

    if debugLib and type(debugLib.traceback) == "function" then
        local ok, result = pcall(debugLib.traceback)

        if ok then
            trace = tostring(result)
        end
    end

    return tostring(err) .. "\n" .. trace
end

--============================================================
-- 2/8 ADOPT ME MODULES
--============================================================

setBoot("2/8", "LOADING ADOPT ME MODULES")

local Fsys
local ClientData
local ItemDB

do
    local ok, err = xpcall(function()

        Fsys = require(
            ReplicatedStorage:WaitForChild("Fsys")
        )

        assert(
            type(Fsys) == "table",
            "Fsys is not table"
        )

        assert(
            type(Fsys.load) == "function",
            "Fsys.load missing"
        )

        ClientData = Fsys.load("ClientData")
        ItemDB = Fsys.load("ItemDB")

        assert(
            type(ClientData) == "table",
            "ClientData is not table"
        )

        assert(
            type(ItemDB) == "table",
            "ItemDB is not table"
        )

    end, safeTraceback)

    if not ok then
        setBoot(
            "ERROR 2/8",
            tostring(err),
            true
        )

        warn("[AM ANALYZER MODULE ERROR]\n" .. tostring(err))
        return
    end
end

setBoot("2/8", "ADOPT ME MODULES OK")

--============================================================
-- COLORS
--============================================================

local C = {
    BG = Color3.fromRGB(13, 15, 20),
    TOP = Color3.fromRGB(23, 26, 34),
    SIDE = Color3.fromRGB(19, 22, 29),

    PANEL = Color3.fromRGB(25, 28, 36),
    PANEL2 = Color3.fromRGB(30, 34, 43),

    SLOT = Color3.fromRGB(38, 42, 53),
    SLOT_HOVER = Color3.fromRGB(48, 53, 66),

    TEXT = Color3.fromRGB(242, 244, 250),
    MUTED = Color3.fromRGB(145, 154, 173),

    ACCENT = Color3.fromRGB(78, 132, 255),

    GREEN = Color3.fromRGB(76, 215, 126),
    RED = Color3.fromRGB(235, 80, 94),
    YELLOW = Color3.fromRGB(244, 190, 72),
    ORANGE = Color3.fromRGB(245, 145, 65),
    PURPLE = Color3.fromRGB(218, 95, 255),
}

--============================================================
-- GUI HELPERS
--============================================================

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(
            0,
            radius or 8
        )

    corner.Parent = object

    return corner
end

local function addStroke(object, transparency)
    local stroke = Instance.new("UIStroke")

    stroke.Color =
        Color3.fromRGB(
            58,
            64,
            78
        )

    stroke.Transparency =
        transparency or 0.35

    stroke.Thickness = 1
    stroke.Parent = object

    return stroke
end

local function makeLabel(
    parent,
    text,
    size,
    position,
    font,
    textSize,
    color,
    alignment
)

    local object = Instance.new("TextLabel")

    object.BackgroundTransparency = 1

    object.Size = size
    object.Position = position

    object.Text = text or ""

    object.Font =
        font
        or Enum.Font.Gotham

    object.TextSize =
        textSize
        or 14

    object.TextColor3 =
        color
        or C.TEXT

    object.TextXAlignment =
        alignment
        or Enum.TextXAlignment.Left

    object.TextYAlignment =
        Enum.TextYAlignment.Center

    object.Parent = parent

    return object
end

local function makeButton(
    parent,
    text,
    size,
    position
)

    local object = Instance.new("TextButton")

    object.Size = size
    object.Position = position

    object.BackgroundColor3 = C.PANEL2
    object.BorderSizePixel = 0

    object.Text = text

    object.Font = Enum.Font.GothamBold
    object.TextSize = 11
    object.TextColor3 = C.TEXT

    object.Parent = parent

    addCorner(object, 7)

    return object
end

--============================================================
-- NUMBER HELPERS
--============================================================

local function toNumber(value)
    if type(value) == "number" then
        return value
    end

    if type(value) == "string" then
        return tonumber(value)
    end

    return nil
end

local function numberText(value)
    if type(value) ~= "number" then
        return "?"
    end

    if math.abs(value) < 0.0000001 then
        return "0"
    end

    local text

    if math.abs(value) >= 100 then

        text =
            string.format(
                "%.2f",
                value
            )

    elseif math.abs(value) >= 1 then

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

    text = text:gsub("0+$", "")
    text = text:gsub("%.$", "")

    if text == "-0" then
        text = "0"
    end

    return text
end

--============================================================
-- NORMALIZE NAME
--============================================================

local function normalizeName(text)
    text = tostring(text or "")
    text = text:lower()

    text = text:gsub("&", "and")
    text = text:gsub("’", "'")
    text = text:gsub("[^%w]", "")

    return text
end

local function normalizeWithoutBrackets(text)
    text = tostring(text or "")

    text =
        text:gsub(
            "%b()",
            ""
        )

    return normalizeName(text)
end

--============================================================
-- ADOPT ME ITEM DATABASE HELPERS
--============================================================

local CATEGORY_NAMES = {
    pets = "PET",
    pet_accessories = "PET WEAR",
    strollers = "STROLLER",
    food = "FOOD",
    vehicles = "VEHICLE",
    toys = "TOY",
    gifts = "GIFT",
    stickers = "STICKER",
    houses = "HOUSE",
}

local function getDBEntry(item)
    if type(item) ~= "table" then
        return nil
    end

    local category = item.category
    local kind = item.kind

    if not category or not kind then
        return nil
    end

    local categoryDB = ItemDB[category]

    if type(categoryDB) ~= "table" then
        return nil
    end

    return categoryDB[kind]
end

local function getItemName(item)
    local db = getDBEntry(item)

    if type(db) == "table" then

        if db.name ~= nil then
            return tostring(db.name)
        end

        if db.display_name ~= nil then
            return tostring(db.display_name)
        end
    end

    return tostring(
        item.kind
        or "Unknown Item"
    )
end

local function getCategoryName(item)
    local category =
        tostring(
            item.category
            or "unknown"
        )

    return
        CATEGORY_NAMES[category]
        or category:upper()
end

--============================================================
-- VARIANT DETECTION
--============================================================

local function getVariant(item)
    if type(item) ~= "table" then
        return ""
    end

    if item.category ~= "pets" then
        return ""
    end

    local properties =
        type(item.properties) == "table"
        and item.properties
        or {}

    local fly =
        properties.flyable == true

    local ride =
        properties.rideable == true

    local neon =
        properties.neon == true

    local mega =
        properties.mega_neon == true

    if mega then

        if fly and ride then
            return "MFR"
        end

        if fly then
            return "MF"
        end

        if ride then
            return "MR"
        end

        return "M"
    end

    if neon then

        if fly and ride then
            return "NFR"
        end

        if fly then
            return "NF"
        end

        if ride then
            return "NR"
        end

        return "N"
    end

    if fly and ride then
        return "FR"
    end

    if fly then
        return "F"
    end

    if ride then
        return "R"
    end

    return "NP"
end

local function variantColor(variant)
    if variant:find("M", 1, true) then
        return C.PURPLE
    end

    if variant:find("N", 1, true) then
        return C.GREEN
    end

    if variant ~= "" and variant ~= "NP" then
        return C.ACCENT
    end

    return C.MUTED
end

--============================================================
-- 3/8 HTTP DETECTION
--============================================================

setBoot("3/8", "DETECTING DELTA HTTP")

local function findRequestFunction()
    if type(request) == "function" then
        return request, "request"
    end

    if type(http_request) == "function" then
        return http_request, "http_request"
    end

    if type(ENV.request) == "function" then
        return ENV.request, "getgenv().request"
    end

    if type(ENV.http_request) == "function" then
        return ENV.http_request, "getgenv().http_request"
    end

    if
        type(syn) == "table"
        and type(syn.request) == "function"
    then
        return syn.request, "syn.request"
    end

    return nil, "none"
end

local REQUEST
local REQUEST_NAME

REQUEST, REQUEST_NAME =
    findRequestFunction()

print(
    "[AMVGG] REQUEST API =",
    REQUEST_NAME,
    type(REQUEST)
)

setBoot(
    "3/8",
    "HTTP = " .. tostring(REQUEST_NAME)
)

--============================================================
-- AMVGG VALUE FIELDS
--============================================================

local PET_VALUE_FIELDS = {
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

local PET_DEMAND_FIELDS = {
    NP = "npRegularDemand",

    F = "fDemand",
    R = "rDemand",
    FR = "regularDemand",

    N = "npNeonDemand",
    NF = "nfDemand",
    NR = "nrDemand",
    NFR = "neonDemand",

    M = "npMegaDemand",
    MF = "mfDemand",
    MR = "mrDemand",
    MFR = "megaDemand",
}

--============================================================
-- AMVGG STATE
--============================================================

local AMVGG_STATE = {
    loading = false,
    ready = false,

    error = nil,

    version = 0,

    pets = {},
    eggs = {},

    petCount = 0,
    eggCount = 0,

    lastRefresh = 0,
}

--============================================================
-- HTTP REQUEST
--============================================================

local function httpDownload(url, rscMode)
    if REQUEST then

        local headers = {
            ["Accept"] = "*/*",
            ["User-Agent"] = "Mozilla/5.0",
            ["Cache-Control"] = "no-cache",
            ["Pragma"] = "no-cache",
            ["Accept-Encoding"] = "identity",
        }

        if rscMode then
            headers["RSC"] = "1"
        end

        local ok, response =
            pcall(
                REQUEST,
                {
                    Url = url,
                    URL = url,

                    Method = "GET",

                    Headers = headers,
                }
            )

        if ok then

            if type(response) == "string" then
                return response, 200, nil
            end

            if type(response) == "table" then

                local body =
                    response.Body
                    or response.body

                local status =
                    response.StatusCode
                    or response.Status
                    or response.status_code
                    or 0

                if type(body) == "string" then
                    return body, tonumber(status) or 0, nil
                end
            end

            return nil, 0, "bad response type"

        else

            return nil, 0, tostring(response)
        end
    end

    --========================================================
    -- FALLBACK
    --========================================================

    local ok, body =
        pcall(function()
            return game:HttpGet(url, true)
        end)

    if ok and type(body) == "string" then
        return body, 200, nil
    end

    return nil, 0, tostring(body)
end

--============================================================
-- JSON OBJECT EXTRACTOR
--============================================================

local function extractJSONObject(text, startPosition)
    local depth = 0
    local inString = false
    local escaped = false

    local length = #text

    for i = startPosition, length do
        local byte = string.byte(text, i)

        if inString then

            if escaped then

                escaped = false

            elseif byte == 92 then

                escaped = true

            elseif byte == 34 then

                inString = false
            end

        else

            if byte == 34 then

                inString = true

            elseif byte == 123 then

                depth = depth + 1

            elseif byte == 125 then

                depth = depth - 1

                if depth == 0 then

                    return
                        string.sub(
                            text,
                            startPosition,
                            i
                        ),
                        i
                end
            end
        end
    end

    return nil, nil
end

--============================================================
-- AMVGG OBJECT CHECK
--============================================================

local POSSIBLE_VALUE_FIELDS = {
    "value",

    "npRegularValue",
    "regularValue",

    "fValue",
    "rValue",

    "npNeonValue",
    "neonValue",

    "nfValue",
    "nrValue",

    "npMegaValue",
    "megaValue",

    "mfValue",
    "mrValue",
}

local function objectHasValue(object)
    if type(object) ~= "table" then
        return false
    end

    if type(object.name) ~= "string" then
        return false
    end

    for _, field in ipairs(POSSIBLE_VALUE_FIELDS) do

        if object[field] ~= nil then
            return true
        end
    end

    return false
end

--============================================================
-- PARSE AMVGG BODY
--============================================================

local function parseAMVGGBody(body)
    local database = {}
    local count = 0

    if type(body) ~= "string" then
        return database, count
    end

    local cursor = 1
    local scanned = 0

    while cursor <= #body do

        local position =
            body:find(
                '{"id":"',
                cursor,
                true
            )

        if not position then
            break
        end

        local jsonText
        local endPosition

        jsonText, endPosition =
            extractJSONObject(
                body,
                position
            )

        if
            not jsonText
            or not endPosition
        then
            break
        end

        cursor = endPosition + 1

        local ok, object =
            pcall(function()
                return HttpService:JSONDecode(jsonText)
            end)

        if
            ok
            and objectHasValue(object)
        then

            local key =
                normalizeName(
                    object.name
                )

            if
                key ~= ""
                and database[key] == nil
            then

                database[key] = object
                count = count + 1
            end
        end

        scanned = scanned + 1

        if scanned % 200 == 0 then
            task.wait()
        end
    end

    return database, count
end

--============================================================
-- AMVGG CATEGORY DOWNLOADER
--============================================================

local function downloadAMVGGCategory(slug)
    local randomToken =
        tostring(os.time())
        .. tostring(
            math.random(
                10000,
                99999
            )
        )

    local attempts = {
        {
            url =
                "https://amvgg.com/values/"
                .. slug
                .. "?_rsc="
                .. randomToken,

            rsc = true,
        },

        {
            url =
                "https://amvgg.com/values/"
                .. slug
                .. "?_rsc=KaY_DfRKC2VA5oy5",

            rsc = true,
        },

        {
            url =
                "https://amvgg.com/values/"
                .. slug,

            rsc = false,
        },
    }

    for index, attempt in ipairs(attempts) do

        print(
            "[AMVGG]["
            .. slug
            .. "] TRY "
            .. index
            .. "/"
            .. #attempts
        )

        local body
        local status
        local requestError

        body, status, requestError =
            httpDownload(
                attempt.url,
                attempt.rsc
            )

        print(
            "[AMVGG]["
            .. slug
            .. "] STATUS =",
            status
        )

        if requestError then

            print(
                "[AMVGG]["
                .. slug
                .. "] REQUEST ERROR =",
                requestError
            )
        end

        if
            type(body) == "string"
            and #body > 100
        then

            print(
                "[AMVGG]["
                .. slug
                .. "] BODY SIZE =",
                #body
            )

            local database, count =
                parseAMVGGBody(body)

            print(
                "[AMVGG]["
                .. slug
                .. "] PARSED =",
                count
            )

            if count > 0 then

                return
                    database,
                    count,
                    nil
            end
        end

        task.wait(0.15)
    end

    return nil, 0, "all attempts failed"
end

--============================================================
-- LOAD AMVGG DATABASE
--============================================================

local function loadAMVGGDatabase()
    if AMVGG_STATE.loading then

        return false,
            "already loading"
    end

    AMVGG_STATE.loading = true
    AMVGG_STATE.error = nil

    print("[AMVGG] LOAD START")

    local success, result =
        xpcall(
            function()

                --================================================
                -- PETS
                --================================================

                local pets
                local petCount
                local petError

                pets, petCount, petError =
                    downloadAMVGGCategory(
                        "pets"
                    )

                --================================================
                -- EGGS
                --================================================

                local eggs
                local eggCount
                local eggError

                eggs, eggCount, eggError =
                    downloadAMVGGCategory(
                        "eggs"
                    )

                return {
                    pets = pets,
                    petCount = petCount,

                    eggs = eggs,
                    eggCount = eggCount,

                    petError = petError,
                    eggError = eggError,
                }

            end,

            safeTraceback
        )

    AMVGG_STATE.loading = false

    if not success then

        AMVGG_STATE.ready = false
        AMVGG_STATE.error = tostring(result)

        warn(
            "[AMVGG LOAD ERROR]\n"
            .. tostring(result)
        )

        return false,
            tostring(result)
    end

    local loadedAnything = false

    if
        type(result.pets) == "table"
        and result.petCount > 0
    then

        AMVGG_STATE.pets =
            result.pets

        AMVGG_STATE.petCount =
            result.petCount

        loadedAnything = true
    end

    if
        type(result.eggs) == "table"
        and result.eggCount > 0
    then

        AMVGG_STATE.eggs =
            result.eggs

        AMVGG_STATE.eggCount =
            result.eggCount

        loadedAnything = true
    end

    if loadedAnything then

        AMVGG_STATE.ready = true
        AMVGG_STATE.error = nil

        AMVGG_STATE.version =
            AMVGG_STATE.version + 1

        AMVGG_STATE.lastRefresh =
            os.time()

        print(
            "[AMVGG] READY",
            "PETS=",
            AMVGG_STATE.petCount,
            "EGGS=",
            AMVGG_STATE.eggCount
        )

        return true, nil
    end

    AMVGG_STATE.ready = false

    AMVGG_STATE.error =
        "PETS: "
        .. tostring(result.petError)
        .. " | EGGS: "
        .. tostring(result.eggError)

    warn(
        "[AMVGG] DATABASE EMPTY"
    )

    return false,
        AMVGG_STATE.error
end

--============================================================
-- FIND AMVGG ENTRY
--============================================================

local function findAMVGGEntry(item)
    if type(item) ~= "table" then
        return nil, nil
    end

    local name =
        getItemName(item)

    local key =
        normalizeName(name)

    local keyNoBrackets =
        normalizeWithoutBrackets(name)

    local lowerName =
        string.lower(name)

    --========================================================
    -- EGGS FIRST
    --========================================================

    if
        string.find(
            lowerName,
            "egg",
            1,
            true
        )
    then

        local egg =
            AMVGG_STATE.eggs[key]
            or AMVGG_STATE.eggs[keyNoBrackets]

        if egg then
            return egg, "eggs"
        end
    end

    --========================================================
    -- PETS
    --========================================================

    local pet =
        AMVGG_STATE.pets[key]
        or AMVGG_STATE.pets[keyNoBrackets]

    if pet then
        return pet, "pets"
    end

    --========================================================
    -- EGGS FALLBACK
    --========================================================

    local egg =
        AMVGG_STATE.eggs[key]
        or AMVGG_STATE.eggs[keyNoBrackets]

    if egg then
        return egg, "eggs"
    end

    return nil, nil
end

--============================================================
-- SIMPLE VALUE
--============================================================

local function getSimpleValue(entry)
    if type(entry) ~= "table" then
        return nil
    end

    local fields = {
        "value",
        "npRegularValue",
        "regularValue",
    }

    for _, field in ipairs(fields) do

        local value =
            toNumber(
                entry[field]
            )

        if value ~= nil then
            return value
        end
    end

    return nil
end

--============================================================
-- AMVGG ITEM ANALYSIS
--============================================================

local function analyzeItem(item)
    local result = {
        name = getItemName(item),

        category =
            getCategoryName(item),

        variant =
            getVariant(item),

        value = nil,
        demand = nil,

        source = nil,

        found = false,

        reason = nil,
    }

    if not AMVGG_STATE.ready then

        if AMVGG_STATE.loading then
            result.reason = "AMVGG LOADING"
        else
            result.reason = "AMVGG NOT READY"
        end

        return result
    end

    local entry
    local source

    entry, source =
        findAMVGGEntry(item)

    if not entry then

        result.reason =
            "NOT FOUND"

        return result
    end

    result.found = true
    result.source = source

    --========================================================
    -- PET
    --========================================================

    if source == "pets" then

        local variant =
            result.variant

        local valueField =
            PET_VALUE_FIELDS[
                variant
            ]

        local demandField =
            PET_DEMAND_FIELDS[
                variant
            ]

        if not valueField then

            result.reason =
                "NO VARIANT FIELD"

            return result
        end

        result.value =
            toNumber(
                entry[valueField]
            )

        result.demand =
            demandField
            and entry[demandField]
            or nil

        if result.value == nil then

            result.reason =
                "NO "
                .. tostring(variant)
                .. " VALUE"
        end

        return result
    end

    --========================================================
    -- EGG
    --========================================================

    if source == "eggs" then

        result.variant = ""

        result.value =
            getSimpleValue(entry)

        result.demand =
            entry.demand
            or entry.regularDemand

        if result.value == nil then
            result.reason = "NO EGG VALUE"
        end

        return result
    end

    result.reason = "UNKNOWN SOURCE"

    return result
end

--============================================================
-- PLAYER HELPERS
--============================================================

local function playerName(value)
    if typeof(value) == "Instance" then
        return value.Name
    end

    return tostring(
        value or "Unknown"
    )
end

local function isMe(value)
    if value == LocalPlayer then
        return true
    end

    return
        string.lower(
            playerName(value)
        )
        ==
        string.lower(
            LocalPlayer.Name
        )
end

--============================================================
-- 4/8 GUI CORE
--============================================================

setBoot("4/8", "CREATING GUI CORE")

local Gui = Instance.new("ScreenGui")

Gui.Name =
    "AdoptMeTradeAnalyzerV1153"

Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999999

Gui.Parent = GuiParent

--============================================================
-- MAIN
--============================================================

local Main = Instance.new("Frame")

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

Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0

Main.ClipsDescendants = true

Main.Parent = Gui

addCorner(Main, 12)
addStroke(Main, 0.15)

--============================================================
-- TOP
--============================================================

local Top = Instance.new("Frame")

Top.Size =
    UDim2.new(
        1,
        0,
        0,
        52
    )

Top.BackgroundColor3 = C.TOP
Top.BorderSizePixel = 0

Top.Parent = Main

makeLabel(
    Top,

    "ADOPT ME  •  TRADE ANALYZER",

    UDim2.new(
        0,
        370,
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

local Version =
    makeLabel(
        Top,

        "V11.5.3",

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

Version.BackgroundTransparency = 0

Version.BackgroundColor3 =
    Color3.fromRGB(
        35,
        50,
        80
    )

addCorner(Version, 6)

local CloseButton =
    makeButton(
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
-- MAIN WINDOW DRAG
--============================================================

local mainDragging = false
local mainDragStart
local mainDragOrigin

Top.InputBegan:Connect(function(input)

    if
        input.UserInputType
        == Enum.UserInputType.MouseButton1

        or input.UserInputType
        == Enum.UserInputType.Touch
    then

        mainDragging = true

        mainDragStart =
            input.Position

        mainDragOrigin =
            Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not mainDragging then
        return
    end

    if
        input.UserInputType
        ~= Enum.UserInputType.MouseMovement

        and input.UserInputType
        ~= Enum.UserInputType.Touch
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
        - mainDragStart

    local startX =
        mainDragOrigin.X.Scale
        * viewport.X
        + mainDragOrigin.X.Offset

    local startY =
        mainDragOrigin.Y.Scale
        * viewport.Y
        + mainDragOrigin.Y.Offset

    local x =
        startX + delta.X

    local y =
        startY + delta.Y

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
end)

UserInputService.InputEnded:Connect(function(input)

    if
        input.UserInputType
        == Enum.UserInputType.MouseButton1

        or input.UserInputType
        == Enum.UserInputType.Touch
    then

        mainDragging = false
    end
end)

--============================================================
-- SIDEBAR
--============================================================

local Sidebar = Instance.new("Frame")

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

Sidebar.BackgroundColor3 = C.SIDE
Sidebar.BorderSizePixel = 0

Sidebar.Parent = Main

makeLabel(
    Sidebar,

    "MENU",

    UDim2.new(
        1,
        -25,
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

--============================================================
-- CONTENT
--============================================================

local Content = Instance.new("Frame")

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

Content.BackgroundTransparency = 1

Content.Parent = Main

--============================================================
-- PAGES
--============================================================

local Pages = {}
local NavButtons = {}

local CurrentPage = nil

local function createPage(name)
    local page = Instance.new("Frame")

    page.Name = name

    page.Size =
        UDim2.fromScale(
            1,
            1
        )

    page.BackgroundTransparency = 1

    page.Visible = false

    page.Parent = Content

    Pages[name] = page

    return page
end

local function switchPage(name)
    CurrentPage = name

    for pageName, page in pairs(Pages) do

        page.Visible =
            pageName == name
    end

    for buttonName, navButton in pairs(NavButtons) do

        local active =
            buttonName == name

        if active then

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

local function createNavigation(name, y)
    local navButton =
        makeButton(
            Sidebar,

            "   " .. name,

            UDim2.new(
                1,
                -20,
                0,
                42
            ),

            UDim2.fromOffset(
                10,
                y
            )
        )

    navButton.BackgroundColor3 = C.PANEL

    navButton.TextColor3 = C.MUTED

    navButton.TextXAlignment =
        Enum.TextXAlignment.Left

    navButton.Activated:Connect(function()

        switchPage(name)
    end)

    NavButtons[name] =
        navButton
end

createNavigation("TRADE", 46)
createNavigation("VALUES", 96)
createNavigation("UPDATES", 146)
createNavigation("SETTINGS", 196)

--============================================================
-- 5/8 TRADE GUI
--============================================================

setBoot("5/8", "CREATING TRADE GUI")

local TradePage =
    createPage("TRADE")

makeLabel(
    TradePage,

    "Current Trade",

    UDim2.new(
        0,
        260,
        0,
        35
    ),

    UDim2.fromOffset(
        18,
        5
    ),

    Enum.Font.GothamBold,
    20,
    C.TEXT
)

local CountsLabel =
    makeLabel(
        TradePage,

        "YOU 0/18   •   THEM 0/18",

        UDim2.new(
            0,
            330,
            0,
            20
        ),

        UDim2.fromOffset(
            19,
            37
        ),

        Enum.Font.Code,
        11,
        C.MUTED
    )

local AMVGGStatus =
    makeLabel(
        TradePage,

        "AMVGG: WAITING",

        UDim2.new(
            0,
            500,
            0,
            20
        ),

        UDim2.fromOffset(
            19,
            54
        ),

        Enum.Font.Code,
        9,
        C.YELLOW
    )

local StageLabel =
    makeLabel(
        TradePage,

        "NO ACTIVE TRADE",

        UDim2.fromOffset(
            165,
            28
        ),

        UDim2.new(
            1,
            -183,
            0,
            14
        ),

        Enum.Font.GothamBold,
        10,
        C.MUTED,
        Enum.TextXAlignment.Center
    )

StageLabel.BackgroundTransparency = 0
StageLabel.BackgroundColor3 = C.PANEL2

addCorner(StageLabel, 7)

--============================================================
-- TRADE AREA
--============================================================

local TradeArea =
    Instance.new("Frame")

TradeArea.Position =
    UDim2.fromOffset(
        16,
        77
    )

TradeArea.Size =
    UDim2.new(
        1,
        -32,
        1,
        -89
    )

TradeArea.BackgroundColor3 = C.PANEL
TradeArea.BorderSizePixel = 0

TradeArea.Parent = TradePage

addCorner(TradeArea, 10)
addStroke(TradeArea, 0.35)

--============================================================
-- CENTER
--============================================================

local Center =
    Instance.new("Frame")

Center.Position =
    UDim2.new(
        0.435,
        0,
        0,
        0
    )

Center.Size =
    UDim2.new(
        0.13,
        0,
        1,
        0
    )

Center.BackgroundTransparency = 1

Center.Parent = TradeArea

makeLabel(
    Center,

    "⇄",

    UDim2.new(
        1,
        0,
        0,
        60
    ),

    UDim2.new(
        0,
        0,
        0.5,
        -76
    ),

    Enum.Font.GothamBold,
    42,
    C.ACCENT,
    Enum.TextXAlignment.Center
)

local ResultLabel =
    makeLabel(
        Center,

        "WAIT",

        UDim2.new(
            1,
            0,
            0,
            30
        ),

        UDim2.new(
            0,
            0,
            0.5,
            -5
        ),

        Enum.Font.GothamBold,
        13,
        C.MUTED,
        Enum.TextXAlignment.Center
    )

local DifferenceLabel =
    makeLabel(
        Center,

        "",

        UDim2.new(
            1,
            0,
            0,
            42
        ),

        UDim2.new(
            0,
            0,
            0.5,
            24
        ),

        Enum.Font.Code,
        9,
        C.MUTED,
        Enum.TextXAlignment.Center
    )

DifferenceLabel.TextWrapped = true

--============================================================
-- OFFER PANEL
--============================================================

local function createOfferPanel(xScale)
    local panel =
        Instance.new("Frame")

    panel.Position =
        UDim2.new(
            xScale,
            0,
            0,
            8
        )

    panel.Size =
        UDim2.new(
            0.425,
            0,
            1,
            -16
        )

    panel.BackgroundColor3 = C.PANEL2
    panel.BorderSizePixel = 0

    panel.Parent = TradeArea

    addCorner(panel, 9)

    --========================================================
    -- PLAYER
    --========================================================

    local Name =
        makeLabel(
            panel,

            "PLAYER",

            UDim2.new(
                1,
                -20,
                0,
                27
            ),

            UDim2.fromOffset(
                10,
                4
            ),

            Enum.Font.GothamBold,
            14,
            C.TEXT,
            Enum.TextXAlignment.Center
        )

    --========================================================
    -- COUNT
    --========================================================

    local Count =
        makeLabel(
            panel,

            "0 / 18",

            UDim2.fromOffset(
                60,
                18
            ),

            UDim2.fromOffset(
                8,
                31
            ),

            Enum.Font.Code,
            9,
            C.MUTED
        )

    --========================================================
    -- READY
    --========================================================

    local Ready =
        makeLabel(
            panel,

            "WAITING",

            UDim2.fromOffset(
                82,
                20
            ),

            UDim2.new(
                1,
                -90,
                0,
                30
            ),

            Enum.Font.GothamBold,
            9,
            C.MUTED,
            Enum.TextXAlignment.Center
        )

    Ready.BackgroundTransparency = 0

    Ready.BackgroundColor3 =
        Color3.fromRGB(
            39,
            43,
            52
        )

    addCorner(Ready, 5)

    --========================================================
    -- TOTAL
    --========================================================

    local Total =
        makeLabel(
            panel,

            "TOTAL: 0",

            UDim2.new(
                1,
                -16,
                0,
                20
            ),

            UDim2.fromOffset(
                8,
                50
            ),

            Enum.Font.GothamBold,
            10,
            C.ACCENT,
            Enum.TextXAlignment.Center
        )

    --========================================================
    -- SCROLL
    --========================================================

    local Scroll =
        Instance.new("ScrollingFrame")

    Scroll.Position =
        UDim2.fromOffset(
            7,
            73
        )

    Scroll.Size =
        UDim2.new(
            1,
            -14,
            1,
            -80
        )

    Scroll.BackgroundColor3 =
        Color3.fromRGB(
            23,
            26,
            33
        )

    Scroll.BackgroundTransparency = 0.12

    Scroll.BorderSizePixel = 0

    Scroll.ScrollBarThickness = 6

    Scroll.ScrollBarImageColor3 =
        C.ACCENT

    Scroll.ScrollingDirection =
        Enum.ScrollingDirection.Y

    Scroll.ElasticBehavior =
        Enum.ElasticBehavior.Never

    Scroll.CanvasSize =
        UDim2.fromOffset(
            0,
            0
        )

    Scroll.Parent = panel

    addCorner(Scroll, 7)

    --========================================================
    -- GRID
    --========================================================

    local Grid =
        Instance.new("UIGridLayout")

    Grid.CellSize =
        UDim2.new(
            0.313,
            0,
            0,
            82
        )

    Grid.CellPadding =
        UDim2.new(
            0.018,
            0,
            0,
            7
        )

    Grid.FillDirectionMaxCells = 3

    Grid.SortOrder =
        Enum.SortOrder.LayoutOrder

    Grid.Parent = Scroll

    --========================================================
    -- PADDING
    --========================================================

    local Padding =
        Instance.new("UIPadding")

    Padding.PaddingLeft =
        UDim.new(
            0,
            5
        )

    Padding.PaddingRight =
        UDim.new(
            0,
            7
        )

    Padding.PaddingTop =
        UDim.new(
            0,
            5
        )

    Padding.PaddingBottom =
        UDim.new(
            0,
            5
        )

    Padding.Parent = Scroll

    --========================================================
    -- REAL CANVAS HEIGHT
    --========================================================

    local function updateCanvas()
        Scroll.CanvasSize =
            UDim2.fromOffset(
                0,
                Grid.AbsoluteContentSize.Y
                + 14
            )
    end

    Grid:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(
        updateCanvas
    )

    task.defer(updateCanvas)

    return {
        Panel = panel,

        Name = Name,
        Count = Count,
        Ready = Ready,
        Total = Total,

        Scroll = Scroll,
        Grid = Grid,

        Slots = {},
    }
end

local Yours =
    createOfferPanel(
        0.008
    )

local Theirs =
    createOfferPanel(
        0.567
    )

--============================================================
-- SLOT CREATION
--============================================================

local function createSlot(side, index)
    local Slot =
        Instance.new("TextButton")

    Slot.LayoutOrder = index

    Slot.BackgroundColor3 = C.SLOT
    Slot.BorderSizePixel = 0

    Slot.AutoButtonColor = false
    Slot.Text = ""

    Slot.Parent = side.Scroll

    addCorner(Slot, 7)
    addStroke(Slot, 0.5)

    --========================================================
    -- INDEX
    --========================================================

    makeLabel(
        Slot,

        "#" .. tostring(index),

        UDim2.fromOffset(
            28,
            15
        ),

        UDim2.fromOffset(
            5,
            3
        ),

        Enum.Font.Code,
        8,
        C.MUTED
    )

    --========================================================
    -- VARIANT
    --========================================================

    local Variant =
        makeLabel(
            Slot,

            "",

            UDim2.fromOffset(
                46,
                15
            ),

            UDim2.new(
                1,
                -51,
                0,
                3
            ),

            Enum.Font.GothamBold,
            8,
            C.ACCENT,
            Enum.TextXAlignment.Right
        )

    --========================================================
    -- NAME
    --========================================================

    local Name =
        makeLabel(
            Slot,

            "EMPTY",

            UDim2.new(
                1,
                -10,
                0,
                34
            ),

            UDim2.fromOffset(
                5,
                17
            ),

            Enum.Font.GothamBold,
            9,

            Color3.fromRGB(
                95,
                101,
                115
            ),

            Enum.TextXAlignment.Center
        )

    Name.TextWrapped = true

    --========================================================
    -- VALUE
    --========================================================

    local Value =
        makeLabel(
            Slot,

            "",

            UDim2.new(
                1,
                -8,
                0,
                15
            ),

            UDim2.new(
                0,
                4,
                1,
                -30
            ),

            Enum.Font.GothamBold,
            8,
            C.ACCENT,
            Enum.TextXAlignment.Center
        )

    --========================================================
    -- CATEGORY
    --========================================================

    local Category =
        makeLabel(
            Slot,

            "",

            UDim2.new(
                1,
                -8,
                0,
                13
            ),

            UDim2.new(
                0,
                4,
                1,
                -16
            ),

            Enum.Font.GothamBold,
            7,
            C.MUTED,
            Enum.TextXAlignment.Center
        )

    local data = {
        Frame = Slot,

        Variant = Variant,
        Name = Name,
        Value = Value,
        Category = Category,

        Item = nil,
        Analysis = nil,
    }

    side.Slots[index] = data

    Slot.MouseEnter:Connect(function()

        if data.Item then
            Slot.BackgroundColor3 =
                C.SLOT_HOVER
        end
    end)

    Slot.MouseLeave:Connect(function()

        Slot.BackgroundColor3 =
            C.SLOT
    end)

    return data
end

--============================================================
-- EXACTLY 18 SLOTS EACH SIDE
--============================================================

for i = 1, 18 do

    createSlot(Yours, i)
    createSlot(Theirs, i)
end

--============================================================
-- SLOT STATE
--============================================================

local function clearSlot(slot)
    slot.Item = nil
    slot.Analysis = nil

    slot.Name.Text = "EMPTY"

    slot.Name.TextColor3 =
        Color3.fromRGB(
            95,
            101,
            115
        )

    slot.Variant.Text = ""

    slot.Value.Text = ""

    slot.Category.Text = ""

    slot.Frame.BackgroundColor3 =
        C.SLOT
end

local function fillSlot(slot, item)
    slot.Item = item

    local analysis =
        analyzeItem(item)

    slot.Analysis = analysis

    slot.Name.Text =
        analysis.name

    slot.Name.TextColor3 =
        C.TEXT

    slot.Variant.Text =
        analysis.variant

    slot.Variant.TextColor3 =
        variantColor(
            analysis.variant
        )

    slot.Category.Text =
        analysis.category

    --========================================================
    -- VALUE
    --========================================================

    if analysis.value ~= nil then

        slot.Value.Text =
            "V "
            .. numberText(
                analysis.value
            )

        slot.Value.TextColor3 =
            C.ACCENT

        return analysis.value, true
    end

    slot.Value.Text = "V ?"

    if AMVGG_STATE.loading then

        slot.Value.TextColor3 =
            C.YELLOW

    elseif analysis.reason == "NOT FOUND" then

        slot.Value.TextColor3 =
            C.RED

    else

        slot.Value.TextColor3 =
            C.MUTED
    end

    return 0, false
end

--============================================================
-- SIDE UPDATE
--============================================================

local function updateSide(side, offer)
    local items = {}

    if
        type(offer) == "table"
        and type(offer.items) == "table"
    then
        items = offer.items
    end

    local count = #items

    local total = 0
    local unknown = 0

    side.Count.Text =
        tostring(count)
        .. " / 18"

    for i = 1, 18 do

        local item =
            items[i]

        if item then

            local value, known =
                fillSlot(
                    side.Slots[i],
                    item
                )

            if known then

                total =
                    total + value

            else

                unknown =
                    unknown + 1
            end

        else

            clearSlot(
                side.Slots[i]
            )
        end
    end

    --========================================================
    -- TOTAL
    --========================================================

    if count == 0 then

        side.Total.Text =
            "TOTAL: 0"

        side.Total.TextColor3 =
            C.MUTED

    elseif unknown == 0 then

        side.Total.Text =
            "TOTAL: "
            .. numberText(total)

        side.Total.TextColor3 =
            C.ACCENT

    else

        side.Total.Text =
            "KNOWN: "
            .. numberText(total)
            .. "  •  ?x"
            .. tostring(unknown)

        side.Total.TextColor3 =
            C.YELLOW
    end

    --========================================================
    -- READY STATE
    --========================================================

    if type(offer) ~= "table" then

        side.Ready.Text =
            "WAITING"

        side.Ready.TextColor3 =
            C.MUTED

    elseif offer.confirmed == true then

        side.Ready.Text =
            "CONFIRMED"

        side.Ready.TextColor3 =
            C.GREEN

    elseif offer.negotiated == true then

        side.Ready.Text =
            "ACCEPTED"

        side.Ready.TextColor3 =
            C.GREEN

    else

        side.Ready.Text =
            "WAITING"

        side.Ready.TextColor3 =
            C.MUTED
    end

    return {
        count = count,

        total = total,

        unknown = unknown,
    }
end

--============================================================
-- OFFER SIGNATURE
--============================================================

local function offerSignature(offer)
    if
        type(offer) ~= "table"
        or type(offer.items) ~= "table"
    then

        return "-"
    end

    local result = {}

    for index, item in ipairs(offer.items) do

        result[#result + 1] =
            tostring(
                item.unique
                or item.kind
                or index
            )
    end

    result[#result + 1] =
        tostring(
            offer.negotiated
        )

    result[#result + 1] =
        tostring(
            offer.confirmed
        )

    return
        table.concat(
            result,
            "|"
        )
end

local LastTradeSignature = nil

--============================================================
-- RESULT CALCULATION
--============================================================

local FAIR_PERCENT = 0.02

local function updateTradeResult(
    yourData,
    theirData
)

    if
        yourData.unknown > 0
        or theirData.unknown > 0
    then

        ResultLabel.Text =
            "INCOMPLETE"

        ResultLabel.TextColor3 =
            C.YELLOW

        DifferenceLabel.Text =
            "missing values"

        DifferenceLabel.TextColor3 =
            C.MUTED

        return
    end

    if
        yourData.count == 0
        and theirData.count == 0
    then

        ResultLabel.Text =
            "WAIT"

        ResultLabel.TextColor3 =
            C.MUTED

        DifferenceLabel.Text = ""

        return
    end

    local difference =
        theirData.total
        - yourData.total

    local reference =
        math.max(
            math.abs(yourData.total),
            math.abs(theirData.total),
            0.000001
        )

    local percent =
        math.abs(difference)
        / reference

    local prefix =
        difference >= 0
        and "+"
        or ""

    DifferenceLabel.Text =
        prefix
        .. numberText(
            difference
        )

    if percent <= FAIR_PERCENT then

        ResultLabel.Text =
            "FAIR"

        ResultLabel.TextColor3 =
            C.YELLOW

        return
    end

    if difference > 0 then

        ResultLabel.Text =
            "WIN"

        ResultLabel.TextColor3 =
            C.GREEN

        return
    end

    ResultLabel.Text =
        "LOSE"

    ResultLabel.TextColor3 =
        C.RED
end

--============================================================
-- NO TRADE
--============================================================

local function showNoTrade()
    Yours.Name.Text =
        LocalPlayer.Name

    Theirs.Name.Text =
        "NO PARTNER"

    StageLabel.Text =
        "NO ACTIVE TRADE"

    StageLabel.BackgroundColor3 =
        C.PANEL2

    StageLabel.TextColor3 =
        C.MUTED

    local yourData =
        updateSide(
            Yours,
            nil
        )

    local theirData =
        updateSide(
            Theirs,
            nil
        )

    CountsLabel.Text =
        "YOU "
        .. tostring(yourData.count)
        .. "/18   •   THEM "
        .. tostring(theirData.count)
        .. "/18"

    updateTradeResult(
        yourData,
        theirData
    )
end

--============================================================
-- TRADE UPDATE
--============================================================

local function updateTrade()
    local ok, trade =
        pcall(function()

            return
                ClientData.get(
                    "trade"
                )
        end)

    if
        not ok
        or type(trade) ~= "table"
    then

        showNoTrade()
        return
    end

    local myOffer
    local theirOffer

    local me
    local partner

    if isMe(trade.sender) then

        myOffer =
            trade.sender_offer

        theirOffer =
            trade.recipient_offer

        me =
            trade.sender

        partner =
            trade.recipient

    else

        myOffer =
            trade.recipient_offer

        theirOffer =
            trade.sender_offer

        me =
            trade.recipient

        partner =
            trade.sender
    end

    local signature =
        tostring(
            trade.trade_id
        )
        .. "::"
        .. tostring(
            trade.current_stage
        )
        .. "::"
        .. offerSignature(
            myOffer
        )
        .. "::"
        .. offerSignature(
            theirOffer
        )
        .. "::AMVGG:"
        .. tostring(
            AMVGG_STATE.version
        )

    if signature == LastTradeSignature then
        return
    end

    LastTradeSignature =
        signature

    --========================================================
    -- NAMES
    --========================================================

    Yours.Name.Text =
        playerName(me)

    Theirs.Name.Text =
        playerName(partner)

    --========================================================
    -- STAGE
    --========================================================

    local stage =
        tostring(
            trade.current_stage
            or "unknown"
        )

    StageLabel.Text =
        string.upper(stage)

    if stage == "negotiation" then

        StageLabel.BackgroundColor3 =
            Color3.fromRGB(
                48,
                76,
                130
            )

        StageLabel.TextColor3 =
            C.TEXT

    elseif
        string.find(
            stage,
            "confirm",
            1,
            true
        )
    then

        StageLabel.BackgroundColor3 =
            Color3.fromRGB(
                105,
                76,
                36
            )

        StageLabel.TextColor3 =
            Color3.fromRGB(
                255,
                220,
                150
            )

    else

        StageLabel.BackgroundColor3 =
            C.PANEL2

        StageLabel.TextColor3 =
            C.TEXT
    end

    --========================================================
    -- SIDES
    --========================================================

    local yourData =
        updateSide(
            Yours,
            myOffer
        )

    local theirData =
        updateSide(
            Theirs,
            theirOffer
        )

    CountsLabel.Text =
        "YOU "
        .. tostring(yourData.count)
        .. "/18   •   THEM "
        .. tostring(theirData.count)
        .. "/18"

    updateTradeResult(
        yourData,
        theirData
    )
end

--============================================================
-- 6/8 VALUES GUI
--============================================================

setBoot("6/8", "CREATING VALUES / UPDATES / SETTINGS")

local ValuesPage =
    createPage("VALUES")

makeLabel(
    ValuesPage,

    "AMVGG Values",

    UDim2.new(
        1,
        -40,
        0,
        42
    ),

    UDim2.fromOffset(
        20,
        14
    ),

    Enum.Font.GothamBold,
    21,
    C.TEXT
)

local ValuesStatus =
    makeLabel(
        ValuesPage,

        "AMVGG: WAITING",

        UDim2.new(
            1,
            -40,
            0,
            22
        ),

        UDim2.fromOffset(
            21,
            51
        ),

        Enum.Font.Code,
        10,
        C.YELLOW
    )

--============================================================
-- SEARCH INPUT
--============================================================

local SearchBox =
    Instance.new("TextBox")

SearchBox.Position =
    UDim2.fromOffset(
        20,
        84
    )

SearchBox.Size =
    UDim2.new(
        0.64,
        -20,
        0,
        34
    )

SearchBox.BackgroundColor3 =
    C.PANEL

SearchBox.BorderSizePixel = 0

SearchBox.Text = ""

SearchBox.PlaceholderText =
    "Pilot Gull"

SearchBox.PlaceholderColor3 =
    C.MUTED

SearchBox.TextColor3 =
    C.TEXT

SearchBox.Font =
    Enum.Font.Code

SearchBox.TextSize = 11

SearchBox.ClearTextOnFocus = false

SearchBox.Parent =
    ValuesPage

addCorner(SearchBox, 7)

local SearchButton =
    makeButton(
        ValuesPage,

        "SEARCH",

        UDim2.fromOffset(
            85,
            34
        ),

        UDim2.new(
            0.64,
            0,
            0,
            84
        )
    )

local RefreshButton =
    makeButton(
        ValuesPage,

        "REFRESH",

        UDim2.fromOffset(
            88,
            34
        ),

        UDim2.new(
            0.64,
            93,
            0,
            84
        )
    )

--============================================================
-- RESULTS
--============================================================

local ResultBox =
    Instance.new("TextBox")

ResultBox.Position =
    UDim2.fromOffset(
        20,
        130
    )

ResultBox.Size =
    UDim2.new(
        1,
        -40,
        1,
        -150
    )

ResultBox.BackgroundColor3 =
    C.PANEL

ResultBox.BorderSizePixel = 0

ResultBox.ClearTextOnFocus = false

ResultBox.MultiLine = true
ResultBox.TextWrapped = false

ResultBox.Font =
    Enum.Font.Code

ResultBox.TextSize = 11

ResultBox.TextColor3 =
    C.TEXT

ResultBox.TextXAlignment =
    Enum.TextXAlignment.Left

ResultBox.TextYAlignment =
    Enum.TextYAlignment.Top

ResultBox.Text =
    "AMVGG database is loading..."

ResultBox.Parent =
    ValuesPage

addCorner(ResultBox, 8)

--============================================================
-- SHOW PET ENTRY
--============================================================

local function formatPetEntry(entry)
    local lines = {
        "NAME = "
        .. tostring(
            entry.name
        ),

        "SOURCE = PETS",

        "ORIGIN = "
        .. tostring(
            entry.origin
            or "?"
        ),

        "",
    }

    local variants = {
        {"NP", "npRegularValue"},
        {"F", "fValue"},
        {"R", "rValue"},
        {"FR", "regularValue"},

        {"N", "npNeonValue"},
        {"NF", "nfValue"},
        {"NR", "nrValue"},
        {"NFR", "neonValue"},

        {"M", "npMegaValue"},
        {"MF", "mfValue"},
        {"MR", "mrValue"},
        {"MFR", "megaValue"},
    }

    for _, variant in ipairs(variants) do

        lines[#lines + 1] =
            string.format(
                "%-4s = %s",
                variant[1],
                tostring(
                    entry[
                        variant[2]
                    ]
                )
            )
    end

    lines[#lines + 1] = ""

    lines[#lines + 1] =
        "UPDATED = "
        .. tostring(
            entry.lastUpdatedAt
            or "?"
        )

    return
        table.concat(
            lines,
            "\n"
        )
end

--============================================================
-- SHOW EGG
--============================================================

local function formatEggEntry(entry)
    return
        "NAME = "
        .. tostring(entry.name)
        .. "\n"
        .. "SOURCE = EGGS"
        .. "\n"
        .. "VALUE = "
        .. tostring(
            getSimpleValue(entry)
        )
        .. "\n"
        .. "DEMAND = "
        .. tostring(
            entry.demand
            or entry.regularDemand
            or "?"
        )
        .. "\n"
        .. "UPDATED = "
        .. tostring(
            entry.lastUpdatedAt
            or "?"
        )
end

--============================================================
-- SEARCH AMVGG
--============================================================

local function searchAMVGG()
    if AMVGG_STATE.loading then

        ResultBox.Text =
            "AMVGG is still loading..."

        return
    end

    if not AMVGG_STATE.ready then

        ResultBox.Text =
            "AMVGG is not ready.\n\n"
            .. tostring(
                AMVGG_STATE.error
                or "No database"
            )

        return
    end

    local query =
        normalizeName(
            SearchBox.Text
        )

    if query == "" then

        ResultBox.Text =
            "Enter item name."

        return
    end

    local pet =
        AMVGG_STATE.pets[query]

    if pet then

        ResultBox.Text =
            formatPetEntry(pet)

        return
    end

    local egg =
        AMVGG_STATE.eggs[query]

    if egg then

        ResultBox.Text =
            formatEggEntry(egg)

        return
    end

    --========================================================
    -- PARTIAL SEARCH
    --========================================================

    local found = {}
    local used = {}

    for key, entry in pairs(AMVGG_STATE.pets) do

        if
            string.find(
                key,
                query,
                1,
                true
            )
        then

            local text =
                tostring(entry.name)
                .. " [PET]"

            if not used[text] then

                used[text] = true

                found[#found + 1] =
                    text
            end
        end

        if #found >= 30 then
            break
        end
    end

    if #found < 30 then

        for key, entry in pairs(AMVGG_STATE.eggs) do

            if
                string.find(
                    key,
                    query,
                    1,
                    true
                )
            then

                local text =
                    tostring(entry.name)
                    .. " [EGG]"

                if not used[text] then

                    used[text] = true

                    found[#found + 1] =
                        text
                end
            end

            if #found >= 30 then
                break
            end
        end
    end

    if #found == 0 then

        ResultBox.Text =
            "Not found: "
            .. SearchBox.Text

        return
    end

    table.sort(found)

    ResultBox.Text =
        "MATCHES:\n\n"
        .. table.concat(
            found,
            "\n"
        )
end

SearchButton.Activated:Connect(
    searchAMVGG
)

SearchBox.FocusLost:Connect(function(enterPressed)

    if enterPressed then
        searchAMVGG()
    end
end)

--============================================================
-- UPDATES PAGE
--============================================================

local UpdatesPage =
    createPage("UPDATES")

makeLabel(
    UpdatesPage,

    "Updates",

    UDim2.new(
        1,
        -40,
        0,
        45
    ),

    UDim2.fromOffset(
        22,
        18
    ),

    Enum.Font.GothamBold,
    21,
    C.TEXT
)

local UpdatesInfo =
    makeLabel(
        UpdatesPage,

        "Current phase:\n\n"
        .. "• AMVGG live database\n"
        .. "• Pets + Eggs\n"
        .. "• Exact pet variants\n\n"
        .. "Next:\n"
        .. "• detect new AMVGG items\n"
        .. "• old value → new value\n"
        .. "• 20-24 hour new-item protection",

        UDim2.new(
            1,
            -44,
            0,
            250
        ),

        UDim2.fromOffset(
            22,
            70
        ),

        Enum.Font.Code,
        12,
        C.MUTED
    )

UpdatesInfo.TextYAlignment =
    Enum.TextYAlignment.Top

--============================================================
-- SETTINGS PAGE
--============================================================

local SettingsPage =
    createPage("SETTINGS")

makeLabel(
    SettingsPage,

    "Settings",

    UDim2.new(
        1,
        -40,
        0,
        45
    ),

    UDim2.fromOffset(
        22,
        18
    ),

    Enum.Font.GothamBold,
    21,
    C.TEXT
)

local SettingsInfo =
    makeLabel(
        SettingsPage,

        "TRADE SLOTS             18\n\n"
        .. "AMVGG PETS             ON\n\n"
        .. "AMVGG EGGS             ON\n\n"
        .. "FAIR RANGE              ±2%\n\n"
        .. "UNKNOWN VALUE           BLOCK RESULT\n\n"
        .. "NEW ITEM COOLDOWN       NEXT\n\n"
        .. "AUTO ACCEPT             OFF",

        UDim2.new(
            1,
            -44,
            0,
            280
        ),

        UDim2.fromOffset(
            22,
            70
        ),

        Enum.Font.Code,
        13,
        C.MUTED
    )

SettingsInfo.TextYAlignment =
    Enum.TextYAlignment.Top

--============================================================
-- AMVGG GUI STATUS
--============================================================

local function refreshAMVGGStatus()
    local text
    local color

    if AMVGG_STATE.loading then

        text =
            "AMVGG: LOADING..."

        color =
            C.YELLOW

    elseif AMVGG_STATE.ready then

        text =
            "AMVGG LIVE • P:"
            .. tostring(
                AMVGG_STATE.petCount
            )
            .. " E:"
            .. tostring(
                AMVGG_STATE.eggCount
            )

        color =
            C.GREEN

    elseif AMVGG_STATE.error then

        text =
            "AMVGG ERROR"

        color =
            C.RED

    else

        text =
            "AMVGG: WAITING"

        color =
            C.YELLOW
    end

    AMVGGStatus.Text = text
    AMVGGStatus.TextColor3 = color

    ValuesStatus.Text = text
    ValuesStatus.TextColor3 = color

    if
        AMVGG_STATE.ready
        and ResultBox.Text
        == "AMVGG database is loading..."
    then

        ResultBox.Text =
            "DATABASE READY\n\n"
            .. "Pets: "
            .. tostring(
                AMVGG_STATE.petCount
            )
            .. "\n"
            .. "Eggs: "
            .. tostring(
                AMVGG_STATE.eggCount
            )
            .. "\n\n"
            .. "Search for an item."
    end
end

--============================================================
-- SAFE AMVGG REFRESH
--============================================================

local function safeRefreshAMVGG()
    if AMVGG_STATE.loading then

        print(
            "[AMVGG] REFRESH SKIPPED - ALREADY LOADING"
        )

        return
    end

    print(
        "[AMVGG] SAFE REFRESH START"
    )

    AMVGGStatus.Text =
        "AMVGG: LOADING..."

    AMVGGStatus.TextColor3 =
        C.YELLOW

    ValuesStatus.Text =
        "AMVGG: LOADING..."

    ValuesStatus.TextColor3 =
        C.YELLOW

    --========================================================
    -- IMPORTANT:
    --
    -- DO NOT SET loading=true HERE.
    --
    -- loadAMVGGDatabase() owns loading.
    --========================================================

    local ok, successOrError =
        xpcall(
            function()

                local success, err =
                    loadAMVGGDatabase()

                if not success then
                    error(
                        err
                        or "AMVGG load failed"
                    )
                end

            end,

            safeTraceback
        )

    if not ok then

        AMVGG_STATE.loading = false

        if not AMVGG_STATE.ready then

            AMVGG_STATE.error =
                tostring(
                    successOrError
                )
        end

        warn(
            "[AMVGG SAFE REFRESH ERROR]\n"
            .. tostring(
                successOrError
            )
        )
    end

    refreshAMVGGStatus()

    --========================================================
    -- FORCE CURRENT TRADE RECALC
    --========================================================

    LastTradeSignature = nil

    pcall(updateTrade)

    print(
        "[AMVGG] SAFE REFRESH DONE",
        "READY=",
        AMVGG_STATE.ready,
        "PETS=",
        AMVGG_STATE.petCount,
        "EGGS=",
        AMVGG_STATE.eggCount
    )
end

RefreshButton.Activated:Connect(function()

    task.spawn(
        safeRefreshAMVGG
    )
end)

--============================================================
-- FLOATING OPEN BUTTON
--============================================================

local OpenButton =
    Instance.new("TextButton")

OpenButton.Name =
    "OpenAnalyzer"

OpenButton.Size =
    UDim2.fromOffset(
        62,
        62
    )

OpenButton.Position =
    UDim2.new(
        1,
        -78,
        0.52,
        -31
    )

OpenButton.BackgroundColor3 =
    Color3.fromRGB(
        48,
        76,
        130
    )

OpenButton.BorderSizePixel = 0

OpenButton.Text = "AM"

OpenButton.Font =
    Enum.Font.GothamBold

OpenButton.TextSize = 17
OpenButton.TextColor3 = C.TEXT

OpenButton.Visible = false

OpenButton.ZIndex = 999999

OpenButton.Parent = Gui

addCorner(OpenButton, 17)
addStroke(OpenButton, 0.1)

--============================================================
-- OPEN BUTTON DRAG
--============================================================

local openDragging = false
local openMoved = false

local openStart
local openOrigin

OpenButton.InputBegan:Connect(function(input)

    if
        input.UserInputType
        == Enum.UserInputType.MouseButton1

        or input.UserInputType
        == Enum.UserInputType.Touch
    then

        openDragging = true
        openMoved = false

        openStart =
            input.Position

        openOrigin =
            OpenButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not openDragging then
        return
    end

    if
        input.UserInputType
        ~= Enum.UserInputType.MouseMovement

        and input.UserInputType
        ~= Enum.UserInputType.Touch
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
        - openStart

    if
        math.abs(delta.X) > 6
        or math.abs(delta.Y) > 6
    then

        openMoved = true
    end

    local startX =
        openOrigin.X.Scale
        * viewport.X
        + openOrigin.X.Offset

    local startY =
        openOrigin.Y.Scale
        * viewport.Y
        + openOrigin.Y.Offset

    local x =
        startX
        + delta.X

    local y =
        startY
        + delta.Y

    x =
        math.clamp(
            x,
            0,
            math.max(
                0,
                viewport.X
                - OpenButton.AbsoluteSize.X
            )
        )

    y =
        math.clamp(
            y,
            0,
            math.max(
                0,
                viewport.Y
                - OpenButton.AbsoluteSize.Y
            )
        )

    OpenButton.Position =
        UDim2.fromOffset(
            x,
            y
        )
end)

UserInputService.InputEnded:Connect(function(input)

    if
        input.UserInputType
        == Enum.UserInputType.MouseButton1

        or input.UserInputType
        == Enum.UserInputType.Touch
    then

        openDragging = false
    end
end)

--============================================================
-- HIDE ANALYZER
--============================================================

CloseButton.Activated:Connect(function()

    Main.Visible = false
    OpenButton.Visible = true
end)

--============================================================
-- REOPEN ANALYZER
--============================================================

OpenButton.Activated:Connect(function()

    if openMoved then

        openMoved = false
        return
    end

    Main.Visible = true
    OpenButton.Visible = false

    LastTradeSignature = nil

    pcall(updateTrade)
end)

--============================================================
-- 7/8 START LOOPS
--============================================================

setBoot("7/8", "STARTING LIVE SYSTEMS")

switchPage("TRADE")

refreshAMVGGStatus()

local firstTradeOk, firstTradeError =
    pcall(updateTrade)

if not firstTradeOk then

    warn(
        "[AM ANALYZER FIRST TRADE ERROR]",
        firstTradeError
    )
end

--============================================================
-- LIVE TRADE LOOP
--============================================================

task.spawn(function()

    while Gui.Parent do

        local ok, err =
            pcall(updateTrade)

        if not ok then

            warn(
                "[AM ANALYZER TRADE LOOP ERROR]",
                err
            )
        end

        task.wait(0.65)
    end
end)

--============================================================
-- STATUS LOOP
--============================================================

task.spawn(function()

    while Gui.Parent do

        pcall(
            refreshAMVGGStatus
        )

        task.wait(1)
    end
end)

--============================================================
-- AMVGG START
--============================================================

task.spawn(function()

    task.wait(1.5)

    safeRefreshAMVGG()
end)

--============================================================
-- 8/8 READY
--============================================================

setBoot("8/8", "ANALYZER READY")

print(
    "[AM ANALYZER V11.5.3] READY 8/8"
)

--============================================================
-- REMOVE BOOT WINDOW AFTER SUCCESSFUL GUI START
--============================================================

task.delay(2.5, function()

    if BootGui and BootGui.Parent then
        BootGui:Destroy()
    end
end)
