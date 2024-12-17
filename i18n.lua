local _, addon = ...

-- Table pour stocker les traductions
addon.L = {}

-- Détecter la langue du client
local locale = GetLocale()

addon.L = addon.locales["enUS"]

