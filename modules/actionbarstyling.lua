-- Nihui ActionBars - Action Bar Styling module (based on rnxmUI)
local addonName, ns = ...

-- ===========================
-- TEXTURE CONFIGURATION
-- ===========================
-- Configure all visual state textures here
local TEXTURES = {
    HIGHLIGHT = "UI-CooldownManager-OORshadow-2x",           -- Hover/mouseover glow
    CHECKED = "UI-HUD-CoolDownManager-IconOverlay",          -- Active/toggled state
    NORMAL = "UI-HUD-CoolDownManager-IconOverlay",           -- Border overlay
    PUSHED = "UI-CooldownManager-ActiveGlow-2x",             -- Pressed/click state
    ICON_MASK_ATLAS = "UI-HUD-CoolDownManager-Mask",        -- IconMask atlas name
    ICON_MASK_PATH = "interface\\hud\\uicooldownmanagermask", -- Icon masking texture path
}

local function StyleActionButton(button)
    if not button then return end

    -- Disable Blizzard's texture override function first
    if button.UpdateButtonArt then
        button.UpdateButtonArt = function() end
    end

    -- ===========================
    -- PROPORTIONAL SIZING SYSTEM
    -- ===========================
    -- Get base icon size for all calculations
    local iconWidth, iconHeight = 36, 36  -- Default fallback for standard action buttons
    if button.icon then
        local w, h = button.icon:GetSize()
        if w > 0 and h > 0 then
            iconWidth, iconHeight = w, h
        end
    end

    -- Define scaling ratios (relative to icon size)
    -- Most overlays are 1.0x (same size as icon) with different z-index/blend modes
    -- Only large animations are bigger for visual impact
    local RATIOS = {
        HIGHLIGHT = 0.98,         -- Hover glow - same size as icon
        CHECKED = 1.0,           -- Active state - same size as icon
        ICON_MASK = 1.0,         -- Circular mask - same size as icon
        INTERRUPT_MAIN = 0.98,    -- Interrupt container - slightly larger
        INTERRUPT_BASE = 0.98,    -- Interrupt texture - same size as icon
        INTERRUPT_MASK = 0.98,    -- Interrupt mask - same size as icon
        CAST_ANIM = 1.3,         -- Spell cast animation - larger for visibility
        COOLDOWN_FLASH = 1.3,    -- Cooldown flash - larger for visibility
        RETICLE_MAIN = 1.3,      -- Placement reticle - larger for visibility
        RETICLE_MASK = 1.0,      -- Reticle mask - same size as icon
        PUSHED = 1.38,            -- Pressed state - slightly larger
        NORMAL = 1.38             -- Border overlay - same size as icon
    }

    if button.SpellCastAnimFrame then
        -- Style the Fill frame's FillMask texture (controls the masking)
        if button.SpellCastAnimFrame.Fill and button.SpellCastAnimFrame.Fill.FillMask then
            if button.SpellCastAnimFrame.Fill.FillMask.SetAtlas then
                button.SpellCastAnimFrame.Fill.FillMask:SetAtlas("CovenantSanctum-Renown-Scroll-Mask") -- Temporary - should be easy to spot
            end
        end

        -- Style the CastFill texture (main animation fill)
        if button.SpellCastAnimFrame.Fill and button.SpellCastAnimFrame.Fill.CastFill then
            if button.SpellCastAnimFrame.Fill.CastFill.SetAtlas then
                button.SpellCastAnimFrame.Fill.CastFill:SetAtlas("CovenantSanctum-Renown-Scroll-Mask") -- Temporary - bright/flashy
                button.SpellCastAnimFrame.Fill.CastFill:SetVertexColor(1, 1, 1, 1)
            end
        end

        -- Style the InnerGlowTexture (inner glow effect)
        if button.SpellCastAnimFrame.Fill and button.SpellCastAnimFrame.Fill.InnerGlowTexture then
            if button.SpellCastAnimFrame.Fill.InnerGlowTexture.SetAtlas then
                button.SpellCastAnimFrame.Fill.InnerGlowTexture:SetAtlas("UI-HUD-ActionBar-IconFrame-Flash") -- Temporary - should show as border-like
            end
        end

        -- Style the EndBurst GlowRing (completion burst effect)
        if button.SpellCastAnimFrame.EndBurst and button.SpellCastAnimFrame.EndBurst.GlowRing then
            if button.SpellCastAnimFrame.EndBurst.GlowRing.SetVertexColor then
                button.SpellCastAnimFrame.EndBurst.GlowRing:SetVertexColor(1, 1, 1, 1)
            end
        end

        -- Style the EndBurst EndMask (completion mask)
        if button.SpellCastAnimFrame.EndBurst and button.SpellCastAnimFrame.EndBurst.EndMask then
            if button.SpellCastAnimFrame.EndBurst.EndMask.SetAtlas then
                button.SpellCastAnimFrame.EndBurst.EndMask:SetVertexColor(1, 1, 1, 1)
            end
        end

        -- Position and size the main SpellCastAnimFrame
        button.SpellCastAnimFrame:ClearAllPoints()
        local castSize = iconWidth * RATIOS.CAST_ANIM
        button.SpellCastAnimFrame:SetSize(castSize, castSize)
        button.SpellCastAnimFrame:SetPoint("CENTER", button, "CENTER", 0, 0)
    end

    -- Handle InterruptDisplay frame
    if button.InterruptDisplay then
        -- Style the Highlight frame's HighlightTexture (interrupt highlight effect)
        if button.InterruptDisplay.Highlight and button.InterruptDisplay.Highlight.HighlightTexture then
            if button.InterruptDisplay.Highlight.HighlightTexture.SetAtlas then
                button.InterruptDisplay.Highlight.HighlightTexture:SetAtlas("") -- Temporary - very bright red flash
            end
        end

        -- Style the Highlight frame's Mask (interrupt highlight mask)
        if button.InterruptDisplay.Highlight and button.InterruptDisplay.Highlight.Mask then
            if button.InterruptDisplay.Highlight.Mask.SetAtlas then
                button.InterruptDisplay.Highlight.Mask:SetAtlas("UI-HUD-CoolDownManager-Mask")
                local interruptMaskSize = iconWidth * RATIOS.INTERRUPT_MASK
                button.InterruptDisplay.Highlight.Mask:SetSize(interruptMaskSize, interruptMaskSize)
            end
        end

        -- Style the Base frame's Base texture (main interrupt visual with flipbook)
        if button.InterruptDisplay.Base and button.InterruptDisplay.Base.Base then
            if button.InterruptDisplay.Base.Base.SetTexture then
                button.InterruptDisplay.Base.Base:SetTexture("Interface\\addons\\Nihui_ab\\textures\\UI_CRB_Anim_Ability_Interrupt")
                button.InterruptDisplay.Base.Base:SetVertexColor(1, 1, 1, 1)

                local interruptBaseSize = iconWidth * RATIOS.INTERRUPT_BASE
                button.InterruptDisplay.Base.Base:SetSize(interruptBaseSize, interruptBaseSize)
                button.InterruptDisplay.Base.Base:ClearAllPoints()
                button.InterruptDisplay.Base.Base:SetPoint("CENTER", button.InterruptDisplay.Base, "CENTER")

                -- Create animation group if it doesn't exist
                if not button.InterruptDisplay.Base.flipbookAnim then
                    button.InterruptDisplay.Base.flipbookAnim = button.InterruptDisplay.Base:CreateAnimationGroup()
                    button.InterruptDisplay.Base.flipbookAnim:SetLooping("NONE") -- Play once only

                    local flipbook = button.InterruptDisplay.Base.flipbookAnim:CreateAnimation("FlipBook")
                    flipbook:SetChildKey("Base") -- Target the Base texture
                    flipbook:SetDuration(0.65) -- 1 second total duration
                    flipbook:SetFlipBookRows(22) -- Use 25 if that's your actual frame count
                    flipbook:SetFlipBookColumns(1)
                    flipbook:SetFlipBookFrames(22)
                    flipbook:SetFlipBookFrameWidth(0) -- 0 means use texture width
                    flipbook:SetFlipBookFrameHeight(0) -- 0 means use texture height
                end

                -- Hook into the interrupt display show/hide
                if not button.InterruptDisplay.Base.hookedShow then
                    button.InterruptDisplay.Base:HookScript("OnShow", function()
                        button.InterruptDisplay.Base.flipbookAnim:Play()
                    end)
                    button.InterruptDisplay.Base.hookedShow = true
                end
            end
        end

        -- Position and size the InterruptDisplay
        button.InterruptDisplay:ClearAllPoints()
        local interruptSize = iconWidth * RATIOS.INTERRUPT_MAIN
        button.InterruptDisplay:SetSize(interruptSize, interruptSize)
        button.InterruptDisplay:SetPoint("CENTER", button, "CENTER", 0, 0)
    end

    -- Handle TargetReticleAnimFrame (spell placement indicator)
    if button.TargetReticleAnimFrame then
        -- Style the Base texture (subtle ring indicator)
        if button.TargetReticleAnimFrame.Base then
            if button.TargetReticleAnimFrame.Base.SetAtlas then
                button.TargetReticleAnimFrame.Base:SetAtlas("UI-HUD-ActionBar-Proc-End-Flipbook")
                button.TargetReticleAnimFrame.Base:SetVertexColor(0.3, 0.8, 1, 0.8) -- Blue tint for placement
            end
        end

        -- Style the Highlight texture (pulsing glow effect)
        if button.TargetReticleAnimFrame.Highlight then
            if button.TargetReticleAnimFrame.Highlight.SetAtlas then
                button.TargetReticleAnimFrame.Highlight:SetAtlas("UI-HUD-ActionBar-Proc-Glow-Flipbook")
                button.TargetReticleAnimFrame.Highlight:SetVertexColor(0.4, 0.9, 1, 1) -- Bright cyan glow
                button.TargetReticleAnimFrame.Highlight:SetBlendMode("ADD") -- Additive blend for bright effect
            end

            -- Create pulsing animation if it doesn't exist
            if not button.TargetReticleAnimFrame.Highlight.pulseAnim then
                local ag = button.TargetReticleAnimFrame.Highlight:CreateAnimationGroup()
                ag:SetLooping("BOUNCE")

                local alpha = ag:CreateAnimation("Alpha")
                alpha:SetFromAlpha(0.6)
                alpha:SetToAlpha(1.0)
                alpha:SetDuration(0.8)
                alpha:SetSmoothing("IN_OUT")

                button.TargetReticleAnimFrame.Highlight.pulseAnim = ag

                -- Start animation when frame is shown (only hook once)
                if not button.TargetReticleAnimFrame.hookedPulse then
                    button.TargetReticleAnimFrame:HookScript("OnShow", function()
                        if button.TargetReticleAnimFrame.Highlight.pulseAnim then
                            button.TargetReticleAnimFrame.Highlight.pulseAnim:Play()
                        end
                    end)

                    button.TargetReticleAnimFrame:HookScript("OnHide", function()
                        if button.TargetReticleAnimFrame.Highlight.pulseAnim then
                            button.TargetReticleAnimFrame.Highlight.pulseAnim:Stop()
                        end
                    end)
                    button.TargetReticleAnimFrame.hookedPulse = true
                end
            end
        end

        -- Style the Mask (clean circular mask)
        if button.TargetReticleAnimFrame.Mask then
            if button.TargetReticleAnimFrame.Mask.SetAtlas then
                button.TargetReticleAnimFrame.Mask:SetAtlas("UI-HUD-CoolDownManager-Mask")
                local reticleMaskSize = iconWidth * RATIOS.RETICLE_MASK
                button.TargetReticleAnimFrame.Mask:SetSize(reticleMaskSize, reticleMaskSize)
            end
        end

        -- Position and size the TargetReticleAnimFrame
        button.TargetReticleAnimFrame:ClearAllPoints()
        local reticleSize = iconWidth * RATIOS.RETICLE_MAIN
        button.TargetReticleAnimFrame:SetSize(reticleSize, reticleSize)
        button.TargetReticleAnimFrame:SetPoint("CENTER", button, "CENTER", 0, 0)
    end

    -- Handle CooldownFlash frame
    if button.CooldownFlash then
        -- Style the Flipbook texture (cooldown flash animation)
        if button.CooldownFlash.Flipbook then
            if button.CooldownFlash.Flipbook.SetAtlas then
                button.CooldownFlash.Flipbook:SetAtlas("timerunning-redbutton-glow-mask") -- Original atlas
                -- or use your custom atlas:
                -- button.CooldownFlash.Flipbook:SetAtlas("UI-HUD-CoolDownManager-IconOverlay")
            end
        end

        -- Position and size the CooldownFlash
        button.CooldownFlash:ClearAllPoints()
        local flashSize = iconWidth * RATIOS.COOLDOWN_FLASH
        button.CooldownFlash:SetSize(flashSize, flashSize)
        button.CooldownFlash:SetPoint("CENTER", button, "CENTER", 0, 0)
    end

    if button.HighlightTexture then
        button.HighlightTexture:SetAtlas(TEXTURES.HIGHLIGHT)
        button.HighlightTexture:SetAlpha(0.5)
        --button.HighlightTexture:SetBlendMode("ADD")
        button.HighlightTexture:ClearAllPoints()
        local highlightSize = iconWidth * RATIOS.HIGHLIGHT
        button.HighlightTexture:SetSize(highlightSize, highlightSize)
        button.HighlightTexture:SetPoint("CENTER", button, "CENTER")
    end

    if button.cooldown then
        button.cooldown:SetAlpha(0.8)
        if button.cooldown.SetSwipeTexture then
            button.cooldown:SetSwipeTexture("Interface\\HUD\\UI-HUD-CoolDownManager-Icon-Swipe")
        end

        -- Keep the cooldown anchored to the masked icon
        button.cooldown:ClearAllPoints()
        button.cooldown:SetAllPoints(button.icon)
    end

    if button.CheckedTexture then
        button.CheckedTexture:SetAtlas(TEXTURES.CHECKED)
        button.CheckedTexture:SetDesaturated(true)
        button.CheckedTexture:SetBlendMode("ADD")
        button.CheckedTexture:SetVertexColor(0.3, 0.9, 0.3, 1)
        button.CheckedTexture:SetAlpha(0.7)
        button.CheckedTexture:ClearAllPoints()
        local checkedSize = iconWidth * RATIOS.CHECKED
        button.CheckedTexture:SetSize(checkedSize, checkedSize)
        button.CheckedTexture:SetPoint("CENTER", button, "CENTER")
    end

    if button.SlotBackground then
        button.SlotBackground:SetTexture(nil)
        button.SlotBackground:SetAllPoints(button) -- Consistent sizing
    end

    -- Style NormalTexture overlay (same size as icon)
    if button.NormalTexture and button.icon then
        button.NormalTexture:SetAtlas(TEXTURES.NORMAL)
        button.NormalTexture:ClearAllPoints()

        local normalSize = iconWidth * RATIOS.NORMAL
        button.NormalTexture:SetSize(normalSize, normalSize)
        button.NormalTexture:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
    end

    -- Crop icon texture to remove built-in border and apply mask
    if button.icon then
        -- Very light zoom (3% crop) to hide the 1-2px built-in texture border
        button.icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)

        -- Apply mask to contain the icon cleanly (uses texture path)
        if ns.modules.masks then
            ns.modules.masks:ApplyMask(button.icon, TEXTURES.ICON_MASK_PATH)
        end
    end

    if button.PushedTexture then
        button.PushedTexture:SetAtlas(TEXTURES.PUSHED)
        --button.PushedTexture:SetDesaturated(true)
        -- button.PushedTexture:SetVertexColor(1, 0.2, 0.2, 1)
        --button.PushedTexture:SetBlendMode("ADD")
        button.PushedTexture:ClearAllPoints()
        local pushedSize = iconWidth * RATIOS.PUSHED
        button.PushedTexture:SetSize(pushedSize, pushedSize)
        button.PushedTexture:SetPoint("CENTER", button, "CENTER", 0.5, -1)
    end

    if button.IconMask then
        button.IconMask:SetAtlas(TEXTURES.ICON_MASK_ATLAS)
        local maskSize = iconWidth * RATIOS.ICON_MASK
        button.IconMask:SetSize(maskSize, maskSize)
        -- IconMask should stay anchored to the icon, not the button
    end
