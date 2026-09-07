repeat task.wait() until game:IsLoaded()

--============================================================
-- ADOPT ME TRADE ANALYZER V11.6.0
--
-- FULL BUILD
--
-- FIXES:
--   Dark Choccybunny detection
--   Pilot Gull M / missing exact variant fields
--   duplicate AMVGG RSC objects are MERGED
--   exact variant first, safe same-stage fallback second
--
-- AMVGG CATEGORIES:
--   Pets
--   Eggs
--   Pet Wear
--   Strollers
--   Food
--   Vehicles
--   Toys
--   Gifts
--   Stickers
--   Houses
--
-- CORE:
--   ClientData
--   ItemDB
--   18 slots
--   live trade
--   exact pet variants
--   values
--   totals
--   WIN / FAIR / LOSE
--   Values search
--   X hide
--   AM reopen
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

print("[AM V11.6.0] BOOT")

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

local OLD = {

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

    "AM_ANALYZER_BOOT_V1153",
    "AM_ANALYZER_BOOT_V1160",
}

for _, name in ipairs(OLD) do

    local object =
        GuiParent:FindFirstChild(name)

    if object then
        object:Destroy()
    end
end

--============================================================
-- BOOT WINDOW
--============================================================

local BootGui =
    Instance.new("ScreenGui")

BootGui.Name =
    "AM_ANALYZER_BOOT_V1160"

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

local bc =
    Instance.new("UICorner")

bc.CornerRadius =
    UDim.new(
        0,
        10
    )

bc.Parent =
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
    "ADOPT ME ANALYZER V11.6.0\nBOOT..."

BootText.Parent =
    BootFrame

local function boot(
    step,
    text,
    bad
)

    BootText.Text =
        "ADOPT ME ANALYZER V11.6.0\n"
        .. tostring(step)
        .. "  "
        .. tostring(text)

    BootText.TextColor3 =
        bad
        and Color3.fromRGB(
            255,
            100,
            110
        )
        or Color3.fromRGB(
            240,
            243,
            250
        )

    print(
        "[AM V11.6.0]",
        step,
        text
    )
end

local function trace(err)

    local result =
        tostring(err)

    if
        debug
        and type(
            debug.traceback
        ) == "function"
    then

        local ok, value =
            pcall(
                debug.traceback
            )

        if ok then

            result =
                result
                .. "\n"
                .. tostring(value)
        end
    end

    return result
end

--============================================================
-- ADOPT ME MODULES
--============================================================

boot(
    "1/8",
    "Loading Adopt Me modules"
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

                ClientData =
                    Fsys.load(
                        "ClientData"
                    )

                ItemDB =
                    Fsys.load(
                        "ItemDB"
                    )

                assert(
                    type(ClientData)
                    == "table"
                )

                assert(
                    type(ItemDB)
                    == "table"
                )

            end,

            trace
        )

    if not ok then

        boot(
            "ERROR",
            err,
            true
        )

        return
    end
end

