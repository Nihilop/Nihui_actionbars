-- Nihui ActionBars - Core initialization
local addonName, ns = ...

-- Addon instance
ns.addon = {}
ns.modules = {}

-- Default configuration
local defaults = {
    actionbars = {
        enabled = true,
        keybind = {
            enabled = true,
            font = "Fonts\\FRIZQT__.TTF",
            fontSize = 12,
            fontFlags = "OUTLINE",
            color = {0.8, 0.8, 0.8, 1},
            shadowColor = {0, 0, 0, 1},
            shadowOffsetX = 1,
            shadowOffsetY = -1,
            anchor = "TOPRIGHT",
            offsetX = -2,
            offsetY = -2,
        },
        macroName = {
            enabled = true,
            font = "Fonts\\FRIZQT__.TTF",
            fontSize = 10,
            fontFlags = "OUTLINE",
            color = {0.8, 0.8, 1, 1},
            shadowColor = {0, 0, 0, 1},
            shadowOffsetX = 1,
            shadowOffsetY = -1,
            anchor = "BOTTOM",
            offsetX = 0,
            offsetY = 2,
        },
        count = {
            enabled = true,
            font = "Fonts\\FRIZQT__.TTF",
            fontSize = 14,
            fontFlags = "OUTLINE",
            color = {1, 1, 1, 1},
            shadowColor = {0, 0, 0, 1},
            shadowOffsetX = 1,
            shadowOffsetY = -1,
            anchor = "BOTTOMRIGHT",
            offsetX = -3,
            offsetY = 3,
        },
    },
}

-- Initialize SavedVariables
function ns.addon:InitializeDB()
    if not NihuiActionBarsDB then
        NihuiActionBarsDB = CopyTable(defaults)
    else
        -- Merge any missing defaults
        for category, settings in pairs(defaults) do
            if not NihuiActionBarsDB[category] then
                NihuiActionBarsDB[category] = CopyTable(settings)
            else
                for key, value in pairs(settings) do
                    if NihuiActionBarsDB[category][key] == nil then
                        NihuiActionBarsDB[category][key] = value
                    elseif type(value) == "table" and type(NihuiActionBarsDB[category][key]) == "table" then
                        for subkey, subvalue in pairs(value) do
                            if NihuiActionBarsDB[category][key][subkey] == nil then
                                NihuiActionBarsDB[category][key][subkey] = subvalue
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Settings accessor
function ns.actionBarSettings()
    return NihuiActionBarsDB.actionbars
end

-- Module registration
function ns.addon:RegisterModule(name, module)
    ns.modules[name] = module
    if module.OnEnable then
        C_Timer.After(1, function()
            module:OnEnable()
        end)
    end
end

-- Event frame for addon events
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        ns.addon:InitializeDB()
        print("|cff00ff00Nihui ActionBars|r loaded successfully!")
    elseif event == "PLAYER_LOGIN" then
        -- Initialize modules after login
        for name, module in pairs(ns.modules) do
            if module.OnEnable then
                module:OnEnable()
            end
        end
    end
end)


-- Slash command
SLASH_NIHUIAB1 = "/nihuiab"
SLASH_NIHUIAB2 = "/nab"
SlashCmdList["NIHUIAB"] = function(msg)
    if msg == "config" or msg == "" then
        if ns.GUI and ns.GUI.Toggle then
            ns.GUI:Toggle()
        else
            print("|cff00ff00Nihui ActionBars:|r GUI not loaded yet")
        end
    elseif msg == "reset" then
        NihuiActionBarsDB = CopyTable(defaults)
        ReloadUI()
    else
        print("|cff00ff00Nihui ActionBars Commands:|r")
        print("/nihuiab config - Open configuration")
        print("/nihuiab reset - Reset to defaults (requires reload)")
    end
end