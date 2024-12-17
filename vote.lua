local _, addon = ...

addon.vote = {}

local voteResponses = {}
local totalPlayers = 0
local voteInProgress = false
local voteTimer = 20
local YES = "Y"
local NO = "N"
local voteResult = nil

local function getChannel()
    local inInstance, instanceType = IsInInstance()
    if instanceType == "party" then
        if C_ChallengeMode.GetActiveChallengeMapID() then
            return "PARTY"
        else
            return "INSTANCE_CHAT"
        end
    end
end

local function sendResult(yesVotes, noVotes)
    SendChatMessage(addon.L.VOTE_RESULTS:format(yesVotes, noVotes), getChannel())

    if yesVotes == noVotes then
        SendChatMessage(addon.L.VOTE_RESULT_EQUAL, getChannel())
        return
    end

    if (voteResult == YES) then
        SendChatMessage(addon.L.VOTE_RESULT_YES, getChannel())
    else
        SendChatMessage(addon.L.VOTE_RESULT_NO, getChannel())
    end
end

local function IsVoteInProgress()
    return voteInProgress
end

local function getResult()
    return voteResult
end

local function EndVote()
    if not voteInProgress then return end

    local yesVotes, noVotes = 0, 0
    for _, response in pairs(voteResponses) do
        if response == YES then
            yesVotes = yesVotes + 1
        elseif response == NO then
            noVotes = noVotes + 1
        end
    end

    if (yesVotes > noVotes) then
        voteResult = YES
    else
        voteResult = NO
    end

    voteInProgress = false
    
    if (addon.utils.getTableLength(voteResponses) == 1) then
        SendChatMessage(addon.L.NOT_ENOUGH_VOTE, getChannel())
        voteResult = NO
        return
    end

    sendResult(yesVotes, noVotes)
end

local function StartVote()
    if not IsInInstance() then
        print(addon.L.MUST_BE_IN_KEY)
        return
    end

    if addon.core.canStartVote == false then
        print(addon.L.CAN_NOT_SURREND)
        return
    end

    if voteInProgress then
        print(addon.L.ERROR_VOTE_IN_PROGRESS)
        return
    end

    voteResult = nil
    voteInProgress = true
    voteResponses = {}
    voteResponses[addon.utils.getCurrentPlayer()] = YES
    totalPlayers = GetNumGroupMembers()

    C_PartyInfo.DoCountdown(voteTimer)

    SendChatMessage(addon.L.START_VOTE, getChannel())
    SendChatMessage(addon.L.START_VOTE_INSTRUCTIONS:format(YES, NO), getChannel())

    C_Timer.After(voteTimer, function()
        if voteInProgress then
            EndVote()
        end
    end)
end

local function HandleVoteResponse(self, event, message, sender, _, _, _, _, _, _, channel)
    if not voteInProgress then return end
    if sender == addon.utils.getCurrentPlayer() then
        return
    end

    if voteResponses[sender] then return end

    if (message:lower() == YES:lower() or message:lower() == "yes") then
        voteResponses[sender] = YES
    elseif (message:lower() == NO:lower() or message:lower() == "no") then
        voteResponses[sender] = NO
    end

    if addon.utils.getTableLength(voteResponses) == totalPlayers then
        C_PartyInfo.DoCountdown(0)
        EndVote()
    end
end

addon.vote.HandleVoteResponse = HandleVoteResponse
addon.vote.startVote = StartVote
addon.vote.IsVoteInProgress = IsVoteInProgress
addon.vote.getResult = getResult
addon.vote.NO = NO
addon.vote.YES = YES