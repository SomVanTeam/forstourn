--https://www.roblox.com/share?code=c947bd6f9524044eb7524850a33fa41b&type=Server
--loadstring(game:HttpGet(("https://raw.githubusercontent.com/SomVanTeam/forstourn/refs/heads/main/main.lua")))()
local HttpService = game:GetService("HttpService")
local networker:RemoteEvent = game.ReplicatedStorage.Modules.Network.Network.RemoteEvent
local reporter = "https://discord.com/api/webhooks/1533176667776880764/DW2Y_nEtY_V5aqD7L3J27z2ywIvmU2IWJ_bWJiE0dlV6BRwfw5uiE8QsDFpLBUV0N5gm"

pings = {
    ["somvanhaaaaiiiiii"] = "<@730864691223593031>",
    ["2022mm12"] = "<@1220054046640046091>",
    ["anderkva"] = "<@1045795103001825400>",
    ["unttaka"] = "<@577128685342031892>",
    ["lengotova"] = "<@796288372388790292>",
    ["Lynzqqx"] = "<@584019099965980674>",
    ["jarik122012"] = "<@946397884209823745>",
    ["Xx_KaKoSuKxX"] = "<@903598078387445770>",
    ["th_vladaimir"] = "<VLADAIMIR PING>", -- TESTING ONLY
}

participants = {
    "somvanhaaaaiiiiii",
    "2022mm12",
    "anderkva",
    "unttaka",
    "lengotova",
    "Lynzqqx",
    "jarik122012",
    "Xx_KaKoSuKxX",
    "th_vladaimir" -- TESTING ONLY
}

function pingFromName(name:string):string
    return pings[name]
end

function sendAdminCommand(buftable:{buffer}):nil
    networker:FireServer(
        "ExecuteCommand",
        buftable
    )
end

function stringBuf(str:string):buffer
    if typeof(str) == "buffer" then
        print(buffer.readstring(str, 0, buffer.len(str)))
    end
    local buf = buffer.create(string.len(str)+5) --buffer.fromstring("\x03\x00\x00\x00\x00"..str)
    -- first byte is 03 meaning this is a string
    buffer.writeu8(buf, 0, 3)
    -- second byte is string length
    -- other zeros are unused
    buffer.writeu8(buf, 1, string.len(str))
    buffer.writestring(buf, 5, str)
    return buf
end

function numberBuf(num:number):buffer
    local buf = buffer.create(9)
    -- first byte is 02 meaning this is a number
    buffer.writeu8(buf, 0, 2)
    -- next bytes are float64 of that number for some odd reason
    buffer.writef64(buf, 1, num)
    return buf
end

function isHitboxGreen(hitbox:BasePart)
    if hitbox.Color.G > 127 then
        return true
    end
    return false
end

local targetAll = "All"

type ActionDesc = {
    pointReward:number,
    formattable:string, -- %A - Actor, %T - Targets
    -- string.gsub(formattable, "&A", "Actor", 1)
}

local actionDescs:{[string]:ActionDesc} = {
    ["Kill"]={pointReward = 0.5, formattable = "%A убил %T"},
    ["Slasher Kill Behead"]={pointReward = 0.25, formattable = "%A убил %T с помощью бихеда"},
    ["Slasher Land Gashing Wound"]={pointReward = 0.5, formattable = "%A попал в %T гешингом"},
    ["Slasher Cancel Stun"]={pointReward = 0.25, formattable = "%A аннулировал стан рейджом"},
    ["C00lkidd Land Corrupt Nature"]={pointReward = 0.25, formattable = "%A попал в %T коррупт нейчуром"},
    ["C00lkidd Land Walkspeed Override"]={pointReward = 0.65, formattable = "%A попал в %T валкспид оверрайдом"},
    ["C00lkidd Land Minion"]={pointReward = 0.5, formattable = "Миньон %A каснулся в %T"},
    ["John Doe Land Spike"]={pointReward = 0.05, formattable = "%A попал шипом в %T"},
    ["John Doe Land Trap"]={pointReward = 0.25, formattable = "%T наступил в ловушку %A"},
    ["John Doe Cancel Stun"]={pointReward = 0.5, formattable = "%A отменил стан с помощью эррор 404"},
    ["1x1x1x1 Land Entanglement"]={pointReward = 0.25, formattable = "%A попал энтанглом в %T"},
    ["1x1x1x1 Land Mass Infection"]={pointReward = 0.4, formattable = "%A попал масс инфекшеном в %T"},

    ["Noob Tricked Killer"]={pointReward = 0.3, formattable = "%A успешно спрятался от киллера гостбургером"},
    ["Noob Used Slateskin"]={pointReward = 0.15, formattable = "%A использовал слейтскин"},
    ["Noob Used BloxyCola"]={pointReward = 0.15, formattable = "%A использовал блокси колу рядом с киллером"},
}

