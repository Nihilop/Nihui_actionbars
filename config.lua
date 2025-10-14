-- Nihui ActionBars - Configuration utilities
local addonName, ns = ...

-- Configuration helper functions
ns.Config = {}

function ns.Config:GetActionBarSettings()
    return ns.actionBarSettings()
end

function ns.Config:UpdateActionBars()
    if ns.modules.actionbars and ns.modules.actionbars.ApplySettings then
        ns.modules.actionbars:ApplySettings()
    end
end



function ns.Config:ResetToDefaults()
    local defaults = {
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
    }

    local settings = ns.actionBarSettings()
    for key, value in pairs(defaults) do
        if type(value) == "table" and type(settings[key]) == "table" then
            for subkey, subvalue in pairs(value) do
                settings[key][subkey] = subvalue
            end
        else
            settings[key] = value
        end
    end

    self:UpdateActionBars()

    print("|cff00ff00Nihui ActionBars:|r Settings reset to defaults!")
end