boot(
    "2/8",
    "ClientData + ItemDB OK"
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

local function corner(
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

local function stroke(
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

local function button(
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

    corner(
        x,
        7
    )

    return x
end

--============================================================
-- NUMBER
--============================================================

local function numeric(value)

    if type(value) == "number" then
        return value
    end

    if type(value) == "string" then
        return tonumber(value)
    end

    return nil
end

local function numText(value)

    if type(value) ~= "number" then
        return "?"
    end

    if math.abs(value) < 0.0000001 then
        return "0"
    end

    local s

    if math.abs(value) >= 100 then

        s =
            string.format(
                "%.2f",
                value
            )

    elseif math.abs(value) >= 1 then

        s =
            string.format(
                "%.4f",
                value
            )

    else

        s =
            string.format(
                "%.6f",
                value
            )
    end

    s =
        s:gsub(
            "0+$",
            ""
        )

    s =
        s:gsub(
            "%.$",
            ""
        )

    return s
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

local function aliases(text)

    local results =
        {}

    local function add(value)

        value =
            normalize(value)

        if value ~= "" then
            results[value] = true
        end
    end

    add(text)

    local x =
        tostring(
            text or ""
        )

    add(
        x:gsub(
            "%b()",
            ""
        )
    )

    -- common spelling compatibility
    add(
        x:gsub(
            "Chocobunny",
            "Choccybunny"
        )
    )

    add(
        x:gsub(
            "Choccybunny",
            "Chocobunny"
        )
    )

    return results
end

--============================================================
-- ADOPT ME ITEM INFO
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

local function dbEntry(item)

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

local function itemName(item)

    local info =
        dbEntry(item)

    if type(info) == "table" then

        if info.name then
            return tostring(info.name)
        end

        if info.display_name then
            return tostring(info.display_name)
        end
    end

    return
        tostring(
            item.kind
            or "Unknown Item"
        )
end

local function categoryName(item)

    local key =
        tostring(
            item.category
            or "unknown"
        )

    return
        CATEGORY_DISPLAY[key]
        or key:upper()
end

--============================================================
-- PET VARIANT
--============================================================

local function variant(item)

    if
        type(item) ~= "table"
        or item.category ~= "pets"
    then

        return ""
    end

    local p =
        type(item.properties)
        == "table"

        and item.properties
        or {}

    local F =
        p.flyable == true

    local R =
        p.rideable == true

    local N =
        p.neon == true

    local M =
        p.mega_neon == true

    if M then

        if F and R then
            return "MFR"
        elseif F then
            return "MF"
        elseif R then
            return "MR"
        else
            return "M"
        end
    end

    if N then

        if F and R then
            return "NFR"
        elseif F then
            return "NF"
        elseif R then
            return "NR"
        else
            return "N"
        end
    end

    if F and R then
        return "FR"
    elseif F then
        return "F"
    elseif R then
        return "R"
    end

    return "NP"
end

local function variantColor(v)

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
-- DELTA HTTP
--============================================================

boot(
    "3/8",
    "Detecting HTTP"
)

local function detectRequest()

    if type(request) == "function" then
        return request
    end

    if type(http_request) == "function" then
        return http_request
    end

    if type(ENV.request) == "function" then
        return ENV.request
    end

    if type(ENV.http_request) == "function" then
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
    "[AMVGG] request =",
    type(REQUEST)
)

--============================================================
-- HTTP
--============================================================

local function download(
    url,
    rsc
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

        if rsc then
            headers["RSC"] = "1"
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

            if type(response) == "string" then

                return
                    response,
                    200
            end

            if type(response) == "table" then

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

    local ok, body =
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

    return nil,
        0
end

--============================================================
-- BALANCED OBJECT
--============================================================

local function extractObject(
    body,
    start
)

    local depth =
        0

    local inString =
        false

    local escaped =
        false

    for i = start, #body do

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
                            start,
                            i
                        ),
                        i
                end
            end
        end
    end
end

--============================================================
-- VALUE FIELD CHECK
--============================================================

local VALUE_FIELDS = {

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

local function isValueObject(object)

    if
        type(object) ~= "table"
        or type(object.name) ~= "string"
    then

        return false
    end

    for _, field in ipairs(VALUE_FIELDS) do

        if object[field] ~= nil then
            return true
        end
    end

    return false
end

--============================================================
-- IMPORTANT FIX:
-- MERGE DUPLICATE RSC OBJECTS
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

local function parseBody(body)

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

        -- Handles BOTH:
        -- {"id":"123"
        -- {"id":123

        local pos =
            body:find(
                '{"id":',
                cursor,
                true
            )

        if not pos then
            break
        end

        local json,
            finish =
            extractObject(
                body,
                pos
            )

        if
            not json
            or not finish
        then

            cursor =
                pos + 6

            continue
        end

        cursor =
            finish + 1

        local ok,
            object =
            pcall(
                function()

                    return
                        HttpService:JSONDecode(
                            json
                        )
                end
            )

        if
            ok
            and isValueObject(
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

                -- NEVER THROW AWAY SECOND OBJECT
                mergeObject(
                    database[key],
                    object
                )
            end
        end

        scanned =
            scanned + 1

        if scanned % 200 == 0 then
            task.wait()
        end
    end

    return
        database,
        count
end

--============================================================
-- AMVGG DATABASE
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
-- DOWNLOAD CATEGORY
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

    local urls = {

        {
            "https://amvgg.com/values/"
            .. slug
            .. "?_rsc="
            .. token,

            true,
        },

        {
            "https://amvgg.com/values/"
            .. slug,

            false,
        },
    }

    for index, data in ipairs(urls) do

        print(
            "[AMVGG]",
            slug,
            "TRY",
            index
        )

        local body,
            status =
            download(
                data[1],
                data[2]
            )

        print(
            "[AMVGG]",
            slug,
            "HTTP",
            status,
            "SIZE",
            body and #body or 0
        )

        if
            type(body) == "string"
            and #body > 100
        then

            local db,
                count =
                parseBody(
                    body
                )

            print(
                "[AMVGG]",
                slug,
                "PARSED",
                count
            )

            if count > 0 then

                return
                    db,
                    count
            end
        end

        task.wait(
            0.15
        )
    end

    return nil,
        0
end

--============================================================
-- AMVGG FULL REFRESH
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

    for _, slug in ipairs(AMVGG_CATEGORIES) do

        local ok,
            db,
            count =
            pcall(
                function()

                    local result,
                        amount =
                        loadCategory(
                            slug
                        )

                    return
                        result,
                        amount
                end
            )

        if
            ok
            and type(db) == "table"
            and count > 0
        then

            newCategories[slug] =
                db

            newCounts[slug] =
                count

            total =
                total + count

        else

            -- keep previous working category
            if AMVGG.categories[slug] then

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

        AMVGG.version =
            AMVGG.version + 1

        AMVGG.lastRefresh =
            os.time()

        print(
            "[AMVGG] READY",
            "PETS",
            newCounts.pets,
            "TOTAL",
            total
        )

        return true
    end

    AMVGG.error =
        "NO PET DATABASE"

    return false
end

--============================================================
-- ITEM -> AMVGG CATEGORY
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
-- FIND BY NAME
--============================================================

local function findInCategory(
    slug,
    name
)

    local db =
        AMVGG.categories[
            slug
        ]

    if type(db) ~= "table" then
        return nil
    end

    local possible =
        aliases(name)

    for key in pairs(possible) do

        if db[key] then

            return
                db[key]
        end
    end

    -- safe unique partial match

    local found =
        nil

    local foundKey =
        nil

    for key in pairs(possible) do

        if #key >= 6 then

            for dbKey,
                entry
                in pairs(db)
            do

                if
                    dbKey:find(
                        key,
                        1,
                        true
                    )
                    or key:find(
                        dbKey,
                        1,
                        true
                    )
                then

                    if
                        found
                        and foundKey ~= dbKey
                    then

                        return nil
                    end

                    found =
                        entry

                    foundKey =
                        dbKey
                end
            end
        end
    end

    return found
end

--============================================================
-- FIND ITEM
--============================================================

local function findAMVGG(item)

    local name =
        itemName(
            item
        )

    if item.category == "pets" then

        -- Eggs are stored as pets inside Adopt Me
        -- but separate category on AMVGG.

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

        -- Some special eggs don't literally contain Egg.
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
-- PET VALUE SELECTION
--
-- EXACT FIELD ALWAYS FIRST.
--
-- If AMVGG left the exact sub-variant null, only then
-- use another value from SAME evolution tier.
--============================================================

local PET_FIELDS = {

    NP = {
        "npRegularValue",
        "regularValue",
        "fValue",
        "rValue",
        "value",
    },

    F = {
        "fValue",
        "regularValue",
        "npRegularValue",
        "rValue",
        "value",
    },

    R = {
        "rValue",
        "regularValue",
        "npRegularValue",
        "fValue",
        "value",
    },

    FR = {
        "regularValue",
        "fValue",
        "rValue",
        "npRegularValue",
        "value",
    },

    N = {
        "npNeonValue",
        "neonValue",
        "nfValue",
        "nrValue",
    },

    NF = {
        "nfValue",
        "neonValue",
        "npNeonValue",
        "nrValue",
    },

    NR = {
        "nrValue",
        "neonValue",
        "npNeonValue",
        "nfValue",
    },

    NFR = {
        "neonValue",
        "nfValue",
        "nrValue",
        "npNeonValue",
    },

    M = {
        "npMegaValue",
        "megaValue",
        "mfValue",
        "mrValue",
    },

    MF = {
        "mfValue",
        "megaValue",
        "npMegaValue",
        "mrValue",
    },

    MR = {
        "mrValue",
        "megaValue",
        "npMegaValue",
        "mfValue",
    },

    MFR = {
        "megaValue",
        "mfValue",
        "mrValue",
        "npMegaValue",
    },
}

local DEMAND_FIELDS = {

    NP = {
        "npRegularDemand",
        "regularDemand",
    },

    F = {
        "fDemand",
        "regularDemand",
    },

    R = {
        "rDemand",
        "regularDemand",
    },

    FR = {
        "regularDemand",
    },

    N = {
        "npNeonDemand",
        "neonDemand",
    },

    NF = {
        "nfDemand",
        "neonDemand",
    },

    NR = {
        "nrDemand",
        "neonDemand",
    },

    NFR = {
        "neonDemand",
    },

    M = {
        "npMegaDemand",
        "megaDemand",
    },

    MF = {
        "mfDemand",
        "megaDemand",
    },

    MR = {
        "mrDemand",
        "megaDemand",
    },

    MFR = {
        "megaDemand",
    },
}

local function firstNumber(
    entry,
    fields
)

    for index,
        field
        in ipairs(fields)
    do

        local value =
            numeric(
                entry[field]
            )

        if value ~= nil then

            return
                value,
                field,
                index > 1
        end
    end
end

local function firstValue(
    entry,
    fields
)

    for _, field in ipairs(fields) do

        if entry[field] ~= nil then

            return
                entry[field],
                field
        end
    end
end

--============================================================
-- GENERIC VALUE
--============================================================

local function genericValue(entry)

    local fields = {

        "value",

        "regularValue",

        "npRegularValue",
    }

    return
        firstNumber(
            entry,
            fields
        )
end

--============================================================
-- ANALYZE ITEM
--============================================================

local function analyze(item)

    local result = {

        name =
            itemName(
                item
            ),

        category =
            categoryName(
                item
            ),

        variant =
            variant(
                item
            ),

        found =
            false,

        value =
            nil,

        demand =
            nil,

        fallback =
            false,

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
            and "LOADING"
            or "AMVGG OFFLINE"

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

    result.found =
        true

    result.source =
        source

    --========================================================
    -- PET
    --========================================================

    if source == "pets" then

        local v =
            result.variant

        local fields =
            PET_FIELDS[v]

        if not fields then

            result.reason =
                "UNKNOWN VARIANT"

            return result
        end

        local value,
            field,
            fallback =
            firstNumber(
                entry,
                fields
            )

        result.value =
            value

        result.field =
            field

        result.fallback =
            fallback == true

        local demandFields =
            DEMAND_FIELDS[v]

        if demandFields then

            result.demand =
                firstValue(
                    entry,
                    demandFields
                )
        end

        if value == nil then

            result.reason =
                "NO VARIANT VALUE"
        end

        return result
    end

    --========================================================
    -- OTHER AMVGG CATEGORY
    --========================================================

    result.variant =
        ""

    local value,
        field,
        fallback =
        genericValue(
            entry
        )

    result.value =
        value

    result.field =
        field

    result.fallback =
        fallback == true

    result.demand =
        entry.demand
        or entry.regularDemand

    if value == nil then

        result.reason =
            "NO VALUE"
    end

    return result
end

--============================================================
-- PLAYER
--============================================================

local function playerName(value)

    if typeof(value) == "Instance" then
        return value.Name
    end

    return
        tostring(
            value or "Unknown"
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
-- GUI CORE
--============================================================

boot(
    "4/8",
    "Building GUI"
)

local Gui =
    Instance.new("ScreenGui")

Gui.Name =
    "AdoptMeTradeAnalyzerV1160"

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

corner(
    Main,
    12
)

stroke(
    Main,
    0.15
)

--============================================================
-- TOP
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

local Version =
    label(
        Top,

        "V11.6.0",

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

Version.BackgroundTransparency =
    0

Version.BackgroundColor3 =
    Color3.fromRGB(
        35,
        50,
        80
    )

corner(
    Version,
    6
)

local Close =
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
-- DRAG MAIN
--============================================================

local dragging =
    false

local dragStart
local originalPosition

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

            originalPosition =
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
            originalPosition.X.Scale
            * viewport.X
            + originalPosition.X.Offset
            + delta.X

        local y =
            originalPosition.Y.Scale
            * viewport.Y
            + originalPosition.Y.Offset
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

    local x =
        Instance.new("Frame")

    x.Name =
        name

    x.Size =
        UDim2.fromScale(
            1,
            1
        )

    x.BackgroundTransparency =
        1

    x.Visible =
        false

    x.Parent =
        Content

    Pages[name] =
        x

    return x
end

local function setPage(name)

    for key, page in pairs(Pages) do

        page.Visible =
            key == name
    end

    for key, nav in pairs(Navigation) do

        if key == name then

            nav.BackgroundColor3 =
                Color3.fromRGB(
                    48,
                    76,
                    130
                )

            nav.TextColor3 =
                C.TEXT

        else

            nav.BackgroundColor3 =
                C.PANEL

            nav.TextColor3 =
                C.MUTED
        end
    end
end

local function nav(
    name,
    y
)

    local x =
        button(
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

    x.TextXAlignment =
        Enum.TextXAlignment.Left

    x.BackgroundColor3 =
        C.PANEL

    x.TextColor3 =
        C.MUTED

    x.Activated:Connect(
        function()

            setPage(
                name
            )
        end
    )

    Navigation[name] =
        x
end

nav(
    "TRADE",
    46
)

nav(
    "VALUES",
    96
)

nav(
    "UPDATES",
    146
)

nav(
    "SETTINGS",
    196
)

--============================================================
-- TRADE PAGE
--============================================================

boot(
    "5/8",
    "Building trade page"
)

local TradePage =
    createPage(
        "TRADE"
    )

label(
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

local Counts =
    label(
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

local Status =
    label(
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

local Stage =
    label(
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

Stage.BackgroundTransparency =
    0

Stage.BackgroundColor3 =
    C.PANEL2

corner(
    Stage,
    7
)

local Area =
    Instance.new("Frame")

Area.Position =
    UDim2.fromOffset(
        16,
        77
    )

Area.Size =
    UDim2.new(
        1,
        -32,
        1,
        -89
    )

Area.BackgroundColor3 =
    C.PANEL

Area.BorderSizePixel =
    0

Area.Parent =
    TradePage

corner(
    Area,
    10
)

stroke(
    Area,
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
    Area

label(
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

local Result =
    label(
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

local Difference =
    label(
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

Difference.TextWrapped =
    true

--============================================================
-- OFFER
--============================================================

local function offerPanel(x)

    local Panel =
        Instance.new("Frame")

    Panel.Position =
        UDim2.new(
            x,
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
        Area

    corner(
        Panel,
        9
    )

    local Name =
        label(
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
        label(
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
        label(
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

    corner(
        Ready,
        5
    )

    local Total =
        label(
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

    corner(
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

    local function canvas()

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
        canvas
    )

    task.defer(
        canvas
    )

    return {

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
    offerPanel(
        0.008
    )

local Theirs =
    offerPanel(
        0.567
    )

--============================================================
-- SLOTS
--============================================================

local function makeSlot(
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

    corner(
        Frame,
        7
    )

    stroke(
        Frame,
        0.5
    )

    label(
        Frame,

        "#"
        .. index,

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
        label(
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
        label(
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
        label(
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
        label(
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

    local slot = {

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
    }

    side.Slots[index] =
        slot

    return slot
end

for i = 1, 18 do

    makeSlot(
        Yours,
        i
    )

    makeSlot(
        Theirs,
        i
    )
end

local function clearSlot(slot)

    slot.Item =
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
end

local function fillSlot(
    slot,
    item
)

    slot.Item =
        item

    local data =
        analyze(
            item
        )

    slot.Name.Text =
        data.name

    slot.Name.TextColor3 =
        C.TEXT

    slot.Variant.Text =
        data.variant

    slot.Variant.TextColor3 =
        variantColor(
            data.variant
        )

    slot.Category.Text =
        data.category

    if data.value ~= nil then

        slot.Value.Text =
            "V "
            .. numText(
                data.value
            )

        slot.Value.TextColor3 =
            data.fallback
            and C.YELLOW
            or C.ACCENT

        if data.fallback then

            print(
                "[AMVGG FALLBACK]",
                data.name,
                data.variant,
                "FIELD=",
                data.field
            )
        end

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

    return
        0,
        false
end

--============================================================
-- SIDE
--============================================================

local function updateSide(
    side,
    offer
)

    local items =
        {}

    if
        type(offer) == "table"
        and type(
            offer.items
        ) == "table"
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
        count .. " / 18"

    for i = 1, 18 do

        if items[i] then

            local value,
                known =
                fillSlot(
                    side.Slots[i],
                    items[i]
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
            .. numText(total)

        side.Total.TextColor3 =
            C.ACCENT

    else

        side.Total.Text =
            "KNOWN: "
            .. numText(total)
            .. "  •  ?x"
            .. missing

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
-- SIGNATURE
--============================================================

local function signature(
    offer
)

    if
        type(offer) ~= "table"
        or type(
            offer.items
        ) ~= "table"
    then

        return "-"
    end

    local x =
        {}

    for index, item in ipairs(offer.items) do

        x[#x + 1] =
            tostring(
                item.unique
                or item.kind
                or index
            )
    end

    x[#x + 1] =
        tostring(
            offer.negotiated
        )

    x[#x + 1] =
        tostring(
            offer.confirmed
        )

    return
        table.concat(
            x,
            "|"
        )
end

local LastSignature =
    nil

--============================================================
-- RESULT
--============================================================

local function result(
    mine,
    theirs
)

    if
        mine.missing > 0
        or theirs.missing > 0
    then

        Result.Text =
            "INCOMPLETE"

        Result.TextColor3 =
            C.YELLOW

        Difference.Text =
            "missing values"

        return
    end

    if
        mine.count == 0
        and theirs.count == 0
    then

        Result.Text =
            "WAIT"

        Result.TextColor3 =
            C.MUTED

        Difference.Text =
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

    Difference.Text =
        (
            difference >= 0
            and "+"
            or ""
        )
        .. numText(
            difference
        )

    if percent <= 0.02 then

        Result.Text =
            "FAIR"

        Result.TextColor3 =
            C.YELLOW

    elseif difference > 0 then

        Result.Text =
            "WIN"

        Result.TextColor3 =
            C.GREEN

    else

        Result.Text =
            "LOSE"

        Result.TextColor3 =
            C.RED
    end
end

--============================================================
-- TRADE UPDATE
--============================================================

local function noTrade()

    Yours.Name.Text =
        LocalPlayer.Name

    Theirs.Name.Text =
        "NO PARTNER"

    Stage.Text =
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

    Counts.Text =
        "YOU 0/18   •   THEM 0/18"

    result(
        mine,
        theirs
    )
end

local function updateTrade()

    local ok, trade =
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

        noTrade()

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

    local sig =
        tostring(
            trade.trade_id
        )
        .. ":"
        .. tostring(
            trade.current_stage
        )
        .. ":"
        .. signature(
            myOffer
        )
        .. ":"
        .. signature(
            theirOffer
        )
        .. ":"
        .. AMVGG.version

    if sig == LastSignature then
        return
    end

    LastSignature =
        sig

    Yours.Name.Text =
        playerName(me)

    Theirs.Name.Text =
        playerName(partner)

    Stage.Text =
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

    Counts.Text =
        "YOU "
        .. mine.count
        .. "/18   •   THEM "
        .. theirs.count
        .. "/18"

    result(
        mine,
        theirs
    )
end

--============================================================
-- VALUES PAGE
--============================================================

boot(
    "6/8",
    "Building values page"
)

local ValuesPage =
    createPage(
        "VALUES"
    )

label(
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
    label(
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

local Search =
    Instance.new("TextBox")

Search.Position =
    UDim2.fromOffset(
        20,
        84
    )

Search.Size =
    UDim2.new(
        0.64,
        -20,
        0,
        34
    )

Search.BackgroundColor3 =
    C.PANEL

Search.BorderSizePixel =
    0

Search.PlaceholderText =
    "Dark Choccybunny"

Search.PlaceholderColor3 =
    C.MUTED

Search.TextColor3 =
    C.TEXT

Search.Font =
    Enum.Font.Code

Search.TextSize =
    11

Search.ClearTextOnFocus =
    false

Search.Parent =
    ValuesPage

corner(
    Search,
    7
)

local SearchButton =
    button(
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

local Refresh =
    button(
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

corner(
    ResultBox,
    8
)

--============================================================
-- SEARCH ALL DB
--============================================================

local function searchValues()

    if not AMVGG.ready then

        ResultBox.Text =
            "AMVGG NOT READY"

        return
    end

    local q =
        normalize(
            Search.Text
        )

    if q == "" then

        ResultBox.Text =
            "Enter item name"

        return
    end

    local matches =
        {}

    for slug, db in pairs(AMVGG.categories) do

        for key, entry in pairs(db) do

            if
                key == q
                or key:find(
                    q,
                    1,
                    true
                )
            then

                matches[
                    #matches + 1
                ] = {
                    slug =
                        slug,

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
            .. Search.Text

        return
    end

    local exact

    for _, match in ipairs(matches) do

        if
            normalize(
                match.entry.name
            )
            == q
        then

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
            .. exact.slug,

            "",
        }

        if exact.slug == "pets" then

            for _, v in ipairs({
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
            }) do

                local value,
                    field,
                    fallback =
                    firstNumber(
                        entry,
                        PET_FIELDS[v]
                    )

                lines[
                    #lines + 1
                ] =
                    string.format(
                        "%-4s = %-10s [%s%s]",
                        v,
                        tostring(value),
                        tostring(field),
                        fallback and " fallback" or ""
                    )
            end

        else

            local value,
                field =
                genericValue(
                    entry
                )

            lines[
                #lines + 1
            ] =
                "VALUE = "
                .. tostring(value)

            lines[
                #lines + 1
            ] =
                "FIELD = "
                .. tostring(field)
        end

        lines[
            #lines + 1
        ] =
            ""

        lines[
            #lines + 1
        ] =
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

        names[
            #names + 1
        ] =
            tostring(
                match.entry.name
            )
            .. " ["
            .. match.slug
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

Search.FocusLost:Connect(
    function(enter)

        if enter then
            searchValues()
        end
    end
)

--============================================================
-- UPDATES
--============================================================

local UpdatesPage =
    createPage(
        "UPDATES"
    )

label(
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
    label(
        UpdatesPage,

        "V11.6.0\n\n"
        .. "• Fixed Dark Choccybunny lookup\n"
        .. "• Fixed duplicate RSC objects\n"
        .. "• Added exact → same-tier fallback\n"
        .. "• Added every AMVGG value category\n"
        .. "• Added food / petwear / vehicles / toys / gifts\n"
        .. "• Added detailed Values diagnostics\n\n"
        .. "NEXT:\n"
        .. "• Value change history\n"
        .. "• New-item firstSeen cache\n"
        .. "• 24h new-item protection",

        UDim2.new(
            1,
            -44,
            0,
            350
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
-- SETTINGS
--============================================================

local SettingsPage =
    createPage(
        "SETTINGS"
    )

label(
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
    label(
        SettingsPage,

        "TRADE SLOTS            18\n\n"
        .. "PET VARIANTS          12\n\n"
        .. "AMVGG CATEGORIES       10\n\n"
        .. "EXACT VALUE FIRST      ON\n\n"
        .. "SAME-TIER FALLBACK     ON\n\n"
        .. "FAIR RANGE             ±2%\n\n"
        .. "UNKNOWN BLOCKS RESULT  ON\n\n"
        .. "AUTO ACCEPT            OFF",

        UDim2.new(
            1,
            -44,
            0,
            300
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

local function updateStatus()

    local text
    local color

    if AMVGG.loading then

        text =
            "AMVGG: LOADING..."

        color =
            C.YELLOW

    elseif AMVGG.ready then

        text =
            "AMVGG LIVE • P:"
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

    Status.Text =
        text

    Status.TextColor3 =
        color

    ValuesStatus.Text =
        text

    ValuesStatus.TextColor3 =
        color
end

--============================================================
-- REFRESH
--============================================================

local function refresh()

    if AMVGG.loading then
        return
    end

    Status.Text =
        "AMVGG: LOADING..."

    ValuesStatus.Text =
        "AMVGG: LOADING..."

    local ok,
        err =
        xpcall(
            function()

                loadAllAMVGG()

            end,

            trace
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

    updateStatus()

    LastSignature =
        nil

    pcall(
        updateTrade
    )
end

Refresh.Activated:Connect(
    function()

        task.spawn(
            refresh
        )
    end
)

--============================================================
-- AM FLOAT BUTTON
--============================================================

local Open =
    Instance.new("TextButton")

Open.Size =
    UDim2.fromOffset(
        62,
        62
    )

Open.Position =
    UDim2.new(
        1,
        -78,
        0.52,
        -31
    )

Open.BackgroundColor3 =
    Color3.fromRGB(
        48,
        76,
        130
    )

Open.BorderSizePixel =
    0

Open.Text =
    "AM"

Open.TextColor3 =
    C.TEXT

Open.Font =
    Enum.Font.GothamBold

Open.TextSize =
    17

Open.Visible =
    false

Open.Parent =
    Gui

corner(
    Open,
    17
)

--============================================================
-- HIDE / OPEN
--============================================================

Close.Activated:Connect(
    function()

        Main.Visible =
            false

        Open.Visible =
            true
    end
)

Open.Activated:Connect(
    function()

        Main.Visible =
            true

        Open.Visible =
            false

        LastSignature =
            nil

        pcall(
            updateTrade
        )
    end
)

--============================================================
-- START
--============================================================

boot(
    "7/8",
    "Starting live systems"
)

setPage(
    "TRADE"
)

updateStatus()

pcall(
    updateTrade
)

task.spawn(
    function()

        while Gui.Parent do

            pcall(
                updateTrade
            )

            task.wait(
                0.65
            )
        end
    end
)

task.spawn(
    function()

        while Gui.Parent do

            pcall(
                updateStatus
            )

            task.wait(
                1
            )
        end
    end
)

-- AMVGG refresh every 15 minutes
task.spawn(
    function()

        task.wait(
            1.5
        )

        while Gui.Parent do

            refresh()

            task.wait(
                15 * 60
            )
        end
    end
)

boot(
    "8/8",
    "READY"
)

print(
    "[AM V11.6.0] READY"
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
