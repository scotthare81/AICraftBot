AICraftBot = AICraftBot or {}

function AICraftBot.CreateGearTab(parent)

    local frame = AICraftBot.Tabs.CreatePanel(parent, "Gear", "Gear")

    --------------------------------------------------
    -- Current Tier
    --------------------------------------------------

    local tierLabel = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormalLarge"
    )

    tierLabel:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -20)

    local function RefreshTier()
        tierLabel:SetText("Tier: " .. AICraftBotGear:GetTierName())
    end

    RefreshTier()

    --------------------------------------------------
    -- Previous
    --------------------------------------------------

    local prev = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    prev:SetWidth(80)
    prev:SetHeight(24)
    prev:SetPoint("TOPLEFT", tierLabel, "BOTTOMLEFT", 0, -20)
    prev:SetText("<")

    prev:SetScript("OnClick", function()

        local tier = AICraftBotGear:GetTier() - 1

        if tier < 0 then
            tier = 5
        end

        AICraftBotGear:SetTier(tier)
        RefreshTier()

    end)

    --------------------------------------------------
    -- Next
    --------------------------------------------------

    local next = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    next:SetWidth(80)
    next:SetHeight(24)
    next:SetPoint("LEFT", prev, "RIGHT", 10, 0)
    next:SetText(">")

    next:SetScript("OnClick", function()

        local tier = AICraftBotGear:GetTier() + 1

        if tier > 5 then
            tier = 0
        end

        AICraftBotGear:SetTier(tier)
        RefreshTier()

    end)

    --------------------------------------------------
    -- Apply
    --------------------------------------------------

    local apply = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    apply:SetWidth(180)
    apply:SetHeight(24)
    apply:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -20)
    apply:SetText("Apply To All Bots")

    apply:SetScript("OnClick", function()

    AICraftBot.Legacy.SendCommand(
        "gear " .. AICraftBotGear:GetTier()
    )

end)

    return frame

end
