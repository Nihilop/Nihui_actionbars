-- Nihui ActionBars - Masks management
local addonName, ns = ...

local Masks = {}
ns.modules.masks = Masks

-- Default mask paths (these should point to actual texture files)
Masks.AVAILABLE_MASKS = {
    [""] = "None",
    ["interface\\hud\\uicooldownmanagermask"] = "Circular (Default)",
    ["Interface\\AddOns\\Nihui_ab\\masks\\round.tga"] = "Round Custom",
    ["Interface\\AddOns\\Nihui_ab\\masks\\square.tga"] = "Square Custom",
    ["Interface\\AddOns\\Nihui_ab\\masks\\rectangle.tga"] = "Rectangle Custom",
    ["Interface\\AddOns\\Nihui_ab\\masks\\triangle.tga"] = "Triangle Custom",
}

-- Copy masks from the original addon if they exist
function Masks:CopyOriginalMasks()
    local originalMasks = {
        ["Interface\\AddOns\\rnxmUI\\Masks\\PPortrait.tga"] = "Round Portrait",
        ["Interface\\AddOns\\rnxmUI\\Masks\\SquarePortrait.tga"] = "Square Portrait",
        ["Interface\\AddOns\\rnxmUI\\Masks\\RectangleMask.tga"] = "Rectangle Mask",
        ["Interface\\AddOns\\rnxmUI\\Masks\\UICooldownManagerMask.tga"] = "Cooldown Manager",
        ["Interface\\AddOns\\rnxmUI\\Masks\\SlantedPlayer.tga"] = "Slanted Player",
        ["Interface\\AddOns\\rnxmUI\\Masks\\SlantedTarget.tga"] = "Slanted Target",
    }

    for path, name in pairs(originalMasks) do
        self.AVAILABLE_MASKS[path] = name
    end
end

-- Get available masks for configuration
function Masks:GetAvailableMasks()
    return self.AVAILABLE_MASKS
end

-- Validate if a mask exists
function Masks:ValidateMask(maskPath)
    if not maskPath or maskPath == "" then
        return true -- Empty is valid (no mask)
    end

    -- For now, just check if it's in our list
    return self.AVAILABLE_MASKS[maskPath] ~= nil
end

-- Apply mask to a texture
function Masks:ApplyMask(texture, maskPath)
    if not texture then return end

    -- Remove existing mask if any
    if texture.nihuiMask then
        texture:RemoveMaskTexture(texture.nihuiMask)
        texture.nihuiMask = nil
    end

    -- Apply new mask if specified
    if maskPath and maskPath ~= "" and self:ValidateMask(maskPath) then
        local parent = texture:GetParent()
        if parent then
            local mask = parent:CreateMaskTexture()
            mask:SetTexture(maskPath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            mask:SetAllPoints(texture)
            texture:AddMaskTexture(mask)
            texture.nihuiMask = mask
        end
    end
end

-- Remove mask from a texture
function Masks:RemoveMask(texture)
    if not texture then return end

    if texture.nihuiMask then
        texture:RemoveMaskTexture(texture.nihuiMask)
        texture.nihuiMask = nil
    end
end

-- Create a test mask preview
function Masks:CreateMaskPreview(parent, maskPath, size)
    size = size or 64

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(size, size)

    -- Background texture
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.2, 0.2, 0.8, 1) -- Blue background

    -- Test texture with mask
    local texture = frame:CreateTexture(nil, "ARTWORK")
    texture:SetAllPoints()
    texture:SetColorTexture(1, 1, 1, 1) -- White foreground

    -- Apply mask
    self:ApplyMask(texture, maskPath)

    frame.texture = texture
    frame.background = bg

    return frame
end

-- Module API
function Masks:OnEnable()
    self:CopyOriginalMasks()
end

function Masks:OnDisable()
    -- Nothing to do
end

-- Export masks to namespace
ns.SpellActivationMasks = Masks.AVAILABLE_MASKS

-- Register the module
ns.addon:RegisterModule("masks", Masks)