-- Test pour voir la taille des stance buttons
local function CheckSizes()
    C_Timer.After(2, function()
        if GetNumShapeshiftForms() > 0 then
            local button = _G["StanceButton1"]
            if button then
                local bw, bh = button:GetSize()
                print("StanceButton size:", bw, bh)
                
                if button.icon then
                    local iw, ih = button.icon:GetSize()
                    print("StanceButton icon size:", iw, ih)
                end
                
                if button.NormalTexture then
                    local nw, nh = button.NormalTexture:GetSize()
                    print("StanceButton NormalTexture size:", nw, nh)
                end
            end
        end
        
        -- Compare avec un action button normal
        local normalButton = _G["ActionButton1"]
        if normalButton then
            local bw, bh = normalButton:GetSize()
            print("ActionButton size:", bw, bh)
            
            if normalButton.icon then
                local iw, ih = normalButton.icon:GetSize()
                print("ActionButton icon size:", iw, ih)
            end
        end
    end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", CheckSizes)
