--============================================================
-- ADOPT ME TRADE ANALYZER
-- TEST / AUTO TRADE MODULE V11.7.0
--
-- PASTE AT THE VERY END OF V11.6.2
--
-- REQUIRES EXISTING V11.6.2:
-- ClientData
-- Fsys
-- AMVGG
-- analyzeItem()
-- findAMVGG()
-- normalize()
-- getVariant()
-- isMe()
-- playerName()
-- refresh()
-- createPage()
-- nav()
-- label()
-- button()
-- corner()
-- C
-- Gui
-- RS
-- HttpService
-- LocalPlayer
--
--============================================================

print("[AM TEST V11.7.0] LOADING")

local TextChatService =
    game:GetService("TextChatService")

--============================================================
-- SETTINGS
--============================================================

local TEST_SETTINGS_FILE =
    "am_test_auto_trade_v117.json"

local FIRST_SEEN_FILE =
    "am_amvgg_first_seen_v117.json"

local TestSettings = {

    -- Manual trade tester
    testAutoAccept = false,

    -- Full random-player automation
    autoTrade = false,

    -- Required minimum profit
    minProfitPercent = 10,

    -- How long we let trade stop changing
    settleSeconds = 2,

    -- Wait for other player to add after showcase
    firstItemTimeout = 25,

    -- After asking for add
    addTimeout = 40,

    -- Trade request timeout
    requestTimeout = 15,

    -- Don't spam same player
    playerCooldown = 300,

    -- AMVGG refresh
    refreshMinutes = 5,

    -- Newly detected AMVGG item
    newItemHours = 24,

    -- Blank = all known inventory items
    allowedItems = "",

    -- Chat request if Roblox allows it.
    chatRequests = true,

    -- Max number of our final items
    maxOurItems = 18,

    -- Beam search accuracy
    optimizerBeam = 300,

    -- Overall negotiation cap
    maxTradeSeconds = 120,
}

--============================================================
-- FILE SETTINGS
--============================================================

local function loadJSONFile(path)

    if
        type(readfile) ~= "function"
        or type(isfile) ~= "function"
    then
        return nil
    end

    local okExists, exists =
        pcall(
            isfile,
            path
        )

    if not okExists or not exists then
        return nil
    end

    local ok, data =
        pcall(
            function()

                return
                    HttpService:JSONDecode(
                        readfile(path)
                    )
            end
        )

    if ok and type(data) == "table" then
        return data
    end

    return nil
end

local function saveJSONFile(path, data)

    if type(writefile) ~= "function" then
        return false
    end

    local ok =
        pcall(
            function()

                writefile(
                    path,

                    HttpService:JSONEncode(
                        data
                    )
                )
            end
        )

    return ok
end

do
    local saved =
        loadJSONFile(
            TEST_SETTINGS_FILE
        )

    if type(saved) == "table" then

        for k, v in pairs(saved) do

            if TestSettings[k] ~= nil then
                TestSettings[k] = v
            end
        end
    end
end

local function saveTestSettings()

    saveJSONFile(
        TEST_SETTINGS_FILE,
        TestSettings
    )
end

--============================================================
-- TEST LOG
--============================================================

local TestLogs = {}