type Action = {
    actor:Player,
    targets:{Player},
    desc:ActionDesc,
}

type character = {
    player:Player,
    charname:string
}

type lastRound = {
    killers:{character},
    survivors:{character},
    actions:{Action},
}
local lastRound:lastRound = {}

function addAction(action:Action)
    table.insert(lastRound.actions, action)
end

local timerCurrentlyStopped = true
function toggleTimer()
    timerCurrentlyStopped = not timerCurrentlyStopped
    sendAdminCommand({
        stringBuf("ToggleTimer")
    })
end

function startTimer()
    if timerCurrentlyStopped then
        toggleTimer()
    end
end

function stopTimer()
    if not timerCurrentlyStopped then
        toggleTimer()
    end
end

function getAliveKillers():{Model}
    return workspace.Players.Killers:GetChildren()
end

function getAliveSurvivors():{Model}
    return workspace.Players.Survivors:GetChildren()
end

function getCharacterUsername(char:Model):string
    return char:GetAttribute("Username")
end

function isKiller(plrname:string):boolean
    for _, k in pairs(getAliveKillers()) do
        if getCharacterUsername(k) == plrname then
            return true
        end
    end
    return false
end

function isSurvivor(plrname:string):boolean
    for _, s in pairs(getAliveSurvivors()) do
        if getCharacterUsername(s) == plrname then
            return true
        end
    end
    return false
end

function getCharacterName(plrname:string):string
    return game.Players:FindFirstChild(plrname).Character.Name
end

function isVipCharacter(charname:string):boolean
    return table.find({
        "Noob",
        "007n7",
        "Veeronica",
        "Shedletsky",
        "Two Time",
        "Chance",
        "Guest 1337",
        "Builderman",
        "Dusekkar",
        "Elliot",
        "Taph",
        "Jane Doe",

        "Slasher",
        "C00lkidd",
        "John Doe",
        "Noli",
        "1x1x1x1",
        "Nosferatu",
        "Azure",
        "Guest 666",
    }, charname) == nil
end

function isLMS():boolean
    return #getAliveSurvivors() == 1 and #getAliveKillers() >= 1
end

local playtimePenaltyMult = 86400*14 -- 14 days
function tryGivePenalty(plr:Player):nil
    local playtime = 0
    local penaltyLevel = math.floor(playtime/playtimePenaltyMult)
    if isLMS() then
        if getCharacterName(plr.Name) == "Veeronica" then
            penaltyLevel = 9000 -- vulnerable lvl
        end
    end
    if penaltyLevel > 0 then
        if isKiller(plr.Name) then
            sendAdminCommand({
                stringBuf("GiveStatus"),
                stringBuf(plr.Name),
                stringBuf("Weakness"),
                numberBuf(penaltyLevel),
                numberBuf(67)
            })
        else
            sendAdminCommand({
                stringBuf("GiveStatus"),
                stringBuf(plr.Name),
                stringBuf("Vulnerable"),
                numberBuf(penaltyLevel),
                numberBuf(67)
            })
        end
    end
end

local desiredMatchCombo = "[0, 8, 2, 5, 7]"
local desiredMap = ""

