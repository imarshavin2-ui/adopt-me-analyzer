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
    "11.7.9"

local GUI_NAME =
    "AdoptMeTradeAnalyzerV1179"

local BOOT_NAME =
    "AM_ANALYZER_BOOT_V1179"


print(
    "[AM V" .. VERSION .. "] BOOT"
)

print(
    "[AM V" .. VERSION .. "] DYNAMIC REBUILD + MIN VALUE FILTERS + V11.6.2 VARIANT ENGINE"
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
}


for _,
    name in ipairs(
        OLD_GUI_NAMES
    )
do

    local object =
        GuiParent:
        FindFirstChild(
            name
        )

    if object then
        object:Destroy()
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

    if type(value) == "number" then
        return value
    end

    return tonumber(value)
end


local function round(
    value,
    decimals
)

    if type(value) ~= "number" then
        return nil
    end

    local power =
        10 ^ (
            decimals
            or 6
        )

    return
        math.floor(
            value
            * power
            + 0.5
        )
        / power
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

    while
        cursor
        <= #body
    do

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
            ending =
            extractObject(
                body,
                position
            )

        if
            not jsonText
            or not ending
        then

            cursor =
                position
                + 5

            continue
        end

        cursor =
            ending
            + 1

        local ok,
            object =
            pcall(
                function()

                    return
                        HttpService:
                        JSONDecode(
                            jsonText
                        )
                end
            )

        if
            ok
            and validEntry(
                object
            )
        then

            local key =
                normalize(
                    object.name
                )

            if key ~= "" then

                if
                    not database[
                        key
                    ]
                then

                    database[key] =
                        {}

                    count =
                        count
                        + 1
                end

                merge(
                    database[key],
                    object
                )
            end
        end

        scanned =
            scanned
            + 1

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

            if count > bestCount then

                bestDatabase =
                    database

                bestCount =
                    count
            end

            if count >= 3 then
                break
            end
        end

        task.wait(
            0.12
        )
    end

    return
        bestDatabase,
        bestCount,
        lastStatus
end


local function refresh()

    if AMVGG.loading then
        return false
    end

    AMVGG.loading =
        true

    AMVGG.error =
        nil

    local nextCategories =
        {}

    local nextCounts =
        {}

    local total =
        0

    local failed =
        {}

    for _,
        slug in ipairs(
            CATEGORY_URLS
        )
    do

        local database,
            count,
            status =
            loadCategory(
                slug
            )

        nextCategories[slug] =
            database

        nextCounts[slug] =
            count

        total =
            total
            + count

        if count <= 0 then

            failed[
                #failed + 1
            ] =
                slug
                .. "("
                .. tostring(
                    status
                )
                .. ")"
        end

        task.wait()
    end

    if total <= 0 then

        AMVGG.loading =
            false

        AMVGG.error =
            "NO AMVGG DATA"

        return false
    end

    AMVGG.categories =
        nextCategories

    AMVGG.counts =
        nextCounts

    AMVGG.total =
        total

    AMVGG.ready =
        true

    AMVGG.loading =
        false

    AMVGG.version =
        AMVGG.version
        + 1

    AMVGG.lastRefresh =
        os.time()

    if #failed > 0 then

        AMVGG.error =
            "PARTIAL: "
            .. table.concat(
                failed,
                ", "
            )
    end

    return true
end


--============================================================
-- AMVGG LOOKUP
--============================================================

local function findCategory(
    slug,
    itemName
)

    local category =
        AMVGG.categories[
            slug
        ]

    if type(category) ~= "table" then
        return nil
    end

    local keys =
        aliases(
            itemName
        )

    for key in pairs(
        keys
    ) do

        local direct =
            category[key]

        if direct then

            return
                direct,
                key
        end
    end

    for key,
        entry in pairs(
            category
        )
    do

        if type(entry) == "table" then

            local entryAliases =
                aliases(
                    entry.name
                )

            for wanted in pairs(
                keys
            ) do

                if
                    entryAliases[
                        wanted
                    ]
                then

                    return
                        entry,
                        key
                end
            end
        end
    end

    return nil
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

