-- Nihui ActionBars - Action Bar Styling module (based on rnxmUI)
local addonName, ns = ...

local function StyleActionButton(button)
    if not button then return end

    -- Disable Blizzard's texture override function first
    if button.UpdateButtonArt then
        button.UpdateButtonArt = function() end
    end

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
        button.SpellCastAnimFrame:SetSize(59, 59)
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
                button.InterruptDisplay.Highlight.Mask:SetAtlas("UI-HUD-CoolDownManager-Mask") -- Temporary - your mask
                button.InterruptDisplay.Highlight.Mask:SetSize(42, 42)
            end
        end

        -- Style the Base frame's Base texture (main interrupt visual with flipbook)
        if button.InterruptDisplay.Base and button.InterruptDisplay.Base.Base then
            if button.InterruptDisplay.Base.Base.SetTexture then
                button.InterruptDisplay.Base.Base:SetTexture("Interface\\addons\\Nihui_ab\\textures\\UI_CRB_Anim_Ability_Interrupt")
                button.InterruptDisplay.Base.Base:SetVertexColor(1, 1, 1, 1)

                button.InterruptDisplay.Base.Base:SetSize(41, 41) -- or whatever size you want
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
        button.InterruptDisplay:SetSize(45, 45)
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
                button.TargetReticleAnimFrame.Mask:SetSize(45, 45)
            end
        end

        -- Position and size the TargetReticleAnimFrame
        button.TargetReticleAnimFrame:ClearAllPoints()
        button.TargetReticleAnimFrame:SetSize(60, 60)
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
        button.CooldownFlash:SetSize(59, 59)
        button.CooldownFlash:SetPoint("CENTER", button, "CENTER", 0, 0)
    end

    if button.HighlightTexture then
        button.HighlightTexture:SetAtlas("UI-CooldownManager-OORshadow-2x")
        button.HighlightTexture:SetAlpha(0.5)
        --button.HighlightTexture:SetBlendMode("ADD")
        button.HighlightTexture:ClearAllPoints() -- Clear any existing anchors first
        button.HighlightTexture:SetSize(41.5, 41.5) -- Your custom size
        button.HighlightTexture:SetPoint("CENTER", button, "CENTER") -- Center it on the button
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
        button.CheckedTexture:SetAtlas("UI-HUD-CoolDownManager-IconOverlay")
        button.CheckedTexture:SetDesaturated(true)
        button.CheckedTexture:SetBlendMode("ADD")
        button.CheckedTexture:SetVertexColor(0.3, 0.9, 0.3, 1)
        button.CheckedTexture:SetAlpha(0.7)
        button.CheckedTexture:ClearAllPoints()
        button.CheckedTexture:SetSize(42, 42)
        button.CheckedTexture:SetPoint("CENTER", button, "CENTER")
    end

    if button.SlotBackground then
        button.SlotBackground:SetTexture(nil)
        button.SlotBackground:SetAllPoints(button) -- Consistent sizing
    end

    -- Remove borders - this is the key part for clean buttons
    if button.NormalTexture then
        button.NormalTexture:SetAtlas("UI-HUD-CoolDownManager-IconOverlay")
        button.NormalTexture:ClearAllPoints() -- Clear any existing anchors first
        button.NormalTexture:SetSize(60, 60) -- Your custom size
        button.NormalTexture:SetPoint("CENTER", button, "CENTER", 0, 0)
    end

    if button.PushedTexture then
        button.PushedTexture:SetAtlas("UI-CooldownManager-ActiveGlow-2x")
        --button.PushedTexture:SetDesaturated(true)
        -- button.PushedTexture:SetVertexColor(1, 0.2, 0.2, 1)
        --button.PushedTexture:SetBlendMode("ADD")
        button.PushedTexture:ClearAllPoints() -- Clear any existing anchors first
        button.PushedTexture:SetSize(63, 63) -- Your custom size
        button.PushedTexture:SetPoint("CENTER", button, "CENTER", 0.5, -1) -- Center it on the button
    end

    if button.IconMask then
        button.IconMask:SetAtlas("UI-HUD-CoolDownManager-Mask") --SetTexture("Interface\\AddOns\\rnxmUI\\masks\\UICooldownManagerMask.tga")
        button.IconMask:SetSize(45, 45)
        -- IconMask should stay anchored to the icon, not the button
    end
end

-- Copy the UI_CRB_Anim_Ability_Interrupt texture from rnxmUI if not already present
local function EnsureInterruptTexture()
    -- Check if texture exists, if not copy from rnxmUI
    local sourcePath = "E:\\Battle.net\\World of Warcraft\\_retail_\\Interface\\AddOns\\rnxmUI\\Textures\\UI_CRB_Anim_Ability_Interrupt.tga"
    local targetPath = "E:\\Battle.net\\World of Warcraft\\_retail_\\Interface\\AddOns\\Nihui_ab\\textures\\UI_CRB_Anim_Ability_Interrupt.tga"

    -- This is handled by the file copy we did earlier
end

-- Only apply styling during PLAYER_ENTERING_WORLD or ADDON_LOADED events
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
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
end

-- Register the module
ns.addon:RegisterModule("actionbarstyling", ActionBarStyling)