-- Nihui ActionBars - GUI with AceConfig
local addonName, ns = ...

-- Check if AceConfig is available
local AceConfig = LibStub("AceConfig-3.0", true)
local AceConfigDialog = LibStub("AceConfigDialog-3.0", true)

if not AceConfig or not AceConfigDialog then
    print("|cff00ff00Nihui ActionBars:|r AceConfig not available, using simple GUI")
    return
end

local GUI = {}
ns.GUI = GUI

-- Create the configuration table
local function CreateConfigTable()
    return {
        type = "group",
        name = "|cff00ff00Nihui|r ActionBars",
        args = {
            enabled = {
                order = 1,
                type = "toggle",
                name = "Enable ActionBars",
                desc = "Enable or disable all action bar customizations",
                width = "full",
                get = function()
                    return ns.actionBarSettings().enabled
                end,
                set = function(_, val)
                    ns.actionBarSettings().enabled = val
                    if ns.modules.actionbars then
                        if val then
                            ns.modules.actionbars:OnEnable()
                        else
                            ns.modules.actionbars:OnDisable()
                        end
                    end
                    if ns.modules.actionbars and ns.modules.actionbars.ApplySettings then
                        ns.modules.actionbars:ApplySettings()
                    end
                end,
            },

            resetButton = {
                order = 2,
                type = "execute",
                name = "Reset to Defaults",
                desc = "Reset all settings to default values",
                func = function()
                    if ns.Config then
                        ns.Config:ResetToDefaults()
                    end
                end,
                width = 1.5,
                confirm = true,
                confirmText = "Are you sure you want to reset all settings to defaults?",
            },


            -- Keybind Text Group
            keybindGroup = {
                order = 20,
                type = "group",
                name = "Keybind Text",
                inline = true,
                args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = "Enable Keybind Styling",
                        desc = "Enable custom keybind text styling",
                        get = function()
                            return ns.actionBarSettings().keybind.enabled
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().keybind.enabled = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = "full",
                    },

                    fontSize = {
                        order = 2,
                        type = "range",
                        name = "Font Size",
                        desc = "Size of keybind text",
                        min = 8,
                        max = 24,
                        step = 1,
                        get = function()
                            return ns.actionBarSettings().keybind.fontSize
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().keybind.fontSize = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.5,
                        disabled = function()
                            return not ns.actionBarSettings().keybind.enabled
                        end,
                    },

                    fontFlags = {
                        order = 3,
                        type = "select",
                        name = "Font Style",
                        desc = "Font outline style",
                        values = {
                            [""] = "None",
                            ["OUTLINE"] = "Outline",
                            ["THICKOUTLINE"] = "Thick Outline",
                            ["MONOCHROME"] = "Monochrome",
                        },
                        get = function()
                            return ns.actionBarSettings().keybind.fontFlags
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().keybind.fontFlags = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.5,
                        disabled = function()
                            return not ns.actionBarSettings().keybind.enabled
                        end,
                    },

                    color = {
                        order = 4,
                        type = "color",
                        name = "Text Color",
                        desc = "Color of keybind text",
                        hasAlpha = true,
                        get = function()
                            local color = ns.actionBarSettings().keybind.color or {0.8, 0.8, 0.8, 1}
                            return color[1], color[2], color[3], color[4]
                        end,
                        set = function(_, r, g, b, a)
                            ns.actionBarSettings().keybind.color = {r, g, b, a}
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.0,
                        disabled = function()
                            return not ns.actionBarSettings().keybind.enabled
                        end,
                    },

                    offsetX = {
                        order = 5,
                        type = "range",
                        name = "Position X",
                        desc = "Horizontal position offset for keybind text",
                        min = -20,
                        max = 20,
                        step = 1,
                        get = function()
                            return ns.actionBarSettings().keybind.offsetX or -2
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().keybind.offsetX = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.5,
                        disabled = function()
                            return not ns.actionBarSettings().keybind.enabled
                        end,
                    },

                    offsetY = {
                        order = 6,
                        type = "range",
                        name = "Position Y",
                        desc = "Vertical position offset for keybind text",
                        min = -20,
                        max = 20,
                        step = 1,
                        get = function()
                            return ns.actionBarSettings().keybind.offsetY or -2
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().keybind.offsetY = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.5,
                        disabled = function()
                            return not ns.actionBarSettings().keybind.enabled
                        end,
                    },
                },
            },

            -- Macro Name Group
            macroNameGroup = {
                order = 30,
                type = "group",
                name = "Macro/Spell Names",
                inline = true,
                args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = "Enable Macro Name Styling",
                        desc = "Enable custom macro/spell name styling",
                        get = function()
                            return ns.actionBarSettings().macroName.enabled
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().macroName.enabled = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = "full",
                    },

                    fontSize = {
                        order = 2,
                        type = "range",
                        name = "Font Size",
                        desc = "Size of macro/spell name text",
                        min = 6,
                        max = 16,
                        step = 1,
                        get = function()
                            return ns.actionBarSettings().macroName.fontSize
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().macroName.fontSize = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.5,
                        disabled = function()
                            return not ns.actionBarSettings().macroName.enabled
                        end,
                    },

                    color = {
                        order = 3,
                        type = "color",
                        name = "Text Color",
                        desc = "Color of macro/spell name text",
                        hasAlpha = true,
                        get = function()
                            local color = ns.actionBarSettings().macroName.color
                            return color[1], color[2], color[3], color[4]
                        end,
                        set = function(_, r, g, b, a)
                            ns.actionBarSettings().macroName.color = {r, g, b, a}
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.0,
                        disabled = function()
                            return not ns.actionBarSettings().macroName.enabled
                        end,
                    },
                },
            },

            -- Count Text Group
            countGroup = {
                order = 40,
                type = "group",
                name = "Item Count Text",
                inline = true,
                args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = "Enable Count Styling",
                        desc = "Enable custom item count text styling",
                        get = function()
                            return ns.actionBarSettings().count.enabled
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().count.enabled = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = "full",
                    },

                    fontSize = {
                        order = 2,
                        type = "range",
                        name = "Font Size",
                        desc = "Size of item count text",
                        min = 8,
                        max = 20,
                        step = 1,
                        get = function()
                            return ns.actionBarSettings().count.fontSize
                        end,
                        set = function(_, val)
                            ns.actionBarSettings().count.fontSize = val
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.5,
                        disabled = function()
                            return not ns.actionBarSettings().count.enabled
                        end,
                    },

                    color = {
                        order = 3,
                        type = "color",
                        name = "Text Color",
                        desc = "Color of item count text",
                        hasAlpha = true,
                        get = function()
                            local color = ns.actionBarSettings().count.color
                            return color[1], color[2], color[3], color[4]
                        end,
                        set = function(_, r, g, b, a)
                            ns.actionBarSettings().count.color = {r, g, b, a}
                            ns.Config:UpdateActionBars()
                        end,
                        width = 1.0,
                        disabled = function()
                            return not ns.actionBarSettings().count.enabled
                        end,
                    },
                },
            },

        },
    }