local roundBeganTime = 0
local roundActive = false
local roundT = false
-- returns success
function roundStart():boolean
    if roundActive or roundT then
        return false
    end
    roundT = true
    print(desiredMatchCombo)
    print(desiredMatchCombo:sub(2,2))
    local killerid = tonumber(desiredMatchCombo:sub(2,2))+1
    local desiredKiller = participants[killerid]
    local survivorids = {
        tonumber(desiredMatchCombo:sub(5,5))+1,
        tonumber(desiredMatchCombo:sub(8,8))+1,
        tonumber(desiredMatchCombo:sub(11,11))+1,
        tonumber(desiredMatchCombo:sub(14,14))+1,
    }
    local allowedSurvivors = {}
    for _, sid in pairs(survivorids) do
        table.insert(allowedSurvivors, participants[sid])
    end
    sendAdminCommand({
        stringBuf("ForceNextKiller"),
        stringBuf(desiredKiller)
    })
    task.wait(1)
    if desiredMap then
        
    end
    startTimer()
    task.wait(1)
    sendAdminCommand({
        "ForceIntermissionEnd"
    })
    task.wait(1)
    stopTimer()
    task.wait(2)
    for _, s in pairs(getAliveSurvivors()) do
        if not table.find(allowedSurvivors, getCharacterUsername(s)) or isVipCharacter(s.Name) then
            sendAdminCommand({
                stringBuf("KillPlayer"),
                stringBuf(getCharacterUsername(s))
            })
        end
    end
    for _, k in pairs(getAliveKillers()) do
        if isVipCharacter(k.Name) then
            sendAdminCommand({
                stringBuf("KillPlayer"),
                stringBuf(getCharacterUsername(k))
            })
        end
    end
    roundActive = true
    lastRound = {
        survivors = {},
        killers = {},
        actions = {}
    }
    sendAdminCommand({
        stringBuf("GiveStatus"),
        stringBuf("All"),
        stringBuf("Helpless"),
        numberBuf(10),
        numberBuf(5)
    })
    sendAdminCommand({
        stringBuf("GiveStatus"),
        stringBuf("All"),
        stringBuf("Slowness"),
        numberBuf(10),
        numberBuf(5)
    })
    sendAdminCommand({
        stringBuf("GiveStatus"),
        stringBuf("All"),
        stringBuf("Resistance"),
        numberBuf(10),
        numberBuf(5)
    })
    for _, s in pairs(getAliveSurvivors()) do
        table.insert(lastRound.survivors, {
            charname = s.Name,
            player = game.Players:FindFirstChild(getCharacterUsername(s))
        })
        s:FindFirstChildOfClass("Humanoid").Died:Once(function()
            addAction({
                actor = desiredKiller,
                targets = {getCharacterUsername(s)},
                desc = actionDescs["Kill"]
            })
        end)
    end
    for _, k in pairs(getAliveKillers()) do
        table.insert(lastRound.killers, {
            charname = k.Name,
            player = game.Players:FindFirstChild(getCharacterUsername(k))
        })
    end
    coroutine.wrap(roundLoop)()
    task.wait(5)
    startTimer()
    task.wait(1)
    roundBeganTime = os.time()
    roundT = false
    return true
end

function roundLoop()
    while roundActive do
        task.wait(2)
        for _, s in pairs(getAliveSurvivors()) do
            local p = game.Players:FindFirstChild(getCharacterUsername(s))
            tryGivePenalty(p)
        end
        for _, k in pairs(getAliveKillers()) do
            local p = game.Players:FindFirstChild(getCharacterUsername(k))
            tryGivePenalty(p)
        end
    end
end

function onRoundEnded()
    roundActive = false
    local roundLastedFor = os.time()-roundBeganTime
    local killersF = ""
    for _, killer in pairs(lastRound.killers) do
        killersF = killersF..pingFromName(killer.player.Name).." - "..killer.charname.."\n"
    end
    local survivorsF = ""
    for _, survivor in pairs(lastRound.survivors) do
        survivorsF = survivorsF..pingFromName(survivor.player.Name).." - "..survivor.charname.."\n"
    end
    local historyF = "abcd\n\n"
    for _, action in pairs(lastRound.actions) do
        local formatted = action.desc.formattable
        local targetsformatted = ""
        local i = 1
        for _, target in pairs(action.targets) do
            targetsformatted = targetsformatted..pingFromName(target)
            if i ~= #action.targets then
                targetsformatted = targetsformatted..", "
            end
            i += 1
        end
        formatted = formatted:gsub("%A", pingFromName(action.actor.Name), 1)
        formatted = formatted:gsub("%T", targetsformatted, 1)
        historyF = historyF..formatted.." (+"..tostring(action.desc.pointReward)..")\n"
    end
    local embedCol = math.random(0, 16777215)
    local payload = {
        embeds={
            {
                title="Раунд Окончен",
                description="Киллеры:\n"+killersF+"\nСюрвы:\n"+survivorsF+"\nПродлился "..tostring(roundLastedFor).." секунд",
                color=embedCol,
                fields={
                    {
                        name="История",
                        value=historyF,
                        inline=false
                    }
                }
            }
        }
    }
    HttpService:PostAsync(reporter, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
    task.wait(1)
    stopTimer()
end

-- returns success
function roundAbandon()
    if roundT or not roundActive then
        return false, 0
    end
    roundT = true
    onRoundEnded()
    roundT = false
    return true
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
    name = "Forsaken Tournament Helper",
    subtitle = "By TH_Vladaimir",
})

local commandsTab = window:CreateTab({ name = "Actions", icon = 93364949241311 })
local roundviewTab = window:CreateTab({ name = "Round Overview", icon = 93364949241311 })

commandsTab:CreateInput({
    name = "Match Combo",
    numeric = false,
    value = "[0, 1, 2, 3, 4]",
    placeholder = "Enter Match Combo",
    callback = function(text)
        desiredMatchCombo = text
    end
})

commandsTab:CreateButton({
    name = "Begin Round",
    callback = function()
        roundStart()
    end
})

commandsTab:CreateButton({
    name = "Abandon Round",
    callback = function()
        roundAbandon()
    end
})