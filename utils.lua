local _, addon = ...

addon.utils = {}

local function getCurrentPlayer()
    return GetUnitName('player') .. "-" .. GetNormalizedRealmName()
end

local function getTableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end
  
addon.utils.getCurrentPlayer = getCurrentPlayer
addon.utils.getTableLength = getTableLength