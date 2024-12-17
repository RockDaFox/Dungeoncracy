local _, addon = ...

addon.core = {}
addon.core.canStartVote = false

local init = function ()
    addon.locales = {}
end

init()
print('Loaded reporter')