local function calculateCategoryVariants(
    category,
    regularValue,
    neonValue,
    megaValue
)
    category = tonumber(category)

    local m = MULTIPLIERS[category]

    if not m then
        return nil
    end

    regularValue = num(regularValue)
    neonValue = num(neonValue)
    megaValue = num(megaValue)

    if
        regularValue == nil
        or neonValue == nil
        or megaValue == nil
    then
        return nil
    end

    local regularDecimals = 4

    if regularValue >= 0.0175 then
        regularDecimals = 3
    end

    local result = {}

    -- REGULAR
    if category == 11 and regularValue > 0.08 then
        result.NP =
            round(
                regularValue * 0.95,
                regularDecimals
            )

        result.R =
            round(
                regularValue * 0.975,
                regularDecimals
            )

        result.F =
            round(
                regularValue * 0.975,
                regularDecimals
            )
    else
        result.NP =
            round(
                regularValue * m.NP,
                regularDecimals
            )

        result.R =
            round(
                regularValue * m.R,
                regularDecimals
            )

        result.F =
            round(
                regularValue * m.F,
                regularDecimals
            )
    end

    result.FR = regularValue

    -- NEON
    result.N =
        round(
            neonValue * m.NNP,
            4
        )

    if category == 11 and neonValue > 0.2 then
        result.NR = neonValue
        result.NF = neonValue
    else
        result.NR =
            round(
                neonValue * m.NR,
                4
            )

        result.NF =
            round(
                neonValue * m.NF,
                4
            )
    end

    result.NFR = neonValue

    -- MEGA
    result.M =
        round(
            megaValue * m.MNP,
            4
        )

    if category == 11 and megaValue > 0.9 then
        result.MR = megaValue
        result.MF = megaValue
    else
        result.MR =
            round(
                megaValue * m.MR,
                4
            )

        result.MF =
            round(
                megaValue * m.MF,
                4
            )
    end

    result.MFR = megaValue

    return result
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

        return
            value,
            field,
            false,
            value ~= nil and nil or "CATEGORY 13 FIELD NIL"
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
        value ~= nil and nil or "CALCULATED NIL"
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
        if value ~= nil then
            return value, field
        end
    end

    return nil
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
            getCategoryDisplay(
                item
            ),

        variant =
            getVariant(
                item
            ),

        source =
            nil,

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

local SETTINGS_FILE =
    "am_trade_v1170.json"

local FIRST_SEEN_FILE =
    "am_first_seen_v1170.json"


local Settings = {

    testAutoAccept =
        false,

    autoTrade =
        false,

    minProfitPercent =
        10,

    -- Minimum-value filter mode:
    -- ALL      -> ALL MIN ITEM VALUE applies to both sides.
    -- SEPARATE -> MY and THEIR thresholds are independent.
    minValueMode =
        "ALL",

    myMinItemValue =
        0.0003,

    theirMinItemValue =
        0.0003,

    allMinItemValue =
        0.0003,

    requestTimeout =
        15,

    firstItemTimeout =
        25,

    addTimeout =
        40,

    playerCooldown =
        300,

    settleSeconds =
        2,

    maxTradeSeconds =
        120,

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

    -- Delay between every add/remove action in our offer.
    -- This prevents the bot from dumping many units into the trade at once.
    itemActionDelay =
        0.85,

    -- Extra wait after the chosen offer has been fully rebuilt.
    postRebuildDelay =
        1.25,

    -- Countdown after the final offer is stable before ACCEPT.
    preAcceptDelay =
        4,

    -- Many low/mid pets on AMVGG do not expose an exact NP/R/F field and
    -- fall back to our variant estimate. Allow those estimates only for
    -- OUR pets so the optimizer can actually use pets. Incoming estimated
    -- values can still be blocked by BLOCK ESTIMATED VALUES.
    allowEstimatedOwnPets =
        true,

    blockEstimated =
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

            if Settings[key] ~= nil then

                Settings[key] =
                    value
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
    math.max(0, tonumber(Settings.myMinItemValue) or 0.0003)

Settings.theirMinItemValue =
    math.max(0, tonumber(Settings.theirMinItemValue) or 0.0003)

Settings.allMinItemValue =
    math.max(0, tonumber(Settings.allMinItemValue) or 0.0003)

-- Maximum one automation mode at a time. If an old save somehow has both ON,
-- real AUTO TRADE wins and TEST AUTO TRADE is switched off.
if Settings.autoTrade and Settings.testAutoAccept then
    Settings.testAutoAccept = false
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
            }
        end
    end

    local analysis =
        analyzeItem(
            item
        )

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

    local result = {

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

            raw =
                item,

            data =
                data,

            ignoredByMin =
                false,
        }

        result.items[
            #result.items + 1
        ] = row

        local function addKnownValue()

            if
                type(data.value) == "number"
                and data.value < minValue
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
            end

            result.total =
                result.total
                + data.value
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


TradeRemote.SuggestItem,
TradeRemote.SuggestItemName =
    resolveRemote({

        "TradeAPI/SuggestItem",
    })


TradeRemote.SuggestRemove,
TradeRemote.SuggestRemoveName =
    resolveRemote({

        "TradeAPI/SuggestRemoveItem",
    })


