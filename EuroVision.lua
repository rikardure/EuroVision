C_WowTokenPublic.UpdateMarketPrice()
local marketPrice = C_WowTokenPublic.GetCurrentMarketPrice()
timeSinceLastUpdate = 0
print("Current Token Market Price:",marketPrice / 10000, "gold")

 goldIcon = "Interface\\AddOns\\EuroVision\\gold.tga"
 silverIcon = "Interface\\AddOns\\EuroVision\\silver.tga"
 copperIcon = "Interface\\AddOns\\EuroVision\\copper.tga"


local function ChangeCurrencyIcons()
    hooksecurefunc("MoneyFrame_Update", function(frame, money)
        if frame and frame.GoldButton then
          
            frame.GoldButton:SetNormalTexture(goldIcon)
            frame.GoldButton:SetPushedTexture(goldIcon)

            frame.SilverButton:SetNormalTexture(silverIcon)
            frame.SilverButton:SetPushedTexture(silverIcon)

            frame.CopperButton:SetNormalTexture(copperIcon)
            frame.CopperButton:SetPushedTexture(copperIcon)
        end
    end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", ChangeCurrencyIcons)


local function MyPeriodicFunction()
    C_WowTokenPublic.UpdateMarketPrice()
    marketPrice = C_WowTokenPublic.GetCurrentMarketPrice()
    print("New market price =", marketPrice)
end

C_Timer.NewTicker(300, MyPeriodicFunction)

local isUpdating = false

local function EuroMoney(amount)
    res = (amount / (marketPrice/20)) * 10000
    return round(res,4)
end

function round(num, decimals)
    local mult = 10^(decimals or 0)  
    return math.floor(num * mult + 0.5) / mult  
end

hooksecurefunc("MoneyFrame_Update", function(frame, money)
    if not frame then
        return
    end

    if type(frame) == "table" then
        local frameName = frame:GetName() or "Unknown Frame"
        if frameName == "ContainerFrame1MoneyFrame" or frameName == "MerchantMoneyFrame"  then
            money = GetMoney() 
        end
        if frameName ~= "ContainerFrame1MoneyFrame" and frameName ~= "MerchantMoneyFrame" then
            return
        end
    end

    if isUpdating then 
        return
    end
    
    isUpdating = true  
    local euroMoney = EuroMoney(money)
    MoneyFrame_Update(frame, euroMoney) 
    isUpdating = false 
end)
