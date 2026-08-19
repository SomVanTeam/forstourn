local HttpService = game:GetService("HttpService")
local networker:RemoteEvent = game.ReplicatedStorage.Modules.Network.Network.RemoteEvent
local reporter = "https://discord.com/api/webhooks/1533176667776880764/DW2Y_nEtY_V5aqD7L3J27z2ywIvmU2IWJ_bWJiE0dlV6BRwfw5uiE8QsDFpLBUV0N5gm"

function sendBufTable(buftable:{buffer}):nil
    networker:FireServer(
        "ExecuteCommand",
        buftable
    )
end

function stringBuf(str:string):buffer
    local buf = buffer.fromstring("\x03\x00\x00\x00\x00"..str)
    -- first byte is 03 meaning this is a string
    -- second byte is string length
    -- other zeros are unused
    buffer.writeu8(buf, 1, string.len(str))
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

local targetAll = stringBuf("All")

local timerCurrentlyStopped = true
function toggleTimer()
    timerCurrentlyStopped = not timerCurrentlyStopped
    sendBufTable({
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

function getAliveKillers():{Player}
    
end

function getAliveSurvivors():{Player}

end

function isKiller(plrname:string):boolean

end

function isSurvivor(plrname:string):boolean

end

function getCharacterName(plrname:string):string
    
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
    return #getAliveSurvivors() == 1
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
            sendBufTable({
                stringBuf("GiveStatus"),
                stringBuf(plr.Name),
                stringBuf("Weakness"),
                numberBuf(penaltyLevel),
                numberBuf(67)
            })
        else
            sendBufTable({
                stringBuf("GiveStatus"),
                stringBuf(plr.Name),
                stringBuf("Vulnerable"),
                numberBuf(penaltyLevel),
                numberBuf(67)
            })
        end
    end
end

local desiredKiller = ""
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
    if desiredKiller then
        sendBufTable({
            stringBuf("ForceNextKiller"),
            stringBuf(desiredKiller)
        })
    end
    if desiredMap then
        
    end

    sendBufTable({

    })
    roundActive = true
    task.wait(5)
    sendBufTable({
        stringBuf("GiveStatus"),
        stringBuf(targetAll),
        stringBuf("Helpless"),
        numberBuf(10),
        numberBuf(5)
    })
    sendBufTable({
        stringBuf("GiveStatus"),
        stringBuf(targetAll),
        stringBuf("Slowness"),
        numberBuf(10),
        numberBuf(5)
    })
    sendBufTable({
        stringBuf("GiveStatus"),
        stringBuf(targetAll),
        stringBuf("Resistance"),
        numberBuf(10),
        numberBuf(5)
    })
    task.wait(5)
    roundBeganTime = os.time()
    roundT = false
    return true
end

-- returns success, roundLastedFor
function roundEnd()
    if roundT or not roundActive then
        return false, 0
    end
    roundT = true
    roundActive = false

    roundT = false
    return true, os.time() - roundBeganTime
end