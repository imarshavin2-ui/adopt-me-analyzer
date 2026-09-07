repeat task.wait() until game:IsLoaded()

--============================================================
-- ADOPT ME TRADE ANALYZER V11.6.1
-- BASELESS EXACT
--
-- IMPORTANT:
-- NO CROSS-VARIANT FALLBACKS.
--
-- NP  -> npRegularValue
-- F   -> fValue
-- R   -> rValue
-- FR  -> regularValue
--
-- N   -> npNeonValue
-- NF  -> nfValue
-- NR  -> nrValue
-- NFR -> neonValue
--
-- M   -> npMegaValue
-- MF  -> mfValue
-- MR  -> mrValue
-- MFR -> megaValue
--
-- If exact field is nil:
-- V ? / NO EXACT BASELESS VALUE
--
-- FEATURES:
-- 18 slots
-- ClientData
-- ItemDB names
-- all AMVGG categories
-- duplicate RSC merge
-- exact variants
-- totals
-- WIN / FAIR / LOSE
-- Values search
-- X hide
-- AM reopen
--============================================================

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

local LocalPlayer =
    Players.LocalPlayer

local PlayerGui =
    LocalPlayer:WaitForChild("PlayerGui")

local ENV =
    type(getgenv) == "function"
    and getgenv()
    or _G

print("[AM V11.6.1] BOOT")

--============================================================
-- GUI PARENT
--============================================================

local GuiParent =
    PlayerGui

if type(gethui) == "function" then

    local ok, hui =
        pcall(gethui)

    if ok and hui then
        GuiParent = hui
    end
end

--============================================================
-- REMOVE OLD GUI
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
    "AdoptMeTradeAnalyzerV1160",
    "AdoptMeTradeAnalyzerV1161",

    "AM_ANALYZER_BOOT_V1153",
    "AM_ANALYZER_BOOT_V1160",
    "AM_ANALYZER_BOOT_V1161",
}

for _, name in ipairs(OLD_GUI_NAMES) do

    local old =
        GuiParent:FindFirstChild(name)

    if old then
        old:Destroy()
    end
end

--============================================================
-- BOOT GUI
--============================================================

local BootGui =
    Instance.new("ScreenGui")

BootGui.Name =
    "AM_ANALYZER_BOOT_V1161"

BootGui.ResetOnSpawn =
    false

BootGui.DisplayOrder =
    1000000

BootGui.Parent =
    GuiParent

local BootFrame =
    Instance.new("Frame")

BootFrame.Size =
    UDim2.fromOffset(
        520,
        80
    )

BootFrame.Position =
    UDim2.new(
        0.5,
        -260,
        0,
        90
    )

BootFrame.BackgroundColor3 =
    Color3.fromRGB(
        18,
        21,
        29
    )

BootFrame.BorderSizePixel =
    0

BootFrame.Parent =
    BootGui

local BootCorner =
    Instance.new("UICorner")

BootCorner.CornerRadius =
    UDim.new(
        0,
        10
    )

BootCorner.Parent =
    BootFrame

local BootStroke =
    Instance.new("UIStroke")

BootStroke.Color =
    Color3.fromRGB(
        70,
        90,
        130
    )

BootStroke.Transparency =
    0.25

BootStroke.Parent =
    BootFrame

local BootText =
    Instance.new("TextLabel")

BootText.Size =
    UDim2.new(
        1,
        -20,
        1,
        -12
    )

BootText.Position =
    UDim2.fromOffset(
        10,
        6
    )

BootText.BackgroundTransparency =
    1

BootText.Font =
    Enum.Font.Code

BootText.TextSize =
    14

BootText.TextWrapped =
    true

BootText.TextColor3 =
    Color3.fromRGB(
        240,
        243,
        250
    )

BootText.Text =
    "ADOPT ME ANALYZER V11.6.1\nBOOT..."

BootText.Parent =
    BootFrame

local function setBoot(
    step,
    text,
    isError
)

    BootText.Text =
        "ADOPT ME ANALYZER V11.6.1\n"
        .. tostring(step)
        .. "  "
        .. tostring(text)

    if isError then

        BootText.TextColor3 =
            Color3.fromRGB(
                255,
                100,
                110
            )

    else

        BootText.TextColor3 =
            Color3.fromRGB(
                240,
                243,
                250
            )
    end

    print(
        "[AM V11.6.1]",
        step,
        text
    )
end

local function safeTraceback(err)

    local result =
        tostring(err)

    if
        debug
        and type(debug.traceback) == "function"
    then

        local ok, trace =
            pcall(debug.traceback)

        if ok then

            result =
                result
                .. "\n"
                .. tostring(trace)
        end
    end

    return result
end

--============================================================
-- ADOPT ME MODULES
--============================================================

setBoot(
    "1/8",
    "LOADING ADOPT ME MODULES"
)

local Fsys
local ClientData
local ItemDB