end

-- Only apply styling during PLAYER_ENTERING_WORLD or ADDON_LOADED events
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
    -- Force EditMode to apply saved positions for StanceBar
    C_Timer.After(0.1, function()
        -- Try to force EditMode to update StanceBar position
        if EditModeManagerFrame and StanceBar then
            -- Find the StanceBar system in EditMode
            local stanceBarSystem = EditModeManagerFrame:GetSystemFrame(Enum.EditModeSystem.StanceBar)
            if stanceBarSystem then
                -- Force update position from saved layout
                stanceBarSystem:UpdateSystem(EditModeManagerFrame:GetActiveLayout())
            end
        end

        -- Also try calling Update on StanceBar itself
        if StanceBar and StanceBar.Update then
            StanceBar:Update()
        end
    end)

    -- Delay styling to let Blizzard apply edit mode positions first
    C_Timer.After(0.5, function()
        -- All action bar button names
        local barNames = {
            "ActionButton",              -- Main action bar
            "MultiBarBottomLeftButton",  -- Bottom left bar
            "MultiBarBottomRightButton", -- Bottom right bar
            "MultiBarLeftButton",        -- Left bar
            "MultiBarRightButton",       -- Right bar
            "MultiBar5Button",           -- Extra bar 5
            "MultiBar6Button",           -- Extra bar 6
            "MultiBar7Button"            -- Extra bar 7
        }

        -- Apply styling to all action bars
        for _, barName in ipairs(barNames) do
            for i = 1, 12 do
                local button = _G[barName .. i]
                if button then
                    StyleActionButton(button)
                end
            end
        end

        -- Apply styling to stance bar
        for i = 1, 10 do
            local button = _G["StanceButton" .. i]
            if button then
                StyleActionButton(button)
            end
        end
    end)
end)

-- Module API for integration with Nihui_ab
local ActionBarStyling = {}
ns.modules.actionbarstyling = ActionBarStyling

function ActionBarStyling:OnEnable()
    -- Already handled by event frame
end

function ActionBarStyling:OnDisable()
    -- Would need to restore original textures/styles
end

function ActionBarStyling:UpdateSettings()
    -- Reapply styling when settings change
    local barNames = {
        "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton",
        "MultiBarLeftButton", "MultiBarRightButton", "MultiBar5Button",
        "MultiBar6Button", "MultiBar7Button"
    }

    for _, barName in ipairs(barNames) do
        for i = 1, 12 do
            local button = _G[barName .. i]
            if button then
                StyleActionButton(button)
            end
        end
    end

    -- Also restyle stance bar
    for i = 1, 10 do
        local button = _G["StanceButton" .. i]
        if button then
            StyleActionButton(button)
        end
    end
end

-- Register the module
ns.addon:RegisterModule("actionbarstyling", ActionBarStyling)