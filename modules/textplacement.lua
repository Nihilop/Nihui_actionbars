-- Nihui ActionBars - Text Placement module
local addonName, ns = ...

local TextPlacement = {}
ns.modules.textplacement = TextPlacement

-- Available anchor points
TextPlacement.ANCHOR_POINTS = {
    ["TOPLEFT"] = "Top Left",
    ["TOP"] = "Top Center",
    ["TOPRIGHT"] = "Top Right",
    ["LEFT"] = "Left",
    ["CENTER"] = "Center",
    ["RIGHT"] = "Right",
    ["BOTTOMLEFT"] = "Bottom Left",
    ["BOTTOM"] = "Bottom Center",
    ["BOTTOMRIGHT"] = "Bottom Right",
}

-- Available font flags
TextPlacement.FONT_FLAGS = {
    [""] = "None",
    ["OUTLINE"] = "Outline",
    ["THICKOUTLINE"] = "Thick Outline",
    ["MONOCHROME"] = "Monochrome",
}

-- Text element update function
function TextPlacement:UpdateTextElement(button, elementType)
    if not button then return end

    local settings = ns.actionBarSettings()
    if not settings or not settings.enabled then return end

    local config = settings[elementType]
    if not config or not config.enabled then return end

    local textObject = nil
    if elementType == "keybind" then
        textObject = button.HotKey
    elseif elementType == "macroName" then
        textObject = button.Name
    elseif elementType == "count" then
        textObject = button.Count
    end

    if not textObject then return end

    -- Font settings
    local font = config.font or "Fonts\\FRIZQT__.TTF"
    local fontSize = config.fontSize or 12
    local fontFlags = config.fontFlags or ""

    textObject:SetFont(font, fontSize, fontFlags)

    -- Color settings
    if config.color then
        textObject:SetTextColor(config.color[1], config.color[2], config.color[3], config.color[4])
    end

    -- Shadow settings
    if config.shadowColor then
        textObject:SetShadowColor(config.shadowColor[1], config.shadowColor[2],
                                  config.shadowColor[3], config.shadowColor[4])
    end

    local shadowOffsetX = config.shadowOffsetX or 1
    local shadowOffsetY = config.shadowOffsetY or -1
    textObject:SetShadowOffset(shadowOffsetX, shadowOffsetY)

    -- Position settings
    if config.anchor and config.offsetX and config.offsetY then
        textObject:ClearAllPoints()
        textObject:SetPoint(config.anchor, button, config.anchor, config.offsetX, config.offsetY)
    end

    -- Special handling for keybind justification
    if elementType == "keybind" then
        textObject:SetJustifyH("CENTER")
        textObject:SetJustifyV("TOP")
    end
end

-- Update all text elements on a button
function TextPlacement:UpdateButtonTexts(button)
    if not button then return end

    self:UpdateTextElement(button, "keybind")
    self:UpdateTextElement(button, "macroName")
    self:UpdateTextElement(button, "count")
end

-- Update all buttons
function TextPlacement:UpdateAllButtons()
    -- Get all action buttons (using the same function as actionbars module)
    local buttons = {}

    -- Main action bar
    for i = 1, 12 do
        local button = _G["ActionButton" .. i]
        if button then table.insert(buttons, button) end
    end

    -- Additional bars
    local barNames = {
        "MultiBarBottomLeftButton",
        "MultiBarBottomRightButton",
        "MultiBarRightButton",
        "MultiBarLeftButton",
        "MultiBar5Button",
        "MultiBar6Button",
        "MultiBar7Button"
    }

    for _, barName in ipairs(barNames) do
        for i = 1, 12 do
            local button = _G[barName .. i]
            if button then table.insert(buttons, button) end
        end
    end

    -- Update all buttons
    for _, button in ipairs(buttons) do
        self:UpdateButtonTexts(button)
    end
end

-- Reset text element to defaults
function TextPlacement:ResetTextElement(button, elementType)
    if not button then return end

    local textObject = nil
    local defaults = {}

    if elementType == "keybind" then
        textObject = button.HotKey
        defaults = {
            font = "Fonts\\FRIZQT__.TTF",
            fontSize = 12,
            fontFlags = "OUTLINE",
            color = {1, 1, 1, 1},
            shadowColor = {0, 0, 0, 1},
            shadowOffset = {1, -1},
            anchor = "TOPRIGHT",
            offset = {-2, -2}
        }
    elseif elementType == "macroName" then
        textObject = button.Name
        defaults = {
            font = "Fonts\\FRIZQT__.TTF",
            fontSize = 10,
            fontFlags = "",
            color = {1, 1, 1, 1},
            shadowColor = {0, 0, 0, 1},
            shadowOffset = {1, -1},
            anchor = "BOTTOM",
            offset = {0, 2}
        }
    elseif elementType == "count" then
        textObject = button.Count
        defaults = {
            font = "Fonts\\FRIZQT__.TTF",
            fontSize = 14,
            fontFlags = "OUTLINE",
            color = {1, 1, 1, 1},
            shadowColor = {0, 0, 0, 1},
            shadowOffset = {1, -1},
            anchor = "BOTTOMRIGHT",
            offset = {-3, 3}
        }
    end

    if not textObject then return end

    -- Apply defaults
    textObject:SetFont(defaults.font, defaults.fontSize, defaults.fontFlags)
    textObject:SetTextColor(defaults.color[1], defaults.color[2], defaults.color[3], defaults.color[4])
    textObject:SetShadowColor(defaults.shadowColor[1], defaults.shadowColor[2],
                              defaults.shadowColor[3], defaults.shadowColor[4])
    textObject:SetShadowOffset(defaults.shadowOffset[1], defaults.shadowOffset[2])
    textObject:ClearAllPoints()
    textObject:SetPoint(defaults.anchor, button, defaults.anchor, defaults.offset[1], defaults.offset[2])
end

-- Reset all text elements on a button
function TextPlacement:ResetButtonTexts(button)
    if not button then return end

    self:ResetTextElement(button, "keybind")
    self:ResetTextElement(button, "macroName")
    self:ResetTextElement(button, "count")
end

-- Module API
function TextPlacement:OnEnable()
    -- This module doesn't need separate initialization
    -- It's used by the actionbars module
end

function TextPlacement:OnDisable()
    -- Reset all texts to defaults
    self:UpdateAllButtons()
end

function TextPlacement:ApplySettings()
    self:UpdateAllButtons()
end

-- Utility functions for configuration
function TextPlacement:GetDefaultSettings(elementType)
    local defaults = {
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

    return defaults[elementType]
end

-- Register the module
ns.addon:RegisterModule("textplacement", TextPlacement)