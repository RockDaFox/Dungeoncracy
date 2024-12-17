local _, addon = ...

local frame = CreateFrame("Frame")

local waitTime = 10 -- 5 min 

local CHALLENGE_MODE_COMPLETED = "CHALLENGE_MODE_COMPLETED"
local CHALLENGE_MODE_START = "CHALLENGE_MODE_START"

frame:RegisterEvent(CHALLENGE_MODE_COMPLETED)
frame:RegisterEvent(CHALLENGE_MODE_START)

local chatEvents = {
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_SAY"
}

for index, value in ipairs(chatEvents) do
    frame:RegisterEvent(value)
end

local function OnDungeonCompleted()
    addon.core.canStartVote = false
end

local function OnDungeonStart()
    C_Timer.After(waitTime, function()
        if (IsInInstance() and C_ChallengeMode.GetActiveChallengeMapID()) then
            addon.core.canStartVote = true
        end
    end)
end
addon.core.canStartVote = true
frame:SetScript("OnEvent", function(self, event, ...)
    if event == CHALLENGE_MODE_COMPLETED then
        OnDungeonCompleted()
    end
    if event == CHALLENGE_MODE_START then
        OnDungeonStart()
    end
    for _, evt in pairs(chatEvents) do
        if evt == event then
            if (addon.core.canStartVote == true) then
                frame:SetScript("OnEvent", addon.vote.HandleVoteResponse)
            end
            break
        end
     end
end)



