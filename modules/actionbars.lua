-- Nihui ActionBars - Main actionbar module
local addonName, ns = ...

local ActionBars = {}
ns.modules.actionbars = ActionBars

local isInitialized = false
local cachedButtons = nil

-- Get all Blizzard action buttons
local function GetBlizzardActionButtons()
    if not cachedButtons then
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

        -- Stance bar (Druid forms, Warrior stances, etc.)
        for i = 1, 10 do
            local button = _G["StanceButton" .. i]
            if button then table.insert(buttons, button) end
        end

        cachedButtons = buttons
    end

    return cachedButtons
end

-- Apply text styling to a button
local function ApplyTextStyling(button)
    if not button then return end

    local settings = ns.actionBarSettings()
    if not settings or not settings.enabled then return end

    -- KEYBIND TEXT STYLING
    if button.HotKey and settings.keybind and settings.keybind.enabled then
        local config = settings.keybind
        local font = config.font or "Fonts\\FRIZQT__.TTF"
        local fontSize = config.fontSize or 12
        local fontFlags = config.fontFlags or ""

        button.HotKey:SetFont(font, fontSize, fontFlags)
        button.HotKey:SetJustifyH("CENTER")
        button.HotKey:SetJustifyV("TOP")

        -- Color
        if config.color then
            button.HotKey:SetTextColor(config.color[1], config.color[2], config.color[3], config.color[4])
        end

        -- Shadow
        if config.shadowColor then
            button.HotKey:SetShadowColor(config.shadowColor[1], config.shadowColor[2],
                                         config.shadowColor[3], config.shadowColor[4])
        end

        local shadowOffsetX = config.shadowOffsetX or 1
        local shadowOffsetY = config.shadowOffsetY or -1
        button.HotKey:SetShadowOffset(shadowOffsetX, shadowOffsetY)

        -- Position
        if config.anchor and config.offsetX and config.offsetY then
            button.HotKey:ClearAllPoints()
            button.HotKey:SetPoint(config.anchor, button, config.anchor, config.offsetX, config.offsetY)
        end
    end

    -- MACRO NAME TEXT STYLING
    if button.Name and settings.macroName and settings.macroName.enabled then
        local config = settings.macroName
        local font = config.font or "Fonts\\FRIZQT__.TTF"
        local fontSize = config.fontSize or 10
        local fontFlags = config.fontFlags or ""

        button.Name:SetFont(font, fontSize, fontFlags)

        -- Color
        if config.color then
            button.Name:SetTextColor(config.color[1], config.color[2], config.color[3], config.color[4])
        end

        -- Shadow
        if config.shadowColor then
            button.Name:SetShadowColor(config.shadowColor[1], config.shadowColor[2],
                                       config.shadowColor[3], config.shadowColor[4])
        end

        local shadowOffsetX = config.shadowOffsetX or 1
        local shadowOffsetY = config.shadowOffsetY or -1
        button.Name:SetShadowOffset(shadowOffsetX, shadowOffsetY)

        -- Position
        if config.anchor and config.offsetX and config.offsetY then
            button.Name:ClearAllPoints()
            button.Name:SetPoint(config.anchor, button, config.anchor, config.offsetX, config.offsetY)
        end
    end

    -- COUNT TEXT STYLING
    if button.Count and settings.count and settings.count.enabled then
        local config = settings.count
        local font = config.font or "Fonts\\FRIZQT__.TTF"
        local fontSize = config.fontSize or 14
        local fontFlags = config.fontFlags or ""

        button.Count:SetFont(font, fontSize, fontFlags)

        -- Color
        if config.color then
            button.Count:SetTextColor(config.color[1], config.color[2], config.color[3], config.color[4])
        end

        -- Shadow
        if config.shadowColor then
            button.Count:SetShadowColor(config.shadowColor[1], config.shadowColor[2],
                                        config.shadowColor[3], config.shadowColor[4])
        end

        local shadowOffsetX = config.shadowOffsetX or 1
        local shadowOffsetY = config.shadowOffsetY or -1
        button.Count:SetShadowOffset(shadowOffsetX, shadowOffsetY)

        -- Position
        if config.anchor and config.offsetX and config.offsetY then
            button.Count:ClearAllPoints()
            button.Count:SetPoint(config.anchor, button, config.anchor, config.offsetX, config.offsetY)
        end
    end
end

