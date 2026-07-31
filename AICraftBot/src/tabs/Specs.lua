AICraftBot=AICraftBot or {}

function AICraftBot.CreateSpecsTab(parent)

    local frame=AICraftBot.Tabs.CreatePanel(parent,"Specs","Specs")

    local classLabel=frame:CreateFontString(nil,"OVERLAY","GameFontNormal")
    classLabel:SetPoint("TOPLEFT",frame.title,"BOTTOMLEFT",0,-20)

    local label=frame:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
    label:SetPoint("TOPLEFT",classLabel,"BOTTOMLEFT",0,-10)

    local prev=CreateFrame("Button",nil,frame,"UIPanelButtonTemplate")
    prev:SetWidth(80)
    prev:SetHeight(24)
    prev:SetPoint("TOPLEFT",label,"BOTTOMLEFT",0,-20)
    prev:SetText("<")

    local next=CreateFrame("Button",nil,frame,"UIPanelButtonTemplate")
    next:SetWidth(80)
    next:SetHeight(24)
    next:SetPoint("LEFT",prev,"RIGHT",10,0)
    next:SetText(">")

    local apply=CreateFrame("Button",nil,frame,"UIPanelButtonTemplate")
    apply:SetWidth(220)
    apply:SetHeight(24)
    apply:SetPoint("TOPLEFT",prev,"BOTTOMLEFT",0,-20)
    apply:SetText("Apply To Selected Bots")

    local function Refresh()
        local specName,commandSpec,class=AICraftBotSpecs:Get()

        if class then
            classLabel:SetText("Class: "..class)
            label:SetText("Build: "..specName)
            prev:Enable()
            next:Enable()
            apply:Enable()
        else
            classLabel:SetText(specName)
            label:SetText("Build: --")
            prev:Disable()
            next:Disable()
            apply:Disable()
        end
    end

    prev:SetScript("OnClick",function()
        AICraftBotSpecs:Prev()
        Refresh()
    end)

    next:SetScript("OnClick",function()
        AICraftBotSpecs:Next()
        Refresh()
    end)

    apply:SetScript("OnClick",function()
        local specName,commandSpec,class=AICraftBotSpecs:Get()

        if commandSpec then
            AICraftBot.Legacy.SendCommand("talents "..commandSpec)
        end

        Refresh()
    end)

    frame:SetScript("OnShow",function()
        Refresh()
    end)

    Refresh()

    return frame

end
