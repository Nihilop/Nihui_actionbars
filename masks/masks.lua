-- Nihui ActionBars - Masks management
local addonName, ns = ...

local Masks = {}
ns.modules.masks = Masks

-- Default mask paths (these should point to actual texture files)
Masks.AVAILABLE_MASKS = {
    [""] = "None",
    ["interface\\hud\\uicooldownmanagermask"] = "Circular (Default)",
}


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


-- Module API
function Masks:OnEnable()
    -- Nothing to do
end

function Masks:OnDisable()
    -- Nothing to do
end

-- Register the module
ns.addon:RegisterModule("masks", Masks)