end

-- Initialize the GUI
function GUI:Initialize()
    -- Register the config table
    AceConfig:RegisterOptionsTable("NihuiActionBars", CreateConfigTable)

    -- Create the dialog
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("NihuiActionBars", "|cff00ff00Nihui|r ActionBars")

    print("|cff00ff00Nihui ActionBars:|r GUI initialized. Use '/nihuiab config' or check Interface > AddOns")
end

-- Toggle the configuration window
function GUI:Toggle()
    if self.optionsFrame then
        -- Use new Settings API for modern WoW versions
        if Settings and Settings.OpenToCategory then
            Settings.OpenToCategory(self.optionsFrame.name)
        elseif SettingsPanel then
            -- Fallback for SettingsPanel
            if SettingsPanel:IsShown() then
                SettingsPanel:Hide()
            else
                SettingsPanel:Open()
            end
        elseif InterfaceOptionsFrame_OpenToCategory then
            -- Legacy support for older versions
            InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
            InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        else
            -- Final fallback - use AceConfigDialog directly
            AceConfigDialog:Open("NihuiActionBars")
        end
    else
        print("|cff00ff00Nihui ActionBars:|r Configuration not available")
    end
end

-- Initialize when addon loads
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon == addonName then
        C_Timer.After(0.5, function()
            GUI:Initialize()
        end)
        frame:UnregisterEvent("ADDON_LOADED")
    end
end)