local function testLog(...)

    local parts = {}

    for i, value in ipairs({...}) do
        parts[i] = tostring(value)
    end

    local text =
        table.concat(
            parts,
            " "
        )

    TestLogs[#TestLogs + 1] =
        text

    if #TestLogs > 60 then
        table.remove(TestLogs, 1)
    end

    print(
        "[AM AUTO]",
        text
    )
end

--============================================================
-- FIRST SEEN DATABASE
--============================================================

local FirstSeen =
    loadJSONFile(
        FIRST_SEEN_FILE
    )

if type(FirstSeen) ~= "table" then

    FirstSeen = {
        initialized = false,
        items = {},
    }
end

if type(FirstSeen.items) ~= "table" then
    FirstSeen.items = {}
end

local function amvggEntryID(
    source,
    key,
    entry
)

    if
        type(entry) == "table"
        and entry.id ~= nil
    then

        return
            tostring(entry.id)
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

    for source, database in pairs(
        AMVGG.categories
    ) do

        if type(database) == "table" then

            for key, entry in pairs(database) do

                local id =
                    amvggEntryID(
                        source,
                        key,
                        entry
                    )

                if
                    FirstSeen.items[id]
                    == nil
                then

                    if baseline then

                        -- Everything existing on first installation
                        -- is treated as already old.
                        FirstSeen.items[id] =
                            0

                    else

                        FirstSeen.items[id] =
                            now

                        testLog(
                            "NEW AMVGG ITEM:",
                            source,
                            tostring(entry.name),
                            "24H IGNORE STARTED"
                        )
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

        saveJSONFile(
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

        return false, 0
    end

    local key =
        normalize(
            entry.name
            or ""
        )

    local id =
        amvggEntryID(
            source,
            key,
            entry
        )

    local seen =
        tonumber(
            FirstSeen.items[id]
        )

    if
        seen == nil
        or seen <= 0
    then

        return false, 0
    end

    local age =
        os.time()
        - seen

    local cooldown =
        (
            tonumber(
                TestSettings.newItemHours
            )
            or 24
        )
        * 3600

    return
        age < cooldown,
        age
end

--============================================================
-- RESOLVE TRADE REMOTES
--============================================================

local RouterClient

pcall(
    function()

        RouterClient =
            Fsys.load(
                "RouterClient"
            )
    end
)

local function resolveTradeRemote(name)

    local API =
        RS:FindFirstChild(
            "API"
        )

    if API then

        local direct =
            API:FindFirstChild(
                name
            )

        if direct then
            return direct
        end
    end

    if
        type(RouterClient) == "table"
        and type(RouterClient.get) == "function"
    then

        local ok, remote =
            pcall(
                RouterClient.get,
                name
            )

        if
            ok
            and remote
        then
            return remote
        end
    end

    return nil
end

local TradeRemote = {

    SendRequest =
        resolveTradeRemote(
            "TradeAPI/SendTradeRequest"
        ),

    Add =
        resolveTradeRemote(
            "TradeAPI/AddItemToOffer"
        ),

    Remove =
        resolveTradeRemote(
            "TradeAPI/RemoveItemFromOffer"
        ),

    Accept =
        resolveTradeRemote(
            "TradeAPI/AcceptNegotiation"
        ),

    Unaccept =
        resolveTradeRemote(
            "TradeAPI/UnacceptNegotiation"
        ),

    Confirm =
        resolveTradeRemote(
            "TradeAPI/ConfirmTrade"
        ),

    Decline =
        resolveTradeRemote(
            "TradeAPI/DeclineTrade"
        ),

    SuggestItem =
        resolveTradeRemote(
            "TradeAPI/SuggestItem"
        ),

    SuggestRemove =
        resolveTradeRemote(
            "TradeAPI/SuggestRemoveItem"
        ),
}

local function remoteCall(
    remote,
    ...
)

    if not remote then
        return false, "REMOTE MISSING"
    end

    local args = {...}

    local ok, result =
        pcall(
            function()

                if remote:IsA("RemoteEvent") then

                    remote:FireServer(
                        table.unpack(args)
                    )

                    return true

                elseif remote:IsA("RemoteFunction") then

                    return
                        remote:InvokeServer(
                            table.unpack(args)
                        )
                end

                error(
                    "UNKNOWN REMOTE CLASS "
                    .. tostring(
                        remote.ClassName
                    )
                )
            end
        )

    if not ok then

        testLog(
            "REMOTE ERROR:",
            remote.Name,
            result
        )

        return false, result
    end

    return true, result
end

--============================================================
-- TRADE STATE
--============================================================

local function getTrade()

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
        ok
        and type(trade) == "table"
    then

        return trade
    end

    return nil
end

local function getTradeSides(trade)

    if type(trade) ~= "table" then
        return nil
    end

    if isMe(trade.sender) then

        return
            trade.sender_offer,
            trade.recipient_offer,
            trade.sender,
            trade.recipient

    else

        return
            trade.recipient_offer,
            trade.sender_offer,
            trade.recipient,
            trade.sender
    end
end

local function getOfferItems(offer)

    if
        type(offer) == "table"
        and type(offer.items) == "table"
    then

        return offer.items
    end

    return {}
end

local function countOfferItems(offer)

    local count = 0

    for _ in pairs(
        getOfferItems(offer)
    ) do
        count += 1
    end

    return count
end

local function itemSignature(item)

    return
        tostring(
            item.unique
            or item.kind
            or "?"
        )
        .. ":"
        .. tostring(
            getVariant(item)
        )
end

local function offerOnlySignature(offer)

    local list = {}

    for _, item in pairs(
        getOfferItems(offer)
    ) do

        list[#list + 1] =
            itemSignature(item)
    end

    table.sort(list)

    return
        table.concat(
            list,
            "|"
        )
end

local function completeOfferSignature(
    mine,
    theirs
)

    return
        offerOnlySignature(mine)
        .. " >>> "
        .. offerOnlySignature(theirs)
end

--============================================================
-- NEW ITEM = VALUE 0
-- UNKNOWN ITEM = BLOCK
--============================================================

local function effectiveItemValue(item)

    local entry,
        source =
        findAMVGG(
            item
        )

    if entry and source then

        local newItem,
            age =
            isNewEntry(
                source,
                entry
            )

        if newItem then

            return {

                known = true,

                newIgnored = true,

                value = 0,

                name =
                    tostring(
                        entry.name
                        or "NEW ITEM"
                    ),

                source = source,

                age = age,
            }
        end
    end

    local analysis =
        analyzeItem(
            item
        )

    if
        type(analysis) ~= "table"
        or type(analysis.value)
            ~= "number"
    then

        return {

            known = false,

            newIgnored = false,

            value = 0,

            name =
                analysis
                and analysis.name
                or tostring(
                    item.kind
                    or "UNKNOWN"
                ),

            reason =
                analysis
                and analysis.reason
                or "UNKNOWN",
        }
    end

    return {

        known = true,

        newIgnored = false,

        value =
            analysis.value,

        name =
            analysis.name,

        analysis =
            analysis,
    }
end

local function evaluateOffer(offer)

    local result = {

        total = 0,

        count = 0,

        unknown = 0,

        newIgnored = 0,

        unknownNames = {},

        newNames = {},
    }

    for _, item in pairs(
        getOfferItems(offer)
    ) do

        result.count += 1

        local data =
            effectiveItemValue(
                item
            )

        if data.known then

            if data.newIgnored then

                result.newIgnored += 1

                result.newNames[
                    #result.newNames + 1
                ] =
                    data.name

            else

                result.total +=
                    data.value
            end

        else

            result.unknown += 1

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
        type(mine) ~= "number"
        or type(theirs) ~= "number"
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
-- ALLOWED INVENTORY FILTER
--============================================================

local function parseAllowed()

    local text =
        tostring(
            TestSettings.allowedItems
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

    local allowed = {}

    for part in text:gmatch(
        "[^,]+"
    ) do

        local key =
            normalize(part)

        if key ~= "" then
            allowed[key] = true
        end
    end

    return allowed
end

local function isAllowedName(name)

    local allowed =
        parseAllowed()

    if next(allowed) == nil then
        return true
    end

    return
        allowed[
            normalize(name)
        ]
        == true
end

--============================================================
-- READ OUR INVENTORY
--============================================================

local function shallowCopy(source)

    local result = {}

    for k, v in pairs(
        source
    ) do

        result[k] = v
    end

    return result
end

local function getInventory()

    local ok, inventory =
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
        type(ClientData.get_data)
        == "function"
    then

        local success, data =
            pcall(
                ClientData.get_data
            )

        if
            success
            and type(data)
                == "table"
        then

            if type(data.inventory) == "table" then
                return data.inventory
            end

            local mine =
                data[
                    tostring(
                        LocalPlayer
                    )
                ]
                or data[
                    LocalPlayer.Name
                ]
                or data[
                    tostring(
                        LocalPlayer.UserId
                    )
                ]

            if
                type(mine) == "table"
                and type(mine.inventory)
                    == "table"
            then

                return mine.inventory
            end
        end
    end

    return nil
end

local function inventoryItems()

    local inventory =
        getInventory()

    local result = {}

    if type(inventory) ~= "table" then

        return result
    end

    for category, bucket in pairs(
        inventory
    ) do

        if type(bucket) == "table" then

            for uid, raw in pairs(bucket) do

                if type(raw) == "table" then

                    local item =
                        shallowCopy(
                            raw
                        )

                    item.unique =
                        item.unique
                        or uid

                    item.category =
                        item.category
                        or category

                    local properties =
                        type(item.properties)
                            == "table"

                        and item.properties
                        or {}

                    local locked =
                        item.locked == true
                        or item.is_locked == true
                        or properties.locked == true

                    if not locked then

                        result[
                            #result + 1
                        ] =
                            item
                    end
                end
            end
        end
    end

    return result
end

--============================================================
-- VALUE OUR INVENTORY
--============================================================

local function valuedInventory()

    local result = {}

    for _, item in ipairs(
        inventoryItems()
    ) do

        local valueData =
            effectiveItemValue(
                item
            )

        -- NEW <24H:
        -- never automatically give away as showcase/final offer.
        if
            valueData.known
            and not valueData.newIgnored
            and valueData.value > 0
            and isAllowedName(
                valueData.name
            )
        then

            result[
                #result + 1
            ] = {

                item = item,

                uid =
                    tostring(
                        item.unique
                    ),

                name =
                    valueData.name,

                value =
                    valueData.value,
            }
        end
    end

    table.sort(
        result,
        function(a, b)

            return
                a.value
                > b.value
        end
    )

    return result
end

--============================================================
-- SHOWCASE
-- Highest known, non-new, allowed item.
--============================================================

local function getShowcaseCandidates()

    return
        valuedInventory()
end

--============================================================
-- COMBINATION OPTIMIZER
--
-- Find our highest total <= THEM / 1.10.
-- This gives a result as close as possible to +10%,
-- without intentionally reducing an already-good trade.
--============================================================

local function optimizeOurOffer(
    theirsValue
)

    local targetProfit =
        tonumber(
            TestSettings.minProfitPercent
        )
        or 10

    local cap =
        theirsValue
        / (
            1
            + targetProfit / 100
        )

    if cap <= 0 then

        return {},
            0,
            cap
    end

    local candidates =
        valuedInventory()

    local filtered = {}

    for _, candidate in ipairs(
        candidates
    ) do

        if candidate.value <= cap then

            filtered[
                #filtered + 1
            ] =
                candidate
        end
    end

    if #filtered == 0 then

        return {},
            0,
            cap
    end

    -- Keep search reasonable on huge inventories.
    if #filtered > 120 then

        local cut = {}

        for i = 1, 120 do
            cut[i] = filtered[i]
        end

        filtered = cut
    end

    local beam = {

        {
            total = 0,
            list = {},
        }
    }

    local beamWidth =
        math.max(
            50,
            math.floor(
                tonumber(
                    TestSettings.optimizerBeam
                )
                or 300
            )
        )

    local maxItems =
        math.clamp(
            math.floor(
                tonumber(
                    TestSettings.maxOurItems
                )
                or 18
            ),
            1,
            18
        )

    for _, candidate in ipairs(
        filtered
    ) do

        local expanded = {}

        for _, state in ipairs(
            beam
        ) do

            expanded[
                #expanded + 1
            ] =
                state

            if
                #state.list
                < maxItems
            then

                local newTotal =
                    state.total
                    + candidate.value

                if
                    newTotal
                    <= cap
                    + 0.000000001
                then

                    local newList = {}

                    for i, old in ipairs(
                        state.list
                    ) do

                        newList[i] = old
                    end

                    newList[
                        #newList + 1
                    ] =
                        candidate

                    expanded[
                        #expanded + 1
                    ] = {

                        total =
                            newTotal,

                        list =
                            newList,
                    }
                end
            end
        end

        table.sort(
            expanded,
            function(a, b)

                return
                    a.total
                    > b.total
            end
        )

        local unique = {}
        local nextBeam = {}

        for _, state in ipairs(
            expanded
        ) do

            local key =
                string.format(
                    "%.7f:%d",
                    state.total,
                    #state.list
                )

            if not unique[key] then

                unique[key] = true

                nextBeam[
                    #nextBeam + 1
                ] =
                    state

                if
                    #nextBeam
                    >= beamWidth
                then
                    break
                end
            end
        end

        beam =
            nextBeam

        if beam[1] then

            local difference =
                cap
                - beam[1].total

            if
                difference
                <= 0.000000001
            then

                break
            end
        end
    end

    local best =
        beam[1]

    if not best then

        return {},
            0,
            cap
    end

    return
        best.list,
        best.total,
        cap
end

--============================================================
-- OUR OFFER REMOTE CONTROL
--============================================================

local function currentUIDSet(offer)

    local set = {}

    for _, item in pairs(
        getOfferItems(offer)
    ) do

        if item.unique then

            set[
                tostring(
                    item.unique
                )
            ] =
                true
        end
    end

    return set
end

local function desiredUIDSet(list)

    local set = {}

    for _, candidate in ipairs(list) do

        set[
            tostring(
                candidate.uid
            )
        ] =
            true
    end

    return set
end

local function rebuildOurOffer(
    myOffer,
    desired
)

    if not TradeRemote.Add
        or not TradeRemote.Remove
    then

        return false
    end

    local current =
        currentUIDSet(
            myOffer
        )

    local wanted =
        desiredUIDSet(
            desired
        )

    -- REMOVE ITEMS THAT ARE NOT WANTED
    for _, item in pairs(
        getOfferItems(myOffer)
    ) do

        local uid =
            item.unique
            and tostring(
                item.unique
            )

        if
            uid
            and not wanted[uid]
        then

            testLog(
                "REMOVE OUR:",
                uid
            )

            remoteCall(
                TradeRemote.Remove,
                uid
            )

            task.wait(
                0.18
            )
        end
    end

    -- ADD MISSING ITEMS
    for _, candidate in ipairs(
        desired
    ) do

        if
            not current[
                candidate.uid
            ]
        then

            testLog(
                "ADD OUR:",
                candidate.name,
                "=",
                candidate.value
            )

            remoteCall(
                TradeRemote.Add,
                candidate.uid
            )

            task.wait(
                0.18
            )
        end
    end

    return true
end

--============================================================
-- CHAT
--
-- Does NOT bypass Roblox account/chat restrictions.
-- If chat isn't available, the trade continues without text.
--============================================================

local function sendChat(text)

    if
        TestSettings.chatRequests
        ~= true
    then

        return false
    end

    local sent = false

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

                general:SendAsync(
                    text
                )

                sent = true
            end
        end
    )

    if not sent then

        pcall(
            function()

                local events =
                    RS:
                    FindFirstChild(
                        "DefaultChatSystemChatEvents"
                    )

                local remote =
                    events
                    and events:
                    FindFirstChild(
                        "SayMessageRequest"
                    )

                if remote then

                    remote:FireServer(
                        text,
                        "All"
                    )

                    sent = true
                end
            end
        )
    end

    testLog(
        "CHAT:",
        text,
        "SENT=",
        sent
    )

    return sent
end

--============================================================
-- ACCEPT / CONFIRM / DECLINE
--============================================================

local function unaccept(myOffer)

    if
        type(myOffer) == "table"
        and myOffer.negotiated == true
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

local function declineTrade()

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
-- TEST PAGE GUI
--============================================================

local TestPage =
    createPage(
        "TEST"
    )

nav(
    "TEST",
    246
)

label(
    TestPage,

    "TEST / AUTO TRADE",

    UDim2.new(
        1,
        -30,
        0,
        34
    ),

    UDim2.fromOffset(
        16,
        7
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
            -32,
            0,
            22
        ),

        UDim2.fromOffset(
            17,
            39
        ),

        Enum.Font.Code,
        10,
        C.MUTED
    )

local TestScroll =
    Instance.new(
        "ScrollingFrame"
    )

TestScroll.Position =
    UDim2.fromOffset(
        15,
        67
    )

TestScroll.Size =
    UDim2.new(
        1,
        -30,
        1,
        -82
    )

TestScroll.BackgroundColor3 =
    C.PANEL

TestScroll.BorderSizePixel =
    0

TestScroll.CanvasSize =
    UDim2.fromOffset(
        0,
        680
    )

TestScroll.ScrollBarThickness =
    6

TestScroll.Parent =
    TestPage

corner(
    TestScroll,
    9
)

local function testButton(
    text,
    x,
    y,
    width
)

    return
        button(
            TestScroll,

            text,

            UDim2.fromOffset(
                width,
                34
            ),

            UDim2.fromOffset(
                x,
                y
            )
        )
end

local function settingBox(
    titleText,
    value,
    y
)

    label(
        TestScroll,

        titleText,

        UDim2.new(
            0.46,
            0,
            0,
            30
        ),

        UDim2.fromOffset(
            15,
            y
        ),

        Enum.Font.GothamBold,
        10,
        C.MUTED
    )

    local box =
        Instance.new(
            "TextBox"
        )

    box.Size =
        UDim2.new(
            0.30,
            0,
            0,
            30
        )

    box.Position =
        UDim2.new(
            0.54,
            0,
            0,
            y
        )

    box.BackgroundColor3 =
        C.PANEL2

    box.BorderSizePixel =
        0

    box.Text =
        tostring(value)

    box.TextColor3 =
        C.TEXT

    box.Font =
        Enum.Font.Code

    box.TextSize =
        10

    box.ClearTextOnFocus =
        false

    box.Parent =
        TestScroll

    corner(
        box,
        6
    )

    return box
end

--============================================================
-- MODE BUTTONS
--============================================================

local TestToggle =
    testButton(
        "",
        15,
        10,
        175
    )

local AutoToggle =
    testButton(
        "",
        200,
        10,
        175
    )

local function renderModeButtons()

    TestToggle.Text =
        "TEST AUTO ACCEPT: "
        .. (
            TestSettings.testAutoAccept
            and "ON"
            or "OFF"
        )

    AutoToggle.Text =
        "AUTO TRADE: "
        .. (
            TestSettings.autoTrade
            and "ON"
            or "OFF"
        )

    TestToggle.BackgroundColor3 =
        TestSettings.testAutoAccept
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2

    AutoToggle.BackgroundColor3 =
        TestSettings.autoTrade
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end

TestToggle.Activated:Connect(
    function()

        TestSettings.testAutoAccept =
            not TestSettings.testAutoAccept

        if TestSettings.testAutoAccept then

            TestSettings.autoTrade =
                false
        end

        saveTestSettings()
        renderModeButtons()
    end
)

AutoToggle.Activated:Connect(
    function()

        TestSettings.autoTrade =
            not TestSettings.autoTrade

        if TestSettings.autoTrade then

            TestSettings.testAutoAccept =
                false
        end

        saveTestSettings()
        renderModeButtons()
    end
)

renderModeButtons()

--============================================================
-- NUMBER SETTINGS
--============================================================

local ProfitBox =
    settingBox(
        "MIN PROFIT %",
        TestSettings.minProfitPercent,
        58
    )

local AddTimeoutBox =
    settingBox(
        "ADD TIMEOUT SEC",
        TestSettings.addTimeout,
        96
    )

local FirstItemBox =
    settingBox(
        "WAIT FIRST ITEM SEC",
        TestSettings.firstItemTimeout,
        134
    )

local RequestBox =
    settingBox(
        "TRADE REQUEST SEC",
        TestSettings.requestTimeout,
        172
    )

local CooldownBox =
    settingBox(
        "PLAYER COOLDOWN SEC",
        TestSettings.playerCooldown,
        210
    )

local RefreshBox =
    settingBox(
        "AMVGG REFRESH MIN",
        TestSettings.refreshMinutes,
        248
    )

local NewHoursBox =
    settingBox(
        "NEW ITEM IGNORE HOURS",
        TestSettings.newItemHours,
        286
    )

local function bindNumber(
    box,
    key,
    minValue,
    maxValue
)

    box.FocusLost:Connect(
        function()

            local value =
                tonumber(
                    box.Text
                )

            if not value then

                box.Text =
                    tostring(
                        TestSettings[key]
                    )

                return
            end

            value =
                math.clamp(
                    value,
                    minValue,
                    maxValue
                )

            TestSettings[key] =
                value

            box.Text =
                tostring(value)

            saveTestSettings()
        end
    )
end

bindNumber(
    ProfitBox,
    "minProfitPercent",
    0,
    500
)

bindNumber(
    AddTimeoutBox,
    "addTimeout",
    5,
    300
)

bindNumber(
    FirstItemBox,
    "firstItemTimeout",
    5,
    120
)

bindNumber(
    RequestBox,
    "requestTimeout",
    5,
    60
)

bindNumber(
    CooldownBox,
    "playerCooldown",
    10,
    3600
)

bindNumber(
    RefreshBox,
    "refreshMinutes",
    1,
    120
)

bindNumber(
    NewHoursBox,
    "newItemHours",
    1,
    168
)

--============================================================
-- ALLOWED ITEMS
--============================================================

label(
    TestScroll,

    "ALLOWED ITEMS (blank = ALL)",

    UDim2.new(
        1,
        -30,
        0,
        24
    ),

    UDim2.fromOffset(
        15,
        328
    ),

    Enum.Font.GothamBold,
    10,
    C.MUTED
)

local AllowedBox =
    Instance.new(
        "TextBox"
    )

AllowedBox.Size =
    UDim2.new(
        1,
        -30,
        0,
        55
    )

AllowedBox.Position =
    UDim2.fromOffset(
        15,
        353
    )

AllowedBox.BackgroundColor3 =
    C.PANEL2

AllowedBox.BorderSizePixel =
    0

AllowedBox.Text =
    tostring(
        TestSettings.allowedItems
        or ""
    )

AllowedBox.PlaceholderText =
    "blank = all | Frost Dragon, Owl, Turtle..."

AllowedBox.PlaceholderColor3 =
    C.MUTED

AllowedBox.TextColor3 =
    C.TEXT

AllowedBox.Font =
    Enum.Font.Code

AllowedBox.TextSize =
    9

AllowedBox.MultiLine =
    true

AllowedBox.ClearTextOnFocus =
    false

AllowedBox.TextWrapped =
    true

AllowedBox.Parent =
    TestScroll

corner(
    AllowedBox,
    6
)

AllowedBox.FocusLost:Connect(
    function()

        TestSettings.allowedItems =
            AllowedBox.Text

        saveTestSettings()
    end
)

--============================================================
-- CHAT TOGGLE
--============================================================

local ChatToggle =
    testButton(
        "",
        15,
        418,
        175
    )

local function renderChat()

    ChatToggle.Text =
        "REQUEST CHAT: "
        .. (
            TestSettings.chatRequests
            and "ON"
            or "OFF"
        )

    ChatToggle.BackgroundColor3 =
        TestSettings.chatRequests
        and Color3.fromRGB(
            40,
            105,
            70
        )
        or C.PANEL2
end

ChatToggle.Activated:Connect(
    function()

        TestSettings.chatRequests =
            not TestSettings.chatRequests

        saveTestSettings()
        renderChat()
    end
)

renderChat()

--============================================================
-- INVENTORY BUTTON
--============================================================

local InventoryButton =
    testButton(
        "SCAN INVENTORY",
        200,
        418,
        175
    )

--============================================================
-- TEST LOG BOX
--============================================================

local TestLogBox =
    Instance.new(
        "TextBox"
    )

TestLogBox.Size =
    UDim2.new(
        1,
        -30,
        0,
        145
    )

TestLogBox.Position =
    UDim2.fromOffset(
        15,
        462
    )

TestLogBox.BackgroundColor3 =
    Color3.fromRGB(
        8,
        10,
        15
    )

TestLogBox.BorderSizePixel =
    0

TestLogBox.Text =
    ""

TestLogBox.TextColor3 =
    C.TEXT

TestLogBox.Font =
    Enum.Font.Code

TestLogBox.TextSize =
    8

TestLogBox.TextXAlignment =
    Enum.TextXAlignment.Left

TestLogBox.TextYAlignment =
    Enum.TextYAlignment.Top

TestLogBox.TextEditable =
    true

TestLogBox.ClearTextOnFocus =
    false

TestLogBox.MultiLine =
    true

TestLogBox.TextWrapped =
    false

TestLogBox.Parent =
    TestScroll

corner(
    TestLogBox,
    6
)

task.spawn(
    function()

        while Gui.Parent do

            TestLogBox.Text =
                table.concat(
                    TestLogs,
                    "\n"
                )

            task.wait(
                0.75
            )
        end
    end
)

InventoryButton.Activated:Connect(
    function()

        task.spawn(
            function()

                testLog(
                    "SCANNING INVENTORY..."
                )

                local list =
                    valuedInventory()

                testLog(
                    "KNOWN ALLOWED ITEMS:",
                    #list
                )

                for i = 1, math.min(
                    10,
                    #list
                ) do

                    testLog(
                        "#"
                        .. tostring(i),
                        list[i].name,
                        "=",
                        list[i].value
                    )
                end

                if list[1] then

                    testLog(
                        "SHOWCASE:",
                        list[1].name,
                        "=",
                        list[1].value
                    )
                end
            end
        )
    end
)

--============================================================
-- STATUS
--============================================================

local function setTestStatus(
    text,
    color
)

    TestStatus.Text =
        "STATUS: "
        .. tostring(text)

    TestStatus.TextColor3 =
        color
        or C.MUTED
end

--============================================================
-- AUTO STATE
--============================================================

local State = {

    mode =
        "IDLE",

    target =
        nil,

    requestStarted =
        nil,

    currentTradeID =
        nil,

    tradeStarted =
        nil,

    lastSignature =
        nil,

    offerChangedAt =
        nil,

    showcaseTried =
        {},

    showcaseSent =
        false,

    initialAskSent =
        false,

    askStarted =
        nil,

    askSignature =
        nil,

    acceptedSignature =
        nil,

    optimizedSignature =
        nil,

    declineSent =
        false,

    lastUnknownRefresh =
        0,
}

local PlayerCooldowns = {}

local function resetTradeState()

    State.currentTradeID =
        nil

    State.tradeStarted =
        nil

    State.lastSignature =
        nil

    State.offerChangedAt =
        nil

    State.showcaseTried =
        {}

    State.showcaseSent =
        false

    State.initialAskSent =
        false

    State.askStarted =
        nil

    State.askSignature =
        nil

    State.acceptedSignature =
        nil

    State.optimizedSignature =
        nil

    State.declineSent =
        false
end

--============================================================
-- RANDOM PLAYER
--============================================================

local function chooseRandomPlayer()

    local candidates = {}

    local now =
        os.clock()

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if player ~= LocalPlayer then

            local untilTime =
                PlayerCooldowns[
                    player.UserId
                ]
                or 0

            if now >= untilTime then

                candidates[
                    #candidates + 1
                ] =
                    player
            end
        end
    end

    if #candidates == 0 then
        return nil
    end

    return
        candidates[
            math.random(
                1,
                #candidates
            )
        ]
end

local function cooldownPlayer(player)

    if not player then
        return
    end

    PlayerCooldowns[
        player.UserId
    ] =
        os.clock()
        + (
            tonumber(
                TestSettings.playerCooldown
            )
            or 300
        )
end

--============================================================
-- SEND RANDOM TRADE
--============================================================

local function sendTradeRequest(player)

    if not TradeRemote.SendRequest then

        setTestStatus(
            "SEND TRADE REMOTE MISSING",
            C.RED
        )

        testLog(
            "TradeAPI/SendTradeRequest missing"
        )

        return false
    end

    testLog(
        "TRADE REQUEST ->",
        player.Name
    )

    local ok =
        remoteCall(
            TradeRemote.SendRequest,
            player
        )

    return ok
end

--============================================================
-- SHOWCASE HIGHEST ITEM
--============================================================

local function tryShowcase(myOffer)

    if
        countOfferItems(
            myOffer
        ) > 0
    then

        State.showcaseSent =
            true

        return true
    end

    local candidates =
        getShowcaseCandidates()

    if #candidates == 0 then

        setTestStatus(
            "NO SHOWCASE ITEM",
            C.RED
        )

        return false
    end

    for _, candidate in ipairs(
        candidates
    ) do

        if
            not State.showcaseTried[
                candidate.uid
            ]
        then

            State.showcaseTried[
                candidate.uid
            ] =
                true

            testLog(
                "SHOWCASE:",
                candidate.name,
                "=",
                candidate.value
            )

            remoteCall(
                TradeRemote.Add,
                candidate.uid
            )

            return true
        end
    end

    return false
end

--============================================================
-- VERIFY TRADE FOR ACCEPT/CONFIRM
--============================================================

local function evaluateCurrentTrade(
    myOffer,
    theirOffer
)

    local mine =
        evaluateOffer(
            myOffer
        )

    local theirs =
        evaluateOffer(
            theirOffer
        )

    local result = {

        mine = mine,

        theirs = theirs,

        valid = false,

        profit = nil,
    }

    -- Unknown = never trust.
    if
        mine.unknown > 0
        or theirs.unknown > 0
    then

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
            >= (
                tonumber(
                    TestSettings.minProfitPercent
                )
                or 10
            )
    end

    return result
end

--============================================================
-- ACCEPT OR CONFIRM
--============================================================

local function secureAcceptOrConfirm(
    trade,
    myOffer,
    theirOffer
)

    local evaluation =
        evaluateCurrentTrade(
            myOffer,
            theirOffer
        )

    if not evaluation.valid then

        unaccept(
            myOffer
        )

        State.acceptedSignature =
            nil

        return false
    end

    local signature =
        completeOfferSignature(
            myOffer,
            theirOffer
        )

    local stage =
        tostring(
            trade.current_stage
            or ""
        ):lower()

    --========================================================
    -- FINAL CONFIRM
    --========================================================

    if
        stage:find(
            "confirm",
            1,
            true
        )
    then

        -- Must still be EXACT SAME offer we accepted.
        if
            State.acceptedSignature
            and State.acceptedSignature
                ~= signature
        then

            testLog(
                "OFFER CHANGED BEFORE CONFIRM"
            )

            unaccept(
                myOffer
            )

            State.acceptedSignature =
                nil

            return false
        end

        testLog(
            "FINAL RECHECK:",
            string.format(
                "+%.2f%%",
                evaluation.profit
            ),
            "NEW IGNORED:",
            evaluation.mine.newIgnored
            + evaluation.theirs.newIgnored
        )

        if
            not myOffer.confirmed
            and TradeRemote.Confirm
        then

            remoteCall(
                TradeRemote.Confirm
            )

            testLog(
                "CONFIRM TRADE"
            )
        end

        return true
    end

    --========================================================
    -- NEGOTIATION ACCEPT
    --========================================================

    if not myOffer.negotiated then

        State.acceptedSignature =
            signature

        testLog(
            "ACCEPT:",
            string.format(
                "+%.2f%%",
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
-- UNKNOWN REFRESH
--============================================================

local function refreshUnknown()

    if
        os.clock()
        - State.lastUnknownRefresh
        < 20
    then

        return
    end

    State.lastUnknownRefresh =
        os.clock()

    task.spawn(
        function()

            testLog(
                "UNKNOWN -> AMVGG REFRESH"
            )

            refresh()

            task.wait(
                1
            )

            updateFirstSeen()
        end
    )
end

--============================================================
-- TEST AUTO ACCEPT
--
-- Manual trade:
-- >= target = accept
-- below target = decline
--
-- New <24h items are ignored.
-- Unknown items block.
--============================================================

local TestHandledTrade

local function runTestMode()

    local trade =
        getTrade()

    if not trade then

        TestHandledTrade =
            nil

        setTestStatus(
            "TEST WAITING FOR TRADE",
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

    local tradeID =
        tostring(
            trade.trade_id
            or trade.id
            or trade
        )

    local mine =
        evaluateOffer(
            myOffer
        )

    local theirs =
        evaluateOffer(
            theirOffer
        )

    if
        mine.unknown > 0
        or theirs.unknown > 0
    then

        unaccept(
            myOffer
        )

        setTestStatus(
            "TEST UNKNOWN VALUE",
            C.RED
        )

        refreshUnknown()

        return
    end

    if
        theirs.count == 0
        or mine.count == 0
    then

        setTestStatus(
            "TEST WAITING OFFER",
            C.YELLOW
        )

        return
    end

    local profit =
        profitPercent(
            mine.total,
            theirs.total
        )

    if not profit then
        return
    end

    local target =
        tonumber(
            TestSettings.minProfitPercent
        )
        or 10

    if profit >= target then

        setTestStatus(
            string.format(
                "TEST WIN +%.2f%%",
                profit
            ),
            C.GREEN
        )

        secureAcceptOrConfirm(
            trade,
            myOffer,
            theirOffer
        )

        return
    end

    unaccept(
        myOffer
    )

    setTestStatus(
        string.format(
            "TEST LOSE %.2f%% -> DECLINE",
            profit
        ),
        C.RED
    )

    if TestHandledTrade ~= tradeID then

        TestHandledTrade =
            tradeID

        declineTrade()
    end
end

--============================================================
-- MANAGE ACTIVE AUTO TRADE
--============================================================

local function manageAutoTrade(trade)

    local myOffer,
        theirOffer,
        me,
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

    local tradeID =
        tostring(
            trade.trade_id
            or trade.id
            or playerName(partner)
        )

    --========================================================
    -- NEW TRADE
    --========================================================

    if
        State.currentTradeID
        ~= tradeID
    then

        resetTradeState()

        State.currentTradeID =
            tradeID

        State.tradeStarted =
            os.clock()

        State.offerChangedAt =
            os.clock()

        testLog(
            "ACTIVE TRADE:",
            playerName(partner)
        )
    end

    --========================================================
    -- MAX TRADE TIME
    --========================================================

    if
        State.tradeStarted
        and os.clock()
            - State.tradeStarted
            >
            (
                tonumber(
                    TestSettings.maxTradeSeconds
                )
                or 120
            )
    then

        if not State.declineSent then

            State.declineSent =
                true

            setTestStatus(
                "TRADE TIMEOUT",
                C.RED
            )

            declineTrade()
        end

        return
    end

    --========================================================
    -- OFFER CHANGE DETECTION
    --========================================================

    local signature =
        completeOfferSignature(
            myOffer,
            theirOffer
        )

    if
        State.lastSignature
        ~= signature
    then

        -- If they changed anything after our ACCEPT,
        -- revoke our acceptance.
        if
            State.acceptedSignature
            and State.acceptedSignature
                ~= signature
        then

            testLog(
                "CHANGE AFTER ACCEPT -> UNACCEPT"
            )

            unaccept(
                myOffer
            )

            State.acceptedSignature =
                nil
        end

        State.lastSignature =
            signature

        State.offerChangedAt =
            os.clock()
    end

    local myCount =
        countOfferItems(
            myOffer
        )

    local theirCount =
        countOfferItems(
            theirOffer
        )

    --========================================================
    -- SHOW MOST EXPENSIVE ITEM
    --========================================================

    if myCount == 0 then

        setTestStatus(
            "ADDING SHOWCASE",
            C.YELLOW
        )

        tryShowcase(
            myOffer
        )

        return
    end

    --========================================================
    -- ASK PLAYER TO SHOW SOMETHING
    --========================================================

    if theirCount == 0 then

        if not State.initialAskSent then

            State.initialAskSent =
                true

            sendChat(
                "add any pet/item"
            )

            testLog(
                "WAITING FOR THEIR FIRST ITEM"
            )
        end

        local elapsed =
            os.clock()
            - (
                State.tradeStarted
                or os.clock()
            )

        local timeout =
            tonumber(
                TestSettings.firstItemTimeout
            )
            or 25

        setTestStatus(
            "WAIT THEIR ITEM "
            .. tostring(
                math.max(
                    0,
                    math.ceil(
                        timeout
                        - elapsed
                    )
                )
            )
            .. "s",
            C.YELLOW
        )

        if elapsed >= timeout then

            if not State.declineSent then

                State.declineSent =
                    true

                declineTrade()

                cooldownPlayer(
                    partner
                )
            end
        end

        return
    end

    --========================================================
    -- WAIT UNTIL OFFER STOPS MOVING
    --========================================================

    if
        State.offerChangedAt
        and os.clock()
            - State.offerChangedAt
            <
            (
                tonumber(
                    TestSettings.settleSeconds
                )
                or 2
            )
    then

        setTestStatus(
            "OFFER CHANGING",
            C.YELLOW
        )

        return
    end

    --========================================================
    -- VALUE CURRENT TRADE
    --========================================================

    local mine =
        evaluateOffer(
            myOffer
        )

    local theirs =
        evaluateOffer(
            theirOffer
        )

    --========================================================
    -- UNKNOWN = BLOCK
    --========================================================

    if
        mine.unknown > 0
        or theirs.unknown > 0
    then

        unaccept(
            myOffer
        )

        setTestStatus(
            "UNKNOWN ITEM - WAIT AMVGG",
            C.RED
        )

        testLog(
            "UNKNOWN MINE=",
            mine.unknown,
            "THEIRS=",
            theirs.unknown
        )

        refreshUnknown()

        return
    end

    --========================================================
    -- NEW <24H
    --========================================================

    if
        mine.newIgnored > 0
        or theirs.newIgnored > 0
    then

        testLog(
            "NEW <24H IGNORED:",
            "MINE=",
            mine.newIgnored,
            "THEIRS=",
            theirs.newIgnored
        )
    end

    local profit =
        profitPercent(
            mine.total,
            theirs.total
        )

    local target =
        tonumber(
            TestSettings.minProfitPercent
        )
        or 10

    --========================================================
    -- ALREADY >= TARGET
    --
    -- IMPORTANT:
    -- DON'T intentionally add more of our pets just to make
    -- +30% become exactly +10%.
    -- Anything >= target is already a WIN.
    --========================================================

    if
        profit
        and profit >= target
    then

        State.askStarted =
            nil

        State.askSignature =
            nil

        setTestStatus(
            string.format(
                "WIN +%.2f%%",
                profit
            ),
            C.GREEN
        )

        secureAcceptOrConfirm(
            trade,
            myOffer,
            theirOffer
        )

        return
    end

    --========================================================
    -- CURRENT OFFER NOT GOOD ENOUGH
    --
    -- Rebuild our offer as close as possible to +10%.
    --========================================================

    unaccept(
        myOffer
    )

    local theirSignature =
        offerOnlySignature(
            theirOffer
        )

    if
        State.optimizedSignature
        ~= theirSignature
    then

        State.optimizedSignature =
            theirSignature

        local desired,
            desiredValue,
            cap =
            optimizeOurOffer(
                theirs.total
            )

        if
            #desired > 0
            and desiredValue > 0
        then

            testLog(
                "OPTIMIZER:",
                "THEIRS=",
                theirs.total,
                "MAX OURS=",
                cap,
                "SELECTED=",
                desiredValue,
                "ITEMS=",
                #desired
            )

            setTestStatus(
                "REBUILDING OUR OFFER",
                C.YELLOW
            )

            rebuildOurOffer(
                myOffer,
                desired
            )

            State.offerChangedAt =
                os.clock()

            return
        else

            testLog(
                "OPTIMIZER: NO OUR COMBO <= ",
                cap
            )
        end
    end

    --========================================================
    -- AFTER OPTIMIZATION STILL NOT +10:
    -- REQUEST ADD
    --========================================================

    local currentTheirSignature =
        offerOnlySignature(
            theirOffer
        )

    if
        not State.askStarted
        or State.askSignature
            ~= currentTheirSignature
    then

        State.askStarted =
            os.clock()

        State.askSignature =
            currentTheirSignature

        sendChat(
            "please add a little"
        )

        testLog(
            "ASK ADD START"
        )
    end

    local elapsed =
        os.clock()
        - State.askStarted

    local timeout =
        tonumber(
            TestSettings.addTimeout
        )
        or 40

    local remaining =
        math.max(
            0,
            timeout
            - elapsed
        )

    setTestStatus(
        "ASK ADD • "
        .. tostring(
            math.ceil(
                remaining
            )
        )
        .. "s",
        C.YELLOW
    )

    if elapsed >= timeout then

        if not State.declineSent then

            State.declineSent =
                true

            testLog(
                "ADD TIMEOUT"
            )

            declineTrade()

            cooldownPlayer(
                partner
            )
        end
    end
end

--============================================================
-- AUTO TRADE MAIN
--============================================================

local function runAutoTrade()

    local trade =
        getTrade()

    --========================================================
    -- ACTIVE TRADE
    --========================================================

    if trade then

        State.target =
            nil

        State.requestStarted =
            nil

        State.mode =
            "TRADE"

        manageAutoTrade(
            trade
        )

        return
    end

    --========================================================
    -- PREVIOUS TRADE FINISHED
    --========================================================

    if State.currentTradeID then

        resetTradeState()

        State.mode =
            "IDLE"
    end

    --========================================================
    -- WAIT FOR SENT REQUEST
    --========================================================

    if
        State.target
        and State.requestStarted
    then

        local elapsed =
            os.clock()
            - State.requestStarted

        local timeout =
            tonumber(
                TestSettings.requestTimeout
            )
            or 15

        setTestStatus(
            "WAIT "
            .. State.target.Name
            .. " "
            .. tostring(
                math.max(
                    0,
                    math.ceil(
                        timeout
                        - elapsed
                    )
                )
            )
            .. "s",
            C.YELLOW
        )

        if elapsed >= timeout then

            testLog(
                "REQUEST TIMEOUT:",
                State.target.Name
            )

            cooldownPlayer(
                State.target
            )

            State.target =
                nil

            State.requestStarted =
                nil

            State.mode =
                "IDLE"

            task.wait(
                1
            )
        end

        return
    end

    --========================================================
    -- SEND REQUEST TO RANDOM PLAYER
    --========================================================

    local target =
        chooseRandomPlayer()

    if not target then

        setTestStatus(
            "NO AVAILABLE PLAYER",
            C.YELLOW
        )

        return
    end

    State.target =
        target

    State.requestStarted =
        os.clock()

    State.mode =
        "REQUEST"

    setTestStatus(
        "REQUEST -> "
        .. target.Name,
        C.YELLOW
    )

    local sent =
        sendTradeRequest(
            target
        )

    if not sent then

        cooldownPlayer(
            target
        )

        State.target =
            nil

        State.requestStarted =
            nil

        task.wait(
            2
        )
    end
end

--============================================================
-- MASTER LOOP
--============================================================

task.spawn(
    function()

        while Gui.Parent do

            local ok, err =
                pcall(
                    function()

                        if TestSettings.testAutoAccept then

                            runTestMode()

                        elseif TestSettings.autoTrade then

                            runAutoTrade()

                        else

                            setTestStatus(
                                "OFF",
                                C.MUTED
                            )

                            TestHandledTrade =
                                nil

                            State.target =
                                nil

                            State.requestStarted =
                                nil

                            resetTradeState()
                        end
                    end
                )

            if not ok then

                testLog(
                    "LOOP ERROR:",
                    err
                )

                setTestStatus(
                    "ERROR",
                    C.RED
                )
            end

            task.wait(
                0.45
            )
        end
    end
)

--============================================================
-- AMVGG FIRST-SEEN WATCHER
--============================================================

task.spawn(
    function()

        local lastVersion =
            -1

        while Gui.Parent do

            if
                AMVGG.ready
                and AMVGG.version
                    ~= lastVersion
            then

                lastVersion =
                    AMVGG.version

                updateFirstSeen()

                testLog(
                    "AMVGG VERSION:",
                    AMVGG.version
                )
            end

            task.wait(
                1.5
            )
        end
    end
)

--============================================================
-- FASTER AMVGG REFRESH
--============================================================

task.spawn(
    function()

        while Gui.Parent do

            local minutes =
                math.max(
                    1,
                    tonumber(
                        TestSettings.refreshMinutes
                    )
                    or 5
                )

            task.wait(
                minutes * 60
            )

            if Gui.Parent then

                testLog(
                    "PERIODIC AMVGG REFRESH"
                )

                pcall(
                    refresh
                )
            end
        end
    end
)

--============================================================
-- DEBUG REMOTE STATUS
--============================================================

testLog(
    "TEST/AUTO V11.7.0 READY"
)

testLog(
    "SendTradeRequest =",
    TradeRemote.SendRequest
        and "OK"
        or "MISSING"
)

testLog(
    "AddItemToOffer =",
    TradeRemote.Add
        and "OK"
        or "MISSING"
)

testLog(
    "RemoveItemFromOffer =",
    TradeRemote.Remove
        and "OK"
        or "MISSING"
)

testLog(
    "AcceptNegotiation =",
    TradeRemote.Accept
        and "OK"
        or "MISSING"
)

testLog(
    "ConfirmTrade =",
    TradeRemote.Confirm
        and "OK"
        or "MISSING"
)

testLog(
    "DeclineTrade =",
    TradeRemote.Decline
        and "OK"
        or "MISSING"
)

testLog(
    "SuggestItem =",
    TradeRemote.SuggestItem
        and "FOUND / NOT USED YET"
        or "MISSING"
)

testLog(
    "DEFAULT PROFIT =",
    TestSettings.minProfitPercent,
    "%"
)

testLog(
    "NEW ITEM RULE = IGNORE VALUE FOR",
    TestSettings.newItemHours,
    "HOURS"
)

print(
    "[AM TEST V11.7.0] READY"
)