local function remoteCall(
    remote,
    ...
)

    if not remote then

        return
            false,
            "REMOTE MISSING"
    end

    local args =
        {...}

    local ok,
        result =
        pcall(
            function()

                if typeof(remote) == "Instance" then

                    if
                        remote:IsA(
                            "RemoteEvent"
                        )
                    then

                        remote:FireServer(
                            table.unpack(
                                args
                            )
                        )

                        return true
                    end

                    if
                        remote:IsA(
                            "RemoteFunction"
                        )
                    then

                        return
                            remote:
                            InvokeServer(
                                table.unpack(
                                    args
                                )
                            )
                    end
                end

                if type(remote) == "function" then

                    return
                        remote(
                            table.unpack(
                                args
                            )
                        )
                end

                if type(remote) == "table" then

                    if
                        type(
                            remote.FireServer
                        ) == "function"
                    then

                        return
                            remote:
                            FireServer(
                                table.unpack(
                                    args
                                )
                            )
                    end

                    if
                        type(
                            remote.InvokeServer
                        ) == "function"
                    then

                        return
                            remote:
                            InvokeServer(
                                table.unpack(
                                    args
                                )
                            )
                    end
                end

                error(
                    "UNSUPPORTED REMOTE"
                )
            end
        )

    if not ok then

        return
            false,
            result
    end

    return
        true,
        result
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
            and data.value
                >= activeMinItemValue("mine")
            -- AUTO TRADE must never build an offer from guessed pet values.
            -- Estimated values may still be displayed outside AUTO TRADE,
            -- but the optimizer only receives exact AMVGG variants.
            and not (
                Settings.autoTrade
                and data.estimated
            )
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
    theirValue
)

    local target =
        tonumber(
            Settings.minProfitPercent
        )
        or 10

    local cap =
        theirValue
        / (
            1
            + target / 100
        )

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

        local cut =
            {}

        for i = 1, 140 do
            cut[i] = candidates[i]
        end

        candidates =
            cut
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

    for _,
        candidate in ipairs(
            candidates
        )
    do

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


local function rebuildOurOffer(
    myOffer,
    desired,
    expectedTheirSignature
)

    -- The other player can add/remove/replace units while we are
    -- rebuilding our side. Never finish a stale build.
    local function liveTheirSignature()

        local trade =
            getTrade()

        if not trade then
            return nil
        end

        local _,
            currentTheirOffer =
            getTradeSides(
                trade
            )

        if not currentTheirOffer then
            return nil
        end

        return
            offerSignature(
                currentTheirOffer
            )
    end

    local function theirOfferStillCurrent()

        if expectedTheirSignature == nil then
            return true
        end

        return
            liveTheirSignature()
            == expectedTheirSignature
    end

    if not theirOfferStillCurrent() then
        return false, "THEIR_CHANGED"
    end

    local current =
        currentUIDSet(
            myOffer
        )

    local wanted =
        {}

    for _,
        candidate in ipairs(
            desired
        )
    do

        wanted[
            candidate.uid
        ] =
            true
    end

    local actionDelay =
        math.max(
            0.1,
            tonumber(
                Settings.itemActionDelay
            )
            or 0.85
        )

    -- Remove slowly first.
    for _,
        item in pairs(
            getOfferItems(
                myOffer
            )
        )
    do

        local uid =
            itemUID(
                item
            )

        if uid then

            uid =
                tostring(
                    uid
                )

            if not wanted[uid] then

                task.wait(
                    actionDelay
                )

                if not theirOfferStillCurrent() then
                    return false, "THEIR_CHANGED"
                end

                removeOurItem(
                    uid
                )

                if not theirOfferStillCurrent() then
                    return false, "THEIR_CHANGED"
                end
            end
        end
    end

    -- Let the client receive removals before additions.
    task.wait(
        math.max(
            0.25,
            tonumber(
                Settings.postRebuildDelay
            )
            or 1.25
        )
        * 0.5
    )

    if not theirOfferStillCurrent() then
        return false, "THEIR_CHANGED"
    end

    -- Add every selected unit one by one, with a visible delay.
    for _,
        candidate in ipairs(
            desired
        )
    do

        if
            not current[
                candidate.uid
            ]
        then

            task.wait(
                actionDelay
            )

            if not theirOfferStillCurrent() then
                return false, "THEIR_CHANGED"
            end

            addOurItem(
                candidate.uid
            )

            if not theirOfferStillCurrent() then
                return false, "THEIR_CHANGED"
            end
        end
    end

    task.wait(
        math.max(
            0.25,
            tonumber(
                Settings.postRebuildDelay
            )
            or 1.25
        )
    )

    if not theirOfferStillCurrent() then
        return false, "THEIR_CHANGED"
    end

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


local Gui =
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