-- Handle keybind color override
local function SetupKeybindColorHooks()
    local settings = ns.actionBarSettings()
    if not settings or not settings.keybind or not settings.keybind.color then return end

    local color = settings.keybind.color

    local function isBlizzardWhite(r)
        return math.abs(r - 0.8) < 0.01
    end

    local function setColor(frameName)
        local frame = _G[frameName]
        if frame and frame.SetVertexColor then
            frame:SetVertexColor(unpack(color))

            if not frame.colorHook then
                hooksecurefunc(frame, "SetVertexColor", function(self, r, g, b, a)
                    if frame.changing then return end
                    frame.changing = true

                    if isBlizzardWhite(r) then
                        local currentColor = ns.actionBarSettings().keybind.color
                        if currentColor then
                            frame:SetVertexColor(unpack(currentColor))
                        end
                    end

                    frame.changing = false
                end)
                frame.colorHook = true
            end
        end
    end

    local prefixes = {
        "ActionButton",
        "MultiBarBottomLeftButton",
        "MultiBarBottomRightButton",
        "MultiBarRightButton",
        "MultiBarLeftButton",
        "MultiBar5Button",
        "MultiBar6Button",
        "MultiBar7Button",
        "PetActionButton",
        "StanceButton"
    }

    for i = 1, 12 do
        for _, prefix in ipairs(prefixes) do
            setColor(prefix .. i .. "HotKey")
        end
    end
end

-- Initialize the system
local function InitializeSystem()
    if isInitialized then return end

    local buttons = GetBlizzardActionButtons()

    -- Apply styling to all buttons
    for _, button in ipairs(buttons) do
        ApplyTextStyling(button)
    end

    -- Setup keybind color hooks
    SetupKeybindColorHooks()

    -- Event handling for updates
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    eventFrame:RegisterEvent("UPDATE_BINDINGS")
    eventFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")  -- Stance bar updates

    eventFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "ACTIONBAR_SLOT_CHANGED" or event == "UPDATE_BINDINGS" or event == "UPDATE_SHAPESHIFT_FORMS" then
            local buttons = GetBlizzardActionButtons()
            for _, button in ipairs(buttons) do
                ApplyTextStyling(button)
            end
        end
    end)

    ActionBars.eventFrame = eventFrame
    isInitialized = true
end

-- Reset button styling to defaults
local function ResetButtonStyling(button)
    if not button then return end

    -- Reset keybind text
    if button.HotKey then
        button.HotKey:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        button.HotKey:SetShadowColor(0, 0, 0, 1)
        button.HotKey:SetShadowOffset(1, -1)
        button.HotKey:ClearAllPoints()
        button.HotKey:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
    end

    -- Reset macro name text
    if button.Name then
        button.Name:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
        button.Name:SetTextColor(1, 1, 1, 1)
        button.Name:SetShadowColor(0, 0, 0, 1)
        button.Name:SetShadowOffset(1, -1)
        button.Name:ClearAllPoints()
        button.Name:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)
    end

    -- Reset count text
    if button.Count then
        button.Count:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
        button.Count:SetTextColor(1, 1, 1, 1)
        button.Count:SetShadowColor(0, 0, 0, 1)
        button.Count:SetShadowOffset(1, -1)
        button.Count:ClearAllPoints()
        button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)
    end
end

-- Module API
function ActionBars:OnEnable()
    C_Timer.After(1, function()
        InitializeSystem()
    end)
end

function ActionBars:OnDisable()
    if self.eventFrame then
        self.eventFrame:UnregisterAllEvents()
        self.eventFrame:SetScript("OnEvent", nil)
        self.eventFrame = nil
    end

    -- Reset all buttons to defaults
    local buttons = GetBlizzardActionButtons()
    for _, button in ipairs(buttons) do
        ResetButtonStyling(button)
    end

    isInitialized = false
end

function ActionBars:ApplySettings()
    local settings = ns.actionBarSettings()
    if not settings or not settings.enabled then
        self:OnDisable()
        return
    end

    local buttons = GetBlizzardActionButtons()
    for _, button in ipairs(buttons) do
        ApplyTextStyling(button)
    end

    -- Re-setup keybind color hooks
    SetupKeybindColorHooks()
end

function ActionBars:ResetToDefaults()
    local buttons = GetBlizzardActionButtons()
    for _, button in ipairs(buttons) do
        ResetButtonStyling(button)
    end
    print("|cff00ff00Nihui ActionBars:|r Reset action bar styling to defaults")
end

-- Register the module
ns.addon:RegisterModule("actionbars", ActionBars)