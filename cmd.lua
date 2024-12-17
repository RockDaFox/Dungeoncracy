local _, addon = ...

SLASH_STARTVOTE1 = "/surrend"
SlashCmdList["STARTVOTE"] = function(msg)
    addon.vote.startVote()
end