do

    local ok, err =
        xpcall(
            function()

                Fsys =
                    require(
                        RS:WaitForChild(
                            "Fsys"
                        )
                    )

                assert(
                    type(Fsys) == "table",
                    "Fsys is not table"
                )

                assert(
                    type(Fsys.load) == "function",
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

                assert(
                    type(ClientData) == "table",
                    "ClientData invalid"
                )

                assert(
                    type(ItemDB) == "table",
                    "ItemDB invalid"
                )

            end,

            safeTraceback
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
    "2/8",
    "CLIENT DATA + ITEM DB OK"
)

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

    SLOT_HOVER =
        Color3.fromRGB(
            48,
            53,
            66
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
            126
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
}

--============================================================
-- UI HELPERS
--============================================================

local function addCorner(
    object,
    radius
)

    local x =
        Instance.new("UICorner")

    x.CornerRadius =
        UDim.new(
            0,
            radius or 8
        )

    x.Parent =
        object

    return x
end

local function addStroke(
    object,
    transparency
)

    local x =
        Instance.new("UIStroke")

    x.Color =
        Color3.fromRGB(
            58,
            64,
            78
        )

    x.Transparency =
        transparency or 0.35

    x.Thickness =
        1

    x.Parent =
        object

    return x
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

    local x =
        Instance.new("TextLabel")

    x.BackgroundTransparency =
        1

    x.Size =
        size

    x.Position =
        position

    x.Text =
        text or ""

    x.Font =
        font or Enum.Font.Gotham

    x.TextSize =
        textSize or 14

    x.TextColor3 =
        color or C.TEXT

    x.TextXAlignment =
        alignment
        or Enum.TextXAlignment.Left

    x.TextYAlignment =
        Enum.TextYAlignment.Center

    x.Parent =
        parent

    return x
end

local function makeButton(
    parent,
    text,
    size,
    position
)

    local x =
        Instance.new("TextButton")

    x.Size =
        size

    x.Position =
        position

    x.BackgroundColor3 =
        C.PANEL2

    x.BorderSizePixel =
        0

    x.Text =
        text

    x.TextColor3 =
        C.TEXT

    x.Font =
        Enum.Font.GothamBold

    x.TextSize =
        11

    x.Parent =
        parent

    addCorner(
        x,
        7
    )

    return x
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

    if math.abs(value) < 0.00000001 then
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

--============================================================
-- NAME NORMALIZATION
--============================================================

local function normalize(text)

    text =
        tostring(
            text or ""
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

local function buildAliases(text)

    local result =
        {}

    local function add(value)

        value =
            normalize(value)

        if value ~= "" then

            result[value] =
                true
        end
    end

    local original =
        tostring(
            text or ""
        )

    add(original)

    add(
        original:gsub(
            "%b()",
            ""
        )
    )

    -- Adopt Me / AMVGG spelling compatibility
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

    return result
end

--============================================================
-- ADOPT ME ITEMS
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

local function getDBEntry(item)

    if type(item) ~= "table" then
        return nil
    end

    local categoryDB =
        ItemDB[
            item.category
        ]

    if type(categoryDB) ~= "table" then
        return nil
    end

    return
        categoryDB[
            item.kind
        ]
end

local function getItemName(item)

    local db =
        getDBEntry(
            item
        )

    if type(db) == "table" then

        if db.name ~= nil then
            return tostring(db.name)
        end

        if db.display_name ~= nil then
            return tostring(db.display_name)
        end
    end

    return
        tostring(
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
        CATEGORY_DISPLAY[
            category
        ]
        or category:upper()
end

--============================================================
-- PET VARIANT
--============================================================

local function getVariant(item)

    if
        type(item) ~= "table"
        or item.category ~= "pets"
    then

        return ""
    end

    local properties =
        type(item.properties) == "table"
        and item.properties
        or {}

    local F =
        properties.flyable
        == true

    local R =
        properties.rideable
        == true

    local N =
        properties.neon
        == true

    local M =
        properties.mega_neon
        == true

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

local function getVariantColor(v)

    if
        v:find(
            "M",
            1,
            true
        )
    then

        return C.PURPLE
    end

    if
        v:find(
            "N",
            1,
            true
        )
    then

        return C.GREEN
    end

    if
        v ~= ""
        and v ~= "NP"
    then

        return C.ACCENT
    end

    return C.GREEN
end

--============================================================
-- EXACT BASELESS FIELD MAP
--============================================================

local PET_VALUE_FIELD = {

    NP =
        "npRegularValue",

    F =
        "fValue",

    R =
        "rValue",

    FR =
        "regularValue",

    N =
        "npNeonValue",

    NF =
        "nfValue",

    NR =
        "nrValue",

    NFR =
        "neonValue",

    M =
        "npMegaValue",

    MF =
        "mfValue",

    MR =
        "mrValue",

    MFR =
        "megaValue",
}

local PET_DEMAND_FIELD = {

    NP =
        "npRegularDemand",

    F =
        "fDemand",

    R =
        "rDemand",

    FR =
        "regularDemand",

    N =
        "npNeonDemand",

    NF =
        "nfDemand",

    NR =
        "nrDemand",

    NFR =
        "neonDemand",

    M =
        "npMegaDemand",

    MF =
        "mfDemand",

    MR =
        "mrDemand",

    MFR =
        "megaDemand",
}

--============================================================
-- HTTP
--============================================================

setBoot(
    "3/8",
    "DETECTING HTTP"
)

local function detectRequest()

    if type(request) == "function" then
        return request
    end

    if type(http_request) == "function" then
        return http_request
    end

    if
        type(ENV.request)
        == "function"
    then

        return ENV.request
    end

    if
        type(ENV.http_request)
        == "function"
    then

        return ENV.http_request
    end

    if
        type(syn) == "table"
        and type(
            syn.request
        ) == "function"
    then

        return syn.request
    end

    return nil
end

local REQUEST =
    detectRequest()

print(
    "[AMVGG] REQUEST =",
    type(REQUEST)
)

local function download(
    url,
    useRSC
)

    if REQUEST then

        local headers = {

            ["Accept"] =
                "*/*",

            ["User-Agent"] =
                "Mozilla/5.0",

            ["Cache-Control"] =
                "no-cache",

            ["Pragma"] =
                "no-cache",

            ["Accept-Encoding"] =
                "identity",
        }

        if useRSC then

            headers["RSC"] =
                "1"
        end

        local ok,
            response =
            pcall(
                REQUEST,
                {
                    Url =
                        url,

                    URL =
                        url,

                    Method =
                        "GET",

                    Headers =
                        headers,
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

                local body =
                    response.Body
                    or response.body

                local status =
                    response.StatusCode
                    or response.Status
                    or response.status_code
                    or 0

                return
                    body,
                    tonumber(status)
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
-- JSON OBJECT EXTRACTOR
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

    for i = startPosition, #body do

        local c =
            string.byte(
                body,
                i
            )

        if inString then

            if escaped then

                escaped =
                    false

            elseif c == 92 then

                escaped =
                    true

            elseif c == 34 then

                inString =
                    false
            end

        else

            if c == 34 then

                inString =
                    true

            elseif c == 123 then

                depth =
                    depth + 1

            elseif c == 125 then

                depth =
                    depth - 1

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

    return nil,
        nil
end

--============================================================
-- RSC OBJECT VALIDATION
--============================================================

local POSSIBLE_VALUE_FIELDS = {

    "value",

    "regularValue",
    "npRegularValue",

    "fValue",
    "rValue",

    "neonValue",
    "npNeonValue",

    "nfValue",
    "nrValue",

    "megaValue",
    "npMegaValue",

    "mfValue",
    "mrValue",
}

local function hasValueField(object)

    if
        type(object) ~= "table"
        or type(object.name) ~= "string"
    then

        return false
    end

    for _, field in ipairs(
        POSSIBLE_VALUE_FIELDS
    ) do

        if
            object[field]
            ~= nil
        then

            return true
        end
    end

    return false
end

--============================================================
-- MERGE RSC OBJECTS
--============================================================

local function mergeObject(
    target,
    source
)

    for key, value in pairs(source) do

        if value ~= nil then

            target[key] =
                value
        end
    end
end

local function parseAMVGGBody(body)

    local database =
        {}

    local count =
        0

    if type(body) ~= "string" then

        return
            database,
            count
    end

    local cursor =
        1

    local scanned =
        0

    while cursor <= #body do

        local position =
            body:find(
                '{"id":',
                cursor,
                true
            )

        if not position then
            break
        end

        local jsonText,
            endPosition =
            extractObject(
                body,
                position
            )

        if
            not jsonText
            or not endPosition
        then

            cursor =
                position + 6

            continue
        end

        cursor =
            endPosition + 1

        local ok,
            object =
            pcall(
                function()

                    return
                        HttpService:JSONDecode(
                            jsonText
                        )
                end
            )

        if
            ok
            and hasValueField(
                object
            )
        then

            local key =
                normalize(
                    object.name
                )

            if key ~= "" then

                if database[key] == nil then

                    database[key] =
                        {}

                    count =
                        count + 1
                end

                -- Merge duplicate RSC appearances.
                -- Nil never destroys an already-found field.

                mergeObject(
                    database[key],
                    object
                )
            end
        end

        scanned =
            scanned + 1

        if
            scanned % 200
            == 0
        then

            task.wait()
        end
    end

    return
        database,
        count
end

--============================================================
-- AMVGG STATE
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

    total =
        0,

    categories =
        {},

    counts =
        {},

    lastRefresh =
        0,
}

local AMVGG_CATEGORIES = {

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

--============================================================
-- LOAD CATEGORY
--============================================================

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

            rsc =
                true,
        },

        {
            url =
                "https://amvgg.com/values/"
                .. slug,

            rsc =
                false,
        },
    }

    for index, attempt in ipairs(attempts) do

        print(
            "[AMVGG]",
            slug,
            "TRY",
            index
        )

        local body,
            status =
            download(
                attempt.url,
                attempt.rsc
            )

        print(
            "[AMVGG]",
            slug,
            "HTTP=",
            status,
            "SIZE=",
            body and #body or 0
        )

        if
            type(body) == "string"
            and #body > 100
        then

            local database,
                count =
                parseAMVGGBody(
                    body
                )

            print(
                "[AMVGG]",
                slug,
                "PARSED=",
                count
            )

            if count > 0 then

                return
                    database,
                    count
            end
        end

        task.wait(
            0.15
        )
    end

    return
        nil,
        0
end

--============================================================
-- LOAD ALL AMVGG
--============================================================

local function loadAllAMVGG()

    if AMVGG.loading then
        return false
    end

    AMVGG.loading =
        true

    AMVGG.error =
        nil

    local newCategories =
        {}

    local newCounts =
        {}

    local total =
        0

    print(
        "[AMVGG] FULL LOAD START"
    )

    for _, slug in ipairs(
        AMVGG_CATEGORIES
    ) do

        local ok,
            database,
            count =
            pcall(
                function()

                    return
                        loadCategory(
                            slug
                        )
                end
            )

        if
            ok
            and type(database) == "table"
            and count > 0
        then

            newCategories[slug] =
                database

            newCounts[slug] =
                count

            total =
                total + count

        elseif AMVGG.categories[slug] then

            -- Keep previous successful copy
            -- if one category temporarily fails.

            newCategories[slug] =
                AMVGG.categories[slug]

            newCounts[slug] =
                AMVGG.counts[slug]
                or 0

            total =
                total
                + (
                    newCounts[slug]
                    or 0
                )
        end

        task.wait()
    end

    AMVGG.loading =
        false

    if
        newCategories.pets
        and next(
            newCategories.pets
        )
    then

        AMVGG.categories =
            newCategories

        AMVGG.counts =
            newCounts

        AMVGG.total =
            total

        AMVGG.ready =
            true

        AMVGG.error =
            nil

        AMVGG.version =
            AMVGG.version + 1

        AMVGG.lastRefresh =
            os.time()

        print(
            "[AMVGG] READY",
            "PETS=",
            newCounts.pets,
            "ALL=",
            total
        )

        return true
    end

    AMVGG.ready =
        false

    AMVGG.error =
        "NO PET DATABASE"

    return false
end

--============================================================
-- ADOPT ME CATEGORY -> AMVGG CATEGORY
--============================================================

local CATEGORY_TO_AMVGG = {

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

--============================================================
-- FIND ITEM BY NAME
--============================================================

local function findInCategory(
    slug,
    name
)

    local database =
        AMVGG.categories[
            slug
        ]

    if type(database) ~= "table" then
        return nil
    end

    local aliases =
        buildAliases(
            name
        )

    -- Exact alias first.

    for key in pairs(aliases) do

        if database[key] then

            return
                database[key],
                key,
                true
        end
    end

    -- Unique partial fallback is ONLY for finding name.
    -- It NEVER changes the value/variant.

    local found =
        nil

    local foundKey =
        nil

    for alias in pairs(aliases) do

        if #alias >= 6 then

            for key, entry in pairs(database) do

                if
                    key:find(
                        alias,
                        1,
                        true
                    )
                    or alias:find(
                        key,
                        1,
                        true
                    )
                then

                    if
                        found
                        and foundKey ~= key
                    then

                        return nil
                    end

                    found =
                        entry

                    foundKey =
                        key
                end
            end
        end
    end

    return
        found,
        foundKey,
        false
end

--============================================================
-- FIND AMVGG ITEM
--============================================================

local function findAMVGGItem(item)

    local name =
        getItemName(
            item
        )

    if item.category == "pets" then

        -- Adopt Me puts eggs in pets category.

        if
            name:lower():find(
                "egg",
                1,
                true
            )
        then

            local egg =
                findInCategory(
                    "eggs",
                    name
                )

            if egg then

                return
                    egg,
                    "eggs"
            end
        end

        local pet =
            findInCategory(
                "pets",
                name
            )

        if pet then

            return
                pet,
                "pets"
        end

        local egg =
            findInCategory(
                "eggs",
                name
            )

        if egg then

            return
                egg,
                "eggs"
        end

        return nil
    end

    local slug =
        CATEGORY_TO_AMVGG[
            item.category
        ]

    if not slug then
        return nil
    end

    local entry =
        findInCategory(
            slug,
            name
        )

    if entry then

        return
            entry,
            slug
    end

    return nil
end

--============================================================
-- GENERIC NON-PET BASELESS VALUE
--============================================================

local function getGenericBaselessValue(entry)

    if type(entry) ~= "table" then

        return
            nil,
            nil
    end

    -- These are not cross-variant fallbacks.
    -- Different AMVGG categories expose their single baseless
    -- value under slightly different field names.

    if
        toNumber(
            entry.value
        )
        ~= nil
    then

        return
            toNumber(
                entry.value
            ),
            "value"
    end

    if
        toNumber(
            entry.npRegularValue
        )
        ~= nil
    then

        return
            toNumber(
                entry.npRegularValue
            ),
            "npRegularValue"
    end

    if
        toNumber(
            entry.regularValue
        )
        ~= nil
    then

        return
            toNumber(
                entry.regularValue
            ),
            "regularValue"
    end

    return
        nil,
        nil
end

--============================================================
-- ANALYZE ITEM
--============================================================

local function analyzeItem(item)

    local result = {

        name =
            getItemName(
                item
            ),

        category =
            getCategoryName(
                item
            ),

        variant =
            getVariant(
                item
            ),

        found =
            false,

        value =
            nil,

        demand =
            nil,

        field =
            nil,

        source =
            nil,

        reason =
            nil,
    }

    if not AMVGG.ready then

        result.reason =
            AMVGG.loading
            and "AMVGG LOADING"
            or "AMVGG NOT READY"

        return result
    end

    local entry,
        source =
        findAMVGGItem(
            item
        )

    if not entry then

        result.reason =
            "NOT FOUND"

        return result
    end

    result.found =
        true

    result.source =
        source

    --========================================================
    -- PET = STRICT EXACT BASELESS VARIANT
    --========================================================

    if source == "pets" then

        local v =
            result.variant

        local valueField =
            PET_VALUE_FIELD[
                v
            ]

        if not valueField then

            result.reason =
                "UNKNOWN VARIANT"

            return result
        end

        local exactValue =
            toNumber(
                entry[
                    valueField
                ]
            )

        result.field =
            valueField

        result.value =
            exactValue

        local demandField =
            PET_DEMAND_FIELD[
                v
            ]

        if demandField then

            result.demand =
                entry[
                    demandField
                ]
        end

        if exactValue == nil then

            result.reason =
                "NO EXACT BASELESS VALUE"
        end

        return result
    end

    --========================================================
    -- OTHER CATEGORY
    --========================================================

    result.variant =
        ""

    local value,
        field =
        getGenericBaselessValue(
            entry
        )

    result.value =
        value

    result.field =
        field

    result.demand =
        entry.demand
        or entry.regularDemand

    if value == nil then

        result.reason =
            "NO BASELESS VALUE"
    end

    return result
end

--============================================================
-- PLAYER HELPERS
--============================================================

local function playerName(value)

    if
        typeof(value)
        == "Instance"
    then

        return value.Name
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

    return
        playerName(value):lower()
        ==
        LocalPlayer.Name:lower()
end

--============================================================
-- GUI
--============================================================

setBoot(
    "4/8",
    "BUILDING GUI"
)

local Gui =
    Instance.new("ScreenGui")

Gui.Name =
    "AdoptMeTradeAnalyzerV1161"

Gui.ResetOnSpawn =
    false

Gui.DisplayOrder =
    999999

Gui.Parent =
    GuiParent

local Main =
    Instance.new("Frame")

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

addCorner(
    Main,
    12
)

addStroke(
    Main,
    0.15
)

--============================================================
-- TOP BAR
--============================================================

local Top =
    Instance.new("Frame")

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

makeLabel(
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
    makeLabel(
        Top,

        "V11.6.1",

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

addCorner(
    VersionLabel,
    6
)

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
-- DRAG WINDOW
--============================================================

local dragging =
    false

local dragStart
local dragOrigin

Top.InputBegan:Connect(
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

UIS.InputChanged:Connect(
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

UIS.InputEnded:Connect(
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
-- SIDEBAR
--============================================================

local Sidebar =
    Instance.new("Frame")

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

makeLabel(
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
    Instance.new("Frame")

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

--============================================================
-- PAGES
--============================================================

local Pages =
    {}

local Navigation =
    {}

local function createPage(name)

    local page =
        Instance.new("Frame")

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

    for key, page in pairs(Pages) do

        page.Visible =
            key == name
    end

    for key, navButton in pairs(Navigation) do

        if key == name then

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

local function createNav(
    name,
    y
)

    local navButton =
        makeButton(
            Sidebar,

            "   "
            .. name,

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

    navButton.TextXAlignment =
        Enum.TextXAlignment.Left

    navButton.BackgroundColor3 =
        C.PANEL

    navButton.TextColor3 =
        C.MUTED

    navButton.Activated:Connect(
        function()

            setPage(
                name
            )
        end
    )

    Navigation[name] =
        navButton
end

createNav(
    "TRADE",
    46
)

createNav(
    "VALUES",
    96
)

createNav(
    "UPDATES",
    146
)

createNav(
    "SETTINGS",
    196
)

--============================================================
-- TRADE PAGE
--============================================================

setBoot(
    "5/8",
    "BUILDING TRADE PAGE"
)

local TradePage =
    createPage(
        "TRADE"
    )

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
            400,
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
            700,
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

StageLabel.BackgroundTransparency =
    0

StageLabel.BackgroundColor3 =
    C.PANEL2

addCorner(
    StageLabel,
    7
)

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

TradeArea.BackgroundColor3 =
    C.PANEL

TradeArea.BorderSizePixel =
    0

TradeArea.Parent =
    TradePage

addCorner(
    TradeArea,
    10
)

addStroke(
    TradeArea,
    0.35
)

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

Center.BackgroundTransparency =
    1

Center.Parent =
    TradeArea

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

local TradeResult =
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

local TradeDifference =
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

TradeDifference.TextWrapped =
    true

--============================================================
-- OFFER PANEL
--============================================================

local function createOfferPanel(xPosition)

    local Panel =
        Instance.new("Frame")

    Panel.Position =
        UDim2.new(
            xPosition,
            0,
            0,
            8
        )

    Panel.Size =
        UDim2.new(
            0.425,
            0,
            1,
            -16
        )

    Panel.BackgroundColor3 =
        C.PANEL2

    Panel.BorderSizePixel =
        0

    Panel.Parent =
        TradeArea

    addCorner(
        Panel,
        9
    )

    local Name =
        makeLabel(
            Panel,

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

    local Count =
        makeLabel(
            Panel,

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

    local Ready =
        makeLabel(
            Panel,

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

    Ready.BackgroundTransparency =
        0

    Ready.BackgroundColor3 =
        Color3.fromRGB(
            39,
            43,
            52
        )

    addCorner(
        Ready,
        5
    )

    local Total =
        makeLabel(
            Panel,

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

    Scroll.BackgroundTransparency =
        0.12

    Scroll.BorderSizePixel =
        0

    Scroll.ScrollBarThickness =
        6

    Scroll.ScrollBarImageColor3 =
        C.ACCENT

    Scroll.ElasticBehavior =
        Enum.ElasticBehavior.Never

    Scroll.CanvasSize =
        UDim2.fromOffset(
            0,
            0
        )

    Scroll.Parent =
        Panel

    addCorner(
        Scroll,
        7
    )

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

    Grid.FillDirectionMaxCells =
        3

    Grid.SortOrder =
        Enum.SortOrder.LayoutOrder

    Grid.Parent =
        Scroll

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

    Padding.Parent =
        Scroll

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

    task.defer(
        updateCanvas
    )

    return {

        Panel =
            Panel,

        Name =
            Name,

        Count =
            Count,

        Ready =
            Ready,

        Total =
            Total,

        Scroll =
            Scroll,

        Slots =
            {},
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
-- TRADE SLOTS
--============================================================

local function createTradeSlot(
    side,
    index
)

    local Frame =
        Instance.new("TextButton")

    Frame.LayoutOrder =
        index

    Frame.BackgroundColor3 =
        C.SLOT

    Frame.BorderSizePixel =
        0

    Frame.AutoButtonColor =
        false

    Frame.Text =
        ""

    Frame.Parent =
        side.Scroll

    addCorner(
        Frame,
        7
    )

    addStroke(
        Frame,
        0.5
    )

    makeLabel(
        Frame,

        "#"
        .. tostring(index),

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

    local Variant =
        makeLabel(
            Frame,

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

    local Name =
        makeLabel(
            Frame,

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

    Name.TextWrapped =
        true

    local Value =
        makeLabel(
            Frame,

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

    local Category =
        makeLabel(
            Frame,

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

    side.Slots[index] = {

        Frame =
            Frame,

        Variant =
            Variant,

        Name =
            Name,

        Value =
            Value,

        Category =
            Category,

        Item =
            nil,

        Analysis =
            nil,
    }
end

for i = 1, 18 do

    createTradeSlot(
        Yours,
        i
    )

    createTradeSlot(
        Theirs,
        i
    )
end

--============================================================
-- SLOT UPDATE
--============================================================

local function clearSlot(slot)

    slot.Item =
        nil

    slot.Analysis =
        nil

    slot.Name.Text =
        "EMPTY"

    slot.Name.TextColor3 =
        Color3.fromRGB(
            95,
            101,
            115
        )

    slot.Variant.Text =
        ""

    slot.Value.Text =
        ""

    slot.Category.Text =
        ""

    slot.Frame.BackgroundColor3 =
        C.SLOT
end

local function fillSlot(
    slot,
    item
)

    slot.Item =
        item

    local data =
        analyzeItem(
            item
        )

    slot.Analysis =
        data

    slot.Name.Text =
        data.name

    slot.Name.TextColor3 =
        C.TEXT

    slot.Variant.Text =
        data.variant

    slot.Variant.TextColor3 =
        getVariantColor(
            data.variant
        )

    slot.Category.Text =
        data.category

    if data.value ~= nil then

        slot.Value.Text =
            "V "
            .. numberText(
                data.value
            )

        slot.Value.TextColor3 =
            C.ACCENT

        print(
            "[BASELESS EXACT]",
            data.name,
            data.variant,
            "=",
            data.value,
            "FIELD=",
            data.field
        )

        return
            data.value,
            true
    end

    slot.Value.Text =
        "V ?"

    if AMVGG.loading then

        slot.Value.TextColor3 =
            C.YELLOW

    else

        slot.Value.TextColor3 =
            C.RED
    end

    print(
        "[BASELESS MISSING]",
        data.name,
        data.variant,
        data.reason,
        "FIELD=",
        data.field
    )

    return
        0,
        false
end

--============================================================
-- SIDE UPDATE
--============================================================

local function updateSide(
    side,
    offer
)

    local items =
        {}

    if
        type(offer) == "table"
        and type(offer.items) == "table"
    then

        items =
            offer.items
    end

    local count =
        #items

    local total =
        0

    local missing =
        0

    side.Count.Text =
        tostring(count)
        .. " / 18"

    for i = 1, 18 do

        local item =
            items[i]

        if item then

            local value,
                known =
                fillSlot(
                    side.Slots[i],
                    item
                )

            if known then

                total =
                    total + value

            else

                missing =
                    missing + 1
            end

        else

            clearSlot(
                side.Slots[i]
            )
        end
    end

    if count == 0 then

        side.Total.Text =
            "TOTAL: 0"

        side.Total.TextColor3 =
            C.MUTED

    elseif missing == 0 then

        side.Total.Text =
            "TOTAL: "
            .. numberText(
                total
            )

        side.Total.TextColor3 =
            C.ACCENT

    else

        side.Total.Text =
            "KNOWN: "
            .. numberText(
                total
            )
            .. "  •  ?x"
            .. tostring(
                missing
            )

        side.Total.TextColor3 =
            C.YELLOW
    end

    if
        type(offer) == "table"
        and offer.confirmed == true
    then

        side.Ready.Text =
            "CONFIRMED"

        side.Ready.TextColor3 =
            C.GREEN

    elseif
        type(offer) == "table"
        and offer.negotiated == true
    then

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

        count =
            count,

        total =
            total,

        missing =
            missing,
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

    local result =
        {}

    for index, item in ipairs(
        offer.items
    ) do

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

local LastTradeSignature =
    nil

--============================================================
-- TRADE RESULT
--============================================================

local FAIR_PERCENT =
    0.02

local function calculateResult(
    mine,
    theirs
)

    if
        mine.missing > 0
        or theirs.missing > 0
    then

        TradeResult.Text =
            "INCOMPLETE"

        TradeResult.TextColor3 =
            C.YELLOW

        TradeDifference.Text =
            "missing values"

        return
    end

    if
        mine.count == 0
        and theirs.count == 0
    then

        TradeResult.Text =
            "WAIT"

        TradeResult.TextColor3 =
            C.MUTED

        TradeDifference.Text =
            ""

        return
    end

    local difference =
        theirs.total
        - mine.total

    local maximum =
        math.max(
            mine.total,
            theirs.total,
            0.000001
        )

    local percent =
        math.abs(
            difference
        )
        / maximum

    TradeDifference.Text =
        (
            difference >= 0
            and "+"
            or ""
        )
        .. numberText(
            difference
        )

    if percent <= FAIR_PERCENT then

        TradeResult.Text =
            "FAIR"

        TradeResult.TextColor3 =
            C.YELLOW

    elseif difference > 0 then

        TradeResult.Text =
            "WIN"

        TradeResult.TextColor3 =
            C.GREEN

    else

        TradeResult.Text =
            "LOSE"

        TradeResult.TextColor3 =
            C.RED
    end
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

    local mine =
        updateSide(
            Yours,
            nil
        )

    local theirs =
        updateSide(
            Theirs,
            nil
        )

    CountsLabel.Text =
        "YOU 0/18   •   THEM 0/18"

    calculateResult(
        mine,
        theirs
    )
end

--============================================================
-- TRADE UPDATE
--============================================================

local function updateTrade()

    local ok,
        trade =
        pcall(
            function()

                return
                    ClientData.get(
                        "trade"
                    )
            end
        )

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
        .. ":"
        .. tostring(
            trade.current_stage
        )
        .. ":"
        .. offerSignature(
            myOffer
        )
        .. ":"
        .. offerSignature(
            theirOffer
        )
        .. ":AMVGG:"
        .. tostring(
            AMVGG.version
        )

    if
        signature
        == LastTradeSignature
    then

        return
    end

    LastTradeSignature =
        signature

    Yours.Name.Text =
        playerName(me)

    Theirs.Name.Text =
        playerName(partner)

    StageLabel.Text =
        tostring(
            trade.current_stage
            or "UNKNOWN"
        ):upper()

    local mine =
        updateSide(
            Yours,
            myOffer
        )

    local theirs =
        updateSide(
            Theirs,
            theirOffer
        )

    CountsLabel.Text =
        "YOU "
        .. tostring(
            mine.count
        )
        .. "/18   •   THEM "
        .. tostring(
            theirs.count
        )
        .. "/18"

    calculateResult(
        mine,
        theirs
    )
end

--============================================================
-- VALUES PAGE
--============================================================

setBoot(
    "6/8",
    "BUILDING VALUES PAGE"
)

local ValuesPage =
    createPage(
        "VALUES"
    )

makeLabel(
    ValuesPage,

    "AMVGG Baseless Values",

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

SearchBox.BorderSizePixel =
    0

SearchBox.PlaceholderText =
    "Pilot Gull"

SearchBox.PlaceholderColor3 =
    C.MUTED

SearchBox.TextColor3 =
    C.TEXT

SearchBox.Font =
    Enum.Font.Code

SearchBox.TextSize =
    11

SearchBox.ClearTextOnFocus =
    false

SearchBox.Parent =
    ValuesPage

addCorner(
    SearchBox,
    7
)

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

ResultBox.BorderSizePixel =
    0

ResultBox.TextColor3 =
    C.TEXT

ResultBox.Font =
    Enum.Font.Code

ResultBox.TextSize =
    11

ResultBox.TextXAlignment =
    Enum.TextXAlignment.Left

ResultBox.TextYAlignment =
    Enum.TextYAlignment.Top

ResultBox.MultiLine =
    true

ResultBox.ClearTextOnFocus =
    false

ResultBox.Text =
    "Waiting for AMVGG..."

ResultBox.Parent =
    ValuesPage

addCorner(
    ResultBox,
    8
)

--============================================================
-- VALUES SEARCH
--============================================================

local VARIANT_ORDER = {

    "NP",
    "F",
    "R",
    "FR",

    "N",
    "NF",
    "NR",
    "NFR",

    "M",
    "MF",
    "MR",
    "MFR",
}

local function searchValues()

    if not AMVGG.ready then

        ResultBox.Text =
            "AMVGG NOT READY"

        return
    end

    local query =
        normalize(
            SearchBox.Text
        )

    if query == "" then

        ResultBox.Text =
            "Enter item name"

        return
    end

    local matches =
        {}

    for slug, database in pairs(
        AMVGG.categories
    ) do

        for key, entry in pairs(database) do

            if
                key == query

                or key:find(
                    query,
                    1,
                    true
                )
            then

                matches[#matches + 1] = {

                    slug =
                        slug,

                    key =
                        key,

                    entry =
                        entry,
                }

                if #matches >= 30 then
                    break
                end
            end
        end
    end

    if #matches == 0 then

        ResultBox.Text =
            "NOT FOUND: "
            .. SearchBox.Text

        return
    end

    local exact =
        nil

    for _, match in ipairs(matches) do

        local aliases =
            buildAliases(
                match.entry.name
            )

        if aliases[query] then

            exact =
                match

            break
        end
    end

    if exact then

        local entry =
            exact.entry

        local lines = {

            "NAME = "
            .. tostring(
                entry.name
            ),

            "CATEGORY = "
            .. tostring(
                exact.slug
            ),

            "MODE = BASELESS EXACT",

            "",
        }

        if exact.slug == "pets" then

            for _, v in ipairs(
                VARIANT_ORDER
            ) do

                local field =
                    PET_VALUE_FIELD[
                        v
                    ]

                local value =
                    toNumber(
                        entry[field]
                    )

                lines[#lines + 1] =
                    string.format(
                        "%-4s = %-10s  [%s]",
                        v,
                        value ~= nil
                            and tostring(value)
                            or "nil",
                        field
                    )
            end

        else

            local value,
                field =
                getGenericBaselessValue(
                    entry
                )

            lines[#lines + 1] =
                "VALUE = "
                .. tostring(value)

            lines[#lines + 1] =
                "FIELD = "
                .. tostring(field)
        end

        lines[#lines + 1] =
            ""

        lines[#lines + 1] =
            "UPDATED = "
            .. tostring(
                entry.lastUpdatedAt
                or "?"
            )

        ResultBox.Text =
            table.concat(
                lines,
                "\n"
            )

        return
    end

    local names =
        {}

    for _, match in ipairs(matches) do

        names[#names + 1] =
            tostring(
                match.entry.name
            )
            .. " ["
            .. tostring(
                match.slug
            )
            .. "]"
    end

    table.sort(
        names
    )

    ResultBox.Text =
        table.concat(
            names,
            "\n"
        )
end

SearchButton.Activated:Connect(
    searchValues
)

SearchBox.FocusLost:Connect(
    function(enterPressed)

        if enterPressed then

            searchValues()
        end
    end
)

--============================================================
-- UPDATES PAGE
--============================================================

local UpdatesPage =
    createPage(
        "UPDATES"
    )

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

local UpdatesText =
    makeLabel(
        UpdatesPage,

        "V11.6.1 BASELESS EXACT\n\n"
        .. "• REMOVED all cross-variant value fallbacks\n"
        .. "• M uses ONLY npMegaValue\n"
        .. "• MF uses ONLY mfValue\n"
        .. "• MR uses ONLY mrValue\n"
        .. "• MFR uses ONLY megaValue\n"
        .. "• Same exact rule for NP/F/R/FR and Neon variants\n"
        .. "• Duplicate RSC objects still merged\n"
        .. "• Dark Choccybunny aliases preserved\n"
        .. "• All AMVGG categories preserved\n\n"
        .. "If exact field = nil -> V ?\n"
        .. "Wrong MFR/NFR price will NEVER be substituted.",

        UDim2.new(
            1,
            -44,
            0,
            380
        ),

        UDim2.fromOffset(
            22,
            70
        ),

        Enum.Font.Code,
        12,
        C.MUTED
    )

UpdatesText.TextYAlignment =
    Enum.TextYAlignment.Top

--============================================================
-- SETTINGS PAGE
--============================================================

local SettingsPage =
    createPage(
        "SETTINGS"
    )

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

local SettingsText =
    makeLabel(
        SettingsPage,

        "PRICE MODE             BASELESS\n\n"
        .. "PET VALUE MODE         EXACT\n\n"
        .. "CROSS VARIANT FALLBACK OFF\n\n"
        .. "TRADE SLOTS            18\n\n"
        .. "PET VARIANTS           12\n\n"
        .. "AMVGG CATEGORIES       10\n\n"
        .. "FAIR RANGE             ±2%\n\n"
        .. "UNKNOWN BLOCK RESULT   ON\n\n"
        .. "AUTO ACCEPT            OFF",

        UDim2.new(
            1,
            -44,
            0,
            340
        ),

        UDim2.fromOffset(
            22,
            70
        ),

        Enum.Font.Code,
        13,
        C.MUTED
    )

SettingsText.TextYAlignment =
    Enum.TextYAlignment.Top

--============================================================
-- STATUS
--============================================================

local function updateAMVGGStatus()

    local text
    local color

    if AMVGG.loading then

        text =
            "AMVGG: LOADING..."

        color =
            C.YELLOW

    elseif AMVGG.ready then

        text =
            "AMVGG BASELESS • P:"
            .. tostring(
                AMVGG.counts.pets
                or 0
            )
            .. " • ALL:"
            .. tostring(
                AMVGG.total
            )

        color =
            C.GREEN

    elseif AMVGG.error then

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

    AMVGGStatus.Text =
        text

    AMVGGStatus.TextColor3 =
        color

    ValuesStatus.Text =
        text

    ValuesStatus.TextColor3 =
        color
end

--============================================================
-- REFRESH AMVGG
--============================================================

local function refreshAMVGG()

    if AMVGG.loading then
        return
    end

    AMVGGStatus.Text =
        "AMVGG: LOADING..."

    ValuesStatus.Text =
        "AMVGG: LOADING..."

    local ok,
        err =
        xpcall(
            function()

                local success =
                    loadAllAMVGG()

                if not success then

                    error(
                        AMVGG.error
                        or "AMVGG LOAD FAILED"
                    )
                end

            end,

            safeTraceback
        )

    if not ok then

        AMVGG.loading =
            false

        AMVGG.error =
            tostring(err)

        warn(
            "[AMVGG ERROR]",
            err
        )
    end

    updateAMVGGStatus()

    LastTradeSignature =
        nil

    pcall(
        updateTrade
    )
end

RefreshButton.Activated:Connect(
    function()

        task.spawn(
            refreshAMVGG
        )
    end
)

--============================================================
-- FLOATING AM BUTTON
--============================================================

local OpenButton =
    Instance.new("TextButton")

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

OpenButton.BorderSizePixel =
    0

OpenButton.Text =
    "AM"

OpenButton.TextColor3 =
    C.TEXT

OpenButton.Font =
    Enum.Font.GothamBold

OpenButton.TextSize =
    17

OpenButton.Visible =
    false

OpenButton.Parent =
    Gui

addCorner(
    OpenButton,
    17
)

addStroke(
    OpenButton,
    0.1
)

--============================================================
-- AM BUTTON DRAG
--============================================================

local openDragging =
    false

local openMoved =
    false

local openStart
local openOrigin

OpenButton.InputBegan:Connect(
    function(input)

        if
            input.UserInputType
            == Enum.UserInputType.Touch

            or input.UserInputType
            == Enum.UserInputType.MouseButton1
        then

            openDragging =
                true

            openMoved =
                false

            openStart =
                input.Position

            openOrigin =
                OpenButton.Position
        end
    end
)

UIS.InputChanged:Connect(
    function(input)

        if not openDragging then
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
            - openStart

        if
            math.abs(delta.X) > 6
            or math.abs(delta.Y) > 6
        then

            openMoved =
                true
        end

        local x =
            openOrigin.X.Scale
            * viewport.X
            + openOrigin.X.Offset
            + delta.X

        local y =
            openOrigin.Y.Scale
            * viewport.Y
            + openOrigin.Y.Offset
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
    end
)

UIS.InputEnded:Connect(
    function(input)

        if
            input.UserInputType
            == Enum.UserInputType.Touch

            or input.UserInputType
            == Enum.UserInputType.MouseButton1
        then

            openDragging =
                false
        end
    end
)

--============================================================
-- HIDE / OPEN
--============================================================

CloseButton.Activated:Connect(
    function()

        Main.Visible =
            false

        OpenButton.Visible =
            true
    end
)

OpenButton.Activated:Connect(
    function()

        if openMoved then

            openMoved =
                false

            return
        end

        Main.Visible =
            true

        OpenButton.Visible =
            false

        LastTradeSignature =
            nil

        pcall(
            updateTrade
        )
    end
)

--============================================================
-- START
--============================================================

setBoot(
    "7/8",
    "STARTING LIVE SYSTEMS"
)

setPage(
    "TRADE"
)

updateAMVGGStatus()

pcall(
    updateTrade
)

-- Trade loop
task.spawn(
    function()

        while Gui.Parent do

            local ok,
                err =
                pcall(
                    updateTrade
                )

            if not ok then

                warn(
                    "[AM TRADE ERROR]",
                    err
                )
            end

            task.wait(
                0.65
            )
        end
    end
)

-- Status loop
task.spawn(
    function()

        while Gui.Parent do

            pcall(
                updateAMVGGStatus
            )

            task.wait(
                1
            )
        end
    end
)

-- AMVGG initial + every 15 minutes
task.spawn(
    function()

        task.wait(
            1.5
        )

        while Gui.Parent do

            refreshAMVGG()

            task.wait(
                15 * 60
            )
        end
    end
)

--============================================================
-- READY
--============================================================

setBoot(
    "8/8",
    "READY - BASELESS EXACT"
)

print(
    "[AM V11.6.1] READY - BASELESS EXACT"
)

task.delay(
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
