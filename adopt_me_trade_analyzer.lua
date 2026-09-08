repeat task.wait() until game:IsLoaded()

--============================================================
-- ADOPT ME TRADE ANALYZER V11.6.2
-- AMVGG BASELESS CALCULATOR LOGIC
--
-- FIX:
-- AMVGG DOES NOT STORE ALL PET VARIANTS DIRECTLY.
--
-- For category ~= 13:
-- NP / R / F are calculated from regularValue
-- N  / NR / NF are calculated from neonValue
-- M  / MR / MF are calculated from megaValue
--
-- FR  = regularValue
-- NFR = neonValue
-- MFR = megaValue
--
-- For category == 13:
-- uses exact fields:
-- npRegularValue / fValue / rValue ...
--
-- Matches AMVGG calculator JS.
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


print("[AM V11.6.2] BOOT")


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
    "AdoptMeTradeAnalyzerV1162",

    "AM_ANALYZER_BOOT_V1153",
    "AM_ANALYZER_BOOT_V1160",
    "AM_ANALYZER_BOOT_V1161",
    "AM_ANALYZER_BOOT_V1162",
}

for _, name in ipairs(OLD_GUI_NAMES) do

    local object =
        GuiParent:FindFirstChild(name)

    if object then
        object:Destroy()
    end
end


--============================================================
-- BOOT GUI
--============================================================

local BootGui =
    Instance.new("ScreenGui")

BootGui.Name =
    "AM_ANALYZER_BOOT_V1162"

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
    "ADOPT ME ANALYZER V11.6.2\nBOOT..."

BootText.Parent =
    BootFrame


local function setBoot(step, text, errorState)

    BootText.Text =
        "ADOPT ME ANALYZER V11.6.2\n"
        .. tostring(step)
        .. "  "
        .. tostring(text)

    BootText.TextColor3 =
        errorState

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
        "[AM V11.6.2]",
        step,
        text
    )
end


local function traceback(errorMessage)

    local result =
        tostring(errorMessage)

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
    "LOADING ADOPT ME"
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
                    "Fsys invalid"
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
    "2/8",
    "CLIENT DATA OK"
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

local function corner(object, radius)

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


local function stroke(object, transparency)

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

local function num(value)

    if type(value) == "number" then
        return value
    end

    return tonumber(value)
end


local function valueText(value)

    if type(value) ~= "number" then
        return "?"
    end

    if math.abs(value) < 0.000000001 then
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
-- EXACT AMVGG ROUND
--============================================================

local function round(value, decimals)

    if type(value) ~= "number" then
        return nil
    end

    local power =
        10 ^ decimals

    return
        math.floor(
            value * power
            + 0.5
        )
        / power
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
            text or ""
        )

    add(original)

    add(
        original:gsub(
            "%b()",
            ""
        )
    )

    -- AMVGG / Adopt Me spelling mismatch
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

    local db =
        getItemDB(
            item
        )

    if type(db) == "table" then

        if db.name then
            return tostring(db.name)
        end

        if db.display_name then
            return tostring(db.display_name)
        end
    end

    return
        tostring(
            item.kind
            or "Unknown Item"
        )
end


local function getCategoryDisplay(item)

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

    local p =
        type(item.properties) == "table"
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
-- AMVGG CATEGORY MULTIPLIERS
--
-- COPIED FROM MODULE 3541 / MODULE 134
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


--============================================================
-- CATEGORY 13 EXACT FIELD MAP
--============================================================