Top.InputBegan:
Connect(
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


UIS.InputChanged:
Connect(
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


UIS.InputEnded:
Connect(
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

    value.Activated:
    Connect(
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

-- Separate TEST tab: intentionally placed high so it remains visible on mobile.
nav(
    "TEST",
    178
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


local function rebuildSearch()

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


SearchBox:
GetPropertyChangedSignal(
    "Text"
):
Connect(
    function()

        task.delay(
            0.15,
            rebuildSearch
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


local function updateStatusPage()

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


RefreshButton.Activated:
Connect(
    function()

        task.spawn(
            function()

                refresh()

                updateFirstSeen()

                updateStatusPage()

                rebuildSearch()
            end
        )
    end
)


--============================================================
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


local RefreshSetting =
    textBox(
        SettingsPage,
        Settings.refreshMinutes,
        "5",

        UDim2.fromOffset(
            100,
            32
        ),

        UDim2.fromOffset(
            220,
            60
        )
    )


label(
    SettingsPage,
    "AMVGG REFRESH MINUTES",

    UDim2.fromOffset(
        195,
        32
    ),

    UDim2.fromOffset(
        16,
        60
    ),

    Enum.Font.GothamBold,
    10,
    C.MUTED
)


local EstimatedToggle =
    button(
        SettingsPage,
        "",

        UDim2.fromOffset(
            260,
            36
        ),

        UDim2.fromOffset(
            16,
            110
        )
    )


local function renderEstimated()

    EstimatedToggle.Text =
        "BLOCK ESTIMATED VALUES: "
        .. (
            Settings.blockEstimated
            and "ON"
            or "OFF"
        )

    EstimatedToggle.BackgroundColor3 =
        Settings.blockEstimated
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end


EstimatedToggle.Activated:
Connect(
    function()

        Settings.blockEstimated =
            not Settings.blockEstimated

        saveSettings()

        renderEstimated()
    end
)


RefreshSetting.FocusLost:
Connect(
    function()

        local value =
            tonumber(
                RefreshSetting.Text
            )

        if value then

            Settings.refreshMinutes =
                math.clamp(
                    value,
                    1,
                    120
                )

            saveSettings()
        end
    end
)


renderEstimated()


--============================================================
-- TEST PAGE
--============================================================

local TestPage =
    createPage(
        "TEST"
    )


label(
    TestPage,
    "TEST / AUTO TRADE",

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


local TestStatus =
    label(
        TestPage,
        "STATUS: OFF",

        UDim2.new(
            1,
            -30,
            0,
            24
        ),

        UDim2.fromOffset(
            16,
            40
        ),

        Enum.Font.Code,
        10,
        C.MUTED
    )


local TestScroll =
    makeScroll(
        TestPage,

        UDim2.new(
            1,
            -30,
            1,
            -78
        ),

        UDim2.fromOffset(
            15,
            66
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
        1540
    )

TestCanvas.BackgroundTransparency =
    1

TestCanvas.Parent =
    TestScroll


local TestToggle =
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
            54
        )
    )


local function renderModes()

    TestToggle.Text =
        "TEST AUTO TRADE: "
        .. (
            Settings.testAutoAccept
            and "ON"
            or "OFF"
        )

    AutoToggle.Text =
        "AUTO TRADE: "
        .. (
            Settings.autoTrade
            and "ON"
            or "OFF"
        )

    TestToggle.BackgroundColor3 =
        Settings.testAutoAccept
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2

    AutoToggle.BackgroundColor3 =
        Settings.autoTrade
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end


TestToggle.Activated:
Connect(
    function()

        Settings.testAutoAccept =
            not Settings.testAutoAccept

        if Settings.testAutoAccept then
            -- TEST AUTO TRADE and AUTO TRADE are mutually exclusive.
            Settings.autoTrade = false
        end

        saveSettings()

        renderModes()
    end
)


AutoToggle.Activated:
Connect(
    function()

        Settings.autoTrade =
            not Settings.autoTrade

        if Settings.autoTrade then
            -- AUTO TRADE and TEST AUTO TRADE are mutually exclusive.
            Settings.testAutoAccept = false

            -- Real AUTO TRADE is always strict. The old estimated-value
            -- multipliers are useful only for rough display/testing.
            Settings.blockEstimated = true
        end

        saveSettings()

        renderModes()
    end
)


renderModes()


-- Keep Auto Trade-related safety/source settings on the TEST page too,
-- so the whole test/auto-trade setup is available from one tab.
label(
    TestCanvas,
    "AUTO TRADE / TEST AUTO TRADE SETTINGS",

    UDim2.new(
        1,
        -24,
        0,
        24
    ),

    UDim2.fromOffset(
        12,
        98
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
            34
        ),

        UDim2.fromOffset(
            10,
            126
        )
    )


local function renderTestEstimated()

    TestEstimatedToggle.Text =
        "BLOCK ESTIMATED VALUES: "
        .. (
            Settings.blockEstimated
            and "ON"
            or "OFF"
        )

    TestEstimatedToggle.BackgroundColor3 =
        Settings.blockEstimated
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end


TestEstimatedToggle.Activated:
Connect(
    function()

        Settings.blockEstimated =
            not Settings.blockEstimated

        saveSettings()

        renderEstimated()
        renderTestEstimated()
    end
)


renderTestEstimated()


local AllowEstimatedOwnPetsToggle =
    button(
        TestCanvas,
        "",

        UDim2.new(
            1,
            -24,
            0,
            34
        ),

        UDim2.fromOffset(
            10,
            166
        )
    )


local function renderAllowEstimatedOwnPets()

    AllowEstimatedOwnPetsToggle.Text =
        "USE ESTIMATED OWN PETS: "
        .. (
            Settings.allowEstimatedOwnPets
            and "ON"
            or "OFF"
        )

    AllowEstimatedOwnPetsToggle.BackgroundColor3 =
        Settings.allowEstimatedOwnPets
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end


AllowEstimatedOwnPetsToggle.Activated:
Connect(
    function()

        Settings.allowEstimatedOwnPets =
            not Settings.allowEstimatedOwnPets

        saveSettings()
        renderAllowEstimatedOwnPets()
    end
)


renderAllowEstimatedOwnPets()


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


local ProfitInput =
    settingInput(
        "MIN PROFIT %",
        Settings.minProfitPercent,
        208
    )


local AddTimeoutInput =
    settingInput(
        "ADD TIMEOUT",
        Settings.addTimeout,
        246
    )


local FirstTimeoutInput =
    settingInput(
        "FIRST ITEM TIMEOUT",
        Settings.firstItemTimeout,
        284
    )


local RequestTimeoutInput =
    settingInput(
        "REQUEST TIMEOUT",
        Settings.requestTimeout,
        322
    )


local CooldownInput =
    settingInput(
        "PLAYER COOLDOWN",
        Settings.playerCooldown,
        360
    )


local NewHoursInput =
    settingInput(
        "NEW ITEM HOURS",
        Settings.newItemHours,
        398
    )


local ItemActionDelayInput =
    settingInput(
        "ITEM ACTION DELAY",
        Settings.itemActionDelay,
        436
    )


local PreAcceptDelayInput =
    settingInput(
        "PRE ACCEPT DELAY",
        Settings.preAcceptDelay,
        474
    )


local PostRebuildDelayInput =
    settingInput(
        "POST REBUILD WAIT",
        Settings.postRebuildDelay,
        512
    )


local function bindNumber(
    input,
    key,
    min,
    max
)

    input.FocusLost:
    Connect(
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
            557
        )
    )


local MyMinValueInput =
    settingInput(
        "MY MIN ITEM VALUE",
        Settings.myMinItemValue,
        601
    )


local TheirMinValueInput =
    settingInput(
        "THEIR MIN ITEM VALUE",
        Settings.theirMinItemValue,
        639
    )


local AllMinValueInput =
    settingInput(
        "ALL MIN ITEM VALUE",
        Settings.allMinItemValue,
        677
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
            715
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


MinValueModeToggle.Activated:
Connect(
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
    0,
    1000
)

bindNumber(
    TheirMinValueInput,
    "theirMinItemValue",
    0,
    1000
)

bindNumber(
    AllMinValueInput,
    "allMinItemValue",
    0,
    1000
)

-- Refresh the active-filter text immediately after a numeric edit.
for _, input in ipairs({
    MyMinValueInput,
    TheirMinValueInput,
    AllMinValueInput,
}) do
    input.FocusLost:Connect(
        function()
            task.defer(renderMinValueMode)
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
        763
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
            789
        )
    )


AllowedInput.MultiLine =
    true

AllowedInput.TextWrapped =
    true


AllowedInput.FocusLost:
Connect(
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
            861
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
            905
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


ChatToggle.Activated:
Connect(
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
            957
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


ScanInventory.Activated:
Connect(
    function()

        task.spawn(
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

    acceptedSignature =
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

    initialAsk =
        false,

    declineSent =
        false,

    showcaseTried =
        {},
}


local PlayerCooldowns =
    {}


local function resetState()

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

    State.acceptedSignature =
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

    State.initialAsk =
        false

    State.declineSent =
        false

    State.showcaseTried =
        {}
end


local function cooldown(player)

    if typeof(player) ~= "Instance" then
        return
    end

    PlayerCooldowns[
        player.UserId
    ] =
        os.clock()
        + Settings.playerCooldown
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

    if
        not TradeRemote.SendRequest
        or not player
    then

        return false
    end

    local ok =
        remoteCall(
            TradeRemote.SendRequest,
            player
        )

    if ok then
        return true
    end

    ok =
        remoteCall(
            TradeRemote.SendRequest,
            player.Name
        )

    if ok then
        return true
    end

    ok =
        remoteCall(
            TradeRemote.SendRequest,
            player.UserId
        )

    return ok
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


local function unaccept(myOffer)

    if
        accepted(
            myOffer
        )
        and TradeRemote.Unaccept
    then

        remoteCall(
            TradeRemote.Unaccept
        )

        testLog(
            "UNACCEPT"
        )
    end
end


local function decline()

    if TradeRemote.Decline then

        remoteCall(
            TradeRemote.Decline
        )

        testLog(
            "DECLINE"
        )
    end
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
                allowEstimated =
                    Settings.allowEstimatedOwnPets
                    == true,

                minValue =
                    activeMinItemValue("mine"),

                -- Never hide value that WE are giving. Below-min OUR items
                -- remain counted for W/F/L, then automated modes block them.
                ignoreBelowMin =
                    false,
            }
        )

    local theirs =
        evaluateOffer(
            theirOffer,
            {
                minValue =
                    activeMinItemValue("theirs"),

                -- THEIR exact items below the selected floor do not count
                -- toward THEM TOTAL.
                ignoreBelowMin =
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
        mine.unknown > 0
        or theirs.unknown > 0
    then

        result.blocked =
            true

        result.reason =
            "UNKNOWN"

        return result
    end

    -- Our automated modes must never ACCEPT while our side contains a unit
    -- below MY/ALL minimum. The optimizer/showcase already filters these out,
    -- so this mainly protects against a manual/stale item in the offer.
    if
        (Settings.autoTrade or Settings.testAutoAccept)
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
        (Settings.autoTrade or Settings.testAutoAccept)
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

    if result.profit then

        result.valid =

            result.profit
            >= Settings.minProfitPercent
    end

    return result
end


--============================================================
-- SECURE ACCEPT / CONFIRM
--============================================================

local function secureAccept(
    trade,
    myOffer,
    theirOffer
)

    local evaluation =
        evaluateTrade(
            myOffer,
            theirOffer
        )

    if
        evaluation.blocked
        or not evaluation.valid
    then

        unaccept(
            myOffer
        )

        State.acceptedSignature =
            nil

        return false
    end

    local signature =
        fullSignature(
            myOffer,
            theirOffer
        )

    local stage =
        tostring(
            trade.current_stage
            or trade.stage
            or trade.state
            or ""
        ):
        lower()

    local confirmStage =

        stage:find(
            "confirm",
            1,
            true
        )
        ~= nil

        or trade.confirming
            == true

        or trade.confirmation_started
            == true

    if confirmStage then

        if
            State.acceptedSignature
            and State.acceptedSignature
                ~= signature
        then

            testLog(
                "CHANGED BEFORE CONFIRM"
            )

            unaccept(
                myOffer
            )

            State.acceptedSignature =
                nil

            return false
        end

        local final =
            evaluateTrade(
                myOffer,
                theirOffer
            )

        if
            final.blocked
            or not final.valid
        then

            testLog(
                "FINAL CHECK FAILED"
            )

            unaccept(
                myOffer
            )

            State.acceptedSignature =
                nil

            return false
        end

        if
            not confirmed(
                myOffer
            )
            and TradeRemote.Confirm
        then

            testLog(
                "CONFIRM +",
                string.format(
                    "%.2f%%",
                    final.profit
                )
            )

            remoteCall(
                TradeRemote.Confirm
            )
        end

        return true
    end

    if
        not accepted(
            myOffer
        )
    then

        State.acceptedSignature =
            signature

        testLog(
            "ACCEPT +",
            string.format(
                "%.2f%%",
                evaluation.profit
            )
        )

        remoteCall(
            TradeRemote.Accept
        )
    end

    return true
end


--============================================================
-- SHOWCASE
--============================================================

local function showcase(myOffer)

    if
        countOfferItems(
            myOffer
        ) > 0
    then

        return true
    end

    local inventory =
        valuedInventory()

    if #inventory == 0 then

        testLog(
            "NO SAFE SHOWCASE"
        )

        return false
    end

    for _,
        item in ipairs(
            inventory
        )
    do

        if
            not State.showcaseTried[
                item.uid
            ]
        then

            State.showcaseTried[
                item.uid
            ] =
                true

            testLog(
                "SHOWCASE",
                item.name,
                item.variant,
                "=",
                valueText(
                    item.value
                )
            )

            return
                addOurItem(
                    item.uid
                )
        end
    end

    return false
end


testLog(
    "TEST TAB READY",
    "AUTO TRADE + TEST AUTO TRADE • EXCLUSIVE MODES"
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


--============================================================
-- TEST AUTO TRADE
--============================================================

local TestBadSignature =
    nil

local TestBadSince =
    nil


local function runTestAutoAccept()

    local trade =
        getTrade()

    if not trade then

        TestBadSignature =
            nil

        TestBadSince =
            nil

        setTestStatus(
            "WAITING FOR TRADE",
            C.MUTED
        )

        return
    end

    local myOffer,
        theirOffer =
        getTradeSides(
            trade
        )

    if
        not myOffer
        or not theirOffer
    then

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

        setTestStatus(
            "BLOCK "
            .. tostring(
                evaluation.reason
            ),
            C.RED
        )

        return
    end

    if evaluation.valid then

        TestBadSignature =
            nil

        TestBadSince =
            nil

        setTestStatus(
            string.format(
                "WIN +%.2f%%",
                evaluation.profit
            ),
            C.GREEN
        )

        secureAccept(
            trade,
            myOffer,
            theirOffer
        )

        return
    end

    if
        evaluation.mine.count == 0
        or evaluation.theirs.count == 0
    then

        setTestStatus(
            "WAITING ITEMS",
            C.YELLOW
        )

        return
    end

    unaccept(
        myOffer
    )

    local signature =
        fullSignature(
            myOffer,
            theirOffer
        )

    if
        TestBadSignature
        ~= signature
    then

        TestBadSignature =
            signature

        TestBadSince =
            os.clock()
    end

    setTestStatus(
        "LOSE • DECLINE",
        C.RED
    )

    if
        TestBadSince
        and os.clock()
            - TestBadSince
            >= 2.5
    then

        decline()

        TestBadSince =
            nil
    end
end


--============================================================
-- ACTIVE AUTO TRADE
--============================================================

local function manageAutoTrade(trade)

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

        if not State.declineSent then

            State.declineSent =
                true

            decline()
        end

        return
    end

    local ourSignature =
        offerSignature(
            myOffer
        )

    local theirSignature =
        offerSignature(
            theirOffer
        )

    local signature =
        ourSignature
        .. " >>> "
        .. theirSignature

    -- Any visible trade change invalidates an ACCEPT countdown.
    -- But ONLY a change on THEIR side invalidates our optimization.
    -- This prevents our own add/remove actions from triggering the
    -- optimizer over and over again.
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

            State.acceptedSignature =
                nil
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

        if hadPrevious then

            testLog(
                "THEIR OFFER CHANGED",
                "REV=",
                State.theirRevision,
                "-> REBUILD"
            )
        end
    end

    State.lastOurSignature =
        ourSignature

    local myCount =
        countOfferItems(
            myOffer
        )

    local theirCount =
        countOfferItems(
            theirOffer
        )

    -- SHOW MOST EXPENSIVE SAFE ITEM
    if myCount == 0 then

        setTestStatus(
            "SHOWCASE",
            C.YELLOW
        )

        showcase(
            myOffer
        )

        return
    end

    -- WAIT FOR THEM
    if theirCount == 0 then

        if not State.initialAsk then

            State.initialAsk =
                true

            sendChat(
                "add any pet/item"
            )

            testLog(
                "ASK FIRST ITEM"
            )
        end

        local elapsed =
            os.clock()
            - State.tradeStarted

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

            State.declineSent =
                true

            decline()
        end

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
    -- from our inventory that still keeps MIN PROFIT.
    if
        State.optimizedSignature
        ~= theirSignature
    then

        local desired,
            ourValue,
            cap =
            optimizeOurOffer(
                evaluation.theirs.total
            )

        if
            #desired > 0
            and ourValue > 0
        then

            testLog(
                "BALANCE TO MIN PROFIT",
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
                "TARGET=+"
                .. valueText(
                    tonumber(
                        Settings.minProfitPercent
                    )
                    or 10
                )
                .. "%"
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
            State.optimizedSignature =
                theirSignature

            State.acceptReadySignature =
                nil

            State.acceptReadySince =
                nil

            State.changedAt =
                os.clock()

            return
        end

        -- Nothing from our inventory can fit below the current cap.
        -- Remember this partner signature so we do not recalculate it
        -- every frame; a new item from them clears it automatically.
        State.optimizedSignature =
            theirSignature
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
                    "WIN +%.2f%% • ACCEPT IN %.1fs",
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
                "WIN +%.2f%%",
                finalCheck.profit
            ),
            C.GREEN
        )

        secureAccept(
            trade,
            myOffer,
            theirOffer
        )

        return
    end

    unaccept(
        myOffer
    )

    -- ASK ADD
    if
        not State.askStarted
        or State.askSignature
            ~= theirSignature
    then

        State.askStarted =
            os.clock()

        State.askSignature =
            theirSignature

        sendChat(
            "please add a little"
        )

        testLog(
            "ASK ADD"
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

        State.declineSent =
            true

        decline()
    end
end


--============================================================
-- AUTO TRADE MAIN
--============================================================

local function runAutoTrade()

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

        if
            typeof(
                endedPartner
            ) == "Instance"
        then

            cooldown(
                endedPartner
            )
        end

        setTestStatus(
            "POST-TRADE RESCAN",
            C.YELLOW
        )

        testLog(
            "TRADE ENDED -> RESCAN INVENTORY"
        )

        -- Give ClientData a moment to receive the completed trade result.
        task.wait(
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

    local trade =
        getTrade()

    if not trade then

        TradeStatus.Text =
            "WAITING FOR TRADE"

        TradeStatus.TextColor3 =
            C.MUTED

        TradeInfo.Text =
            ""

        return
    end

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

    local mine =
        evaluateOffer(
            myOffer
        )

    local theirs =
        evaluateOffer(
            theirOffer
        )

    local lines = {

        "PARTNER: "
        .. playerName(
            partner
        ),

        "",

        "========== YOU ==========",
    }

    for index,
        itemData in ipairs(
            mine.items
        )
    do

        local data =
            itemData.data

        local value

        if data.newIgnored then

            value =
                "NEW<24H IGNORE"

        elseif not data.known then

            value =
                "UNKNOWN"

        elseif data.estimated then

            value =
                "~"
                .. valueText(
                    data.value
                )

        else

            value =
                valueText(
                    data.value
                )
        end

        lines[
            #lines + 1
        ] =
            tostring(index)
            .. ". "
            .. data.name
            .. " "
            .. getVariant(
                itemData.raw
            )
            .. " = "
            .. value
    end

    lines[
        #lines + 1
    ] =
        "YOU TOTAL = "
        .. valueText(
            mine.total
        )

    lines[
        #lines + 1
    ] =
        ""

    lines[
        #lines + 1
    ] =
        "========== THEM =========="

    for index,
        itemData in ipairs(
            theirs.items
        )
    do

        local data =
            itemData.data

        local value

        if data.newIgnored then

            value =
                "NEW<24H IGNORE"

        elseif not data.known then

            value =
                "UNKNOWN"

        elseif data.estimated then

            value =
                "~"
                .. valueText(
                    data.value
                )

        else

            value =
                valueText(
                    data.value
                )
        end

        lines[
            #lines + 1
        ] =
            tostring(index)
            .. ". "
            .. data.name
            .. " "
            .. getVariant(
                itemData.raw
            )
            .. " = "
            .. value
    end

    lines[
        #lines + 1
    ] =
        "THEM TOTAL = "
        .. valueText(
            theirs.total
        )

    TradeInfo.Text =
        table.concat(
            lines,
            "\n"
        )

    if
        mine.unknown > 0
        or theirs.unknown > 0
    then

        TradeStatus.Text =
            "UNKNOWN • BLOCK"

        TradeStatus.TextColor3 =
            C.RED

        return
    end

    if
        Settings.blockEstimated
        and (
            mine.estimated > 0
            or theirs.estimated > 0
        )
    then

        TradeStatus.Text =
            "ESTIMATED • BLOCK"

        TradeStatus.TextColor3 =
            C.ORANGE

        return
    end

    local profit =
        profitPercent(
            mine.total,
            theirs.total
        )

    if not profit then

        TradeStatus.Text =
            "WAITING"

        TradeStatus.TextColor3 =
            C.YELLOW

    elseif
        profit
        >= Settings.minProfitPercent
    then

        TradeStatus.Text =
            string.format(
                "WIN +%.2f%%",
                profit
            )

        TradeStatus.TextColor3 =
            C.GREEN

    else

        TradeStatus.Text =
            string.format(
                "LOSE %.2f%%",
                profit
            )

        TradeStatus.TextColor3 =
            C.RED
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
        and "FOUND / NOT USED YET"
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


CloseButton.Activated:
Connect(
    function()

        Main.Visible =
            false

        OpenButton.Visible =
            true
    end
)


OpenButton.Activated:
Connect(
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


task.spawn(
    function()

        local ok,
            err =
            pcall(
                function()

                    refresh()

                    updateFirstSeen()

                    updateStatusPage()

                    rebuildSearch()
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


task.spawn(
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

            task.wait(
                0.6
            )
        end
    end
)


--============================================================
-- TEST / AUTO LOOP
--============================================================

setBoot(
    "6/9",
    "AUTO LOOP"
)


task.spawn(
    function()

        while Gui.Parent do

            local ok,
                err =
                pcall(
                    function()

                        if
                            Settings.testAutoAccept
                        then

                            runTestAutoAccept()

                        elseif
                            Settings.autoTrade
                        then

                            runAutoTrade()

                        else

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

            task.wait(
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


task.spawn(
    function()

        while Gui.Parent do

            LogBox.Text =
                table.concat(
                    TestLogs,
                    "\n"
                )

            updateStatusPage()

            task.wait(
                0.8
            )
        end
    end
)


--============================================================
-- PERIODIC AMVGG REFRESH
--============================================================

task.spawn(
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

            task.wait(
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

                        rebuildSearch()
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

Players.PlayerRemoving:
Connect(
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