local EXACT_FIELD = {

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


local EXACT_DEMAND_FIELD = {

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
-- AMVGG CALCULATOR
-- THIS COPIES eP() FROM THEIR JS
--============================================================

local function calculateCategoryVariants(
    category,
    regularValue,
    neonValue,
    megaValue
)

    category =
        tonumber(category)

    local m =
        MULTIPLIERS[
            category
        ]

    if not m then
        return nil
    end

    regularValue =
        num(
            regularValue
        )

    neonValue =
        num(
            neonValue
        )

    megaValue =
        num(
            megaValue
        )

    if
        regularValue == nil
        or neonValue == nil
        or megaValue == nil
    then
        return nil
    end


    local regularDecimals =
        4

    if regularValue >= 0.0175 then
        regularDecimals = 3
    end


    local result =
        {}


    --========================================================
    -- REGULAR
    --========================================================

    if
        category == 11
        and regularValue > 0.08
    then

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


    result.FR =
        regularValue


    --========================================================
    -- NEON
    --========================================================

    result.N =
        round(
            neonValue * m.NNP,
            4
        )


    if
        category == 11
        and neonValue > 0.2
    then

        result.NR =
            neonValue

        result.NF =
            neonValue

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


    result.NFR =
        neonValue


    --========================================================
    -- MEGA
    --========================================================

    result.M =
        round(
            megaValue * m.MNP,
            4
        )


    if
        category == 11
        and megaValue > 0.9
    then

        result.MR =
            megaValue

        result.MF =
            megaValue

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


    result.MFR =
        megaValue


    return result
end


--============================================================
-- PET VALUE
--============================================================

local function getPetBaselessValue(
    entry,
    variant
)

    if type(entry) ~= "table" then

        return
            nil,
            nil,
            "INVALID ENTRY"
    end


    local category =
        tonumber(
            entry.category
        )


    --========================================================
    -- CATEGORY 13
    --========================================================

    if category == 13 then

        local field =
            EXACT_FIELD[
                variant
            ]

        if not field then

            return
                nil,
                nil,
                "UNKNOWN VARIANT"
        end

        local value =
            num(
                entry[field]
            )

        return
            value,
            field,
            value ~= nil
                and nil
                or "CATEGORY 13 FIELD NIL"
    end


    --========================================================
    -- NORMAL AMVGG CATEGORY
    --========================================================

    if not category then

        return
            nil,
            nil,
            "NO CATEGORY"
    end


    local variants =
        calculateCategoryVariants(

            category,

            entry.regularValue,

            entry.neonValue,

            entry.megaValue
        )


    if not variants then

        return
            nil,
            nil,
            "NO MULTIPLIER FOR CATEGORY "
            .. tostring(category)
    end


    local value =
        variants[
            variant
        ]


    return
        value,
        "CALC/CAT="
        .. tostring(category),
        value ~= nil
            and nil
            or "CALCULATED NIL"
end


--============================================================
-- PET DEMAND
--============================================================

local function getPetDemand(
    entry,
    variant
)

    local category =
        tonumber(
            entry.category
        )


    if category == 13 then

        local field =
            EXACT_DEMAND_FIELD[
                variant
            ]

        return
            field
            and entry[field]
            or nil
    end


    if
        variant:find(
            "M",
            1,
            true
        )
    then

        return
            entry.megaDemand
    end


    if
        variant:find(
            "N",
            1,
            true
        )
    then

        return
            entry.neonDemand
    end


    return
        entry.regularDemand
end


--============================================================
-- HTTP
--============================================================

setBoot(
    "3/8",
    "HTTP"
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
        and type(syn.request) == "function"
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


local function download(url, rsc)

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


    return
        nil,
        0
end


--============================================================
-- JSON OBJECT EXTRACT
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
                    depth + 1

            elseif byte == 125 then

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


    return nil
end


--============================================================
-- AMVGG OBJECT VALIDATION
--============================================================

local function validEntry(object)

    if
        type(object) ~= "table"
        or type(object.name) ~= "string"
    then

        return false
    end


    return

        object.value ~= nil

        or object.regularValue ~= nil

        or object.neonValue ~= nil

        or object.megaValue ~= nil

        or object.npRegularValue ~= nil

        or object.npNeonValue ~= nil

        or object.npMegaValue ~= nil
end


local function merge(target, source)

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
                position + 5

            continue
        end


        cursor =
            ending + 1


        local ok, object =
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
            and validEntry(
                object
            )
        then

            local key =
                normalize(
                    object.name
                )


            if key ~= "" then

                if not database[key] then

                    database[key] =
                        {}

                    count =
                        count + 1
                end


                merge(
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


    for attemptIndex, attempt in ipairs(attempts) do

        local body, status =
            download(
                attempt.url,
                attempt.rsc
            )


        print(
            "[AMVGG]",
            slug,
            "TRY",
            attemptIndex,
            "HTTP",
            status,
            "SIZE",
            body and #body or 0
        )


        if
            type(body) == "string"
            and #body > 100
        then

            local database,
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
                    database,
                    count
            end
        end


        task.wait(
            0.1
        )
    end


    return
        nil,
        0
end


local function loadAMVGG()

    if AMVGG.loading then
        return false
    end


    AMVGG.loading =
        true

    AMVGG.error =
        nil


    local categories =
        {}

    local counts =
        {}

    local total =
        0


    print(
        "[AMVGG] LOAD START"
    )


    for _, slug in ipairs(CATEGORY_URLS) do

        local ok,
            database,
            count =
            pcall(
                loadCategory,
                slug
            )


        if
            ok
            and type(database) == "table"
            and count > 0
        then

            categories[slug] =
                database

            counts[slug] =
                count

            total =
                total
                + count


        elseif AMVGG.categories[slug] then

            categories[slug] =
                AMVGG.categories[slug]

            counts[slug] =
                AMVGG.counts[slug]
                or 0

            total =
                total
                + (
                    counts[slug]
                    or 0
                )
        end


        task.wait()
    end


    AMVGG.loading =
        false


    if
        categories.pets
        and next(
            categories.pets
        )
    then

        AMVGG.categories =
            categories

        AMVGG.counts =
            counts

        AMVGG.total =
            total

        AMVGG.ready =
            true

        AMVGG.version =
            AMVGG.version + 1

        AMVGG.lastRefresh =
            os.time()

        AMVGG.error =
            nil


        print(
            "[AMVGG] READY",
            "PETS",
            counts.pets,
            "ALL",
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
-- CATEGORY MAP
--============================================================

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


--============================================================
-- FIND ENTRY
--============================================================

local function findCategory(
    slug,
    itemName
)

    local database =
        AMVGG.categories[
            slug
        ]

    if type(database) ~= "table" then
        return nil
    end


    local names =
        aliases(
            itemName
        )


    -- Exact
    for key in pairs(names) do

        if database[key] then

            return
                database[key],
                key
        end
    end


    -- Unique partial name fallback
    local result
    local resultKey


    for alias in pairs(names) do

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
                        result
                        and resultKey ~= key
                    then

                        return nil
                    end


                    result =
                        entry

                    resultKey =
                        key
                end
            end
        end
    end


    return
        result,
        resultKey
end


local function findAMVGG(item)

    local itemName =
        getItemName(
            item
        )


    if item.category == "pets" then

        -- Eggs are technically under pets in Adopt Me

        if
            itemName:lower():find(
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
-- NON PET VALUE
--============================================================

local function genericValue(entry)

    if type(entry) ~= "table" then
        return nil
    end


    local value =
        num(
            entry.value
        )

    if value ~= nil then

        return
            value,
            "value"
    end


    value =
        num(
            entry.regularValue
        )

    if value ~= nil then

        return
            value,
            "regularValue"
    end


    value =
        num(
            entry.npRegularValue
        )

    if value ~= nil then

        return
            value,
            "npRegularValue"
    end


    return nil
end


--============================================================
-- ANALYZE ITEM
--============================================================

local function analyzeItem(item)

    local data = {

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

        demand =
            nil,

        field =
            nil,

        amvggCategory =
            nil,

        reason =
            nil,
    }


    if not AMVGG.ready then

        data.reason =
            AMVGG.loading

            and "AMVGG LOADING"

            or "AMVGG NOT READY"


        return data
    end


    local entry,
        source =
        findAMVGG(
            item
        )


    if not entry then

        data.reason =
            "NOT FOUND"

        return data
    end


    data.source =
        source


    --========================================================
    -- PET
    --========================================================

    if source == "pets" then

        data.amvggCategory =
            tonumber(
                entry.category
            )


        local value,
            field,
            reason =
            getPetBaselessValue(

                entry,

                data.variant
            )


        data.value =
            value

        data.field =
            field

        data.reason =
            reason


        data.demand =
            getPetDemand(
                entry,
                data.variant
            )


        return data
    end


    --========================================================
    -- NON PET / EGG
    --========================================================

    data.variant =
        ""


    local value,
        field =
        genericValue(
            entry
        )


    data.value =
        value

    data.field =
        field

    data.demand =
        entry.demand
        or entry.regularDemand


    if value == nil then

        data.reason =
            "NO VALUE"
    end


    return data
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
    "AdoptMeTradeAnalyzerV1162"

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


local VersionLabel =
    label(
        Top,

        "V11.6.2",

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
-- DRAG MAIN
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
-- PAGE SYSTEM
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

    for pageName, page in pairs(Pages) do

        page.Visible =
            pageName == name
    end


    for buttonName, nav in pairs(Navigation) do

        if buttonName == name then

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


local function nav(name, y)

    local x =
        button(
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


nav("TRADE", 46)
nav("VALUES", 96)
nav("UPDATES", 146)
nav("SETTINGS", 196)


--============================================================
-- TRADE PAGE
--============================================================

setBoot(
    "5/8",
    "TRADE PAGE"
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


local CountsLabel =
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


local AMVGGStatus =
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


local StageLabel =
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


StageLabel.BackgroundTransparency =
    0

StageLabel.BackgroundColor3 =
    C.PANEL2

corner(
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


corner(
    TradeArea,
    10
)

stroke(
    TradeArea,
    0.35
)


--============================================================
-- CENTER RESULT
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


local TradeResult =
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


local TradeDifference =
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


TradeDifference.TextWrapped =
    true


--============================================================
-- OFFER PANEL
--============================================================

local function createOfferPanel(x)

    local panel =
        Instance.new("Frame")

    panel.Position =
        UDim2.new(
            x,
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

    panel.BackgroundColor3 =
        C.PANEL2

    panel.BorderSizePixel =
        0

    panel.Parent =
        TradeArea


    corner(
        panel,
        9
    )


    local player =
        label(
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


    local count =
        label(
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


    local ready =
        label(
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


    ready.BackgroundTransparency =
        0

    ready.BackgroundColor3 =
        Color3.fromRGB(
            39,
            43,
            52
        )

    corner(
        ready,
        5
    )


    local total =
        label(
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


    local scroll =
        Instance.new("ScrollingFrame")

    scroll.Position =
        UDim2.fromOffset(
            7,
            73
        )

    scroll.Size =
        UDim2.new(
            1,
            -14,
            1,
            -80
        )

    scroll.BackgroundColor3 =
        Color3.fromRGB(
            23,
            26,
            33
        )

    scroll.BackgroundTransparency =
        0.12

    scroll.BorderSizePixel =
        0

    scroll.ScrollBarThickness =
        6

    scroll.ScrollBarImageColor3 =
        C.ACCENT

    scroll.CanvasSize =
        UDim2.fromOffset(
            0,
            0
        )

    scroll.Parent =
        panel


    corner(
        scroll,
        7
    )


    local grid =
        Instance.new("UIGridLayout")

    grid.CellSize =
        UDim2.new(
            0.313,
            0,
            0,
            82
        )

    grid.CellPadding =
        UDim2.new(
            0.018,
            0,
            0,
            7
        )

    grid.FillDirectionMaxCells =
        3

    grid.SortOrder =
        Enum.SortOrder.LayoutOrder

    grid.Parent =
        scroll


    local padding =
        Instance.new("UIPadding")

    padding.PaddingLeft =
        UDim.new(
            0,
            5
        )

    padding.PaddingRight =
        UDim.new(
            0,
            7
        )

    padding.PaddingTop =
        UDim.new(
            0,
            5
        )

    padding.PaddingBottom =
        UDim.new(
            0,
            5
        )

    padding.Parent =
        scroll


    local function canvas()

        scroll.CanvasSize =
            UDim2.fromOffset(
                0,
                grid.AbsoluteContentSize.Y
                + 14
            )
    end


    grid:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(
        canvas
    )


    task.defer(
        canvas
    )


    return {

        Panel =
            panel,

        Name =
            player,

        Count =
            count,

        Ready =
            ready,

        Total =
            total,

        Scroll =
            scroll,

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
-- 18 SLOTS
--============================================================

local function createSlot(
    side,
    index
)

    local frame =
        Instance.new("TextButton")

    frame.LayoutOrder =
        index

    frame.BackgroundColor3 =
        C.SLOT

    frame.BorderSizePixel =
        0

    frame.AutoButtonColor =
        false

    frame.Text =
        ""

    frame.Parent =
        side.Scroll


    corner(
        frame,
        7
    )

    stroke(
        frame,
        0.5
    )


    label(
        frame,

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


    local variant =
        label(
            frame,

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


    local name =
        label(
            frame,

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


    name.TextWrapped =
        true


    local value =
        label(
            frame,

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


    local category =
        label(
            frame,

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
            frame,

        Variant =
            variant,

        Name =
            name,

        Value =
            value,

        Category =
            category,

        Item =
            nil,

        Analysis =
            nil,
    }
end


for i = 1, 18 do

    createSlot(
        Yours,
        i
    )

    createSlot(
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
        variantColor(
            data.variant
        )

    slot.Category.Text =
        data.category


    if data.value ~= nil then

        slot.Value.Text =
            "V "
            .. valueText(
                data.value
            )

        slot.Value.TextColor3 =
            C.ACCENT


        print(

            "[BASELESS]",

            data.name,

            data.variant,

            "=",
            data.value,

            "CATEGORY=",
            data.amvggCategory,

            "FIELD=",
            data.field
        )


        return
            data.value,
            true
    end


    slot.Value.Text =
        "V ?"


    slot.Value.TextColor3 =
        AMVGG.loading
        and C.YELLOW
        or C.RED


    warn(

        "[BASELESS MISSING]",

        data.name,

        data.variant,

        "CATEGORY=",
        data.amvggCategory,

        "REASON=",
        data.reason
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
            .. valueText(
                total
            )

        side.Total.TextColor3 =
            C.ACCENT


    else

        side.Total.Text =
            "KNOWN: "
            .. valueText(
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
-- TRADE SIGNATURE
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


    for index, item in ipairs(offer.items) do

        result[#result + 1] =

            tostring(
                item.unique
                or item.kind
                or index
            )

            .. ":"

            .. getVariant(
                item
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
-- RESULT
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

        .. valueText(
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

local function noTrade()

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
-- UPDATE TRADE
--============================================================

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

        .. ":DB:"

        .. tostring(
            AMVGG.version
        )


    if signature == LastTradeSignature then
        return
    end


    LastTradeSignature =
        signature


    Yours.Name.Text =
        playerName(
            me
        )


    Theirs.Name.Text =
        playerName(
            partner
        )


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
    "VALUES PAGE"
)


local ValuesPage =
    createPage(
        "VALUES"
    )


label(
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


corner(
    SearchBox,
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


local RefreshButton =
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
-- VALUES SEARCH
--============================================================

local VARIANTS = {

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


    local found
    local source


    for slug, database in pairs(AMVGG.categories) do

        if database[query] then

            found =
                database[query]

            source =
                slug

            break
        end
    end


    if not found then

        local candidates =
            {}


        for slug, database in pairs(AMVGG.categories) do

            for key, entry in pairs(database) do

                if
                    key:find(
                        query,
                        1,
                        true
                    )
                then

                    candidates[#candidates + 1] =
                        tostring(entry.name)
                        .. " ["
                        .. slug
                        .. "]"
                end
            end
        end


        if #candidates == 0 then

            ResultBox.Text =
                "NOT FOUND: "
                .. SearchBox.Text

        else

            table.sort(
                candidates
            )

            ResultBox.Text =
                table.concat(
                    candidates,
                    "\n"
                )
        end


        return
    end


    local lines = {

        "NAME = "
        .. tostring(
            found.name
        ),

        "SOURCE = "
        .. tostring(
            source
        ),

        "CATEGORY = "
        .. tostring(
            found.category
        ),

        "REGULAR BASE = "
        .. tostring(
            found.regularValue
        ),

        "NEON BASE = "
        .. tostring(
            found.neonValue
        ),

        "MEGA BASE = "
        .. tostring(
            found.megaValue
        ),

        "",
    }


    if source == "pets" then

        for _, variant in ipairs(VARIANTS) do

            local value,
                field,
                reason =
                getPetBaselessValue(
                    found,
                    variant
                )


            lines[#lines + 1] =

                string.format(
                    "%-4s = %-10s  [%s]",
                    variant,
                    value ~= nil
                        and tostring(value)
                        or "nil",
                    tostring(
                        field
                        or reason
                        or "?"
                    )
                )
        end

    else

        local value,
            field =
            genericValue(
                found
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
            found.lastUpdatedAt
            or "?"
        )


    ResultBox.Text =
        table.concat(
            lines,
            "\n"
        )
end


SearchButton.Activated:Connect(
    searchValues
)


SearchBox.FocusLost:Connect(
    function(pressedEnter)

        if pressedEnter then
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


local UpdateText =
    label(
        UpdatesPage,

        "V11.6.2\n\n"
        .. "• Added REAL AMVGG category multipliers\n"
        .. "• Uses category from AMVGG item\n"
        .. "• NP/R/F calculated from Regular\n"
        .. "• N/NR/NF calculated from Neon\n"
        .. "• M/MR/MF calculated from Mega\n"
        .. "• FR/NFR/MFR use raw base values\n"
        .. "• Category 11 special rules implemented\n"
        .. "• Category 13 uses direct variant fields\n"
        .. "• Exact AMVGG rounding implemented\n"
        .. "• 18 trade slots\n"
        .. "• Dark Chocobunny alias preserved\n\n"
        .. "This now follows the calculator JS logic.",

        UDim2.new(
            1,
            -44,
            0,
            400
        ),

        UDim2.fromOffset(
            22,
            70
        ),

        Enum.Font.Code,
        12,
        C.MUTED
    )


UpdateText.TextYAlignment =
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

        "VALUE MODE               BASELESS\n\n"
        .. "AMVGG LOGIC              CALCULATOR\n\n"
        .. "CATEGORY MULTIPLIERS      ON\n\n"
        .. "CATEGORY 11 SPECIAL       ON\n\n"
        .. "CATEGORY 13 EXACT         ON\n\n"
        .. "TRADE SLOTS              18\n\n"
        .. "PET VARIANTS             12\n\n"
        .. "FAIR RANGE               ±2%\n\n"
        .. "UNKNOWN VALUE BLOCK       ON\n\n"
        .. "AUTO ACCEPT              OFF",

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
-- REFRESH
--============================================================

local function refresh()

    if AMVGG.loading then
        return
    end


    updateStatus()


    local ok, err =
        xpcall(
            function()

                if not loadAMVGG() then

                    error(
                        AMVGG.error
                        or "LOAD FAILED"
                    )
                end
            end,

            traceback
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


    LastTradeSignature =
        nil


    pcall(
        updateTrade
    )
end


RefreshButton.Activated:Connect(
    function()

        task.spawn(
            refresh
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


corner(
    OpenButton,
    17
)

stroke(
    OpenButton,
    0.1
)


--============================================================
-- FLOAT DRAG
--============================================================

local floatDragging =
    false

local floatMoved =
    false

local floatStart
local floatOrigin


OpenButton.InputBegan:Connect(
    function(input)

        if
            input.UserInputType
                == Enum.UserInputType.Touch

            or input.UserInputType
                == Enum.UserInputType.MouseButton1
        then

            floatDragging =
                true

            floatMoved =
                false

            floatStart =
                input.Position

            floatOrigin =
                OpenButton.Position
        end
    end
)


UIS.InputChanged:Connect(
    function(input)

        if not floatDragging then
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
            - floatStart


        if
            math.abs(delta.X) > 6

            or math.abs(delta.Y) > 6
        then

            floatMoved =
                true
        end


        local x =
            floatOrigin.X.Scale
                * viewport.X
            + floatOrigin.X.Offset
            + delta.X


        local y =
            floatOrigin.Y.Scale
                * viewport.Y
            + floatOrigin.Y.Offset
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

            floatDragging =
                false
        end
    end
)


--============================================================
-- CLOSE / OPEN
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

        if floatMoved then

            floatMoved =
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
    "STARTING"
)


setPage(
    "TRADE"
)


updateStatus()


pcall(
    updateTrade
)


--============================================================
-- TRADE LOOP
--============================================================

task.spawn(
    function()

        while Gui.Parent do

            local ok, err =
                pcall(
                    updateTrade
                )


            if not ok then

                warn(
                    "[TRADE ERROR]",
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
-- STATUS LOOP
--============================================================

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


--============================================================
-- AMVGG LOAD + 15 MINUTES
--============================================================

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


--============================================================
-- READY
--============================================================

setBoot(
    "8/8",
    "READY - REAL BASELESS"
)


print(
    "[AM V11.6.2] READY"
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
